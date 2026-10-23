#!/usr/bin/env python3
"""Adds what the generated Android project needs for reminders and the app name.

Run from the project root after `flutter create --platforms=android .`:

    python3 tool/patch_android.py .

Changes:
  - permissions: INTERNET, POST_NOTIFICATIONS, RECEIVE_BOOT_COMPLETED
  - app label: እስላማዊ አዝካር
  - boot/alarm receivers used by flutter_local_notifications
  - core library desugaring (needed by flutter_local_notifications on Android)

It is safe to run twice: every change is skipped if it is already there.
If an expected part of the project is missing, it stops with an error instead
of guessing.
"""

import pathlib
import re
import sys

LABEL = 'እስላማዊ አዝካር'
PERMISSIONS = [
    'android.permission.INTERNET',
    'android.permission.POST_NOTIFICATIONS',
    'android.permission.RECEIVE_BOOT_COMPLETED',
]
RECEIVERS = """
        <receiver
            android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver"
            android:exported="false" />
        <receiver
            android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver"
            android:exported="false">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED" />
                <action android:name="android.intent.action.MY_PACKAGE_REPLACED" />
                <action android:name="android.intent.action.QUICKBOOT_POWERON" />
                <action android:name="com.htc.intent.action.QUICKBOOT_POWERON" />
            </intent-filter>
        </receiver>
    """
DESUGAR_LIB = 'com.android.tools:desugar_jdk_libs:2.1.4'


def fail(message: str) -> None:
    print(f'patch_android: {message}', file=sys.stderr)
    sys.exit(1)


def patch_manifest(app_dir: pathlib.Path) -> None:
    manifest = app_dir / 'src' / 'main' / 'AndroidManifest.xml'
    if not manifest.exists():
        fail(f'{manifest} not found')
    text = manifest.read_text(encoding='utf-8')

    # Permissions go right after the opening <manifest ...> tag.
    tag = re.search(r'<manifest\b[^>]*>', text)
    if not tag:
        fail('no <manifest> tag in AndroidManifest.xml')
    missing = [p for p in PERMISSIONS if p not in text]
    if missing:
        lines = ''.join(f'\n    <uses-permission android:name="{p}" />' for p in missing)
        text = text[: tag.end()] + lines + text[tag.end():]

    # App name shown under the icon.
    app_tag = re.search(r'<application\b[^>]*>', text)
    if not app_tag:
        fail('no <application> tag in AndroidManifest.xml')
    new_tag = re.sub(r'android:label="[^"]*"', f'android:label="{LABEL}"', app_tag.group(0))
    if new_tag == app_tag.group(0) and f'android:label="{LABEL}"' not in new_tag:
        new_tag = new_tag.replace('<application', f'<application android:label="{LABEL}"', 1)
    text = text[: app_tag.start()] + new_tag + text[app_tag.end():]

    # Receivers go just before </application>.
    if 'ScheduledNotificationReceiver' not in text:
        if '</application>' not in text:
            fail('no </application> in AndroidManifest.xml')
        text = text.replace('</application>', RECEIVERS + '</application>', 1)

    manifest.write_text(text, encoding='utf-8')
    print('patch_android: manifest ok')


def patch_gradle(app_dir: pathlib.Path) -> None:
    kts = app_dir / 'build.gradle.kts'
    groovy = app_dir / 'build.gradle'
    if kts.exists():
        path, is_kts = kts, True
    elif groovy.exists():
        path, is_kts = groovy, False
    else:
        fail('no build.gradle(.kts) in android/app')

    text = path.read_text(encoding='utf-8')
    if DESUGAR_LIB in text:
        print('patch_android: gradle already patched')
        return

    if is_kts:
        option = 'isCoreLibraryDesugaringEnabled = true'
        dependency = f'    coreLibraryDesugaring("{DESUGAR_LIB}")\n'
    else:
        option = 'coreLibraryDesugaringEnabled true'
        dependency = f"    coreLibraryDesugaring '{DESUGAR_LIB}'\n"

    # Put the option into the existing compileOptions block if there is one,
    # otherwise add a new block at the start of android { }.
    existing = re.search(r'^[ \t]*compileOptions\s*\{[ \t]*\n', text, re.M)
    if existing:
        text = text[: existing.end()] + f'        {option}\n' + text[existing.end():]
    else:
        android = re.search(r'^android\s*\{[ \t]*\n', text, re.M)
        if not android:
            fail(f'no android {{ block in {path.name}')
        block = f'    compileOptions {{\n        {option}\n    }}\n'
        text = text[: android.end()] + block + text[android.end():]

    deps = re.search(r'^dependencies\s*\{[ \t]*\n', text, re.M)
    if deps:
        text = text[: deps.end()] + dependency + text[deps.end():]
    else:
        text = text.rstrip() + f'\n\ndependencies {{\n{dependency}}}\n'

    if DESUGAR_LIB not in text or option not in text:
        fail(f'desugaring not inserted into {path.name}')
    path.write_text(text, encoding='utf-8')
    print(f'patch_android: {path.name} ok')


def patch_release_shrinking(app_dir: pathlib.Path) -> None:
    """Turns off R8 for release builds.

    R8 strips the generic type information that flutter_local_notifications
    needs to read its saved reminders, which crashes with "Missing type
    parameter" when reminders are changed in a release build.
    """
    kts = app_dir / 'build.gradle.kts'
    groovy = app_dir / 'build.gradle'
    path = kts if kts.exists() else groovy
    is_kts = path == kts
    text = path.read_text(encoding='utf-8')

    off = 'isMinifyEnabled = false' if is_kts else 'minifyEnabled false'
    on_pattern = r'isMinifyEnabled\s*=\s*true' if is_kts else r'minifyEnabled\s+true'
    if off in text and not re.search(on_pattern, text):
        print(f'patch_android: release shrinking already off in {path.name}')
        return
    if re.search(on_pattern, text):
        text = re.sub(on_pattern, off, text)
    else:
        release = re.search(r'^[ \t]*release\s*\{[ \t]*\n', text, re.M)
        if not release:
            fail(f'no release {{ block in {path.name}')
        text = text[: release.end()] + f'            {off}\n' + text[release.end():]
    if off not in text:
        fail(f'could not disable release shrinking in {path.name}')
    path.write_text(text, encoding='utf-8')
    print(f'patch_android: {path.name} release shrinking off')


def main() -> None:
    root = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else '.')
    app_dir = root / 'android' / 'app'
    if not app_dir.is_dir():
        fail(f'{app_dir} not found. Run `flutter create --platforms=android .` first.')
    patch_manifest(app_dir)
    patch_gradle(app_dir)
    patch_release_shrinking(app_dir)
    print('patch_android: done')


if __name__ == '__main__':
    main()

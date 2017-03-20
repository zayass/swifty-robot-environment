#### swifty-robot-environment ####
#
# Builds Swift compiler for Android targets based on the last source cloned
#
# Version 0.4 (2016-12-30)
#
# Dependencies: ndk @ google/android
#               libiconv-libicu-android @ github/SwiftAndroid
#               swift @ github/apple
#

source .profile

pushd $SWIFT_ANDROID_SOURCE/swift
	utils/build-script \
		-R \
		--android \
		--android-ndk $NDK \
		--android-api-level 21 \
		--android-icu-uc $LIBICONV_ANDROID/armeabi-v7a \
		--android-icu-uc-include $LIBICONV_ANDROID/armeabi-v7a/icu/source/common \
		--android-icu-i18n $LIBICONV_ANDROID/armeabi-v7a \
		--android-icu-i18n-include $LIBICONV_ANDROID/armeabi-v7a/icu/source/i18n \
		--llbuild \
		--lldb \
		--swiftpm \
		--xctest
popd

# I don't like this. Maybe if SYSROOT were taken into account a better way of handling this could be figured out. In the meantime...
ln -f -s $NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ld.gold /usr/bin/armv7-none-linux-android-ld.gold
ln -f -s $NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ld.gold /usr/bin/armv7-none-linux-androideabi-ld.gold

export SWIFT_ANDROID_BUILDPATH="$SWIFT_ANDROID_SOURCE/build/Ninja-ReleaseAssert"
echo 'export SWIFT_ANDROID_BUILDPATH="'$SWIFT_ANDROID_BUILDPATH'"' >> .profile

# Installation seems to be broken on current master?
cp -r $SWIFT_ANDROID_BUILDPATH/swift-linux-x86_64/lib/* /usr/local/lib/

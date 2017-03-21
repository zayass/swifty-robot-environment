#### swifty-robot-environment ####
#
# Get last swift and components repositories cloned
#
# Version 0.2 (2016-12-30)
#
# Dependencies: swift @ github/apple
#

source .profile

export APPROVED_PRS_URL=http://pick.ly/swiftyrobot/util/approved_prs.php
export GIT_URL_SWIFT=https://github.com/apple/swift.git

tag="swift-DEVELOPMENT-SNAPSHOT-2017-03-19-a"
patches="swift-corelibs-libdispatch 228"

function fetch_pr {
        curl -s https://patch-diff.githubusercontent.com/raw/apple/$1/pull/$2.patch > pr_$2.patch
}

function apply_pr {
	fetch_pr $@

	pushd $1 > /dev/null
		if git apply --check ../pr_$2.patch; then
			git apply ../pr_$2.patch > /dev/null 2> /dev/null
			echo "Done!"
		else
			echo "Path failed..."
			exit 127
		fi
	popd > /dev/null

	rm pr_$2.patch
}

function apply_patches {
        echo $patches | while read PR; do
                apply_pr $PR
        done
}

mkdir -p swift-source/swift
git clone $GIT_URL_SWIFT swift-source/swift

pushd swift-source
	swift/utils/update-checkout --clone
	swift/utils/update-checkout --tag $tag
	apply_patches
popd

echo 'export SWIFT_ANDROID_SOURCE="'`realpath ./swift-source`'"' >> .profile

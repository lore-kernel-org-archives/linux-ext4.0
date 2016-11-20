From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] generic: add utilities for testing filesystem
 encryption
Date: Mon, 21 Nov 2016 08:33:13 +1100
Message-ID: <20161120213313.GI28177@dastard>
References: <1479412027-34416-1-git-send-email-ebiggers@google.com>
 <1479412027-34416-2-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs@vger.kernel.org, "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>
To: Eric Biggers <ebiggers@google.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1479412027-34416-2-git-send-email-ebiggers@google.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 17, 2016 at 11:47:04AM -0800, Eric Biggers wrote:
> Add utilities for testing the filesystem-level encryption feature
> currently supported by ext4 and f2fs.  Tests will be able to source
> common/encrypt and call _begin_encryption_test to set up an
> encryption-capable filesystem on the scratch device, or skip the test
> when not supported.
> 
> A program fscrypt_util is also added to expose filesystem
> encryption-related commands to shell scripts.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  .gitignore         |   1 +
>  common/encrypt     |  89 ++++++++++++++++
>  src/Makefile       |   2 +-
>  src/fscrypt_util.c | 306 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 397 insertions(+), 1 deletion(-)
>  create mode 100755 common/encrypt
>  create mode 100644 src/fscrypt_util.c
> 
> diff --git a/.gitignore b/.gitignore
> index 915d2d8..7040f67 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -54,6 +54,7 @@
>  /src/fill
>  /src/fill2
>  /src/fs_perms
> +/src/fscrypt_util
>  /src/fssum
>  /src/fstest
>  /src/fsync-tester
> diff --git a/common/encrypt b/common/encrypt
> new file mode 100755
> index 0000000..599d16f
> --- /dev/null
> +++ b/common/encrypt
> @@ -0,0 +1,89 @@
> +#!/bin/bash
> +#
> +# Common functions for testing filesystem-level encryption
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2016 Google, Inc.
> +#
> +# Author: Eric Biggers <ebiggers@google.com>
> +#
> +# This program is free software; you can redistribute it and/or modify
> +# it under the terms of the GNU General Public License as published by
> +# the Free Software Foundation; either version 2 of the License, or
> +# (at your option) any later version.
> +#
> +# This program is distributed in the hope that it will be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, see <http://www.gnu.org/licenses/>.
> +#-----------------------------------------------------------------------
> +
> +. ./common/rc

Tests will already have included common/rc before this file, so we
do not source it here.


> +
> +# Begin an encryption test.  This creates the scratch filesystem with encryption
> +# enabled and mounts it, or skips the test if encryption isn't supported.
> +_begin_encryption_test() {
> +
> +	_supported_os Linux
> +	_supported_fs ext4 f2fs

These go in the tests, not here.

> +
> +	# We use a dedicated test program 'fscrypt_util' for making API calls
> +	# related to encryption.  We aren't using 'e4crypt' because 'e4crypt' is
> +	# currently ext4-specific, and with a test program we can easily include
> +	# test-only commands and other functionality or behavior that wouldn't
> +	# make sense in a real program.
> +	_require_test_program fscrypt_util
> +
> +	# The 'test_dummy_encryption' mount option interferes with trying to use
> +	# encryption for real.  So skip the real encryption tests if the
> +	# 'test_dummy_encryption' mount option was specified.
> +	if echo "$MOUNT_OPTIONS" | grep -q "test_dummy_encryption"; then
> +		_notrun "Dummy encryption is on; skipping real encryption tests"
> +	fi

_requires_real_encryption()

In each test.


> +
> +	# Make a filesystem on the scratch device with the encryption feature
> +	# enabled.  If this fails then probably the userspace tools (e.g.
> +	# e2fsprogs or f2fs-tools) are too old to understand encryption.
> +	_require_scratch
> +	if ! _scratch_mkfs_encrypted >/dev/null; then
> +		_notrun "$FSTYP userspace tools do not support encryption"
> +	fi
> +
> +	# Try to mount the filesystem.  If this fails then probably the kernel
> +	# isn't aware of encryption.
> +	if ! _scratch_mount &> /dev/null; then
> +		_notrun "kernel is unaware of $FSTYP encryption feature"
> +	fi
> +
> +	# The kernel may be aware of encryption without supporting it.  For
> +	# example, for ext4 this is the case with kernels configured with
> +	# CONFIG_EXT4_FS_ENCRYPTION=n.  Detect support for encryption by trying
> +	# to set an encryption policy.  (For ext4 we could instead check for the
> +	# presence of /sys/fs/ext4/features/encryption, but this is broken on
> +	# some older kernels and is ext4-specific anyway.)
> +	mkdir $SCRATCH_MNT/tmpdir
> +	if src/fscrypt_util set_policy 0000111122223333 $SCRATCH_MNT/tmpdir \
> +		2>&1 >/dev/null |
> +		egrep -q 'Inappropriate ioctl for device|Operation not supported'
> +	then
> +		_notrun "kernel does not support $FSTYP encryption"
> +	fi
> +	rmdir $SCRATCH_MNT/tmpdir

And this should all be in a _requires_encryption() function.

> +}
> +
> +_scratch_mkfs_encrypted() {
> +	case $FSTYP in
> +	ext4)
> +		# ext4 encryption requires block size = PAGE_SIZE.
> +		MKFS_OPTIONS="-O encrypt -b $(getconf PAGE_SIZE)" _scratch_mkfs
> +		;;
> +	*)
> +		MKFS_OPTIONS="-O encrypt" _scratch_mkfs
> +		;;
> +	esac
> +}

THis completely overrides any user supplied mkfs options, which we
try to avoid doing. Instead, this should simply be

	_scratch_mkfs -O encrypt

so that _scratch_mkfs_encrypted() fails if there are conflicting
mkfs options specified. This means _requires_encryption() will
not_run the test when this occurrs...


> +FSCRYPT_UTIL=`pwd`/src/fscrypt_util

_require_test_program fscrypt_util

FSCRYPT_UTIL=src/fscrypt_util

> diff --git a/src/fscrypt_util.c b/src/fscrypt_util.c
> new file mode 100644
> index 0000000..de63667
> --- /dev/null
> +++ b/src/fscrypt_util.c

....

Ok, can we get this added to xfs_io rather than a stand-alone
fstests helper? There are three clear commands here:

	{"gen_key", gen_key},
	{"rm_key", rm_key},
	{"set_policy", set_policy},

So it should plug straight into the xfs_io command parsing
infrastructure without much change at all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

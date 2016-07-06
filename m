From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests, generic: add project quota attribute tests
Date: Thu, 7 Jul 2016 09:35:33 +1000
Message-ID: <20160706233533.GK27480@dastard>
References: <1467786171-21127-1-git-send-email-wangshilong1991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu,
	sihara@ddn.com, lixi@ddn.com, Wang Shilong <wshilong@ddn.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1467786171-21127-1-git-send-email-wangshilong1991@gmail.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 06, 2016 at 03:22:51PM +0900, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> lsattr/chattr support both of ext4 and xfs, add
> a test to cover both of them.
> 
>  1. ioctl with project quota.
>  2. project inherit attribute.
>  3. Link accross project should fail
>  4. change project ignores quota
> 
> Signed-off-by: Wang Shilong <wshilong@ddn.com>

FWIW, this test already points out a few problems with the ext4
project quota implementation....

> +#
> +# Test Project quota attr function
> +#
> +#-----------------------------------------------------------------------
> +# Copyright 2016 (C) Wang Shilong <wshilong@ddn.com>

Ambiguous copyright statement. Is it your personal copyright, or
should it be DDN, the company you work for? If it's a personal
copyright, please use your personal email address, not the email
address supllied by the company you work for. If it's DDN that
owns the copyright, then please put DDN's name here along with your
DDN email address.


> +# real QA test starts here
> +_supported_fs ext4 xfs
> +_supported_os Linux

Generic tests shouldn't need a _supported_fs line - the filesystems
it runs on should be selected by the _requires*  functions below.

> +_require_scratch
> +_require_chattr
> +_require_test_lsattr
> +_require_quota

needs  _require_prjquota, and that function needs to be modified to
detect for both XFS and ext4 support.

> +
> +rm -f $seqres.full
> +MKFSOPTIONS=""
> +MOUNTOPTIONS=""

This doesn't seem appropriate. We really want to test project quotas
under all the configurations that come in from the environment. e.g.
for different block sizes.

> +function setup_quota_options()
> +{
> +    case $FSTYP in
> +    xfs)
> +	#quotaon rely on this.
> +	MOUNTOPTIONS="-o pquota"
> +	;;
> +    ext4)
> +	#project quota is disabled in default.
> +	MKFSOPTIONS="-O quota,project"
> +	;;
> +    *)
> +        ;;
> +    esac
> +
> +}

Oh, I see now. Really, ext4 needs to support the pquota mount
option, just like all the other filesystem quotas are configured.
Please fix that ext4 kernel bug, not hack around it in the test
harnesses.

> +function set_inherit_attribute()
> +{
> +    case $FSTYP in
> +    xfs)
> +	$XFS_IO_PROG -r -c 'chattr +P' $*
> +	;;
> +    ext4)
> +	chattr +P $*
> +	;;
> +    *)
> +        ;;
> +    esac
> +}

Don't the two programs use exactly the same ioctl interface to set
the project attribute?  If not, then that's a deficiency in the ext4
project quota implementation that needs fixing. If there's some
other reason for xfs_io not working on ext4, then that needs fixing.
Again, don't work around implementation problems in the test harness.

> +setup_quota_options
> +
> +echo "+ create scratch fs"
> +_scratch_mkfs $MKFSOPTIONS > /dev/null 2>&1
> +
> +echo "+ mount fs image"
> +_scratch_mount $MOUNTOPTIONS

Once everything is done via mount option, then we can use the
standard _qmount_option function for setting the quota type, and
_qmount for mounting with quotas enabled according to
_qmount_option.


> +function attr_test()
> +{
> +	#default project without inherit
> +	mkdir $SCRATCH_MNT/dir
> +	chattr -p 123456 $SCRATCH_MNT/dir | _filter_scratch | _filter_spaces
> +	lsattr -p $SCRATCH_MNT/dir | _filter_scratch | $AWK_PROG '{print $1" "$3}'
> +	touch $SCRATCH_MNT/dir/foo
> +	lsattr -p $SCRATCH_MNT/dir/foo | _filter_scratch | $AWK_PROG '{print $1" "$3}'
> +
> +	#test project inherit with inherit attribute
> +	set_inherit_attribute $SCRATCH_MNT/dir
> +	touch $SCRATCH_MNT/dir/foo1
> +	lsattr -p $SCRATCH_MNT/dir/foo1 | _filter_scratch | $AWK_PROG '{print $1" "$3}'
> +
> +	#Link accross project should fail
> +	mkdir $SCRATCH_MNT/dir1
> +	set_inherit_attribute $SCRATCH_MNT/dir1
> +	chattr -p 654321 $SCRATCH_MNT/dir1 | _filter_scratch | _filter_spaces
> +	ln $SCRATCH_MNT/dir/foo1 $SCRATCH_MNT/dir1/foo1 2>&1 \
> +		| _filter_scratch | _filter_spaces
> +
> +	#mv accross different projects should work
> +	mv $SCRATCH_MNT/dir/foo1 $SCRATCH_MNT/dir1/foo1
> +	lsattr -p $SCRATCH_MNT/dir1/foo1 | _filter_scratch | $AWK_PROG '{print $1" "$3}'
> +
> +	#change project ignores quota
> +	quotaon $SCRATCH_MNT >/dev/null 2>&1
> +	setquota -P 654321 0 0 0 1 $SCRATCH_MNT/
> +	chattr -p 123456 $SCRATCH_MNT/dir1/foo1 | _filter_scratch | _filter_spaces
> +	lsattr -p $SCRATCH_MNT/dir1/foo1 | _filter_scratch | $AWK_PROG '{print $1" "$3}'
> +}
> +attr_test

We don't need this encapsulated in a function.

Also, there is nothing to set status=0 before exit, so this test
will always fail due to the exit code being 1.

> diff --git a/tests/generic/362.out b/tests/generic/362.out
> new file mode 100644
> index 0000000..31db991
> --- /dev/null
> +++ b/tests/generic/362.out
> @@ -0,0 +1,8 @@
> +QA output created by 362
> ++ create scratch fs
> ++ mount fs image
> +0 SCRATCH_MNT/dir/foo
> +123456 SCRATCH_MNT/dir/foo1
> +ln: failed to create hard link 'SCRATCH_MNT/dir1/foo1' => 'SCRATCH_MNT/dir/foo1': Invalid cross-device link
> +654321 SCRATCH_MNT/dir1/foo1
> +123456 SCRATCH_MNT/dir1/foo1
> diff --git a/tests/generic/group b/tests/generic/group
> index 7491282..e834762 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -364,3 +364,4 @@
>  359 auto quick clone
>  360 auto quick metadata
>  361 auto quick
> +362 auto quick

and quota.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

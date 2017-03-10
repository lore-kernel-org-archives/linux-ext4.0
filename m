From: Xiong Zhou <xzhou@redhat.com>
Subject: Re: [PATCH] generic: require journal in shutdown tests
Date: Fri, 10 Mar 2017 17:48:48 +0800
Message-ID: <20170310094848.guqyntkclvx7lqzd@XZHOUW.usersys.redhat.com>
References: <20170307061609.27099-1-eguan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35262 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935203AbdCJJsu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 10 Mar 2017 04:48:50 -0500
Content-Disposition: inline
In-Reply-To: <20170307061609.27099-1-eguan@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 07, 2017 at 02:16:09PM +0800, Eryu Guan wrote:
> Tests in shutdown group are supposed to test journal recovery after
> filesystem shutdown, and the tests assume the filesystem in test has
> journal support. But with the ext4 shutdown function added in
> 4.11-rc kernel, ext2 gains shutdown support too when driving with
> ext4 driver, so generic/051 fails because fs corruption after test.
> 
> Adding _require_metadata_journaling to all generic tests in shutdown
> group to ensure there's journal present.

Good!

Thanks,
Xiong

> 
> generic/050 is skipped because it has _require_scratch_nocheck,
> which indicates no fsck is done after test.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  tests/generic/042 | 1 +
>  tests/generic/043 | 1 +
>  tests/generic/044 | 1 +
>  tests/generic/045 | 1 +
>  tests/generic/046 | 1 +
>  tests/generic/047 | 1 +
>  tests/generic/048 | 1 +
>  tests/generic/049 | 1 +
>  tests/generic/051 | 1 +
>  tests/generic/052 | 1 +
>  tests/generic/054 | 3 +++
>  tests/generic/055 | 3 +++
>  tests/generic/388 | 1 +
>  tests/generic/392 | 1 +
>  14 files changed, 18 insertions(+)
> 
> diff --git a/tests/generic/042 b/tests/generic/042
> index 6eecbdc..68ff03c 100755
> --- a/tests/generic/042
> +++ b/tests/generic/042
> @@ -92,6 +92,7 @@ _require_xfs_io_command "fpunch"
>  _require_xfs_io_command "fzero"
>  
>  _scratch_mkfs >/dev/null 2>&1
> +_require_metadata_journaling $SCRATCH_DEV
>  _scratch_mount
>  
>  _crashtest "falloc -k"
> diff --git a/tests/generic/043 b/tests/generic/043
> index b76a5aa..3d98ab0 100755
> --- a/tests/generic/043
> +++ b/tests/generic/043
> @@ -43,6 +43,7 @@ _require_scratch
>  _require_scratch_shutdown
>  _require_fiemap
>  _scratch_mkfs >/dev/null 2>&1
> +_require_metadata_journaling $SCRATCH_DEV
>  _scratch_mount
>  
>  # create files
> diff --git a/tests/generic/044 b/tests/generic/044
> index 0331baa..eb64b86 100755
> --- a/tests/generic/044
> +++ b/tests/generic/044
> @@ -43,6 +43,7 @@ _require_scratch
>  _require_scratch_shutdown
>  _require_fiemap
>  _scratch_mkfs >/dev/null 2>&1
> +_require_metadata_journaling $SCRATCH_DEV
>  _scratch_mount
>  
>  # create files
> diff --git a/tests/generic/045 b/tests/generic/045
> index 874c955..5ef747f 100755
> --- a/tests/generic/045
> +++ b/tests/generic/045
> @@ -43,6 +43,7 @@ _require_scratch
>  _require_scratch_shutdown
>  _require_fiemap
>  _scratch_mkfs >/dev/null 2>&1
> +_require_metadata_journaling $SCRATCH_DEV
>  _scratch_mount
>  
>  # create files
> diff --git a/tests/generic/046 b/tests/generic/046
> index 5a894b8..882cb09 100755
> --- a/tests/generic/046
> +++ b/tests/generic/046
> @@ -43,6 +43,7 @@ _require_scratch
>  _require_scratch_shutdown
>  _require_fiemap
>  _scratch_mkfs >/dev/null 2>&1
> +_require_metadata_journaling $SCRATCH_DEV
>  _scratch_mount
>  
>  # create files
> diff --git a/tests/generic/047 b/tests/generic/047
> index 631dc1e..d7e4610 100755
> --- a/tests/generic/047
> +++ b/tests/generic/047
> @@ -44,6 +44,7 @@ _require_scratch
>  _require_scratch_shutdown
>  _require_fiemap
>  _scratch_mkfs >/dev/null 2>&1
> +_require_metadata_journaling $SCRATCH_DEV
>  _scratch_mount
>  
>  _check_files()
> diff --git a/tests/generic/048 b/tests/generic/048
> index 51d7efd..3f0bcc1 100755
> --- a/tests/generic/048
> +++ b/tests/generic/048
> @@ -44,6 +44,7 @@ _require_scratch
>  _require_scratch_shutdown
>  _require_fiemap
>  _scratch_mkfs >/dev/null 2>&1
> +_require_metadata_journaling $SCRATCH_DEV
>  _scratch_mount
>  
>  # Do we have enough space on disk?  10G
> diff --git a/tests/generic/049 b/tests/generic/049
> index 1299242..1f2a4b2 100755
> --- a/tests/generic/049
> +++ b/tests/generic/049
> @@ -44,6 +44,7 @@ _require_scratch
>  _require_scratch_shutdown
>  _require_fiemap
>  _scratch_mkfs >/dev/null 2>&1
> +_require_metadata_journaling $SCRATCH_DEV
>  _scratch_mount
>  
>  _check_files()
> diff --git a/tests/generic/051 b/tests/generic/051
> index 7b807b9..29ac61b 100755
> --- a/tests/generic/051
> +++ b/tests/generic/051
> @@ -55,6 +55,7 @@ _require_command "$KILLALL_PROG" killall
>  rm -f $seqres.full
>  
>  _scratch_mkfs > $seqres.full 2>&1
> +_require_metadata_journaling $SCRATCH_DEV
>  _scratch_mount
>  
>  SLEEP_TIME=$((30 * $TIME_FACTOR))
> diff --git a/tests/generic/052 b/tests/generic/052
> index f7cdd09..65d430d 100755
> --- a/tests/generic/052
> +++ b/tests/generic/052
> @@ -53,6 +53,7 @@ _require_logstate
>  echo "mkfs"
>  _scratch_mkfs >>$seqres.full 2>&1 \
>      || _fail "mkfs scratch failed"
> +_require_metadata_journaling $SCRATCH_DEV
>  
>  echo "mount"
>  _scratch_mount >>$seqres.full 2>&1 \
> diff --git a/tests/generic/054 b/tests/generic/054
> index 8375e57..4d4be59 100755
> --- a/tests/generic/054
> +++ b/tests/generic/054
> @@ -50,6 +50,9 @@ _require_logstate
>  echo "*** init FS"
>  _scratch_unmount >/dev/null 2>&1
>  
> +_scratch_mkfs >/dev/null 2>&1
> +_require_metadata_journaling $SCRATCH_DEV
> +
>  _get_log_configs > $tmp.seq.params
>  
>  # Do the work for various log params which
> diff --git a/tests/generic/055 b/tests/generic/055
> index 207c007..aed3b28 100755
> --- a/tests/generic/055
> +++ b/tests/generic/055
> @@ -79,6 +79,9 @@ QUOTA_OPTION=`_get_quota_option`
>  echo "*** init FS"
>  _scratch_unmount >/dev/null 2>&1
>  
> +_scratch_mkfs >/dev/null 2>&1
> +_require_metadata_journaling $SCRATCH_DEV
> +
>  _get_log_configs > $tmp.seq.params
>  
>  cat $tmp.seq.params \
> diff --git a/tests/generic/388 b/tests/generic/388
> index 3729aa5..2760208 100755
> --- a/tests/generic/388
> +++ b/tests/generic/388
> @@ -62,6 +62,7 @@ rm -f $seqres.full
>  echo "Silence is golden."
>  
>  _scratch_mkfs >> $seqres.full 2>&1
> +_require_metadata_journaling $SCRATCH_DEV
>  _scratch_mount || _fail "mount failed"
>  
>  for i in $(seq 1 50); do
> diff --git a/tests/generic/392 b/tests/generic/392
> index b8af8a0..6922f7d 100755
> --- a/tests/generic/392
> +++ b/tests/generic/392
> @@ -53,6 +53,7 @@ _require_scratch_shutdown
>  _require_xfs_io_command "fpunch"
>  
>  _scratch_mkfs >/dev/null 2>&1
> +_require_metadata_journaling $SCRATCH_DEV
>  _scratch_mount
>  
>  testfile=$SCRATCH_MNT/testfile
> -- 
> 2.9.3
> 

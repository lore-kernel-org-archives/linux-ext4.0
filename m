From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] shared/272: fail quickly on mkfs errors and improve
 logging
Date: Fri, 3 Oct 2014 14:36:11 +1000
Message-ID: <20141003043611.GK24490@dastard>
References: <20140930195004.GB5803@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:15767 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751847AbaJCEgP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Oct 2014 00:36:15 -0400
Content-Disposition: inline
In-Reply-To: <20140930195004.GB5803@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 30, 2014 at 03:50:04PM -0400, Eric Whitney wrote:
> 272 will log diagnostic information if it fails to make its scratch file
> system, but the test itself won't fail immediately.  If the scratch
> device had previously contained a valid filesystem, and the attempt to
> make a small scratch file system on it fails, 272 will mount and run on
> the pre-existing file system (as seen during ext4 inline data testing).
> Since 272 tests to ENOSPC, it can take a long time to learn mkfs failed.
> This behavior can also lead to invalid positive test results unless
> 272.full is examined separately.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> ---
>  tests/shared/272 | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/shared/272 b/tests/shared/272
> index 4417535..9695e59 100755
> --- a/tests/shared/272
> +++ b/tests/shared/272
> @@ -87,8 +87,11 @@ _supported_os Linux
>  _need_to_be_root
>  _require_scratch
>  
> -_scratch_mkfs_sized $((64 * 1024 * 1024)) >> $seqres.full 2>&1
> -_scratch_mount
> +rm -f $seqres.full
> +
> +_scratch_mkfs_sized $((64 * 1024 * 1024)) >> $seqres.full 2>&1 \
> +	|| _fail "mkfs failed"
> +_scratch_mount >> $seqres.full 2>&1 || _fail "mount failed"

Let's not have an unending stream of patches to make this same
change to every test that calls _scratch_mkfs or scratch_mount.

If you need more debug output from them if they fail, please put it
inside the low level _scratch_mkfs_$FSTYP functions themselves, as
they already capture errors and dump debug to $seqres.full.

And we've had the discussion in the past about failing if
scratch_mkfs fails. It came down on the side of "unless there's a
specific reason for failing the test, it should still run to give us
as much coverage as possible". e.g  a failed mkfs can result in the
test exercising error paths being exercised that wouldn't otherwise
be tested....

The case you have here (filling the fs can take ages) is a good
reason for terminating the test if _scratch_mkfs_sized fails, but in
general we really want the tests to run if at all possible...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] 285: Fix test for ext4 in some configurations
Date: Fri, 31 May 2013 08:30:00 +1000
Message-ID: <20130530223000.GQ29466@dastard>
References: <1369917939-22660-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:29408 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140Ab3E3Wa1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 May 2013 18:30:27 -0400
Content-Disposition: inline
In-Reply-To: <1369917939-22660-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 30, 2013 at 02:45:37PM +0200, Jan Kara wrote:
> In some configurations (e.g. 1 KB block size), ext4 can decide it is
> better to zero out several blocks rather than splitting unwritten
> extent. This changes results SEEK_HOLE / SEEK_DATA returns and thus the
> test fails. Fix the problem by disabling the feature for this test.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  tests/generic/285 | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tests/generic/285 b/tests/generic/285
> index b700a15..8078b1c 100755
> --- a/tests/generic/285
> +++ b/tests/generic/285
> @@ -46,6 +46,12 @@ BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
>  
>  [ -x $here/src/seek_sanity_test ] || _notrun "seek_sanitfy_tester not built"
>  
> +# Disable extent zeroing for ext4 as that change where holes are created
> +if [ "$FSTYP" = "ext4" ]; then
> +	DEV=`basename $TEST_DEV`
> +	echo 0 >/sys/fs/ext4/$DEV/extent_max_zeroout_kb
> +fi

would that be better going into _require_seek_data_hole so that 286
also picks up this behaviour for ext4?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

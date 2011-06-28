From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3 v2] XFS TESTS: Fix 252 Failure: Update 252 Golden
 Output
Date: Tue, 28 Jun 2011 15:09:00 +1000
Message-ID: <20110628050900.GL32466@dastard>
References: <1309235247-32650-1-git-send-email-achender@linux.vnet.ibm.com>
 <1309235247-32650-3-git-send-email-achender@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:44125 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756122Ab1F1FJD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jun 2011 01:09:03 -0400
Content-Disposition: inline
In-Reply-To: <1309235247-32650-3-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 27, 2011 at 09:27:26PM -0700, Allison Henderson wrote:
> New filtered golden output for test 252
> 
> Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
> ---
> :100644 100644 930c924... fcfd121... M	252.out
>  252.out |  272 +++++++++++++++++++++++++++++++++++++++------------------------
>  1 files changed, 170 insertions(+), 102 deletions(-)
> 
> diff --git a/252.out b/252.out
> index 930c924..fcfd121 100644
> --- a/252.out
> +++ b/252.out
> @@ -1,239 +1,307 @@
>  QA output created by 252
>  	1. into a hole
> +daa100df6e6711906b61c9ab5aa16032
>  	2. into allocated space
> -0: [0..7]: data
> +0: [0..7]: extent
>  1: [8..23]: hole
> -2: [24..39]: data
> +2: [24..39]: extent
> +cc58a7417c2d7763adc45b6fcd3fa024

I don't really like the way this weakens the test for XFS. With this
change, the test no longer is checking that unwritten extent
behaviour is correct.

Rather than weakening the test, perhaps it would be better to
execute 252 for XFS only (with the md5sums added), and then
duplicate it to a new test for all filesystems to run with the
weaker result checking that using the new filter function gives us.
With the amount of common code the two tests share, it should be
trivial to do this....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

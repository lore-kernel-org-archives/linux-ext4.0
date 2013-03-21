From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 299-305: remove fio config files after finished
 test
Date: Thu, 21 Mar 2013 12:09:02 +1100
Message-ID: <20130321010902.GH17758@dastard>
References: <1363685450-27452-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:28263 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753916Ab3CUBJN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Mar 2013 21:09:13 -0400
Content-Disposition: inline
In-Reply-To: <1363685450-27452-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 19, 2013 at 05:30:50PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> After finished test, temporarily fio config file should be removed.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  299 | 2 +-
>  300 | 2 +-
>  301 | 2 +-
>  302 | 2 +-
>  303 | 2 +-
>  304 | 2 +-
>  305 | 1 +
>  7 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/299 b/299
> index 4305ead..9d0c32f 100644
> --- a/299
> +++ b/299
> @@ -32,7 +32,7 @@ echo "QA output created by $seq"
>  here=`pwd`
>  tmp=/tmp/$$
>  status=1	# failure is the default!
> +trap "rm -f $tmp.*; rm -f $tmp-$seq.fio; exit \$status" 0 1 2 3 15

Umm, wouldn't this be better:

-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "rm -f $tmp*; exit \$status" 0 1 2 3 15


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

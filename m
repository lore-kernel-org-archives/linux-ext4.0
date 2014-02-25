From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfstests: Define fallocate flags locally in fsx
Date: Wed, 26 Feb 2014 07:39:22 +1100
Message-ID: <20140225203922.GC13647@dastard>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
 <1393355728-12056-5-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:38241 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752259AbaBYUjf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Feb 2014 15:39:35 -0500
Content-Disposition: inline
In-Reply-To: <1393355728-12056-5-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 25, 2014 at 08:15:27PM +0100, Lukas Czerner wrote:
> Define fallocate flags such as FALLOC_FL_PUNCH_HOLE and
> FALLOC_FL_ZERO_RANGE locally if they do not exist.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  ltp/fsx.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index b3c30db..331257e 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -35,8 +35,13 @@
>  #endif
>  #ifdef FALLOCATE
>  #include <linux/falloc.h>
> +#ifndef FALLOC_FL_PUNCH_HOLE
> +#define FALLOC_FL_PUNCH_HOLE    0x02 /* de-allocates range */
> +#endif
> +#ifndef FALLOC_FL_ZERO_RANGE
> +#define FALLOC_FL_ZERO_RANGE    0x10 /* zeroes range */
> +#endif
>  #endif

This pattern is appearing all over the place in xfstests now.  I'd
suggest that this should really be handled by autoconf,
include/config.h and src/globals.h....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

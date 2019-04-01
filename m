Return-Path: <SRS0=tO+/=SD=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80BF5C43381
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Apr 2019 05:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57C5720828
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Apr 2019 05:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfDAFDE (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 1 Apr 2019 01:03:04 -0400
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:30778 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725817AbfDAFDD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Apr 2019 01:03:03 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail03.adl6.internode.on.net with ESMTP; 01 Apr 2019 15:32:57 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1hAp5z-0004MY-CL; Mon, 01 Apr 2019 16:02:55 +1100
Date:   Mon, 1 Apr 2019 16:02:55 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, axboe@fb.com, prakash.v@samsung.com,
        anshul@samsung.com, joshiiitr@gmail.com
Subject: Re: [PATCH v3 1/7] block: extend stream count for in-kernel use
Message-ID: <20190401050255.GP23020@dastard>
References: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
 <CGME20190329075743epcas1p12f1d290e65ddf84eb74ed94a5ae6eb74@epcas1p1.samsung.com>
 <1553846032-4451-2-git-send-email-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1553846032-4451-2-git-send-email-joshi.k@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Mar 29, 2019 at 01:23:46PM +0530, Kanchan Joshi wrote:
> This patch bumps up stream count to suppor in-kernel hints. It also
> adds 'streamid' member in 'request' and declares new API for driver
> to register stream-info with block layer.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  include/linux/blkdev.h | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 338604d..4088e21 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -214,6 +214,7 @@ struct request {
>  #endif
>  
>  	unsigned short write_hint;
> +	unsigned short streamid;
>  	unsigned short ioprio;
>  
>  	void *special;		/* opaque pointer available for LLD use */
> @@ -341,6 +342,8 @@ struct queue_limits {
>  	unsigned char		misaligned;
>  	unsigned char		discard_misaligned;
>  	unsigned char		raid_partial_stripes_expensive;
> +
> +	unsigned short		nr_streams;
>  	enum blk_zoned_model	zoned;
>  };
>  
> @@ -567,8 +570,9 @@ struct request_queue {
>  	size_t			cmd_size;
>  
>  	struct work_struct	release_work;
> -
> -#define BLK_MAX_WRITE_HINTS	5
> +#define BLK_MAX_USER_HINTS	(WRITE_LIFE_KERN_MIN - 2)

WRITE_LIFE_KERN_MIN is undefined.

-Dave.

> +#define BLK_MAX_KERN_HINTS	4
> +#define BLK_MAX_WRITE_HINTS	(1 + BLK_MAX_USER_HINTS + BLK_MAX_KERN_HINTS)
>  	u64			write_hints[BLK_MAX_WRITE_HINTS];
>  };
>  
> @@ -1071,6 +1075,7 @@ extern void blk_queue_update_dma_alignment(struct request_queue *, int);
>  extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
>  extern void blk_queue_flush_queueable(struct request_queue *q, bool queueable);
>  extern void blk_queue_write_cache(struct request_queue *q, bool enabled, bool fua);
> +extern void blk_queue_stream_limits(struct request_queue *, unsigned short);
>  
>  /*
>   * Number of physical segments as sent to the device.
> -- 
> 2.7.4
> 
> 

-- 
Dave Chinner
david@fromorbit.com

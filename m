From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH 5/8] nowait aio: return on congested block device
Date: Wed, 8 Mar 2017 09:03:08 +0200
Message-ID: <0d1ba678-69c0-16ce-6c3e-475cd8da203c@grimberg.me>
References: <20170228233610.25456-1-rgoldwyn@suse.de>
 <20170228233610.25456-6-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, jack@suse.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34926 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751226AbdCHHFW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Mar 2017 02:05:22 -0500
In-Reply-To: <20170228233610.25456-6-rgoldwyn@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> -		if (likely(blk_queue_enter(q, false) == 0)) {
> +		if (likely(blk_queue_enter(q, bio_flagged(bio, BIO_NOWAIT)) == 0)) {
>  			ret = q->make_request_fn(q, bio);

I think that for ->make_request to not block we'd need to set
BLK_MQ_REQ_NOWAIT in blk_mq_alloc_data to avoid blocking on a tag
allocation.

Something like the untested addition below:
--
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 09af8ff18719..40e78b57fb44 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -119,6 +119,9 @@ struct request *blk_mq_sched_get_request(struct 
request_queue *q,
         if (likely(!data->hctx))
                 data->hctx = blk_mq_map_queue(q, data->ctx->cpu);

+       if (likely(bio) && bio_flagged(bio, BIO_NOWAIT))
+               data->flags |= BLK_MQ_REQ_NOWAIT;
+
         if (e) {
                 data->flags |= BLK_MQ_REQ_INTERNAL;
--

Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C34C6C10F0E
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 14:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F1AD2083D
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 14:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389238AbfDROGI (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:06:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:49434 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388392AbfDROGI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Apr 2019 10:06:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 96984AF1C;
        Thu, 18 Apr 2019 14:06:06 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 8DC201E15AE; Thu, 18 Apr 2019 16:06:03 +0200 (CEST)
Date:   Thu, 18 Apr 2019 16:06:03 +0200
From:   Jan Kara <jack@suse.cz>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, prakash.v@samsung.com
Subject: Re: [PATCH v4 4/7] block: introduce write-hint to stream-id
 conversion
Message-ID: <20190418140603.GL28541@quack2.suse.cz>
References: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
 <CGME20190417175358epcas1p41a0a4e349dfe0a70bdcc244161c71604@epcas1p4.samsung.com>
 <1555523406-2380-5-git-send-email-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1555523406-2380-5-git-send-email-joshi.k@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed 17-04-19 23:20:03, Kanchan Joshi wrote:
> This patch moves write-hint-to-stream-id conversion in block-layer.
> Earlier this was done by driver (nvme). Current conversion is of the
> form "streamid = write-hint - 1", for both user and kernel streams.
> Conversion takes stream limit (maintained in request queue) into
> account. Write-hints beyond the exposed limit turn to 0.
> A new field 'streamid' has been added in request. While 'write-hint'
> field continues to exist. It keeps original value passed from upper
> layer, and used during merging checks.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  block/blk-core.c       | 20 ++++++++++++++++++++
>  include/linux/blkdev.h |  1 +
>  2 files changed, 21 insertions(+)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index a55389b..712e6b7 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -730,6 +730,25 @@ bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
>  	return false;
>  }
>  
> +enum rw_hint blk_write_hint_to_streamid(struct request *req,
> +				        struct bio *bio)
> +{
> +	enum rw_hint streamid, nr_streams;
> +	struct request_queue *q = req->q;
> +	nr_streams = q->limits.nr_streams;
> +
> +	streamid = bio->bi_write_hint;
> +	if (!nr_streams || streamid == WRITE_LIFE_NOT_SET ||
> +	    streamid == WRITE_LIFE_NONE)
> +		streamid = 0;
> +	else {
> +		--streamid;
> +		if(streamid > nr_streams)
> +			streamid = 0;
> +	}
> +	return streamid;
> +}
> +

Someone told me that stream ids are potentially persistent on the storage
so it isn't great to change the id for the same thing e.g. if we add
another user hint. So maybe we should allocate kernel hints from top as
Dave Chinner suggested? I.e., something like the following mapping function:

	if (streamid <= BLK_MAX_USER_HINTS) {
		streamid--;
		if (streamid > nr_streams)
			streamid = 0;
	} else {
		/* Kernel hints get allocated from top */
		streamid -= WRITE_LIFE_KERN_MIN;
		if (streamid > nr_streams - BLK_MAX_USER_HINTS)
			streamid = 0;
		else
			streamid = nr_streams - streamid - 1;
	}

what do you think?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

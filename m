Return-Path: <SRS0=tO+/=SD=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A11E4C43381
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Apr 2019 05:08:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A24520828
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Apr 2019 05:08:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfDAFI0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 1 Apr 2019 01:08:26 -0400
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:29795 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725784AbfDAFI0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Apr 2019 01:08:26 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail03.adl6.internode.on.net with ESMTP; 01 Apr 2019 15:38:23 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1hApBF-0004N7-IS; Mon, 01 Apr 2019 16:08:21 +1100
Date:   Mon, 1 Apr 2019 16:08:21 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, axboe@fb.com, prakash.v@samsung.com,
        anshul@samsung.com, joshiiitr@gmail.com
Subject: Re: [PATCH v3 3/7] block: add write-hint to stream-id conversion
Message-ID: <20190401050821.GQ23020@dastard>
References: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
 <CGME20190329075749epcas2p22b85cbdbb7ccb4f7f3ecf69b84f75dc9@epcas2p2.samsung.com>
 <1553846032-4451-4-git-send-email-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1553846032-4451-4-git-send-email-joshi.k@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Mar 29, 2019 at 01:23:48PM +0530, Kanchan Joshi wrote:
> Earlier this conversion was done by driver (nvme). Current conversion
> is of the form "streamid = write-hint - 1", for both user and kernel
> streams (note that existing infra takes care that user-streams do not
> bump into kernel ones).

Unless we add new user streams, then all the kernel streams change
ID. I'll deal with this in more detail in a later patch.

> Conversion takes stream limit (maintained in
> request queue) into account. Write-hints beyond the queue-limit turn
> to 0.
> New field 'streamid' has been added in request. While 'write-hint' field
> continues to exist. It keeps original value passed from upper layer, and
> used during merging checks.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  block/blk-core.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 3c5f61c..c86daed 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -727,6 +727,25 @@ bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
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

What's this magic thing do?

> +		if(streamid > nr_streams)
> +			streamid = 0;

So, basically, we'll compress all the kernel hints down to "no hint"
if there are more user streams than the device supports?

Surely we should be reserving a stream for the kernel hints separate
from the user and "none" streams when we have limited device streams
available...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

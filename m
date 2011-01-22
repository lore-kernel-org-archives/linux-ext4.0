From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/3] block: reimplement FLUSH/FUA to support merge
Date: Fri, 21 Jan 2011 19:49:55 -0500
Message-ID: <20110122004955.GA17792@redhat.com>
References: <1295625598-15203-1-git-send-email-tj@kernel.org>
 <1295625598-15203-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, tytso@mit.edu, djwong@us.ibm.com, shli@kernel.org,
	neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
	linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
	josef@redhat.com
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab1AVAuy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jan 2011 19:50:54 -0500
Content-Disposition: inline
In-Reply-To: <1295625598-15203-4-git-send-email-tj@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 21 2011 at 10:59am -0500,
Tejun Heo <tj@kernel.org> wrote:

> diff --git a/block/blk-flush.c b/block/blk-flush.c
> index 8592869..cd73e93 100644
> --- a/block/blk-flush.c
> +++ b/block/blk-flush.c
> @@ -1,6 +1,69 @@
>  /*
>   * Functions to sequence FLUSH and FUA writes.
> + *
> + * Copyright (C) 2011		Max Planck Institute for Gravitational Physics
> + * Copyright (C) 2011		Tejun Heo <tj@kernel.org>
> + *
> + * This file is released under the GPLv2.
> + *
> + * REQ_{FLUSH|FUA} requests are decomposed to sequences consisted of three
> + * optional steps - PREFLUSH, DATA and POSTFLUSH - according to the request
> + * properties and hardware capability.
> + *
> + * If a request doesn't have data, only REQ_FLUSH makes sense, which
> + * indicates a simple flush request.  If there is data, REQ_FLUSH indicates
> + * that the device cache should be flushed before the data is executed, and
> + * REQ_FUA means that the data must be on non-volatile media on request
> + * completion.
> + *
> + * If the device doesn't have writeback cache, FLUSH and FUA don't make any
> + * difference.  The requests are either completed immediately if there's no
> + * data or executed as normal requests otherwise.

For devices without a writeback cache, I'm not seeing where pure flushes
are completed immediately.  But I do see where data is processed
directly in blk_insert_flush().


> -struct request *blk_do_flush(struct request_queue *q, struct request *rq)
> +/**
> + * blk_abort_flush - @q is being aborted, abort flush requests
      ^^^^^^^^^^^^^^^ 
Small comment nit, s/blk_abort_flush/blk_abort_flushes/

> + * @q: request_queue being aborted
> + *
> + * To be called from elv_abort_queue().  @q is being aborted.  Prepare all
> + * FLUSH/FUA requests for abortion.
> + *
> + * CONTEXT:
> + * spin_lock_irq(q->queue_lock)
> + */
> +void blk_abort_flushes(struct request_queue *q)

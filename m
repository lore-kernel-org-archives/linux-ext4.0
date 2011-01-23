From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] block: reimplement FLUSH/FUA to support merge
Date: Sun, 23 Jan 2011 11:31:33 +0100
Message-ID: <20110123103133.GC23121@htj.dyndns.org>
References: <1295625598-15203-1-git-send-email-tj@kernel.org>
 <1295625598-15203-4-git-send-email-tj@kernel.org>
 <20110122004955.GA17792@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, tytso@mit.edu, djwong@us.ibm.com, shli@kernel.org,
	neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
	linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
	josef@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59609 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1AWKbi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Jan 2011 05:31:38 -0500
Content-Disposition: inline
In-Reply-To: <20110122004955.GA17792@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 21, 2011 at 07:49:55PM -0500, Mike Snitzer wrote:
> > + * If the device doesn't have writeback cache, FLUSH and FUA don't make any
> > + * difference.  The requests are either completed immediately if there's no
> > + * data or executed as normal requests otherwise.
> 
> For devices without a writeback cache, I'm not seeing where pure flushes
> are completed immediately.  But I do see where data is processed
> directly in blk_insert_flush().

Yeah, it does.  Pure flushes on a device w/o writeback cache, @policy
is zero and blk_flush_complete_seq() will directly proceed to
REQ_FSEQ_DONE.

> > -struct request *blk_do_flush(struct request_queue *q, struct request *rq)
> > +/**
> > + * blk_abort_flush - @q is being aborted, abort flush requests
>       ^^^^^^^^^^^^^^^ 
> Small comment nit, s/blk_abort_flush/blk_abort_flushes/

Thanks.

-- 
tejun

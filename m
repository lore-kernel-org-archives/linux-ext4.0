From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] direct-io: move aio_complete into ->end_io
Date: Fri, 25 Jun 2010 12:35:50 +0200
Message-ID: <20100625103550.GA3586@quack.suse.cz>
References: <20100622122144.302857146@bombadil.infradead.org>
 <20100622123113.011371666@bombadil.infradead.org>
 <20100624215922.GE3345@quack.suse.cz>
 <20100625063610.GA4128@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33201 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab0FYKgR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jun 2010 06:36:17 -0400
Content-Disposition: inline
In-Reply-To: <20100625063610.GA4128@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 25-06-10 02:36:10, Christoph Hellwig wrote:
> On Thu, Jun 24, 2010 at 11:59:22PM +0200, Jan Kara wrote:
> >   Moreover the async testing you do does not seem to be completely right.
> > dio->is_async is a flag that controls whether dio code waits for IO to be
> > completed or not. In particular it is not set for AIO that spans beyond
> > current i_size so it does not seem to be exactly what you need (at least
> > for ext4 it isn't). I think that is_sync_kiocb() is a test that should be
> > used to recognize AIO - and that has an advantage that you don't have to
> > pass the is_async flag around.
> 
> No.  is_sync_kiocb() means the ioctb was not intended as sync I/O from
> the start.  But we can only call aio_complete when we returned
> -EIOCBQUEUED from ->aio_read/write.  Take a look at the comment near the
> end of direct_io_worker().
  Ah, I see. Thanks for explanation. It's ugly but I also don't see a
nicer way how to handle this.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

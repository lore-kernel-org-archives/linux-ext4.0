From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] direct-io: move aio_complete into ->end_io
Date: Fri, 25 Jun 2010 02:36:10 -0400
Message-ID: <20100625063610.GA4128@infradead.org>
References: <20100622122144.302857146@bombadil.infradead.org>
 <20100622123113.011371666@bombadil.infradead.org>
 <20100624215922.GE3345@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100624215922.GE3345@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 24, 2010 at 11:59:22PM +0200, Jan Kara wrote:
>   Umm, I don't get this. Looking at the ->end_io callback it has been
> always called with i_alloc_sem held. It's only aio_complete() which will
> be called with i_alloc_sem held after your changes. Or am I missing
> something?

No, that part of the commit message is flat out wrong.  Not sure what
I was thinking when I wrote it.

>   Moreover the async testing you do does not seem to be completely right.
> dio->is_async is a flag that controls whether dio code waits for IO to be
> completed or not. In particular it is not set for AIO that spans beyond
> current i_size so it does not seem to be exactly what you need (at least
> for ext4 it isn't). I think that is_sync_kiocb() is a test that should be
> used to recognize AIO - and that has an advantage that you don't have to
> pass the is_async flag around.

No.  is_sync_kiocb() means the ioctb was not intended as sync I/O from
the start.  But we can only call aio_complete when we returned
-EIOCBQUEUED from ->aio_read/write.  Take a look at the comment near the
end of direct_io_worker().

AIO beyond i_size is not supported using blockdev_direct_IO yet.  I
think I can add it fairly easily for XFS, but that will require
passing a new DIO_* flag to __blockdev_direct_IO which will make
is_async true for writes beyond i_size.


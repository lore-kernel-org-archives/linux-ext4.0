From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/4] fs: Provide function to unmap metadata for a range
 of blocks
Date: Mon, 24 Oct 2016 13:45:40 +0200
Message-ID: <20161024114540.GE1108@quack2.suse.cz>
References: <1477050941-29682-1-git-send-email-jack@suse.cz>
 <1477050941-29682-2-git-send-email-jack@suse.cz>
 <20161021120542.GA20475@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161021120542.GA20475@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 21-10-16 05:05:42, Christoph Hellwig wrote:
> > + * Functionally, this is like unmap_underlying_metadata() for a range of
> > + * blocks. It is implemented to be more efficient for larger ranges of blocks
> > + * though.
> > + */
> > +void unmap_underlying_metadata_ext(struct block_device *bdev, sector_t block,
> > +				   sector_t len)
> 
> Please explain what it does and why you'd call it.  And while we're

OK.

> naming I think the 'metadata' part is highly confusing.  What it does
> is to clear buffers from the block device mapping, nothing about
> metadata really.
> 
> So how about unmap_buffers_range or similar?

I can rename the function but I wanted to be consistent with
unmap_underlying_metadata() function. It seems strange to have a function
for a single block and a function for a range of blocks with very different
names...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

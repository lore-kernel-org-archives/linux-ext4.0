From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] fs: Provide function to unmap metadata for a range
 of blocks
Date: Fri, 21 Oct 2016 05:05:42 -0700
Message-ID: <20161021120542.GA20475@infradead.org>
References: <1477050941-29682-1-git-send-email-jack@suse.cz>
 <1477050941-29682-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1477050941-29682-2-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> + * Functionally, this is like unmap_underlying_metadata() for a range of
> + * blocks. It is implemented to be more efficient for larger ranges of blocks
> + * though.
> + */
> +void unmap_underlying_metadata_ext(struct block_device *bdev, sector_t block,
> +				   sector_t len)

Please explain what it does and why you'd call it.  And while we're
naming I think the 'metadata' part is highly confusing.  What it does
is to clear buffers from the block device mapping, nothing about
metadata really.

So how about unmap_buffers_range or similar?

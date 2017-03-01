From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] nowait aio: return if direct write will trigger
 writeback
Date: Wed, 1 Mar 2017 07:38:57 -0800
Message-ID: <20170301153857.GC30631@infradead.org>
References: <20170228233610.25456-1-rgoldwyn@suse.de>
 <20170228233610.25456-4-rgoldwyn@suse.de>
 <20170301034606.GK16328@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, jack@suse.com,
        hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
To: Matthew Wilcox <willy@infradead.org>
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170301034606.GK16328@bombadil.infradead.org>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 28, 2017 at 07:46:06PM -0800, Matthew Wilcox wrote:
> Ugh, this is pretty inefficient.  If that's all you want to know, then
> using the radix tree directly will be far more efficient than spinning
> up all the pagevec machinery only to discard the pages found.
> 
> But what's going to kick these pages out of cache?  Shouldn't we rather
> find the pages, kick them out if clean, start writeback if not, and *then*
> return -EAGAIN?
> 
> So maybe we want to spin up the pagevec machinery after all so we can
> do that extra work?

As pointed out in the last round of these patches I think we really
need to pass a flags argument to filemap_write_and_wait_range to
communicate the non-blocking nature and only return -EAGAIN if we'd
block.  As a bonus that can indeed start to kick the pages out.

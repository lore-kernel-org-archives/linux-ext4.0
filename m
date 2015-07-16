From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] fs: Remove ext3 filesystem driver
Date: Thu, 16 Jul 2015 11:41:01 +0200
Message-ID: <20150716094101.GI22847@quack.suse.cz>
References: <1436955987-7305-1-git-send-email-jack@suse.com>
 <1436955987-7305-3-git-send-email-jack@suse.com>
 <20150715095822.f994bc58.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>, Ted Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150715095822.f994bc58.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 15-07-15 09:58:22, Andrew Morton wrote:
> On Wed, 15 Jul 2015 12:26:26 +0200 Jan Kara <jack@suse.com> wrote:
> 
> > From: Jan Kara <jack@suse.cz>
> > 
> > The functionality of ext3 is fully supported by ext4 driver. Major
> > distributions (SUSE, RedHat) already use ext4 driver to handle ext3
> > filesystems for quite some time. There is some ugliness in mm resulting
> > from jbd cleaning buffers in a dirty page without cleaning page dirty
> > bit and also support for buffer bouncing in the block layer when stable
> > pages are required is there only because of jbd. So let's remove the
> > ext3 driver.
> 
> Does this imply that ext4 doesn't do the
> secretly-clean-the-page-via-buffers thing?  If so, how?

The biggest offender which was cleaning pages via buffers was JBD commit
code writing back data=ordered buffers. I have modified JBD2 to do this
via generic_writepages() instead of through buffer heads (which required
locking overhaul in JBD2). So JBD2 doesn't do this for quite a few years.

That being said, JBD2 checkpointing code will still clean pages via buffer
heads so blockdev mapping may still have silently cleaned pages. And in
data=journal mode this can be the case even for other mappings. In these
cases, locking isn't luckily an issue and fixing this is relatively
straightforward. I'm just looking for an elegant way to do this inside JBD2
- I'm hoping for something better than just get page from bh, lock it and
call clear_page_dirty_for_io() and ->writepage(). It works but looks
ugly...

> The comment in shrink_page_list() says the blockdev mapping will do
> this as well, although I can't imagine how - there's no means of
> getting to those buffer_heads except via the page.  So maybe the "even
> if the page is PageDirty()" is no longer true.  It was added by:
> 
> commit 493f4988d640a73337df91f2c63e94c78ecd5e97
> Author: Andrew Morton <akpm@zip.com.au>
> Date:   Mon Jun 17 20:20:53 2002 -0700
> 
>     [PATCH] allow GFP_NOFS allocators to perform swapcache writeout
>     
>     One weakness which was introduced when the buffer LRU went away was
>     that GFP_NOFS allocations became equivalent to GFP_NOIO.  Because all
>     writeback goes via writepage/writepages, which requires entry into the
>     filesystem.
>     
>     However now that swapout no longer calls bmap(), we can honour
>     GFP_NOFS's intent for swapcache pages.  So if the allocation request
>     specifies __GFP_IO and !__GFP_FS, we can wait on swapcache pages and we
>     can perform swapcache writeout.
>     
>     This should strengthen the VM somewhat.
> 
> I wonder what I was thinking.

Well, e.g. sync_mapping_buffers() from fs/buffer.c will write out buffer
heads without cleaning the page. So does the checkpointing code in
JBD/JBD2. So for blockdev mappings, this really happens rather frequently
I'd say.

> Also, what's the status of ext4's data=journal?  It's the hardest ext3
> mode for the rest of the kernel to support and I suspect hardly anyone
> uses it.

As this thread shows, there are people using it (and I occasionally see bug
reports for it as well). It would simplify things if we could get rid of it
but I don't think it's currently an option...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

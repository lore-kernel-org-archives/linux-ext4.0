From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] fs: Remove ext3 filesystem driver
Date: Wed, 15 Jul 2015 09:58:22 -0700
Message-ID: <20150715095822.f994bc58.akpm@linux-foundation.org>
References: <1436955987-7305-1-git-send-email-jack@suse.com>
	<1436955987-7305-3-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>, Ted Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
To: Jan Kara <jack@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436955987-7305-3-git-send-email-jack@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 15 Jul 2015 12:26:26 +0200 Jan Kara <jack@suse.com> wrote:

> From: Jan Kara <jack@suse.cz>
> 
> The functionality of ext3 is fully supported by ext4 driver. Major
> distributions (SUSE, RedHat) already use ext4 driver to handle ext3
> filesystems for quite some time. There is some ugliness in mm resulting
> from jbd cleaning buffers in a dirty page without cleaning page dirty
> bit and also support for buffer bouncing in the block layer when stable
> pages are required is there only because of jbd. So let's remove the
> ext3 driver.

Does this imply that ext4 doesn't do the
secretly-clean-the-page-via-buffers thing?  If so, how?

The comment in shrink_page_list() says the blockdev mapping will do
this as well, although I can't imagine how - there's no means of
getting to those buffer_heads except via the page.  So maybe the "even
if the page is PageDirty()" is no longer true.  It was added by:

commit 493f4988d640a73337df91f2c63e94c78ecd5e97
Author: Andrew Morton <akpm@zip.com.au>
Date:   Mon Jun 17 20:20:53 2002 -0700

    [PATCH] allow GFP_NOFS allocators to perform swapcache writeout
    
    One weakness which was introduced when the buffer LRU went away was
    that GFP_NOFS allocations became equivalent to GFP_NOIO.  Because all
    writeback goes via writepage/writepages, which requires entry into the
    filesystem.
    
    However now that swapout no longer calls bmap(), we can honour
    GFP_NOFS's intent for swapcache pages.  So if the allocation request
    specifies __GFP_IO and !__GFP_FS, we can wait on swapcache pages and we
    can perform swapcache writeout.
    
    This should strengthen the VM somewhat.

I wonder what I was thinking.



Also, what's the status of ext4's data=journal?  It's the hardest ext3
mode for the rest of the kernel to support and I suspect hardly anyone
uses it.

> 46 files changed, 54 insertions(+), 28109 deletions(-)

Heroic. 

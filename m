From: Christoph Lameter <clameter@sgi.com>
Subject: Re: [36/37] Large blocksize support for ext2
Date: Wed, 20 Jun 2007 14:27:22 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0706201425050.31425@schroedinger.engr.sgi.com>
References: <20070620182907.506775016@sgi.com> <20070620183014.438784820@sgi.com>
 <20070620205602.GI5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
	William Lee Irwin III <wli@holomorphy.com>,
	David Chinner <dgc@sgi.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Badari Pulavarty <pbadari@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070620205602.GI5181@schatzie.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 20 Jun 2007, Andreas Dilger wrote:

> On Jun 20, 2007  11:29 -0700, clameter@sgi.com wrote:
> > This adds support for a block size of up to 64k on any platform.
> > It enables the mounting filesystems that have a larger blocksize
> > than the page size.
> 
> Might have been good to CC the ext2/3/4 maintainers here?  I definitely
> have been waiting for a patch like this for ages (so definitely no
> objection from me), but there are a few caveats before this will work
> on ext2/3/4.

The CC list is already big so I thought those would be monitoring 
linux-fsdevel.

> > Hmmm... Actually there is nothing additional to be done after the earlier
> > cleanup of the macros. So just modify copyright.
> 
> It is NOT possible to have 64kB blocksize on ext2/3/4 without some small
> changes to the directory handling code.  The reason is that an empty 64kB
> directory block would have a rec_len == (__u16)2^16 == 0, and this would
> cause an error to be hit in the filesystem.  What is needed is to put
> 2 empty records in such a directory, or to special-case an impossible
> value like rec_len = 0xffff to handle this.
> 
> There was a patch to fix the 64kB blocksize directory problem, but it
> hasn't been merged anywhere yet seeing as there wasn't previously a
> patch to allow larger blocksize...

mke2fs allows to specify a 64kb blocksize and IA64 can run with 64kb 
PAGE_SIZE. So this is a bug in ext2fs that needs to be fixed regardless.

> Having 32kB blocksize has no problems that I'm aware of.  Also, I'm not
> sure how it happened, but ext2 SHOULD have an explicit check (as
> ext3/4 does) limiting it to EXT2_MAX_BLOCK_SIZE.  Otherwise it appears
> that there would be no error reported if the superblock reports e.g. 16MB
> blocksize, and all kinds of things would break.

mke2fs fails for blocksizes > 64k so you are safe there. I'd like to see 
that limit lifted?

> There shouldn't be a problem with increasing EXT{2,3,4}_MAX_BLOCK_SIZE to
> 32kB (AFAIK), but I haven't looked into this in a while.

I'd love to see such a patch. That is also useful for arches that have 
PAGE_SIZE > 4kb without this patchset.


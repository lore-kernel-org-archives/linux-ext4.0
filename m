From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Thu, 19 Dec 2013 08:20:49 -0700
Message-ID: <20131219152049.GB19166@parisc-linux.org>
References: <cover.1387307259.git.matthew.r.wilcox@intel.com> <20131217223050.GB20579@dastard> <20131218023143.GA24491@parisc-linux.org> <20131218050127.GA15289@thunk.org> <20131218142749.GA9207@parisc-linux.org> <20131219020759.GA27469@thunk.org> <20131219041240.GA19166@parisc-linux.org> <20131219054303.GA4391@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131219054303.GA4391@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 19, 2013 at 12:43:03AM -0500, Theodore Ts'o wrote:
> On Wed, Dec 18, 2013 at 09:12:41PM -0700, Matthew Wilcox wrote:
> > Now that I've spent the best part of a day looking at the ext4 code, I
> > still don't think there's a problem here.  With the way the XIP code is
> > currently written (calling ext4_get_block with create=1), we won't get an
> > uninitialised extent in the caller.  Instead, we'll get one that's been
> > zeroed (the zeroing is part of patch 3/3 and done only for xip files).
> 
> If the block was originally allocated via fallocate(2), it will be
> marked as uninitialized.  When you call ext4_get_block(), if the block
> has been allocated, it will be returned --- and ext4_map_block() as
> called by ext4_get_block() does ****not*** clear the uninitialized
> flag.  It can't do so because it would be racy; you can only clear the
> flag once the data blocks has been written.
> 
> As far as patch 3/3, it clears the pages in the page cache, but it
> doesn't zap them in the XIP storage device.  But it only does this on
> the code path when it allocated a block.  But if the block has already
> been previously mapped via fallocate(2), you never hit this section of
> code.

Umm.  That sounds like the real bug then.  Any page returned from
get_xip_mem must be initialised, because we may be about to map it
into userspace.

We could have ext4_get_xip_mem() check buffer_unwritten(); if it's set,
zero the blocks and call ext4_convert_unwritten_extents().  Would that
work?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

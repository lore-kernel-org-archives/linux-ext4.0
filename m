From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Wed, 18 Dec 2013 07:27:49 -0700
Message-ID: <20131218142749.GA9207@parisc-linux.org>
References: <cover.1387307259.git.matthew.r.wilcox@intel.com> <20131217223050.GB20579@dastard> <20131218023143.GA24491@parisc-linux.org> <20131218050127.GA15289@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:48316 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab3LRO1w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Dec 2013 09:27:52 -0500
Content-Disposition: inline
In-Reply-To: <20131218050127.GA15289@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 18, 2013 at 12:01:27AM -0500, Theodore Ts'o wrote:
> On Tue, Dec 17, 2013 at 07:31:43PM -0700, Matthew Wilcox wrote:
> > On Wed, Dec 18, 2013 at 09:30:50AM +1100, Dave Chinner wrote:
> > > No, you haven't addressed the problem. There is nothing in this
> > > patch set that converts an unwritten extent after it is written to.
> > > Hence on every subsequent read will return zeros because the block
> > > is still marked as unwritten.
> > 
> > I don't understand.  Here's the path as I understand it:
> > 
> > xip_file_write -> __xip_file_write -> ext4_get_xip_mem(create=0),
> > returns -ENODATA.  So we call ext4_get_xip_mem again, this time with
> > create=1 which causes ext4_get_block() to allocate blocks.
> 
> When Dave says that the extent is unwritten, what he means is that the
> block as been allocated, but it is marked as being uninitialized.
> Since the block is uninitialized we must not read from that block;
> instead, if the user issues a read request to an uninitialized block,
> we must return all zero's for that block (lest we reveal stale data).
> And if we try to write to an uninitialized block, *after* we write to
> the data block, we have to clear the uninitalized block, which in some
> cases might mean splitting the extent --- if we have an extent which
> maps logical blocks 0 to 5 to physical blocks 100 to 105, and we write
> to block #2, will need to change that single uninitialized extent to
> three extents --- one covering blocks logical blocks 0-1, one covering
> logical block 2, and one covering logical blocks 3-5, where the first
> and third would be marked uninitialized, and the second would be
> marked initialized.  Since we potentially need to convert one extent
> to three extents, this might involve an extent tree node split.

So I think we do all that.  If xip_file_read() sees a block which is
!buffer_mapped, it fills with zeroes.  If xip_file_write() sees a block
which is !buffer_mapped, it asks ext4_get_block to map it by passing
in create=1.  Part of the patch includes zeroing the newly allocated
block under i_data_sem before calling ext4_es_insert_extent(), which I
think is enough to prevent reading stale data.

> You keep talking about allocated vs unallocated, and create=0 and
> create=1, but even for an allocated block, that block may be marked
> initialized or uninitialized --- and if it is marked uninitialized,
> xip_file_write must call a file system-specific callback to allow this
> conversion to take place.

Could you take pity on me and tell me what flags I need to check in the
buffer_head to determine this state of affairs?

> In other words, suppose somone calls fallocate on a 2GB region on an
> XIP mounted file system.  Would you be happy forcing 2GB's worth of
> writes at fallocate time(), just because we don't want to deal with
> adding a file system callback in xip_file_write()?

I think there is a callback in xip_file_write(), and it's get_xip_mem().
>From what you're saying, it sounds like it's just not doing enough.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

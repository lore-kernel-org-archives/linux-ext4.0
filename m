From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH RFC] Insure direct IO writes do not use the page cache
Date: Wed, 29 Jul 2009 14:10:07 -0400
Message-ID: <20090729181007.GC14105@mit.edu>
References: <6601abe90907281728h22be79fenc68a16b578e28a91@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54697 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbZG2SKP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Jul 2009 14:10:15 -0400
Content-Disposition: inline
In-Reply-To: <6601abe90907281728h22be79fenc68a16b578e28a91@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 28, 2009 at 05:28:05PM -0700, Curt Wohlgemuth wrote:
> This insures that direct IO writes to fallocate'd file space do not use the
> page cache.

This isn't a full review, but I haven't found the time to write a
complete summary of all of the issues around direct I/O yet; but since
people are working on the solutions, I thought I'd raise a few issues
that I noticed while doing a quick read-through of the patch.  It's
not a full review, sorry --- ENOTIME.

One thing that we really need to do is in handle_uninit_extent(), but
a comment that it's only going to be used by at the end of direct I/O,
and then put in a call to ext4_handle_sync() to mark the handle as
synchronous.  That way, the DIO write won't return until the journal
transaction which commits the metadata operation is complete.

This is going to make the DIO write performance with a journal have
horrendous performance, but at least it will be correct.
(Specifically, DIO writes have the semantics that if the alignment
constraints are respected, the write is supposed to be synchronous ---
which means that if the write completes, and the system crashes
immediately afterwards, the data has to be accessible after the system
reboots.  If the extent tree change isn't committed, then the written
data won't be visible to userspace, so it might as well be lost.)  I
don't think we need to do anything special in the no journal case,
since by definition without a journal metadata updates aren't
guaranteed to be up to date.

I think I've only mentioned this on the weekly ext4 concall, so let me
fill in the optimizations I have in mind that should hopefully make
DIO less painful when writing into preallocated space. 

1) If extent tree block in question isn't already part of a journalled
transaction, and there is space in the extent block so we don't have
to split the extent tree node (which would require allocating a new
block), we can update the extent block in place, bypassing the
journal.  This will allow us to avoid waiting for the journal commit.

2) We can modify the ext4_ext_convert_to_initialized() to be more
aggressive about initializing data blocks if we know we are doing DIO,
since zero'ing an aligned 16 to 32 blocks and then waiting for the
journal commit once is cheaper than converting the extent one block at
a time and waiting for the journal commit after each block write.

Does that make sense?

       	   	       	   	   	  - Ted

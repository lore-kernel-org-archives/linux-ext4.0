From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix ext4_evict_inode() racing against workqueue
 processing code
Date: Wed, 20 Mar 2013 21:13:55 +0100
Message-ID: <20130320201355.GI13294@quack.suse.cz>
References: <1363742959-12815-1-git-send-email-tytso@mit.edu>
 <5149C452.3070206@redhat.com>
 <20130320144523.GF12865@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756756Ab3CTUN6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Mar 2013 16:13:58 -0400
Content-Disposition: inline
In-Reply-To: <20130320144523.GF12865@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 20-03-13 10:45:23, Ted Tso wrote:
> On Wed, Mar 20, 2013 at 09:14:42AM -0500, Eric Sandeen wrote:
> > 
> > As an aside, is there any reason to have "dioread_nolock" as an option
> > at this point?  If it works now, would you ever *not* want it?
> > 
> > (granted it doesn't work with some journaling options etc, but that
> > behavior could be automatic, w/o the need for special mount options).
> 
> The primary restriction is that diread_nolock doesn't work when fs
> block size != page size.  If your proposal is that we automatically
> enable diread_nolock when we can use it safely, that's definitely
> something to consider for the next merge window.
> 
> My long range plan/hope is that we eventually be able to use the
> extent status tree so that we do allocating writes, we first (a)
> allocate the blocks, and mark them as in use as far as the mballoc
> data structures are concerned, but we do _not_ mark them as in use in
> the on-disk allocation bitmaps, then (b) we write the data blocks, and
> then triggered by the block I/O completion, (c) in a single journal
> trnasaction, we update the allocation bitmaps, update the inode's
> extent tree, and update the inode's i_size field.
> 
> This is different from the dioread_nolock approach in that we're not
> initially inserting the blocks in the extent tree as uninitialized,
> and then convert the extent tree entries from uninit to init after the
> I/O completion.
> 
> If we get to this long-term nirvana, then (1) we can eliminate the
> data=writeback vs data=ordered distiction, since we'll have the safety
> benefits of data=ordered while still having the performance
> characteristics of data=writeback, and (2) we can eliminate
> diread_nolock, since this approach should also obviate needing to take
> the read lock on the direct I/O read path. 
  But this will be somewhat tricky because when we have racing buffered
write and DIO read to the same block, we have to make sure that DIO read
ignores the information in the extent status tree because data isn't
written to the blocks yet. Umm, maybe we could just mark the extent as
unwritten in the extent status tree (without having anything on disk) and
this should make DIO read work. That sounds like a nice optimization.

> I also think this approach
> in the long term will be simpler and faster, since we don't have
> modify the extent tree, and start a journal transaction, before we
> write the data blocks.
  Yeah, it should be faster because we will need to perform some extent ops
only in memory and not on disk.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

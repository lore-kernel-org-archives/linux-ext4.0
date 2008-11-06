From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH -V3 8/9] ext4: Fix double free of blocks
Date: Thu, 6 Nov 2008 17:37:02 -0500
Message-ID: <20081106223702.GN18939@mit.edu>
References: <1225997374-10846-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:53949 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750860AbYKFWhH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 17:37:07 -0500
Content-Disposition: inline
In-Reply-To: <1225997374-10846-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2008 at 12:19:33AM +0530, Aneesh Kumar K.V wrote:
> Blocks freed but not yet committed will be marked free in disk bitmap.

That should probably read, "marked free in the on-disk block
allocation bitmap".

And I'm having real trouble parsing this below

> ext4_mb_release_inode_pa looks at the block bitmap and mark the
> block found free in the bitmap withing the inode prealloc space

"the block"  should that be plural?   Which block is it?

"found free in the bitmap"?  which bitmap?  The block allocation
bitmap?

"withing"?  Is that supposed to be within?

"withing the prealloc space"?  What is that supposed to be modifying?
It is cloest to "the bitmap", but that doesn't make any sense; is this
phrase supposed to be modifying "the block"?

> as unused. If we have blocks allocated out of a prealloc space

"mark as unused" Mark as unused where?  In the block allocation
bitmap?  But I thought these were "blocks found free in the bitmap",
so aren't they already unused?

It's better to try to explain things at a higher level.  What what
you've said on the conference call, I *think* what happens is that the
preallocation range is range of blocks which is reserved for
allocation for that particular inode.  To support this, the blocks in
question are made to appear as though they are not available in the
mballoc's in-memory buddy bitmap, which is what mballoc consults when
making allocations.

For some strange reason which I don't understand, when blocks are
served out of the preallocation area and allocated to the inode, they
are not removed from the preallocation area.  (This seems like the
real bug, but whatever...)  So when we release a preallocation area
for an inode, for each block in the inode's preallocation area, we
check and see if the block is marked as free according to the on-disk
disk allocation bitmap, and if so we make it look available in
mballoc's in-memory buddy bitmap.

Unfortunately, if the disk blocks in question are freed before the
commit transmit, the blocks would look free in the on-disk block
allocation bitmap, and so there would be an attempt to mark them as
available twice in mballoc's buddy bitmap. 

To get around this problem, the patch allocates a temporary bitmap
which also includes the blocks in the "release on commit" linked list.

Did I get this right?  If so, we should put an abbreviated version of
the above in the commit, and more of this needs to be explicitly
documented in comments in mballoc.c

So ---- stupid question.  Instead of creating the temporary bitmap,
which I fear will be very expensive --- why not remove the block from
the inode's preallocation area when it is served up?  Then, it becomes
easier when releasing the inode preallocation area; we wouldn't need
to consult the on-disk block allocation bitmap at all, and merely just
iterate over all of the blocks in the inode preallocation space, and
mark them as available in the mballoc buddy bitmap?

						- Ted

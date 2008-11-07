From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH -V3 8/9] ext4: Fix double free of blocks
Date: Fri, 7 Nov 2008 21:31:24 +0530
Message-ID: <20081107160124.GM25194@skywalker>
References: <1225997374-10846-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081106223702.GN18939@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:36904 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbYKGQBh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2008 11:01:37 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id mA7G1Y5I008276
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 21:31:34 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA7G1YOk3326052
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 21:31:34 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id mA7G1XbV003513
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 21:31:33 +0530
Content-Disposition: inline
In-Reply-To: <20081106223702.GN18939@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 06, 2008 at 05:37:02PM -0500, Theodore Tso wrote:
> On Fri, Nov 07, 2008 at 12:19:33AM +0530, Aneesh Kumar K.V wrote:
> > Blocks freed but not yet committed will be marked free in disk bitmap.
> 
> That should probably read, "marked free in the on-disk block
> allocation bitmap".
> 
> And I'm having real trouble parsing this below
> 
> > ext4_mb_release_inode_pa looks at the block bitmap and mark the
> > block found free in the bitmap withing the inode prealloc space
> 
> "the block"  should that be plural?   Which block is it?
> 
> "found free in the bitmap"?  which bitmap?  The block allocation
> bitmap?
> 
> "withing"?  Is that supposed to be within?
> 
> "withing the prealloc space"?  What is that supposed to be modifying?
> It is cloest to "the bitmap", but that doesn't make any sense; is this
> phrase supposed to be modifying "the block"?
> 
> > as unused. If we have blocks allocated out of a prealloc space
> 
> "mark as unused" Mark as unused where?  In the block allocation
> bitmap?  But I thought these were "blocks found free in the bitmap",
> so aren't they already unused?
> 
> It's better to try to explain things at a higher level.  What what
> you've said on the conference call, I *think* what happens is that the
> preallocation range is range of blocks which is reserved for
> allocation for that particular inode.  To support this, the blocks in
> question are made to appear as though they are not available in the
> mballoc's in-memory buddy bitmap, which is what mballoc consults when
> making allocations.


Yes. That is correct

> 
> For some strange reason which I don't understand, when blocks are
> served out of the preallocation area and allocated to the inode, they
> are not removed from the preallocation area.  (This seems like the
> real bug, but whatever...) 

This happens for inode prealloc space. Because i node prealloc space
is mapped using the logical block number. Ie if we have a prealloc space
of contiguous 'x' blocks starting at physical block 'p'.  When creating
this prealloc space we would have been requesting for blocks for logical
block 'l'. ie 

[ p .........(p+k).............p+x]
  l

Now request for 2 blocks at logical file block 'l' get allocated
from above prealloc space. Again request for 3 blocks at logical block
'l+k' get allocated from the above prealloc space. Also request for 
3 blocks at logical block 'p+x+1' WON't use the above prealloc space.
Inshort inode prealloc space use logical block number to find which
prealloc space to use. We also don't reduce the pa_len of the prealloc
space. But we reduce pa_free. Now when we discard this prealloc space
we need to look at on-block bitmap and find out how many blocks actually
got allocated out of the prealloc space. So we start with the first zero
block on the block bitmap starting from physical block 'p'. We search
for next set bit. All the blocks in that range are free.  We them mark
them free in the buddy bitmap.


>So when we release a preallocation area
> for an inode, for each block in the inode's preallocation area, we
> check and see if the block is marked as free according to the on-disk
> disk allocation bitmap, and if so we make it look available in
> mballoc's in-memory buddy bitmap.
> 
> Unfortunately, if the disk blocks in question are freed before the
> commit transmit, the blocks would look free in the on-disk block
> allocation bitmap, and so there would be an attempt to mark them as
> available twice in mballoc's buddy bitmap. 

exactly.

> 
> To get around this problem, the patch allocates a temporary bitmap
> which also includes the blocks in the "release on commit" linked list.
> 
> Did I get this right?  If so, we should put an abbreviated version of
> the above in the commit, and more of this needs to be explicitly
> documented in comments in mballoc.c

I am tempted to add your mail above as it is :)

> 
> So ---- stupid question.  Instead of creating the temporary bitmap,
> which I fear will be very expensive --- why not remove the block from
> the inode's preallocation area when it is served up? 

We can't do that because inode prealloc space look at logical block
of the file.


>Then, it becomes
> easier when releasing the inode preallocation area; we wouldn't need
> to consult the on-disk block allocation bitmap at all, and merely just
> iterate over all of the blocks in the inode preallocation space, and
> mark them as available in the mballoc buddy bitmap?

-aneesh

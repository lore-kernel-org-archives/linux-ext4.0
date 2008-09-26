From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC] dynamic inodes
Date: Fri, 26 Sep 2008 09:49:03 -0500
Message-ID: <20080926094903.08e68f5b@gara>
References: <48DA28B0.2020207@sun.com>
	<20080925223731.GM10950@webber.adilger.int>
	<20080925201039.454bf742@gara>
	<20080926103607.GB10950@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <bzzz@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33440 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbYIZOtM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Sep 2008 10:49:12 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m8QEn9qi004166
	for <linux-ext4@vger.kernel.org>; Fri, 26 Sep 2008 10:49:09 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8QEn9DT281438
	for <linux-ext4@vger.kernel.org>; Fri, 26 Sep 2008 10:49:09 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8QEn9wQ002930
	for <linux-ext4@vger.kernel.org>; Fri, 26 Sep 2008 10:49:09 -0400
In-Reply-To: <20080926103607.GB10950@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 26 Sep 2008 04:36:07 -0600
Andreas Dilger <adilger@sun.com> wrote:

> On Sep 25, 2008  20:10 -0500, Jose R. Santos wrote:
> > One way to get around this is to implement the exact opposite of what I
> > proposed earlier and have a block group with no inode tables.  If we do
> > a 1:1 distribution of inode per block and don't allocate inodes tables
> > for a series of block groups within a flexbg we could later on attempt
> > to allocate new inode tables when we run out of inodes.  If we leave
> > holes in the inode numbers for the missing inode tables, adding new
> > inode tables in these block groups would not require any inode
> > renumbering.  This also does not break the current inode allocator
> > which would be a good thing.  This should be even simpler to implement
> > than the previous proposal.  The drawbacks are that when allocating a
> > new inode table, the 1:1 distribution of inode per block would mean
> > that we need to find a bigger chunk on contiguous blocks to since we
> > have bigger inode tables per block group.  Since the current inode
> > allocator tries to keep a 10% of blocks in a flexbg free, finding
> > contiguous blocks may not be a really big issue.  Another issue is 64bit
> > filesystem if we use a 1:1 scheme.
> > 
> > This would be like uninitialized inode tables with the added steps of
> > finding free blocks, allocating a new inode and zeroing the newly
> > created inode table.  Since we could chose to allocate a new inode
> > table on a flexbg with the most free blocks, this could keep filesystem
> > meta-data/data layout consistently close together to maintain
> > predictable performance.  This option also has no overhead compared to
> > the previous proposal.
> 
> The problem with leaving gaps in the itable is that this needs the
> filesystem to be created in this manner in the first place, while adding
> them at the end can be done to any filesystem.  If we are preparing the
> filesystem in advance for this we could just reserve enough GDT space
> too (as online resize already does to some extent)..

Agreed, but performance wise this way is more consistent with the
current block and inode allocators.  The block allocator will start its
free block search on the block group that contains the inode.  Since
these block groups do not contain any blocks, the block allocator will
have to be modify to make sure data is not being placed randomly in the
disk.  The flex_bg inode allocator would also need to be modify since
it currently depends on a algoright that assumes that block groups
contain actual blocks.  One of the things that got flex_bg added to
ext4 in the first place was performance the performance improvements it
provided.  I would like to keep that advantage if possible.

This could also be use to speed mkfs since we would not need to zero
out as many inode tables.  We could initialize just a couple of inode
tables per flex_bg group and allocate the rest dynamically.  You do pay
a small penalty when allocating a new inode table since we first need
to find the blocks for that inode table as well as zeroing it afterward.
The penalty is less than if we do the one time background zeroing of
inode tables where your disk will be trashing for a while the first
time it is mounted.

If supporting already existing filesystems is really important we could
always implement both techniques since they technically should not
conflict with each other, though you couldn't use both of them at the
same time if you have a 1:1 block/inode ratio.

> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 



-JRS

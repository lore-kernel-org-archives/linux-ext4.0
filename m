From: Andreas Dilger <adilger@sun.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at	00000000
 [ext4_new_meta_blocks+0x7c/0xb7]
Date: Thu, 18 Dec 2008 01:55:24 -0700
Message-ID: <20081218085524.GE5000@webber.adilger.int>
References: <20081209104121.GA7572@skywalker> <20081212145609.GA26085@mit.edu>
 <20081217075635.GA7685@skywalker> <20081217114711.GL10590@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:45880 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbYLRIza (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Dec 2008 03:55:30 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mBI8tRIg009543
	for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2008 00:55:29 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KC200901DZI9N00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 18 Dec 2008 00:55:27 -0800 (PST)
In-reply-to: <20081217114711.GL10590@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 17, 2008  06:47 -0500, Theodore Ts'o wrote:
> I've played with this a bit, and changing extents.c to pass in
> EXT4_MB_HINT_DATA for directories does work, although it's a toss-up
> regarding exactly how effective it really is.  It does seem to reduce
> fragmentation of directories, but I'm concerned that it might impact
> the long-term performance of the filesystem as it ages.

How can reducing fragmentation of the directories hurt long-term performance?

> My current thinking is that we should consider changing the block
> allocation algorithms as follows:
> 
> 1) Change the inode allocator to strongly avoid (unless no other
> inodes are available) block groups where the block group number is a
> even multiple of the flex blockgroup size.  The reasoning behind this
> is these bg's have a fewer number of blocks given that the inode table
> blocks are all allocated there, so they are much more likely to
> overflow into other bg's when used.  So we should try to avoid these
> bg's by the inode allocator unless there is no other choice.

With flex_bg does it really matter at all where the blocks for an inode
are located?  There will ALWAYS be a seek from reading the inode until
the first data block is read, so I don't see any significance to whether
the inode's "group" has more free blocks or not.

> 2) Directory blocks for inodes in the flex bg metagroup should be
> allocated in this first bg of the flexbg metagroup.  This keeps the
> filesystem metadata together, and keeps directory blocks (which tend
> to be much longer-lived that data blocks, especially for source/build
> directories) in different block allocation regions, which is a good
> thing.  It may be that all metadata blocks (i.e., also long symlinks
> and extent-tree blocks) should also be located here, although that's
> probably less important, simply because there are so few of such
> blocks in most ext4 filesystems.  

I do agree with this, and if (1) is just a mechanism to ensure that there
is space for (2) then I would tend to agree.

This would also allow implementation of my long-held idea of using LVM
to put some parts of the filesystem on one type of device (e.g. RAID-1
and/or SSD) for metadata, and the rest (data blocks) on RAID-5/6.  I had
always thought of doing this with the first N of 128 MB for each group
on the fast storage.

Putting the first of each N whole groups on the fast storage would be
equivalent, and probably less work to configure.  Having the allocator
also put other metadata there (index and directory blocks) is a bonus.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


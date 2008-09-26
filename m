From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] dynamic inodes
Date: Fri, 26 Sep 2008 14:01:45 -0600
Message-ID: <20080926200145.GF10950@webber.adilger.int>
References: <48DA28B0.2020207@sun.com>
 <20080925223731.GM10950@webber.adilger.int> <20080925201039.454bf742@gara>
 <20080926103607.GB10950@webber.adilger.int> <20080926094903.08e68f5b@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Alex Tomas <bzzz@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:59983 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbYIZUCK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Sep 2008 16:02:10 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8QK28Cg006509
	for <linux-ext4@vger.kernel.org>; Fri, 26 Sep 2008 13:02:08 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K7T00I01JLIQH00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 26 Sep 2008 13:02:08 -0700 (PDT)
In-reply-to: <20080926094903.08e68f5b@gara>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 26, 2008  09:49 -0500, Jose R. Santos wrote:
> Agreed, but performance wise this way is more consistent with the
> current block and inode allocators.  The block allocator will start its
> free block search on the block group that contains the inode.  Since
> these block groups do not contain any blocks, the block allocator will
> have to be modify to make sure data is not being placed randomly in the
> disk.

This is already the case today when a block group is full.  The block
allocator needs to handle this gracefully.

> The flex_bg inode allocator would also need to be modify since
> it currently depends on a algoright that assumes that block groups
> contain actual blocks.  One of the things that got flex_bg added to
> ext4 in the first place was performance the performance improvements it
> provided.  I would like to keep that advantage if possible.

I don't think the performance advantage was at all related to inode->block
locality (since this is actually worse with FLEX_BG) but rather better
metadata locality (e.g. contiguous bitmaps, itables avoiding seeking
during metadata operations).

> This could also be use to speed mkfs since we would not need to zero
> out as many inode tables.  We could initialize just a couple of inode
> tables per flex_bg group and allocate the rest dynamically.

There is already the ability to avoid zeroing ANY inode tables with
uninit_bg, but it is unsafe to do this in production because the old
itable data is there and e2fsck might become confused if the group
bg_itable_unused is lost (due to gdt corruption or other inconsistency).

> You do pay
> a small penalty when allocating a new inode table since we first need
> to find the blocks for that inode table as well as zeroing it afterward.
> The penalty is less than if we do the one time background zeroing of
> inode tables where your disk will be trashing for a while the first
> time it is mounted.

I don't think it is any different.  The itable zeroing is _still_ needed,
because the flag that indicates if an itable is used or not is unreliable
in some corruption cases, and we don't want to read garbage from disk.
IMHO when a filesystem is first formatted and mounted it is probably
mostly idle, and if not the zeroing (and other stuff) thread can be delayed
(e.g. in a new distro install maybe the itables aren't zeroed until the
second or third mount, no great loss/risk).

> If supporting already existing filesystems is really important we could
> always implement both techniques since they technically should not
> conflict with each other, though you couldn't use both of them at the
> same time if you have a 1:1 block/inode ratio.

IMHO dynamic inode tables for existing filesystems is the MAIN goal.
Once you know you have run out of inodes it is already too late to plan
for it, and if you need a reformat to implement this scheme you could
just as easily reformat with enough inodes in the first place :-).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


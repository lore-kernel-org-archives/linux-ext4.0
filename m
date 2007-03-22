From: Mingming Cao <cmm@us.ibm.com>
Subject: 64bit inode number and dynamic inode table for ext4
Date: Thu, 22 Mar 2007 09:45:46 -0800
Message-ID: <1174585546.16068.50.camel@localhost.localdomain>
References: <4601EF95.6020006@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:49637 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934154AbXCVRpv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Mar 2007 13:45:51 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l2MHi2tB009945
	for <linux-ext4@vger.kernel.org>; Thu, 22 Mar 2007 13:44:02 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2MHjnSw061036
	for <linux-ext4@vger.kernel.org>; Thu, 22 Mar 2007 11:45:49 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2MHjmja016474
	for <linux-ext4@vger.kernel.org>; Thu, 22 Mar 2007 11:45:48 -0600
In-Reply-To: <4601EF95.6020006@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-03-21 at 19:53 -0700, Avantika Mathur wrote:
> Ext4 Developer Interlock Call: 03/21/2007 Meeting Minutes
...
> 64 bit Inode and Dynamic Inode Table Discussion:
> - Though this feature has been discussed for many years; there does not seem to be high demand currently for 64 bit inode numbers, but it is a problem which will eventually arise.

The benefit of dynamic inode table is clear, not only it could scales up
the number of inode of files fs could support, it could also help speed
up fsck since there are only used inode stored in fs. fsck scalability
issue is a more high demand with now that ext4 could support larger
filesystem.

> - If this incompat feature is implemented, there are many other changes that need to be considered.
> - Mingming and Ted suggested the inode number could be based on block number, with 48 bits for block number, and 5-7 bits for the offset; to directly point to the inode location.

Here is the basic idea about the dynamic inode table:

In default 4k filesystem block size, a inode table block could store 4
265  bytes inode structures(4*265 = 4k). To avoid inode table blocks
fragmentation, we could allocate a cluster of contigous blocks for inode
tables at run time, for every say, 64 inodes or 8 blocks 16*8=64 inodes.

To efficiently allocate and deallocate inode structures, we could link
all free/used inode structures within the block group and store the
first free/used inode number in the block group descriptor. 

There are some safety concern with dynamic inode table allocation in the
case of block group corruption.  This could be addressed by checksuming
the block group descriptor.

With dynamical inode table, the block to store the inode structure is
not at fixed location anymore. One idea to efficiently map the inode
number to the block store the corresponding inode structure is encoding
the block number into the inode number directly. This implies to use 64
bit inode number. The low 4-5 bit of the inode number stores the offset
bits within the inode table block, and the rest of 59 bits is enough to
store the 48 bit block number, or 32 bit block group number + relative
block number within the group:

63               47               31          20             4      0
----------------|-----------------------------|--------------|------|
|               | 32bit group #               |   15 bit     | 5bit |
|               |                             |   blk #      |offset|
----------------|-----------------------------|--------------|------|

The bigger concern is possible inode number collision if we choose 64
bit inode number.  Although today linux kernel VFS layer is fixed to
handle 64 bit inode number, applications might still using 32 bit stat()
to access inode numbers could break.  It is unclear how common this case
is, and whether by now the application is fixed to use the 64 bit stat64
().  

One solution is avoid generate inode number >2**32 on 32 bit platform.
Since ext4 only could address 16TB fs on 32 bit arch, the max of group
number is 2**17 (2**17 * 2**15 blocks = 2**32 blocks = 16TB(on 4k blk)),
if we could force that inode table blocks could only be allocated at the
first 2**10 blocks within a block group, like this:

63               47               31               15          4      0
----------------|----------------|------------------|---------|------|
|               | High 15 bit    |low 17bit grp #   |10 bit   | 5bit |
|               | grp #          |                  |blk #    |offset|
----------------|----------------|------------------|---------|------|


Then on 32 bit platform, the inode number is always <2**32. So even if
inode number on fs is 64 bit, since it's high 32 bit is always 0, user
application using stat() will get unique inode number.

On 64 bit plat format, there should not be collision issue for 64 bit
applications. For 32 bit application running on 64 bit platform,
hopefully they are fixed by now. or we could force the inode table block
allocated at the first 16TB of fs, since anyway we need meta block group
to support >256TB fs, and that already makes the inode structure apart
from the data blocks.


> 	- Andreas is concerned about inode relocation, it would take a lot of effort; because references to the inode would have to be updated.  

I am not clear about this concern. Andreas, are you worried about online
defrag? I thought online defrag only transfer the extent maps from the
temp inode to the original inode, we do not transfer inode number and
structure.


> 	- Another option Andreas suggested is the inode number be an offset in and inode table.  The table could be virtually mapped around the filesystem, and also be defragmented.
> 	- Ted believes that this could be used as a faster way of dealing with the 32 bit stat proble, because the logical block numbers that the inode number represents could be used to see what the 32 bit inode number would be.
> - There are many issues to address before 64 bit inodes can be fully implemented, Andreas sees this feature as a very long term future plan.

I agree there are many ext4 features could be done in short-term, but
thinking back why we have ext4: it was initially started by address
scalability issue: fs limit and large file performance (32 bit block
number issue and extent). It was cloned from ext3 mostly political
reason, but having a new fs also allow us to design ext4 for a longer
view.  Since we are already in ext4, and now it is still called ext4dev,
why postpone it later. Think about how long it takes ext3 from start to
stable and then ext4 start with extent and 48/64 bit bit number (10
years?), I think ext5 is at least 10 years away. There are customer
already use millions or billions of files today, or even ask for
trillions of files, it could be a issue hit us within a few years.


Regards,

Mingming

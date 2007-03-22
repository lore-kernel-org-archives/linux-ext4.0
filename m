From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Ext4 devel interlock meeting minutes (March 21, 2007)
Date: Wed, 21 Mar 2007 19:53:09 -0700
Message-ID: <4601EF95.6020006@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40471 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965622AbXCVCxG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Mar 2007 22:53:06 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2M2r51w003933
	for <linux-ext4@vger.kernel.org>; Wed, 21 Mar 2007 22:53:05 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2M2r5O7314964
	for <linux-ext4@vger.kernel.org>; Wed, 21 Mar 2007 22:53:05 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2M2r5Ld015305
	for <linux-ext4@vger.kernel.org>; Wed, 21 Mar 2007 22:53:05 -0400
Received: from [9.67.35.208] (wecm-9-67-35-208.wecm.ibm.com [9.67.35.208])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l2M2r4rU015293
	for <linux-ext4@vger.kernel.org>; Wed, 21 Mar 2007 22:53:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call: 03/21/2007 Meeting Minutes

 Attendees: Mingming Cao, Dave Kleikamp, Jean-Noel Cordenner, Valerie Clement, Ted T'so, Andreas Dilger, Jose Santos, Avantika Mathur

- Jose Santos just joined the IBM LTC filesystem team, and will start looking at 64 bit support in e2fsprogs

E2fsprogs:
	- Ted gave a detailed outline on what changes are needed to support 64 bit block numbers in e2fsprogs.  He will be sending out a write up of this outline to the linux-ext4 mailing list.

	- Ted and Andreas also discussed if there is immediate need for 64 bit support.  If not, the extents suport can be the primary focus for e2fsprogs, after which 64 bit support can be implemented.  This question will also be posted on the mailin list

	- Andreas suggested creating an e4fsprogs, which uses the same code base as e2fsprogs, but has 64 bit block_t; and doesn't build shared libraries.

Git Tree:
- Ted has created an ext4 git patch queue; which multiple users can access and update.  Currently Ted, Mingming and Shaggy have access to the tree, but more users can be added.
- This tree will help clarify which patches are ready for mainline or -mm, and which patches still need to be tested.  This will prevent patches that have issues (e.g whitespace etc) from going into the mm tree. 
- Every time the tree is update, a cron job will shoot off various benchmarks on different architectures, on the IBM automated test tool.  We will then create a summary of results to post to the list.  If the patches pass sufficient tests, they can by passed to the mm git tree.
- Shaggy mentioned he uses sparse to test for endian issues in patches, and will post the options he uses to the mailing list.
- There will also need to be a mechanism for informing developers that we have fixed/changed their patches, so they use the update patch for future versions.
- Anyone who adds a patch should test that the tree builds cleanly on basic architectures.

PATCH STATUS:

- Kalpak Shah posted patches to break 32000 subdir limit

- Amit Arora posted updated preallocation patches
	- Mingming was wondering what the need for 64 bit length of fallocate syscall is.

Uninitialized Bitmaps:
- Andreas has been working on patches to support uninitialized block and inode bitmaps, using the group descriptors and checksumming.  
- There is a flag in the group descriptor, which had been added for lazy block groups.  If set, this  means that the block and inode bitmap are uninitialized.  The group is marked as having zero blocks, and the kernel does not touch them
- This greatly improves fsck time because uninitialized groups do not need to be scanned. it also improves mkfs times
	- in preliminary fsck testing, the run time grown linearly with number of inodes.
- This feature is RO_COMPAT.
	- strictly need to maintain the group checksum; of the flag is accidentally set, the whole group would be skipped.
- So far Andreas has not done any performance testing.

Mballoc and Delalloc:
- Alex has been working on polishing the mballoc allocater.  Andreas will ask him to submit a new version to the list, since the online defragmenation patches are based on an older version.
- Alex spent has spend some time addressing the request that delayed allocation be implemented in the VFS layer.  Recently Christoph Hellwin pulled delayed allocation out of XFS, and will be doing the implementation in the VFS.
	- the ext4 delalloc patches will then be dependent on these patches from Christoph.  Will implement hooks in ext4 to use the vfs level delayed allocation.
- Though mballoc is not very useful without the delayed allocation, Andreas will ask Alex to post patches, so that mballoc can be tetsed using direct IO.

64 bit Inode and Dynamic Inode Table Discussion:
- Though this feature has been discussed for many years; there does not seem to be high demand currently for 64 bit inode numbers, but it is a problem which will eventually arise.
- If this incompat feature is implemented, there are many other changes that need to be considered.
- Mingming and Ted suggested the inode number could be based on block number, with 48 bits for block number, and 5-7 bits for the offset; to directly point to the inode location.
	- Andreas is concerned about inode relocation, it would take a lot of effort; because references to the inode would have to be updated.  
	- Another option Andreas suggested is the inode number be an offset in and inode table.  The table could be virtually mapped around the filesystem, and also be defragmented.
	- Ted believes that this could be used as a faster way of dealing with the 32 bit stat proble, because the logical block numbers that the inode number represents could be used to see what the 32 bit inode number would be.
- There are many issues to address before 64 bit inodes can be fully implemented, Andreas sees this feature as a very long term future plan.

Large Inode:
- Andreas working on patch that will resize the inode if space is needed for the nanosecond timestamp fields
- This entails shifting down EAs if there is enough space in the inode.
- If there isn't enough space in the inode for the EA's, they are moved.

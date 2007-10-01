From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Ext4 devel interlock meeting minutes (October 1, 2007)
Date: Mon, 01 Oct 2007 15:10:27 -0700
Message-ID: <47017053.9060005@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:52452 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757873AbXJAWJd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Oct 2007 18:09:33 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l91M9Q32011945
	for <linux-ext4@vger.kernel.org>; Mon, 1 Oct 2007 18:09:26 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l91M9Qee399970
	for <linux-ext4@vger.kernel.org>; Mon, 1 Oct 2007 16:09:26 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l91M9QRt022924
	for <linux-ext4@vger.kernel.org>; Mon, 1 Oct 2007 16:09:26 -0600
Received: from [9.47.16.62] (dyn9047016062.beaverton.ibm.com [9.47.16.62])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l91M9PL0022898
	for <linux-ext4@vger.kernel.org>; Mon, 1 Oct 2007 16:09:26 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call:  10/1/07 Meeting Minutes

Attendees: Mingming Cao, Aneesh Veetil, Dave Kleikamp, Akira Fujita, Ted 
Ts'o, Jose Santos, Avantika Mathur, Jean-Pierre Dion

Minutes can be accessed at: 
http://ext4.wiki.kernel.org/index.php/Ext4_Developer%27s_Conference_Call

EXT4 PATCH QUEUE

Multiple Block Allocation:
- Main outstanding issue is still need for better documentation of the code.
- Aneesh has marked the places that need explanation with fixme, and 
Alex will be adding the needed comments.  If this gets done quickly, we 
can try to push this feature to 2.6.24
- Aneesh has asked for recommendations for a benchmark to run which will 
test the mballoc allocator.  Mingming suggested using dd and dbench, as 
was done in the past for basic mballoc patches.  To test the in-core 
preallocation, kernel untar tests.  Look at the file fragmentation after 
running the test.

Large Block Patches:
- Mingming will post these patches to lkml for review

Uninitialized block groups:
- the uninitialized block group patches were posted to lkml and are in 
the -mm tree.

JBD-stats through procfs patches:
- Ted will look at these patches and see if they are ready to push upstream

generic-find-next-le-bit:
- This function is only used in multiple block allocation  patches. It 
would not be a good idea to post this before mballoc, since the function 
would be unused and may be cleaned up later.

Delayed Allocation:
- There has been an lkml thread about these patches.
- We have and approach that works for ext4, implemented at the vfs 
level, but unless we can prove it can work for other filesystems, it 
will not be accepted.  
- Christoph Hellwig has commented that these patches will not work for 
XFS.  
- Mingming will try the patches with ext2/3, and Shaggy will try to find 
time to test with JFS.  
- If this approach works for other filesystems, we can try to push to 
mainline as a placeholder.

truncate mutex patch:
- There is a performance concern with these patches. Mingming suggested 
doing some testing to see what the actual performance regression is.
- Ted suggests breaking into two patches:
-- Patch 1 - Change the name of the mutex to block_mapped_mutex and 
update comments to reflect the usage of the mutex
-- Patch 2 - Change to a read/write mutex

GENERAL
- Those patches we would still like to see in 2.6.24 need to be pushed 
very quickly
- We should avoid having ext2/3 patches in the ext4-patch-queue and git 
tree.
- Some of the patches that we just send to lkml for review end up being 
pulled into the -mm tree, then Ted pulls them to the ext4-git tree, and 
Andrew must remove from -mm.  When we post for comments, we should use 
[PATCH,RFC] to avoid this.
- Mingming suggested having a patch queue for the ext4-git tree for 
easier review. Ted is also considering having a pu branch for the git 
tree.  Ted will think about what will work best.
- In the ext4-patch qDescription of patch include which version of -mm 
the patch is in

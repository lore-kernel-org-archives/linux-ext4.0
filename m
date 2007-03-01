From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Ext4 devel interlock meeting minutes (Feb. 28, 2007)
Date: Thu, 01 Mar 2007 11:43:18 -0800
Message-ID: <45E72CD6.2080306@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:35806 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965540AbXCATnO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Mar 2007 14:43:14 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l21JhD2j026239
	for <linux-ext4@vger.kernel.org>; Thu, 1 Mar 2007 14:43:13 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l21JhD5K295858
	for <linux-ext4@vger.kernel.org>; Thu, 1 Mar 2007 12:43:13 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l21JhDES026675
	for <linux-ext4@vger.kernel.org>; Thu, 1 Mar 2007 12:43:13 -0700
Received: from [9.47.16.74] (mathur.beaverton.ibm.com [9.47.16.74])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l21JhCPk026633
	for <linux-ext4@vger.kernel.org>; Thu, 1 Mar 2007 12:43:12 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call: 01/28/2007 Meeting Minutes

Attendees: Mingming Cao, Suparna Bhattacharya, Dave Kleikamp, Eric 
Sandeen, Takashi Sato, Avantika Mathur
Minutes can be accessed at: 
http://ext4.wiki.kernel.org/index.php/Ext4_Developer%27s_Conference_Call

Mingming sent out minutes from the Ext4 filesystem and storage workshop 
which took place two weeks ago, and will be posting these on the ext4 
wiki as well.  Mingming gave a talk and led a BOF on ext4 at the summit
- feel free to update or add comments to these minute.

- One thing that was not discussed at the conference is the overall 
future plans for the Ext4 filesystem.  Many people believe that Ext4 is 
a new filesystem that will include many new features that new 
filesystems have; including greater scalability.  But such additions may 
need  massive chagnes and rewrite.  Our question is, how long to we plan 
to continue to support backwards compatibility.

_PATCH STATUS_

Inode Versioning:
- Need to implement the high 32 bits for the i_version field. Andreas is 
looking at adding the new field in i_extra_isize.
- The 64 bit i_version would therefore only be available in ext4; and we 
would add the 32 bit patch to ext3.  Need to verify with NFS that this 
would be ok for them.

Nanosecond Timestamps:
- Kalpak has resent the patches
- CPU usage is a concern. Ted had suggested masking off different levels 
of granularity and testing performance at each level.

Preallocation:
- akpm suggested that we created and implement a system call for 
fallocate, Amit Arora is working on a simple patch which implements the 
system call fo i386 architecture.
- the main concern is the need to add an inode operation at VFS layer. 
There are mixed responses about whether we should add a system call for 
preallocation. hch suggested we add a cmd paramter to the fallocate 
system call to do preallocate, unprealloc, reserve, unreserve etc.
  -- Mingming thinks it would be it would be good to use this syscall 
for reservation as well. current interface to reservation is ioctl.
- Before continuing development on the system call, it is a good idea to 
discuss implementation details on lkml and linux-fsdevel.  
  -- Eric will send and email to linux-ext4 before extending the 
discussion to other lists.
  -- Mingming will ask Amit to resend patches and follow up with this 
discussion.
 
Online Defragmentation:
- Takashi tested his online defrag patches and found a problem, that he 
is currently looking into.
- After fixing the problem he will upgrade and repost his patches.
- Need Alex's update on his mballoc patch as this online defrag patch is 
currently depending on it.
  -- Could we try to use preallocation in online defragmentation?
- In the filesystem workshop there was discussion on how locking works 
if the file being defragmented is in use.
  -- There were suggestions to do defragmention at directory level as 
well.  
  -- Use page cache rather than O_DIRECT to avoid complexity.

e2fsprogs Changes:
- Ted has planned to support 64 bit block number and extents in e2fsprogs.
- This will require many changes and rewrite. We will ask Ted about 
current status and distributing work items.

Migration Tool:
- Suparna and Mingming are working with Aneesh Veetil to create a tool 
to migrate from regular files to exent files, and from 128 to 256 byte 
inode.

- Andrew Morton had posted asking for help in testing positive return 
value from prepare_write.  Shaggy and Suparna will look into this.

- Mapped I/O with preallocation
  -- David Chinner has discussed an issue with performing mapped IO with 
unwritten extents in XFS.
  -- Mapped I/O can read/write and initialize unwritten extents without 
notifying the underlying filesystem.  So an unwritten extent is not 
being flagged to an initialized extent, and after the data is written to 
disk the extent is still flagged as unwritten.  If the filesystem is 
remounted, reading would return zeros.
  -- This problem should only apply to a cold cache.  If the cache is in 
use, the data would be retrieved from cache.

- Mingming and Eric discussed a different method of implementing 
preallocation proposed by Arjan
  -- when you want to reserve or preallocate 1000 blocks.  Reduce the 
superblock counter by 1000 and add 1000 to the inode counter.  As more 
writes are performed, inode would decrement from the inode allocated 
blocks counter.  
  -- This could possibly be integrated with the current ext4 
reservation.  The reservation window would know that there are allocated 
but unwritten blocks in memory, only accessible when blocks have been 
written.  
  -- But using the current reservation, contiguous preallocated blocks 
would not be guaranteed.  Having contiguous blocks is one of the 
requirements of the feature.  

- Eric has benchmark data between ext3 and ext4; he will retest and post 
results on the mailing list.

From: "AVANTIKA R. MATHUR" <mathur@linux.vnet.ibm.com>
Subject: Ext4 devel interlock meeting minutes (Jan. 24 2007)
Date: Wed, 24 Jan 2007 16:24:40 -0800
Message-ID: <45B7F8C8.4090807@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46355 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933097AbXAYAZh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Jan 2007 19:25:37 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0P0PZix007271
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jan 2007 19:25:35 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0P0OZWj154832
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jan 2007 19:24:35 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0P0OZpr012079
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jan 2007 19:24:35 -0500
Received: from [9.47.16.74] (mathur.beaverton.ibm.com [9.47.16.74])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l0P0OZ92012074
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jan 2007 19:24:35 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call: 01/24/2007 Meeting Minutes
Attendees: Mingming Cao, Suparna Bhattacharya, Dave Kleikamp, Laurent 
Vivier, Valerie Clement, Badari Pulavarty, Avantika Mathur

Minutes can be accessed at: 
http://ext4.wiki.kernel.org/index.php/Ext4_Developer%27s_Conference_Call

OLS:
- Laurent plans to propose a paper on 64 bit work for ext4, describing 
what is missing in the current implementation for 64 bit ext4.  
- We also plan to submit a proposal for a collaborative paper on ext4 in 
general.  This paper would include an overview the features currently in 
ext4, performance evaluation, and planned features.
- Mingming has already submitted a proposal for a BOF on ext4

Directory Pagecache:
- Andrew Morton would like to see directories moved to a per directory 
pagecache, which would allow readahead on directories, and also address 
directory fragmentation issues.
- Badari mentioned that the reason directories were in pagecache in ext2 
and not in ext3 may be the htree extension in ext3.
- We will look into how this can be added and supported in ext4

Preallocation Patches:
- The preallocation patches are ready to be submitted for inclusion; 
other than deciding on an interface.
- Mingming suggested abstracting the preallocation implementation from 
interface.  But we will wait until the interface is decided.
- Still looking into posix_fallocate and ioctl as options for interface; 
this discussion will be moved to larger mailing lists, in order to reach 
consensus and move patches forward.

Delayed and Multiple Block Allocation Patches:
- Delayed allocation: Alex Tomas' patches have a few issues still to be 
resolved
- Multiple block allocation:
-- This is ext4 specific code and can  be pushed to mainline before 
delayed allocation.
-- Ask Alex Tomas if he would like to shift focus to mult block 
allocation, over delayed allocation.

Inode Version Patches:
- the inode version patches recently resubmitted by Jean-Noel Cordenner 
are at the vfs level and port the i_version field to user space.
- There are concerns about the peformance with the overhead of updating 
the i_version each time ctime is updated.

Chunkfs:
- Amit Gud was working on an in kernel implementation for chunkfs, but 
there haven't been any patches posted yet. He does not seem to have much 
time to devote to this develpment. There was also a group of students 
working on chunkfs.
- chunkfs was originally based on ext2. One goal was to improve 
filesystem recovery. Developers looked at how to measure and compare 
fsck times based not only on time, but reliability and being thorough.
- Status on chunkfs development can be discussed at the upcoming 
filesystem workshop

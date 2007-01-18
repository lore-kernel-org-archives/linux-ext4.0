From: "AVANTIKA R. MATHUR" <mathur@linux.vnet.ibm.com>
Subject: Ext4 devel interlock meeting minutes (Jan. 17 2007)
Date: Wed, 17 Jan 2007 17:29:47 -0800
Message-ID: <45AECD8B.1020806@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34534 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbXARB3q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jan 2007 20:29:46 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0I1UKIH003947
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jan 2007 20:30:20 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0I1Tiwg207370
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jan 2007 20:29:44 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0I1TijT008486
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jan 2007 20:29:44 -0500
Received: from [9.67.63.126] (wecm-9-67-63-126.wecm.ibm.com [9.67.63.126])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l0I1ThJY008468
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jan 2007 20:29:43 -0500
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call
Meeting Minutes January 17, 2007

Attendees: Mingming Cao, Dave Kleikamp, Jean Pierre Dion, Jean Noel 
Cordenner, Valerie Clement, Suparna Bhattacharya, Eric Sandeen, Avantika 
Mathur

- In the last call Ted proposed having a git tree for ext4 on 
kernel.org, and Mingming then sent an email to the list requesting 
everyone to resend latest versions of ext4 patches to put in these 
tree.  Mingming suggested that all bug fixes to ext4 should also be 
copied to the git tree

- Eric asked if people would be interested if ext4 built better as 
module.  First by perhaps moving some ext4 headers from include/linux to 
the ext4 directory; making it easier to build as a module

- Takashi posted updated patches to the mailing list. Mingming update 
the ext4 wiki with status. Andreas and Takashi have been discussing what 
the interface for online defragmentation should be.  The next step is to 
wait for a new patch set from Takashi, as there are some to do items.

- Preallocation: Amit Arora posted new patch set, Mingming reviewed the 
patches and they look good.
   -- The main outstanding issue is determining what the interface 
should be: ioctl, fcntl, ftruncate, posix_fallocate.    -- Eric does not 
want to use ftruncate as it does not support creating sparse files.
   -- Mingming asked if the return value should be how many blocks were 
allocated, because when allocating accross holes, it may not allocate 
number of blocks requested.  Eric did not see allocation accross holes 
to be a common case, and was not sure if the number of blocks allocated 
will be useful.  Eric will check how XFS handles this situation, it 
could be helpful to try to keep semantics similar accross filesystems.

- Support for trillions of files in ext4: Mingming asked how XFS handles 
a 64 bit inode number and binary incompatability issues.
   -- XFS by default limits the inode number to 32 bit range; but can be 
configured for 64 bit inode numbers.  Eric suggested that as a 
filesystem that is moving forward, ext4 could default to 64 bit inodes, 
but be set to 32 bit inode if necesary.
   -- Eric also mentioned looking at the scaling of mkfs block/inode 
ratio based on filesystem size
   -- fsck time on very large number of files is also an issue

- Mingming discussed the limitation on filesystem size by the fact that 
all block group descriptors are stored in the first block; this limits 
max filesystem size to 256 TB.  We could enlarge the block group size to 
store more block group descriptors or not store all descriptors in the 
same block group. If meta block groups are turned on by default, this 
limit could be resolved, but all peices for this feature may not be in 
place.

- Encourage developers to update the ext4 wiki (ext4.wiki.kernel.org), 
new patches page with details and status on features, It might be 
helpful if there is a separate page on the WIKI for each feature.

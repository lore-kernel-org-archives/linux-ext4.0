From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Ext4 devel interlock meeting minutes (March 7, 2007)
Date: Thu, 08 Mar 2007 10:06:17 -0800
Message-ID: <45F05099.5020506@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49796 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbXCHSG0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Mar 2007 13:06:26 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l28I6Orr016565
	for <linux-ext4@vger.kernel.org>; Thu, 8 Mar 2007 13:06:24 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l28I6AQV210342
	for <linux-ext4@vger.kernel.org>; Thu, 8 Mar 2007 13:06:10 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l28I6AXH027482
	for <linux-ext4@vger.kernel.org>; Thu, 8 Mar 2007 13:06:10 -0500
Received: from [9.47.16.74] (mathur.beaverton.ibm.com [9.47.16.74])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l28I69bF027414
	for <linux-ext4@vger.kernel.org>; Thu, 8 Mar 2007 13:06:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call: 03/07/2007 Meeting Minutes

Attendees: Mingming Cao, Ted Ts'o, Suparna Bhattacharya, Dave Kleikamp, Jean Noel Cordenner, Eric Sandeen, Akira Fujita, Avantika Mathur

Minutes can be accessed at: http://ext4.wiki.kernel.org/index.php/Ext4_Developer%27s_Conference_Call 

Ext4 git tree:

- Andrew Morton asked about updated Ext4 patches on kernel.org tree; last update was 2/18

- Ted plans to test the current ext4 patch set before updating the tree

Preallocation fallocate interface:

- There has been a lot of discussion on the mailing list about the fallocate system call, the parameters to the system call (mode), and whether there should be a generic function written in kernel, or the libc function should be used for filesystems that don't have there own fs specific function.

    - Generic Function: After much discussion during the call, it was concluded that it would be desirable to have a generic function in the VFS; but that is not a priority.

    - Mode bit: The mode bit seems like a good way to support preallocate, unpreallocate and other types of allocation within the fallocate system call. Having the mode bit would cause the syscall to have different parameters for each mode, making it more like ioctl.  This may be undesirable by some.

    - Policy: Ted proposed an idea of having an integer value which represents which allocation policy is to be used.  This value would be set by interpreting the parameters sent by some interface (syscall, ioctl), and the filesystem would then perform allocation based on the policy (prealloc, reserve, unalloc, punch).  The default value for normal allocation would be 0. 

- The general opinion on the call was that there should be a separate system call for fallocate and punch operations.

Block Group Number type:

- Avantika is working on patches to change all block group numbers to type unsigned  long. Currently there are many locations where block group numbers are type int, and sometimes assigned negative values.  In the patches there will be a new ext4_grpnum_t type added.

Metadata block groups:

- At the filesystem and storage workshop, it was decided that metadata block groups will be turned on by default in Ext4 to support larger filesystem size. With current format where group descriptors are saved in the first block group, filesystem size is limited to 256 TB.

- Metadata is stored in one group. Data is stored a the first, second and last block group of the meta block group.  Relaxed restrictions on where inode table block have to be, they are put at the beginning of every metadata block group.

i_version Patches:

- Jean Noel is working on a new version of the patches.

    - In an earlier e-mail he had mentioned high CPU utilization with the patches, but this is not the case. 

    - He will publish the new version of the patches and test results to the mailing list.  He has been testing on iozone and looking at oprofile data.

- NFSv4 requires a 64 bit i_version field. The current patches have 32 bit field, we need to have consensus on where the high 32 bits of the field will come from

    - Andreas Dilger had suggested using bits from i_extra_isize.

    - Jean Noel will send out an RFC to start discussion on the mailing list.

- Lustre had an additional request; that the i-version amount is updated by a global counter.  Ted is concerned about bottlenecks on metadata intensive benchmarks, because of the globally accessed incremental counter. 

    - There hasn't been any decision made on this issue.

Ext3->Ext4 Migration Tool:

- Aneesh Veetil has been working on a migration tool from block based to extents allocation. He is looking at two options.

    - Offline Migration: Modify e2fsprogs code to actually be able to create extents. This involves a lot of duplication of ext4 code (btree).  e2fsprogs has code for interpreting extents, but code for creating them would have to be duplicated.

    - Online Migration: Use existing filesystem code to convert to extents - similar to online defragmentation.

- Mingming suggested looking into doing a cp; but this involves data movement. Aneesh's approaches are performing migration in place. 

- Migration from block based->extents can be done online or offline; but the migration tool will also include migration from 128 byte inode to large inode, which should be done offline.

From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH 0/8] ext4 online defrag (ver 0.8)
Date: Fri, 04 Apr 2008 20:19:03 +0900
Message-ID: <47F60EA7.1050604@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	Mingming Cao <cmm@us.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:58102 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbYDDLVd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Apr 2008 07:21:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Aneesh Kumar K.V wrote:
> you would need http://www.kernel.org/pub/software/devel/sparse/
> to find and fix these warnings.

I have updated ext4 online defrag to fix sparse warnings.
I also changed the construction of ext4 online defrag patches
to compile one-by-one and make them small but there is
no functional change since previous version.

Outline for ext4 online defrag:
Ext4 online defrag has the following three functions.

1.[ no option ] Solving a single file fragmentation
  Single file fragmentation is solved by moving file
  data to contiguous free blocks.

2.[ -r ] Solving a relevant file fragmentation
  Relevant file fragmentation could be solved by moving
  the files under the specified directory close together with
  the block containing the directory data.

3.[ -f ] Solving a free space fragmentation
  If there is no contiguous free blocks in the filesystem,
  the other files are moved to make sufficient space to allocate
  contiguous blocks for the target file.

Next steps:
1. Rework of defrag functions based on review comments from Mingming.
2. Implement defrag -f mode with FIEMAP ioctl.
3. Remove the limit of target file size (now 128MB) in -f mode.
   * Past mail concerning -f mode.
   http://marc.info/?l=linux-ext4&m=118239067704899&w=4

Summary of patches:
* These patches are replaced with ext4 online defrag patches
  which are already in the ext4 git tree (linux-2.6.26-rc8).

[PATCH 1/8]  Exchange the blocks between two inodes
- Exchange the data blocks between the temporary inode and
  the original inode.

[PATCH 2/8] Read and write file data with memory page
- Read the file data from the old blocks to the page and
  write the file data on the page into the new blocks.

[PATCH 3/8] Allocate new contiguous blocks with mballoc
- Search contiguous free blocks with mutil-block allocation
  and allocate them for the temporary inode.

[PATCH 4/8] Main function of ext4 online defrag and ioctl implementation
- Create the temporary inode and do defrag per
  defrag_size (defalut 64MB).

[PATCH 5/8] Defragmentation for the relevant files (-r mode)
- Relevant file fragmentation could be solved by moving
  the files under the specified directory close together with
  the block containing the directory data.

[PATCH 6/8] Check the free space fragmentation (-f mode)
- Check the free space fragmentation in the block group
  where target file is located.

[PATCH 7/8] Move victim files for the target file (-f mode)
- Move victim files to make sufficient space and reallocates
  the contiguous blocks for the target file.

[PATCH 8/8] Online defrag command
- The defrag command. Usage is as follows:
  - Put the multiple files closer together.
    # e4defrag -r directory-name
  - Defrag for free space fragmentation.
    # e4defrag -f file-name
  - Defrag for a single file.
    # e4defrag file-name
  - Defrag for all files on ext4.
    # e4defrag device-name

Comments and reviews are welcome.

Regards,
Akira

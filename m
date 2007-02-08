From: "Takashi Sato" <sho@tnes.nec.co.jp>
Subject: [RFC][PATCH 0/3] ext4 online defrag (ver 0.3)
Date: Thu, 8 Feb 2007 18:00:24 +0900
Message-ID: <20070208180024sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:44494 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423099AbXBHJAq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Feb 2007 04:00:46 -0500
Received: from mailgate4.nec.co.jp (mailgate53.nec.co.jp [10.7.69.184])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l1890iVu004087
	for <linux-ext4@vger.kernel.org>; Thu, 8 Feb 2007 18:00:44 +0900 (JST)
Received: (from root@localhost) by mailgate4.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l1890ij25871 for linux-ext4@vger.kernel.org; Thu, 8 Feb 2007 18:00:44 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv.nec.co.jp (8.11.7/3.7W-MAILSV-NEC) with ESMTP
	id l1890iO23912 for <linux-ext4@vger.kernel.org>; Thu, 8 Feb 2007 18:00:44 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070208.180043.48402328 for <linux-ext4@vger.kernel.org>
	; Thu, 8 Feb 2007 18:00:43 +0900
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

I've updated my online defrag patches to support leaf node
which is filled with extents and has no space for new extent any more.
Any comments from reviews or tests are very welcome.

Implementation:
1. When the leaf node is filled with extents and there is no space
   for additional extent, the new extent can not be inserted and the defrag
   fails in my previous implementation.
   To solve this problem, call ext4_ext_insert_extent() to create
   a new leaf node and split full leaf node into a new leaf node. 
   In this case, leaf node count or depth of extent tree must be increased.
   Maybe you should turn "AGRESSIVE_TEST" on, if you test this fix.
   "AGRESSIVE_TEST" makes leaf node capacity small, so you can create
   complex inode tree easily.

2. Instead of previous version's ioctl(EXT4_IOC_GET_DATA_BLOCK),
   add new ioctl(EXT4_IOC_FIBMAP) which behaves like FIBMAP and
   returns the physical block number of the specified logical block.
   This ioctl is called by "e4defrag -r directory-name"
   to put all the files under the directory closer together.
   Andreas advised me to use FIBMAP to get physical block number,
   but not feasible due to address_space_operations.
   So this ioctl calls ext4_bmap() directly. 
   Thank you for your advice, Andreas!

3. Change the interface unit from bytes into blocks between user-space and
   kernel-space to be clear.

4. Andrew Morton suggested the following fixes.
   - Consider the type of variables which are file related offset,
     so I change them from unsigned long into ext4_fsblk_t. 
   - Remove unneeded wait_on_page_locked() in ext4_ext_replace_branches.
   - To avoid overflow, add the cast to shift bit calculate points.
   Thank you for your review and comments, Andrew. 

Current status:
These patches are at the experimental stage so they have many issues and
items to improve.  But they are worth enough to examine my trial.

Dependencies:
My patches depend on the following Alex's patches of the multi-block
allocation for Linux 2.6.19-rc6.
"[RFC] delayed allocation, mballoc, etc"
http://marc.theaimsgroup.com/?l=linux-ext4&m=116493228301966&w=2

Outstanding issues:
Nothing for the moment.

Items to improve:
- Optimize the depth of extent tree and the number of leaf nodes.
  after defragmentation.

- The blocks on the temporary inode are moved to the original inode
  by a page in the current implementation.  I have to tune
  the pages unit for the performance.

- Support indirect block file.

Next steps:
I will update my patches to optimize the depth of extent tree
and the number of leaf nodes.

Summary of patches:
*These patches apply on top of Alex's patches.
"[RFC] delayed allocation, mballoc, etc"
http://marc.theaimsgroup.com/?l=linux-ext4&m=116493228301966&w=2

[PATCH 1/3] Allocate new contiguous blocks with Alex's mballoc
- Search contiguous free blocks and allocate them for the temporary
  inode with Alex's multi-block allocation.

[PATCH 2/3] Move the file data to the new blocks
- Move the blocks on the temporary inode to the original inode
  by a page.

[PATCH 3/3] Online defrag command
- The defrag command.  Usage is as follows:
  o Put the multiple files closer together.
    # e4defrag -r directory-name
  o Defrag for a single file.
    # e4defrag file-name
  o Defrag for all files on ext4.
    # e4defrag device-name

Cheers, Takashi
    

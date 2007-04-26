From: "Takashi Sato" <sho@tnes.nec.co.jp>
Subject: ext4 online defrag (ver 0.4)
Date: Thu, 26 Apr 2007 21:11:39 +0900
Message-ID: <20070426211139sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:59250 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031194AbXDZMPd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Apr 2007 08:15:33 -0400
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l3QCFUZf017136
	for <linux-ext4@vger.kernel.org>; Thu, 26 Apr 2007 21:15:30 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.192])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l3QCBScs022518
	for <linux-ext4@vger.kernel.org>; Thu, 26 Apr 2007 21:11:28 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l3QCBS302942 for linux-ext4@vger.kernel.org; Thu, 26 Apr 2007 21:11:28 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv3.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l3QCBRL24854 for <linux-ext4@vger.kernel.org>; Thu, 26 Apr 2007 21:11:27 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070426.211127.09401608 for <linux-ext4@vger.kernel.org>
	; Thu, 26 Apr 2007 21:11:27 +0900
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

I have made following changes to the previous online defrag patchset
to improve it. Note that there is no functional change.

1. Change the handling of temporary inode.
   Now ext4_ext_defrag() calls ext4_new_inode()/iput() pair instead of
   new_inode()/delete_ext_defrag_inode(). Because new_inode() does not
   initialize all of entries that I need such as i_extra_isize.

2. Change how to swap blocks.
   In this patchset, the original blocks of the target file are swapped
   with temporary inode carefully to release them in iput().

3. Add an exclusive lock.
   Now ext4_inode_info.truncate_mutex is locked while the file being
   defragmented.

4. Add marking locality group as dirty.
   The lg is moved to s_locality_dirty list and marked as dirty
   if nr_to_write (total page count which has not written in disk yet)
   is 0 or less and lg_io is not empty in ext4_lg_sync_single_group(). 
   This makes sure that inode is written to disk.

Current status:
These patches are at the experimental stage so they have issues and
items to improve. But these are worth enough to examine my trial.

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
- Defragmentation for free space fragmentation.
  If filesytem has insufficient contiguous blocks, move other files
  to make sufficient space and allocate the contiguous blocks for
  the target file.

Summary of patches:
*These patches apply on top of Alex's patches.
"[RFC] delayed allocation, mballoc, etc"
http://marc.theaimsgroup.com/?l=linux-ext4&m=116493228301966&w=2

[PATCH 1/4] Allocate new contiguous blocks with Alex's mballoc
- Search contiguous free blocks and allocate them for the temporary
  inode with Alex's multi-block allocation.

[PATCH 2/4] Move the file data to the new blocks
- Move the blocks on the temporary inode to the original inode
  by a page.

[PATCH 3/4] Online defrag command
- The defrag command.  Usage is as follows:
  o Put the multiple files closer together.
    # e4defrag -r directory-name
  o Defrag for a single file.
    # e4defrag file-name
  o Defrag for all files on ext4.
    # e4defrag device-name

[PATCH 4/4] ext4_locality_group bug fix 
- Move lg_list to s_locality_dirty in ext4_lg_sync_single_group()
  to flush all of dirty inodes.

Any comments from reviews or tests are very welcome.

Cheers, Takashi

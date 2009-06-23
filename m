From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH 0/7]ext4: Block allocation restriction and inode preferred
 range of blocks for ext4
Date: Tue, 23 Jun 2009 17:25:06 +0900
Message-ID: <4A409162.6000307@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:38357 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbZFWI0i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jun 2009 04:26:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

These are trial patches to add block allocation restriction and
inode preferred range of blocks for ext4
(http://marc.info/?l=linux-ext4&m=123615213508332&w=2).

This change will help ext4 online defrag to re-implement
force defrag (-f) and relevant defrag (-r) features
which defrag had implemented in the past version.

Summary of this function:
  a. Block allocation restriction (EXT4_IOC_ADD_GLOBAL_ALLOC_RULE)
     This is the ioctl interface which allows a privileged program to specify
     one or more range of blocks which the filesystem's block allocator
     must not allocate from.
     This allows the ext4 online defrag to solve free space fragmentation;
     it has to do with force defragmentation mode.
     This feature may be useful for online shrink; at first, we restrict the
     allocation from the tail of a filesystem, then move data away from there,
     and shorten the size of it.

  b. Preferred blocks allocation (EXT4_IOC_ADD_INODE_ALLOC_RULE)
     This is ioctl interface which associates an inode with preferred range of
     blocks which the block allocator will try using first.
     It gives the two following features to ext4 online defrag.
      1. Defragment files and re-allocate them closely each other
         (Relevant file defragmentation mode needs this one).
      2. After solving free space fragmentation, re-allocate a file to the
         contiguous free space (Force defragmentation mode needs this one).
     It is also possible to allocate particular blocks to a file with
     fallocate in advance.

This patch set consists of following 7 patches (6/7 and 7/7 are for debugging).
And can be applied to the ext4 patch queue (2.6.30-git14).

[1/7] Add EXT4_IOC_ADD_GLOBAL_ALLOC_RULE restricts block allocation
[2/7] Add EXT4_IOC_CLR_GLOBAL_ALLOC_RULE clears block allocation restriction
[3/7] Add EXT4_IOC_ADD_INODE_ALLOC_RULE sets inode preferred range of blocks
[4/7] Implement the block allocation with restricted blocks
[5/7] Implement the block allocation with preferred allocation range
[6/7] (For debugging) Add EXT4_IOC_PRINT_GLOBAL_ARULE prints
      block allocation restriction
[7/7] (For debugging) Add EXT4_IOC_PRINT_INODE_ARULE prints
      preferred block allocation

ToDos:
1. Support indirect blocks (Current implementation is just for extent based file).
2. Inspect for the lock order of block group and allocation rule.

Any comments are very welcome.

Best regards,
Akira Fujita


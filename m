From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH 0/5] ext4 online defrag (ver 0.6)
Date: Thu, 27 Dec 2007 20:11:29 +0900
Message-ID: <200712271111.AA00285@TNESG9526.rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:33667 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbXL0LNi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Dec 2007 06:13:38 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I have updated my ext4 online defrag patch set to re-base from
linux-2.6.19-rc6 to linux-2.6.24-rc5(ext4 patch queue).
Ext4 online defrag has the following three functions.

1.[ no option ] Solving a single file fragmentation
Single file fragmentation is solved by moving file
data to contiguous free blocks.

2.[ -r ] Solving a relevant file fragmentation
Relevant file fragmentation is solved by moving
the files under the specified directory closer together.

3.[ -f ] Solving a free space fragmentation
If there is no contiguous free blocks in the filesystem,
the other files are moved to make sufficient space to allocate
contiguous blocks for the target file.

Current status:
These patches are at the experimental stage so they have some
items to improve. But these are worth enough to examine my trial.

Dependencies:
My patches depend on the multi-block allocation in ext4 patch queue.

Outstanding issues:
Nothing for the moment.

Next steps:
- Make carry out movement of data as atomic transaction.

Summary of patches:
*These patches are applied on the top of
 ext4 git tree(linux-2.6.24-rc5).
http://repo.or.cz/r/ext4-patch-queue.git

[PATCH 1/5] ext4 online defrag header file changes
- Header file changes used by online defrag.

[PATCH 2/5] Allocate new contiguous blocks with mballoc
- Search contiguous free blocks and allocate them for the temporary
inode with the multi-block allocation.

[PATCH 3/5] Move the file data to the new blocks
- Move the blocks on the temporary inode to the original inode
by a page.

[PATCH 4/5] Free space fragmentation functions
- Defrag tries to move other files to make sufficient space
and reallocates the contiguous blocks for the target file.

[PATCH 5/5] Online defrag command
- The defrag command. Usage is as follows:
o Put the multiple files closer together.
  # e4defrag -r directory-name
o Defrag for free space fragmentation.
  # e4defrag -f file-name
o Defrag for a single file.
  # e4defrag file-name
o Defrag for all files on ext4.
  # e4defrag device-name

Any comments from reviews or tests are very welcome.

Cheers, Akira

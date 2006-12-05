From: sho@tnes.nec.co.jp
Subject: [RFC][PATCH 0/2] Extent base online defrag (ver 0.2)
Date: Tue, 5 Dec 2006 20:18:44 +0900
Message-ID: <20061205201844sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:59160 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759954AbWLELSp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Dec 2006 06:18:45 -0500
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.195])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id kB5BIh4X024449
	for <linux-ext4@vger.kernel.org>; Tue, 5 Dec 2006 20:18:43 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id kB5BIgI01410 for linux-ext4@vger.kernel.org; Tue, 5 Dec 2006 20:18:42 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv3.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id kB5BIgA23989 for <linux-ext4@vger.kernel.org>; Tue, 5 Dec 2006 20:18:42 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20061205.202412.76502608 for <linux-ext4@vger.kernel.org>
	; Tue, 5 Dec 2006 20:24:12 +0900
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi

I've updated my patches for the extent base online defrag.
The differences from my previous patches are as follows:
- Fix the problem that the number of the used blocks reported by
  quota command decreases incorrectly after defragmentation.
- Support the hole file.
- Fix the credit calculation for the journal transaction. 
  2048 was passed to ext3_journal_start() directly for the provisional
  solution.  Now, the number of the modified blocks 
  is calculated and passed to ext3_ext_journal_restart() before
  modifying the metadata block for inserting the new extent or freeing
  the blocks.

My patches need the following Alex's old patches for the multi-block
allocation.
"[RFC] extents,mballoc,delalloc for 2.6.16.8"
  http://marc.theaimsgroup.com/?l=linux-ext4&m=114669168616780&w=2
So they support only ext3.  Alex updated his patches recently, so I will
update my patches to support ext4 later.

I have found the problem which causes Oops when inserting
the 5th extent into the temporary inode.  The new extent was corrupted
because the first block in it was used as a extent block and the length
of it shortened in ext3_new_block_cb().
When the filesystem has free blocks sufficiently, the number of
the extents in the temporary inode is usually less than 5 and it
doesn't occur.
This problem seems to be fixed on ext4 of the mainline.  So, it will
be solved when I update my patches for ext4 later.

My TODO list contains the followings.
- Support ext4.
- Put the multiple files close together.
- Support indirect block file.
- Optimize the depth of extent tree and the number of extent blocks
  after defragmentation.
- The blocks on the temporary inode are moved to the original inode
  by a page in the current implementation.  I have to tune
  the pages unit for the performance.

Summary Of Patches:
*These patches apply on top of Alex's patches.
 "[RFC] extents,mballoc,delalloc for 2.6.16.8"
 http://marc.theaimsgroup.com/?l=linux-ext4&m=114669168616780&w=2

[PATCH 1/2] Allocate new contiguous blocks with Alex's mballoc
- Search contiguous free blocks and allocate them for the temporary
  inode with Alex's multi-block allocation.

[PATCH 2/2] Move the file data to the new blocks
- Move the blocks on the temporary inode to the original inode
  by a page.

* The command isn't changed.  You can get it from the following URL.
  "[RFC][PATCH 3/3] Online defrag command"
  http://marc.10east.com/?l=linux-ext4&m=116307074817572&w=1

Any comments are welcome.

Cheers, Takashi

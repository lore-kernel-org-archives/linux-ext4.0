From: sho@tnes.nec.co.jp
Subject: [RFC][PATCH 0/3] ext4 online defrag (ver 0.2)
Date: Tue, 16 Jan 2007 21:03:46 +0900
Message-ID: <20070116210346sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:35963 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbXAPMII (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Jan 2007 07:08:08 -0500
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l0GC864P008090
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jan 2007 21:08:06 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.162])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l0GC434N005852
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jan 2007 21:04:03 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l0GC43N19946 for linux-ext4@vger.kernel.org; Tue, 16 Jan 2007 21:04:03 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv.nec.co.jp (8.11.7/3.7W-MAILSV-NEC) with ESMTP
	id l0GC43j25745 for <linux-ext4@vger.kernel.org>; Tue, 16 Jan 2007 21:04:03 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070116.210402.95300436 for <linux-ext4@vger.kernel.org>
	; Tue, 16 Jan 2007 21:04:03 +0900
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi

I have modified the online defrag patches to add new function which can
put the multiple files closer together.  It is effective for
an application which reads many small files.  Our goal is to reduce
OS booting time by putting the files, read during OS booting,
closer together.

Implementation:
All the files under the directory specified by
"e4defrag -r directory-name" are put closer together.
The modifications are as followings.
1. Add new ioctl(EXT4_IOC_DEFRAG) which returns the first physical
   block number of the specified file.  With this ioctl, a command
   gets the specified directory's.

2. The new entry "goal" is added on ext4_ext_defrag_data structure
   which is passed to existing ioctl(EXT4_IOC_DEFRAG)
   as the argument.  The kernel starts searching the free blocks
   from "goal".  The command passes the physical block number
   gotten in the above step(1) to the ioctl.

struct ext4_ext_defrag_data {
        loff_t start_offset; /* start offset to defrag in byte */
        loff_t defrag_size;  /* size of defrag in bytes */
	ext4_fsblk_t goal;   /* block offset for allocation */
};

Current status:
These patches are at the experimental stage so they have many issues and
items to improve.  But they are worth enough to examine my trial.

Dependencies:
My patches depend on the following Alex's patches of the multi-block
allocation for Linux 2.6.19-rc6.
"[RFC] delayed allocation, mballoc, etc"
http://marc.theaimsgroup.com/?l=linux-ext4&m=116493228301966&w=2

Outstanding issues:
When the extent block is filled with extents and there are no space
for additional extent, the new extent cannot be inserted and the defrag
fails in my current implementation.

Items to improve:
- Optimize the depth of extent tree and the number of extent blocks
  after defragmentation.
- The blocks on the temporary inode are moved to the original inode
  by a page in the current implementation.  I have to tune
  the pages unit for the performance.
- Support indirect block file.

Next steps:
I will update my patches to solve the problem described on above
"Outstanding issues" in the beginning of February.

Any comments from reviews or tests are welcome.

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

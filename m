From: sho@tnes.nec.co.jp
Subject: [RFC][PATCH 0/3] Extent base online defrag
Date: Thu, 9 Nov 2006 20:09:50 +0900
Message-ID: <20061109200950sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:37276 "EHLO
	tyo202.gate.nec.co.jp") by vger.kernel.org with ESMTP
	id S932789AbWKILJs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Nov 2006 06:09:48 -0500
Received: from mailgate4.nec.co.jp (mailgate53.nec.co.jp [10.7.69.184])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id kA9B9lT6019818
	for <linux-ext4@vger.kernel.org>; Thu, 9 Nov 2006 20:09:47 +0900 (JST)
Received: (from root@localhost) by mailgate4.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id kA9B9l823224 for linux-ext4@vger.kernel.org; Thu, 9 Nov 2006 20:09:47 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv5.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id kA9B9ka20038 for <linux-ext4@vger.kernel.org>; Thu, 9 Nov 2006 20:09:46 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20061109.201440.20304392 for <linux-ext4@vger.kernel.org>
	; Thu, 9 Nov 2006 20:14:40 +0900
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

>I am considering the online defrag function for ext4 and thinking
>that your following patch set for multi-block allocation is useful
>to search contiguous free blocks for the defragmentation.
>
>"[RFC] extents,mballoc,delalloc for 2.6.16.8"
>http://marc.theaimsgroup.com/?l=linux-ext4&m=114669168616780&w=2
>
>I will send the patch of simple defrag implementation for ext4 later.

I have written the patches of ioctl for extent base online defragment
and the command which call it.
These patches are at the experimental stage so they need many
improvements.  But they work well so far as basic defragmenter,
which means they are worth enough to examine my trial.

- Specify the target area in a file using the following structure:
  struct ext3_ext_defrag_data {
	  loff_t start_offset; /* start offset to defrag in bytes */
	  loff_t defrag_size;  /* size of defrag in bytes */
  }
  It uses loff_t so that the size of the structure is identical on
  both 32 bits and 64 bits architecture.
  Block allocation, including searching for the free contiguous
  blocks, is implemented in kernel.
  
- The procedures for the defragment in kernel are as follows:
  Blocks are allocated for the temporary inode by 16384 pages
  and the block on the temporary inode is moved to the original inode
  by a page.  I think I need to tune the above pages unit
  for the performance.  It's in my TODO list.
  1. Allocate blocks for the temporary inode.
  2. Move the blocks on the temporary inode to the original inode
     by a page.
     2.1 Read the file data from the old blocks to the page
     2.2 Move the block on the temporary inode to the original inode
     2.3 Write the file data on the page into the new blocks

- Currently, this patch works only for ext3 because it needs
  Alex Tomas's ext3 multi-block allocation patch which is for 2.6.16.8.
  "[RFC] extents,mballoc,delalloc for 2.6.16.8"
  http://marc.theaimsgroup.com/?l=linux-ext4&m=114669168616780&w=2
  But, my target is the defragment for ext4.  So I hope to start
  the work for ext4 soon.

- On block allocation for the temporary inode(ext3_ext_new_extent_tree()),
  the number of the modified blocks for metadata(extent block) is
  calculated in ext3_ext_writepage_trans_blocks().  As the resulting
  value can exceed the max blocks for the transaction(2048), passing
  2048 directly to ext3_journal_start() for the provisional solution.
  It's in my TODO list.

- They don't support the following:
  - Not support the indirect block file(only for the extent file).
  - Not optimize the depth of extent tree and the number of
    extent blocks after defragmentation.
  - Not support quota.
  - Not support a hole file.
  These are also in my TODO list.

Summary Of Patches:
*These patches apply on top of above Alex's patches.

[PATCH 1/3] Allocate new contiguous blocks with Alex's mballoc
- Search contiguous free blocks and allocate them for the temporary
  inode with Alex's multi-block allocation.

[PATCH 2/3] Move the file data to the new blocks
- Move the blocks on the temporary inode to the original inode
  by a page.

[PATCH 3/3] Online defrag command
- The defrag command.  Usage is as follows:
  o Defrag for a file.
    # e4defrag file-name
  o Defrag for all files on ext3.
    # e4defrag device-name

I created 50 fragmented files of 1GB and ran e4defrag for each of them.
As a result, I got the following improvement.
"Fragments" is the total number of fragments on 50 files.
"I/O performance" is the elapsed time for reading 50 files
with "cat" command(cat file* > /dev/null). 

                   Before defrag    After defrag 
---------------------------------------------------------------------
Fragments                  12175             800
I/O performance(Second)    618.3           460.6(25% improvement!!)

Any comments are welcome.
Cheers, Takashi

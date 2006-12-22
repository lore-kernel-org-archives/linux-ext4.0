From: sho@tnes.nec.co.jp
Subject: [RFC][PATCH 0/3] ext4 online defrag
Date: Fri, 22 Dec 2006 19:27:53 +0900
Message-ID: <20061222192753sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi

I have modified the online defrag patches to support ext4
on Linux 2.6.19-rc6.  There is no difference of the features
from the previous version.

My patches need the following Alex's patches of the multi-block
allocation for Linux 2.6.19-rc6.
"[RFC] delayed allocation, mballoc, etc"
http://marc.theaimsgroup.com/?l=linux-ext4&m=116493228301966&w=2

The extent old code for Linux 2.6.16.8 has the problem which causes Oops
on defrag when inserting the 5th extent into the temporary inode.
This problem is solved in Linux 2.6.19-rc6 which is the base for my new
patches.

ext4_mb_free_blocks() calls ext4_mb_return_to_preallocation() to release
the pre-allocated blocks from inode.
But ext4_mb_return_to_preallocation() is empty in current Alex's
implementation.
So the defrag calls ext4_mb_discard_inode_preallocations() to release
the pre-allocated blocks before calling ext4_md_free_blocks() to free
the blocks of the target file.  This is a provisional solution.
I will remove it when Alex implements the formal
ext4_mb_return_to_preallocation().

My TODO list contains the followings.
- When the extent block is filled with extents and there are no space
  for additional extent, the new extent cannot be inserted and the defrag
  fails in my current implementation.  I am considering the solution
  of it.
- Put the multiple files closer together.
- Support indirect block file.
- Optimize the depth of extent tree and the number of extent blocks
  after defragmentation.
- The blocks on the temporary inode are moved to the original inode
  by a page in the current implementation.  I have to tune
  the pages unit for the performance.

These patches are at the experimental stage so they need many
improvements.  But they are worth enough to examine my trial.
Any comments from reviews or tests are welcome.

Summary Of Patches:
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
  o Defrag for a file.
    # e4defrag file-name
  o Defrag for all files on ext4.
    # e4defrag device-name

Cheers, Takashi

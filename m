From: "J.D. Bakker" <jdb@lartmaker.nl>
Subject: Once more: Recovering a damaged ext4 fs?
Date: Fri, 27 Mar 2009 21:41:21 +0100
Message-ID: <p0624058dc5f2d7be08cc@[130.161.115.44]>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.lartmaker.nl ([69.93.127.100]:35056 "EHLO www.lartmaker.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbZC0VZ6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Mar 2009 17:25:58 -0400
Received: from bakker by www.lartmaker.nl with local (Exim 4.69)
	(envelope-from <bakker@lartmaker.nl>)
	id 1LnIrf-0002lV-9T
	for linux-ext4@vger.kernel.org; Fri, 27 Mar 2009 21:41:19 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

My 4TB ext4 RAID-6 has been damaged again. Symptoms leading up to it 
were very similar to the last time (see 
http://article.gmane.org/gmane.comp.file-systems.ext4/11418 ): a 
process attempted to delete a large (~2GB) file, resulting in a soft 
lockup with the following call trace:

  [<ffffffff80526dd7>] ? _spin_lock+0x16/0x19
  [<ffffffff80317b49>] ? ext4_mb_init_cache+0x81c/0xa58
  [<ffffffff80281249>] ? __lru_cache_add+0x8e/0xb6
  [<ffffffff80279d37>] ? find_or_create_page+0x62/0x88
  [<ffffffff80317ec2>] ? ext4_mb_load_buddy+0x13d/0x326
  [<ffffffff80318385>] ? ext4_mb_free_blocks+0x2da/0x75e
  [<ffffffff802c02d7>] ? __find_get_block+0xc6/0x1bc
  [<ffffffff802feebb>] ? ext4_free_blocks+0x7f/0xb2
  [<ffffffff8031294b>] ? ext4_ext_truncate+0x3e3/0x854
  [<ffffffff80306e38>] ? ext4_truncate+0x67/0x5bd
  [<ffffffff8032594e>] ? jbd2_journal_dirty_metadata+0x124/0x146
  [<ffffffff80314d44>] ? __ext4_handle_dirty_metadata+0xac/0xb7
  [<ffffffff803024c1>] ? ext4_mark_iloc_dirty+0x432/0x4a9
  [<ffffffff80303177>] ? ext4_mark_inode_dirty+0x135/0x166
  [<ffffffff803074e0>] ? ext4_delete_inode+0x152/0x22e
  [<ffffffff8030738e>] ? ext4_delete_inode+0x0/0x22e
  [<ffffffff802b44ac>] ? generic_delete_inode+0x82/0x109
  [<ffffffff802acd44>] ? do_unlinkat+0xf7/0x150
  [<ffffffff802a380c>] ? vfs_read+0x11e/0x133
  [<ffffffff80527545>] ? page_fault+0x25/0x30
  [<ffffffff8020c0ea>] ? system_call_fastpath+0x16/0x1

Kernel is 2.6.29-rc6. Machine is still responsive to anything that 
doesn't touch the ext4 file system, but fails to halt. Upon power 
cycling fsck fails with:

  newraidfs: Superblock has an invalid ext3 journal (inode 8).
  CLEARED.
  *** ext3 journal has been deleted - filesystem is now ext2 only ***

  newraidfs: Note: if several inode or block bitmap blocks or part
  of the inode table require relocation, you may wish to try
  running e2fsck with the '-b 32768' option first.  The problem
  may lie only with the primary block group descriptors, and
  the backup block group descriptors may be OK.

  newraidfs: Block bitmap for group 0 is not in group.  (block 3273617603)

  newraidfs: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
  	(i.e., without -a or -p options)

A manual e2fsck -nv /dev/md0 reported:

  e2fsck 1.41.4 (27-Jan-2009)
  ./e2fsck/e2fsck: Group descriptors look bad... trying backup blocks...
  Block bitmap for group 0 is not in group.  (block 3273617603)
  Relocate? no
  Inode bitmap for group 0 is not in group.  (block 3067860682)
  Relocate? no
  Inode table for group 0 is not in group.  (block 3051956899)
  WARNING: SEVERE DATA LOSS POSSIBLE.
  Relocate? no
  Group descriptor 0 checksum is invalid.  Fix? no
  Inode table for group 1 is not in group.  (block 1842273247)
  WARNING: SEVERE DATA LOSS POSSIBLE.
  Relocate? no
  Group descriptor 1 checksum is invalid.  Fix? no
  Inode bitmap for group 2 is not in group.  (block 3148026909)
  Relocate? no
  Inode table for group 2 is not in group.  (block 1321535690)
  WARNING: SEVERE DATA LOSS POSSIBLE.
  Relocate? no
  Group descriptor 2 checksum is invalid.  Fix? no
  [...]
  ./e2fsck/e2fsck: Invalid argument while reading bad blocks inode
  This doesn't bode well, but we'll try to go on...
  Pass 1: Checking inodes, blocks, and sizes
  Illegal block number passed to ext2fs_test_block_bitmap #3051956899 
for in-use block map
  Illegal block number passed to ext2fs_mark_block_bitmap #3051956899 
for in-use block map
  Illegal block number passed to ext2fs_test_block_bitmap #3051956900 
for in-use block map
  Illegal block number passed to ext2fs_mark_block_bitmap #3051956900 
for in-use block map
  [...]

Full logs available at:
   http://lartmaker.nl/ext4/e2fsck-md0-20090327.txt
   http://lartmaker.nl/ext4/e2fsck-md0-32768-20090327.txt
   http://lartmaker.nl/ext4/e2fsck-md0-98304-20090327.txt

I've run dumpe2fs:
   http://lartmaker.nl/ext4/dumpe2fs-md0-20090327.txt
   http://lartmaker.nl/ext4/dumpe2fs-md0-32768-20090327.txt
   http://lartmaker.nl/ext4/dumpe2fs-md0-98304-20090327.txt
...but it worries me that all three start with "ext2fs_read_bb_inode: 
Invalid argument".

This is linux-2.6.29-rc6 (x86_64) running on an Intel Core i7 920 
processor (quad core plus hyperthreading). Kernel config is 
http://lartmaker.nl/ext4/kernel-config-20090327.txt ; dmesg is at 
http://lartmaker.nl/ext4/dmesg-20090327.txt

So,
- is there a way to recover my file system? I do have backups of most 
data,but as my remote weeklies run on Saturdays I'd still lose a lot 
of work
- is ext4 on software raid-6 on x86_64 considered production stable? 
I have been getting these hangs almost monthly, which is a lot worse 
than my old ext3 software RAID.

Thanks,

JDB.


-- 
LART. 250 MIPS under one Watt. Free hardware design files.
http://www.lartmaker.nl/

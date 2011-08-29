From: Utako Kusaka <u-kusaka@wm.jp.nec.com>
Subject: BUG: i_size and i_blocks corruption on ext4 with ^huge_file
Date: Mon, 29 Aug 2011 10:45:31 +0900
Message-ID: <4E5AEF3B.8090207@wm.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:40214 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab1H2B4r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Aug 2011 21:56:47 -0400
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id p7T1ujfp007523
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 29 Aug 2011 10:56:45 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

In ext4 with ^huge_file, s_maxbytes is 2199023251456. But when I create a file
size of 2199023251456 bytes, i_size and i_blocks are corrupted.

If a file size of 2TB is created, i_blocks including metadata blocks will be
over 32bit. So ext4_inode_blocks_set returns EFBIG, and i_size and i_blocks
are not updated in ext4_do_update_inode.

e.g. fallocate

ext4_fallocate
    ext4_map_blocks
    ext4_falloc_update_inode
    ext4_mark_inode_dirty
         ext4_do_update_inode
              ext4_inode_blocks_set	<---- error


# uname -a
Linux mcds1 3.0.0 #2 SMP Mon Aug 8 17:58:28 JST 2011 x86_64 x86_64 x86_64 GNU/Linux
# mkfs -t ext4 -O ^huge_file /dev/vg0/lv0
# mount /dev/vg0/lv0 /mnt/mp1
# fallocate -o 0 -l 2199023251456 /mnt/mp1/testfile
# stat /mnt/mp1/testfile
  File: `/mnt/mp1/testfile'
  Size: 2199023251456	Blocks: 4294967688 IO Block: 4096   regular file
Device: fd00h/64768d	Inode: 12          Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2011-08-09 10:20:31.008699267 +0900
Modify: 2011-08-09 10:20:31.008699267 +0900
Change: 2011-08-09 10:20:42.769699811 +0900

# umount /mnt/mp1
# e2fsck -ttf /dev/vg0/lv0
e2fsck 1.41.12 (17-May-2010)
Pass 1: Checking inodes, blocks, and sizes
Inode 12, i_size is 2198888873984, should be 2199023251456.  Fix<y>? yes

Inode 12, i_blocks is 4294705232, should be 4294967688.  Fix<y>? yes

:

--
Utako Kusaka

From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: on disk format: value of bg_inode_table_hi?
Date: Wed, 28 Jan 2009 00:20:38 +0000 (GMT)
Message-ID: <736081.19431.qm@web23606.mail.ird.yahoo.com>
Reply-To: etienne_lorrain@yahoo.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web23606.mail.ird.yahoo.com ([87.248.115.49]:20434 "HELO
	web23606.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751524AbZA1A1V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2009 19:27:21 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I have created an ext4 fs on a 64 Mb USB disk by "mkfs.ext4 /dev/sdb" on debian lenny (no partition). I have debugfs 1.41.3 (12-Oct-2008), so
probably an up-to-date mkfs.ext4.
When I analyse the filesystem using my own tools, I seem to read at least
some bg_inode_table_hi values which are not null, on such a very small
filesystem.
Because the superblock s_feature_incompat has the 64BITS set, I assumed
I should use those _hi fields.
If I ignore the value of bg_inode_table_hi that I read as 512, I can at
least analyse the few files I have put into it with debugfs (I strangely
cannot mount that filesystem under debian).

Here is the log I get from my debug softs (sorry, long lines):
#### disk_analyse disk 2 i.e. EBIOS 0x01: (nb found = 6):

## open_filesystem Disk 2 part 0 type 0xE, read first 4 Kbytes: name already set to 'floppy'

E2FS_get_parameter: Filesystem name: 'testext4' Filesystem opened (inode size 128, inodes_per_group 1912).

FSname 'testext4': byte_per_block 1024 bytes, sector_per_block 2, first_data_block 1, inodes_count 15296, blocks_count 61,056.

open_filesystem() success, Scan root directory: E2FS_get_sector_chain (inode 2): [E2FS_read_inode: inode 2, group 0, block 1] [bg_inode_table_hi = 512, bg_inode_table_lo = 273] i_blocks_lo 2 i_size_lo 1024: [create for lba 498]  [read_analyse_chain: indirect blocknr == 0, level 1]  [read_analyse_chain: indirect blocknr == 0, level 2]  [read_analyse_chain: indirect blocknr == 0, level 3] 2 sectors at 498, OK

 [ignore: '/.']  [ignore: '/..']  [ignore: '/lost+found']  [is vmlinuz with header: '/vmlinuz-2.6.26-1-686']  [E2FS_read_inode: inode 12, group 0, block 11] [bg_inode_table_hi = 512, bg_inode_table_lo = 273]  [E2FS_treat_directory: adding file 'vmlinuz-2.6.26-1-686' size 1505936 bytes]  [is initrd: '/initrd.img-2.6.26-1-686']  [E2FS_read_inode: inode 13, group 0, block 12] [bg_inode_table_hi = 512, bg_inode_table_lo = 273]  [E2FS_treat_directory: adding file 'initrd.img-2.6.26-1-686' size 7182236 bytes]  [E2FS_read_inode: inode 14, group 0, block 13] [bg_inode_table_hi = 512, bg_inode_table_lo = 273]  [E2FS_treat_directory: storing 'boot' directory at inode 14 size 1024]  [E2FS_treat_directory: need to read more sectors] [file_treat: done, read 1024 bytes]

 (main dir size 1024) 

Scan /boot directory: E2FS_get_sector_chain (inode 14): [E2FS_read_inode: inode 14, group 0, block 13] [bg_inode_table_hi = 512, bg_inode_table_lo = 273] i_blocks_lo 2 i_size_lo 1024: [create for lba 21816]  [read_analyse_chain: indirect blocknr == 0, level 1]  [read_analyse_chain: indirect blocknr == 0, level 2]  [read_analyse_chain: indirect blocknr == 0, level 3] 2 sectors at 21816, OK

 [ignore: '/boot/.']  [ignore: '/boot/..']  [is vmlinuz with header: '/boot/vmlinuz-2.6.26-1-686']  [E2FS_read_inode: inode 15, group 0, block 14] [bg_inode_table_hi = 512, bg_inode_table_lo = 273]  [E2FS_treat_directory: adding file 'vmlinuz-2.6.26-1-686' size 1505936 bytes]  [is initrd: '/boot/initrd.img-2.6.26-1-686']  [E2FS_read_inode: inode 16, group 0, block 15] [bg_inode_table_hi = 512, bg_inode_table_lo = 273]  [E2FS_treat_directory: adding file 'initrd.img-2.6.26-1-686' size 7182236 bytes]  [E2FS_treat_directory: need to read more sectors] [file_treat: done, read 1024 bytes]

 (/ScanPath directory size 1024) , end scan.



So my question:
Is that a bug on my side, a mis-interpretation of the use of that bg_inode_table_hi field, or a problem somewhere else?

Thanks for any answer,
Etienne.


      

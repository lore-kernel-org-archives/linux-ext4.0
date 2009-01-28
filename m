From: Andreas Dilger <adilger@sun.com>
Subject: Re: on disk format: value of bg_inode_table_hi?
Date: Wed, 28 Jan 2009 11:01:37 -0700
Message-ID: <20090128180137.GD3652@webber.adilger.int>
References: <736081.19431.qm@web23606.mail.ird.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:53155 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZA1SB7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Jan 2009 13:01:59 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n0SI1iWo004388
	for <linux-ext4@vger.kernel.org>; Wed, 28 Jan 2009 10:01:56 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KE700D0108Z5300@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 28 Jan 2009 10:01:44 -0800 (PST)
In-reply-to: <736081.19431.qm@web23606.mail.ird.yahoo.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 28, 2009  00:20 +0000, Etienne Lorrain wrote:
> I have created an ext4 fs on a 64 Mb USB disk by "mkfs.ext4 /dev/sdb" on
> debian lenny (no partition). I have debugfs 1.41.3 (12-Oct-2008), so
> probably an up-to-date mkfs.ext4.
> When I analyse the filesystem using my own tools, I seem to read at least
> some bg_inode_table_hi values which are not null, on such a very small
> filesystem.
> Because the superblock s_feature_incompat has the 64BITS set, I assumed
> I should use those _hi fields.
> If I ignore the value of bg_inode_table_hi that I read as 512, I can at
> least analyse the few files I have put into it with debugfs (I strangely
> cannot mount that filesystem under debian).

Does "e2fsck -f" fix this problem?  It definitely should.

> Here is the log I get from my debug softs (sorry, long lines):
> #### disk_analyse disk 2 i.e. EBIOS 0x01: (nb found = 6):
> 
> ## open_filesystem Disk 2 part 0 type 0xE, read first 4 Kbytes: name already set to 'floppy'
> 
> E2FS_get_parameter: Filesystem name: 'testext4' Filesystem opened (inode size 128, inodes_per_group 1912).
> 
> FSname 'testext4': byte_per_block 1024 bytes, sector_per_block 2, first_data_block 1, inodes_count 15296, blocks_count 61,056.
> 
> open_filesystem() success, Scan root directory: E2FS_get_sector_chain (inode 2): [E2FS_read_inode: inode 2, group 0, block 1] [bg_inode_table_hi = 512, bg_inode_table_lo = 273] i_blocks_lo 2 i_size_lo 1024: [create for lba 498]  [read_analyse_chain: indirect blocknr == 0, level 1]  [read_analyse_chain: indirect blocknr == 0, level 2]  [read_analyse_chain: indirect blocknr == 0, level 3] 2 sectors at 498, OK
> 
>  [ignore: '/.']  [ignore: '/..']  [ignore: '/lost+found']  [is vmlinuz with header: '/vmlinuz-2.6.26-1-686']  [E2FS_read_inode: inode 12, group 0, block 11] [bg_inode_table_hi = 512, bg_inode_table_lo = 273]  [E2FS_treat_directory: adding file 'vmlinuz-2.6.26-1-686' size 1505936 bytes]  [is initrd: '/initrd.img-2.6.26-1-686']  [E2FS_read_inode: inode 13, group 0, block 12] [bg_inode_table_hi = 512, bg_inode_table_lo = 273]  [E2FS_treat_directory: adding file 'initrd.img-2.6.26-1-686' size 7182236 bytes]  [E2FS_read_inode: inode 14, group 0, block 13] [bg_inode_table_hi = 512, bg_inode_table_lo = 273]  [E2FS_treat_directory: storing 'boot' directory at inode 14 size 1024]  [E2FS_treat_directory: need to read more sectors] [file_treat: done, read 1024 bytes]
> 
>  (main dir size 1024) 
> 
> Scan /boot directory: E2FS_get_sector_chain (inode 14): [E2FS_read_inode: inode 14, group 0, block 13] [bg_inode_table_hi = 512, bg_inode_table_lo = 273] i_blocks_lo 2 i_size_lo 1024: [create for lba 21816]  [read_analyse_chain: indirect blocknr == 0, level 1]  [read_analyse_chain: indirect blocknr == 0, level 2]  [read_analyse_chain: indirect blocknr == 0, level 3] 2 sectors at 21816, OK
> 
>  [ignore: '/boot/.']  [ignore: '/boot/..']  [is vmlinuz with header: '/boot/vmlinuz-2.6.26-1-686']  [E2FS_read_inode: inode 15, group 0, block 14] [bg_inode_table_hi = 512, bg_inode_table_lo = 273]  [E2FS_treat_directory: adding file 'vmlinuz-2.6.26-1-686' size 1505936 bytes]  [is initrd: '/boot/initrd.img-2.6.26-1-686']  [E2FS_read_inode: inode 16, group 0, block 15] [bg_inode_table_hi = 512, bg_inode_table_lo = 273]  [E2FS_treat_directory: adding file 'initrd.img-2.6.26-1-686' size 7182236 bytes]  [E2FS_treat_directory: need to read more sectors] [file_treat: done, read 1024 bytes]
> 
>  (/ScanPath directory size 1024) , end scan.
> 
> 
> 
> So my question:
> Is that a bug on my side, a mis-interpretation of the use of that bg_inode_table_hi field, or a problem somewhere else?
> 
> Thanks for any answer,
> Etienne.
> 
> 
>       
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


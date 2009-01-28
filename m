From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re: on disk format: value of bg_inode_table_hi?
Date: Wed, 28 Jan 2009 20:47:09 +0000 (GMT)
Message-ID: <653674.25270.qm@web23601.mail.ird.yahoo.com>
References: <20090128180137.GD3652@webber.adilger.int>
Reply-To: etienne_lorrain@yahoo.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web23601.mail.ird.yahoo.com ([87.248.115.44]:31475 "HELO
	web23601.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754808AbZA1UrL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Jan 2009 15:47:11 -0500
In-Reply-To: <20090128180137.GD3652@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> De: Andreas Dilger <adilger@sun.com>
> Date: Mercredi 28 Janvier 2009, 18h01
> On Jan 28, 2009  00:20 +0000, Etienne Lorrain wrote:
> > I have created an ext4 fs on a 64 Mb USB disk by
> > "mkfs.ext4 /dev/sdb" on debian lenny (no partition).
> > When I analyse the filesystem using my own tools, I
> > seem to read at least some bg_inode_table_hi values which
> > are not null, on such a very small filesystem.
> 
> Does "e2fsck -f" fix this problem?  It definitely
> should.
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.

 Well, e2fsck does not see anything:
etienne-laptop:~# e2fsck -f /dev/sdc
e2fsck 1.41.3 (12-Oct-2008)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
testext4: 16/15296 files (43.8% non-contiguous), 24210/61056 blocks
etienne-laptop:~# umount /mnt/disk
umount: /mnt/disk: not mounted
etienne-laptop:~# mount -t ext4dev /dev/sdc /mnt/disk/
mount: wrong fs type, bad option, bad superblock on /dev/sdc,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

But after some reading, I used debugfs to "set_super_value s_flags 4",
and now the filesystem mounts under Debian.

My problem stays, I still read a non null bg_inode_table_hi, equal to 512.
I am using a copy of the structure struct ext_group_desc from ext4fs.h,
and I can read the right inode but only if I ignore that bg_inode_table_hi
value. I think I should use this _hi field because of the 64BIT bit of
the superblock, maybe I should not.
I retried to make the filesystem on the same device but from Fedora 10
on ia32, and I got the same bg_inode_table_hi:

## open_filesystem Disk 2 part 0 type 0xE, read first 4 Kbytes: name already set to 'floppy'

E2FS_get_parameter: Filesystem name: '' Filesystem opened (inode size 128, inodes_per_group 1912).

FSname '': byte_per_block 1024 bytes, sector_per_block 2, first_data_block 1, inodes_count 15296, blocks_count 61,056.

open_filesystem() success, Scan root directory: E2FS_get_sector_chain (inode 2): [E2FS_read_inode: inode 2, group 0, block 1] [bg_inode_table_hi = 512, bg_inode_table_lo = 273] i_blocks_lo 2 i_size_lo 1024: [create for lba 498]  [read_analyse_chain: indirect blocknr == 0, level 1]  [read_analyse_chain: indirect blocknr == 0, level 2]  [read_analyse_chain: indirect blocknr == 0, level 3] 2 sectors at 498, OK

 [ignore: '/.']  [ignore: '/..']  [ignore: '/lost+found']  [ignore: '/mkfs.log']  [E2FS_treat_directory: need to read more sectors] [file_treat: done, read 1024 bytes]

 (main dir size 1024) , end scan.



In short, shall I ignore bg_inode_table_hi when analysing an ext4fs,
because it is planed to be active under another bit than EXT4_FEATURE_INCOMPAT_64BIT ?

 Thanks,
 Etienne.



      

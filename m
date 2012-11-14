From: "George Spelvin" <linux@horizon.com>
Subject: 64bit + resize2fs... this is Not Good.
Date: 13 Nov 2012 22:51:01 -0500
Message-ID: <20121114035101.15686.qmail@science.horizon.com>
Cc: linux@horizon.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:33767 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932576Ab2KNDvD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Nov 2012 22:51:03 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As people might know from my recent postings, I've been expanding a RAID
with an ext4 file system.  This has uncovered Some Issues.

Because the final size exceeded 16 TiB, I had to use the 64bit support
which is relatively recent.

But now carrying out the resize has produced some problems...

# resize2fs -p /dev/md1
resize2fs 1.43-WIP (22-Sep-2012)
Filesystem at /dev/md1 is mounted on /data; on-line resizing required
old_desc_blocks = 932, new_desc_blocks = 2562
resize2fs: Not enough reserved gdt blocks for resizing

# /etc/init.d/smbd stop

# umount /data

# resize2fs -p /dev/md1
resize2fs 1.43-WIP (22-Sep-2012)
Please run 'e2fsck -f /dev/md1' first.

# e2fsck -v -C0 /dev/md1
e2fsck 1.43-WIP (22-Sep-2012)
data: clean, 2012464/7630464 files, 1727380558/1953383296 blocks

# e2fsck -f -v -C0 /dev/md1
e2fsck 1.43-WIP (22-Sep-2012)
Pass 1: Checking inodes, blocks, and sizes
eh_magic = 0000 != f30a
Pass 2: Checking directory structure                                           
Pass 3: Checking directory connectivity                                        
Pass 4: Checking reference counts                                              
Pass 5: Checking group summary information                                     
                                                                               
     2012464 inodes used (26.37%, out of 7630464)
        9604 non-contiguous files (0.5%)
        1374 non-contiguous directories (0.1%)
             # of inodes with ind/dind/tind blocks: 0/0/0
             Extent depth histogram: 2009443/3000
  1727380558 blocks used (88.43%, out of 1953383296)
           0 bad blocks
         392 large files

     1096215 regular files
      916227 directories
           0 character device files
           0 block device files
           0 fifos
     4346198 links
          12 symbolic links (12 fast symbolic links)
           1 socket
------------
     6358653 files

# resize2fs -p /dev/md1
resize2fs 1.43-WIP (22-Sep-2012)
Resizing the filesystem on /dev/md1 to 5371804064 (4k) blocks.
Begin pass 1 (max = 104322)
Extending the inode table     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Begin pass 2 (max = 12201)
Relocating blocks             XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Begin pass 3 (max = 59613)
Scanning inode table          XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Begin pass 5 (max = 1)
Moving inode table            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
The filesystem on /dev/md1 is now 5371804064 blocks long.

# e2fsck -v -C0 /dev/md1
e2fsck 1.43-WIP (22-Sep-2012)
ext2fs_check_desc: Corrupt group descriptor: bad block for block bitmap
e2fsck: Group descriptors look bad... trying backup blocks...
data was not cleanly unmounted, check forced.
Pass 1: Checking inodes, blocks, and sizes
Group 1's inode table at 1997 conflicts with some other fs block.
Relocate<y>? ^C

	[This bit lost toscroll.  Something like...]

data: e2fsck canceled.                                                           

data: ***** FILE SYSTEM WAS MODIFIED *****

	[Then I ran e2fsck -n once, it scrolled too much, and I ran it
	again while capturing the output.]

# e2fsck -n -v -C0 /dev/md1
e2fsck 1.43-WIP (22-Sep-2012)
ext2fs_check_desc: Corrupt group descriptor: bad block for block bitmap
e2fsck: Group descriptors look bad... trying backup blocks...
data was not cleanly unmounted, check forced.
Pass 1: Checking inodes, blocks, and sizes
Group 1's inode table at 1997 conflicts with some other fs block.
Relocate? no

Group 1's inode table at 1998 conflicts with some other fs block.
Relocate? no

Group 1's inode table at 1999 conflicts with some other fs block.
Relocate? no

Group 1's inode table at 2000 conflicts with some other fs block.
Relocate? no

Group 1's inode table at 2001 conflicts with some other fs block.
Relocate? no

Group 1's inode table at 2002 conflicts with some other fs block.
Relocate? no

Group 1's inode table at 2003 conflicts with some other fs block.
Relocate? no

Group 1's inode table at 2004 conflicts with some other fs block.
Relocate? no

Group 1's block bitmap at 1958 conflicts with some other fs block.
Relocate? no


This is tripleplusungood.  Any recovery suggestions eagerly received.
I'm poking around with dwbugfs -n right now...

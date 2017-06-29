From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: mkfs.ext4 -D option fails to mount
Date: Thu, 29 Jun 2017 09:35:38 -0600
Message-ID: <20170629153538.GA4268@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:59112 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753299AbdF2Pfk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 29 Jun 2017 11:35:40 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Our validation team noticed that in some configurations mkfs.ext4 with the
-D option creates a filesystem that can't be mounted:

  # mkfs.ext4 -D -F /dev/pmem5 
  mke2fs 1.43.3 (04-Sep-2016)
  /dev/pmem5 contains a ext4 file system
  	last mounted on Tue Jul 26 07:44:19 2016
  Creating filesystem with 65027584 4k blocks and 16261120 inodes
  Filesystem UUID: 6f95ece9-d4cb-4cfc-bc22-211119d5efe7
  Superblock backups stored on blocks: 
  	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
  	4096000, 7962624, 11239424, 20480000, 23887872
  
  Allocating group tables: done                            
  Writing inode tables: done                            
  Creating journal (262144 blocks): done
  Writing superblocks and filesystem accounting information: done     
  
  # mount /dev/pmem5 /mnt
  mount: wrong fs type, bad option, bad superblock on /dev/pmem5,
         missing codepage or helper program, or other error
  
         In some cases useful info is found in syslog - try
         dmesg | tail or so.

where dmesg says:

  EXT4-fs (pmem5): ext4_check_descriptors: Block bitmap for group 1 overlaps superblock
  EXT4-fs (pmem5): ext4_check_descriptors: Inode bitmap for group 1 overlaps superblock
  EXT4-fs (pmem5): ext4_check_descriptors: Inode table for group 1 overlaps superblock
  EXT4-fs (pmem5): ext4_check_descriptors: Block bitmap for group 2 overlaps superblock
  EXT4-fs (pmem5): ext4_check_descriptors: Inode bitmap for group 2 overlaps superblock
  EXT4-fs (pmem5): ext4_check_descriptors: Inode table for group 2 overlaps superblock
  ...
  EXT4-fs (pmem5): ext4_check_descriptors: Block bitmap for group 63 overlaps superblock
  EXT4-fs (pmem5): ext4_check_descriptors: Inode bitmap for group 63 overlaps superblock
  EXT4-fs (pmem5): ext4_check_descriptors: Inode table for group 63 overlaps superblock
  EXT4-fs (pmem5): no journal found

If we omit the "-D" option from mkfs.ext4, everything works.  Note also that
this behavior is independent of the DAX mount option.

This isn't blocking us, I just thought you would want to know.

- Ross

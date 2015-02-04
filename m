From: Olaf Hering <olaf@aepfle.de>
Subject: Re: ext3_dx_add_entry complains about Directory index full
Date: Wed, 4 Feb 2015 17:30:48 +0100
Message-ID: <20150204163048.GA8438@aepfle.de>
References: <20150204090447.GA20003@aepfle.de>
 <FCD1EFFD-330A-4953-8CF4-AC88D297F433@dilger.ca>
 <20150204135215.GA15159@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:54927 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965355AbbBDQau (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Feb 2015 11:30:50 -0500
Content-Disposition: inline
In-Reply-To: <20150204135215.GA15159@aepfle.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 04, Olaf Hering wrote:

> Ok, will try that. Thanks.

root@linux-fceg:~ # time env -i /sbin/e2fsck -fDvv /dev/mapper/luks-861f1f73-7037-486a-9a8a-8588367fcf33
e2fsck 1.42.12 (29-Aug-2014)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 3A: Optimizing directories
Pass 4: Checking reference counts
Pass 5: Checking group summary information

BACKUP_OLH_500G: ***** FILE SYSTEM WAS MODIFIED *****

     1886589 inodes used (7.20%, out of 26214400)
       38925 non-contiguous files (2.1%)
       28851 non-contiguous directories (1.5%)
             # of inodes with ind/dind/tind blocks: 163156/45817/319
   344807093 blocks used (82.21%, out of 419430400)
           0 bad blocks
           8 large files

      859307 regular files
     1026949 directories
           0 character device files
           0 block device files
           0 fifos
    19504583 links
         322 symbolic links (316 fast symbolic links)
           2 sockets
------------
    21391163 files

real    78m31.853s
user    3m24.616s
sys     1m20.599s

root@probook:~ # dumpe2fs -h /dev/dm-5
dumpe2fs 1.41.14 (22-Dec-2010)
Filesystem volume name:   BACKUP_OLH_500G
Last mounted on:          /media/BACKUP_OLH_500G
Filesystem UUID:          f0d41610-a993-4b77-8845-f0f07e37f61d
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery sparse_super large_file dir_nlink
Filesystem flags:         signed_directory_hash 
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              26214400
Block count:              419430400
Reserved block count:     419430
Free blocks:              74623307
Free inodes:              24327811
First block:              1
Block size:               1024
Fragment size:            1024
Reserved GDT blocks:      256
Blocks per group:         8192
Fragments per group:      8192
Inodes per group:         512
Inode blocks per group:   128
Filesystem created:       Tue Feb 12 18:24:13 2013
Last mount time:          Wed Feb  4 17:02:29 2015
Last write time:          Wed Feb  4 17:02:29 2015
Mount count:              1
Maximum mount count:      -1
Last checked:             Wed Feb  4 15:08:34 2015
Check interval:           0 (<none>)
Lifetime writes:          5039 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      55aeb7a2-43ca-4104-ad21-56d7a523dc8f
Journal backup:           inode blocks
Journal features:         journal_incompat_revoke
Journal size:             32M
Journal length:           32768
Journal sequence:         0x000a3a58
Journal start:            1

But still:

[44220.530001] scsi 4:0:0:0: Direct-Access     ATA      ST3500418AS      CC45 PQ: 0 ANSI: 5
[44220.530455] sd 4:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[44220.530548] sd 4:0:0:0: [sdb] Write Protect is off
[44220.530557] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[44220.530596] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[44220.534670] sd 4:0:0:0: Attached scsi generic sg1 type 0
[44220.549014]  sdb: sdb1
[44220.549721] sd 4:0:0:0: [sdb] Attached SCSI disk
[44238.004550] EXT4-fs (dm-5): mounted filesystem with ordered data mode. Opts: (null)
[45191.549831] EXT4-fs warning (device dm-5): ext4_dx_add_entry:1990: Directory index full!


Guess its time to wipe it and go with something else.


Olaf

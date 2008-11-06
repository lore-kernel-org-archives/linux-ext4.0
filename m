From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: EXT4-fs: not enough memory for 522250 flex groups
Date: Thu, 6 Nov 2008 16:00:54 +0100
Message-ID: <200811061600.54264.borntraeger@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

I tried to use ext4 on my s390 system. Converting the old ext3 file systems 
(tune2fs -O extents) worked fine. When I tried to create a new ext4 file 
system on a logical volume I got the "EXT4-fs: not enough memory for 522250 
flex groups" error messageduring mount:


# mke2fs -t ext4 /dev/mapper/space-test
mke2fs 1.41.3 (12-Oct-2008)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
262144 inodes, 1048576 blocks
52428 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=1073741824
32 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done
This filesystem will be automatically checked every 22 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.


# mount -t ext4 /dev/mapper/space-test /mnt/
mount: wrong fs type, bad option, bad superblock on /dev/mapper/space-test,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so



# dmesg
[...]
[6923911.715968] EXT4-fs: not enough memory for 522250 flex groups
[6923911.715973] EXT4-fs: unable to initialize flex_bg meta info!



# lvdisplay
  --- Logical volume ---
  LV Name                /dev/space/test
  VG Name                space
  LV UUID                FPhFLU-1xTK-XtG4-STmI-u3D5-KhCR-FmlcCO
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                4.00 GB
  Current LE             1024
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:54



# free
             total       used       free     shared    buffers     cached
Mem:       3081168     822972    2258196          0     154784     445420
-/+ buffers/cache:     222768    2858400
Swap:      9615904          0    9615904


# uname -a
Linux 2.6.28-rc2 #64 SMP Thu Nov 6 15:22:04 CET 2008 s390x s390x s390x 
GNU/Linux



# git describe
kvm-78-2-g6e6c459


Any ideas?

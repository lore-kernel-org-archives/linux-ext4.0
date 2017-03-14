From: Daniel Schultz <d.schultz@phytec.de>
Subject: Corrupt ext4 fs after creation
Date: Tue, 14 Mar 2017 11:34:32 +0100
Message-ID: <532e8151-ecc8-6411-9471-b7a74b4e0ab9@phytec.de>
References: <153de314-38ff-ad68-65d9-a292213b47f6@phytec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Cc: Teresa Remmet <t.remmet@phytec.de>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.rapiddevelopmentkit.de ([217.6.246.34]:32853 "EHLO
        root.phytec.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750785AbdCNKee (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 14 Mar 2017 06:34:34 -0400
Received: from idefix.phytec.de (idefix.phytec.de [172.16.0.10])
        by root.phytec.de (Postfix) with ESMTP id A187EA00269
        for <linux-ext4@vger.kernel.org>; Tue, 14 Mar 2017 11:35:01 +0100 (CET)
In-Reply-To: <153de314-38ff-ad68-65d9-a292213b47f6@phytec.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

we use the Yocto Project to create custom BSPs for a AM335x SoC. After 
they upgraded the e2fsprogs from 1.42.9 to 1.43 we run into problems 
with our ext4 root file system. During the first boot systemd checks the 
rootfs with fsck.ext4 and needs a restart beacause of an error.

The fs is created with mkfs.ext4 and direct I/O and is available on 
ftp://ftp.phytec.de/pub/Test/phytec-headless-image-phyboard-wega-am335x-2.ext4

$ du -ks 
/home/schultz/yocto/PD17.1.0/build/tmp/work/phyboard_wega_am335x_2-phytec-linux-gnueabi/phytec-headless-image/1.0-r0/rootfs
  109708
$ truncate /var/tmp/wic/build/rootfs_root.2.ext4 -s 159674777
$ mkfs.ext4 -F -i 8192 /var/tmp/wic/build/rootfs_root.2.ext4 -L root -d 
/home/schultz/yocto/PD17.1.0/build/tmp/work/phyboard_wega_am335x_2-phytec-linux-gnueabi/phytec-headless-image/1.0-r0/rootfs
  mke2fs 1.43 (17-May-2016)
  Discarding device blocks: done
  Creating filesystem with 155932 1k blocks and 19520 inodes
  Filesystem UUID: 6728344f-aa6d-4bbb-a06d-e649e36024d3
  Superblock backups stored on blocks:
  	8193, 24577, 40961, 57345, 73729

  Allocating group tables: done
  Writing inode tables: done
  Creating journal (4096 blocks): done
  Copying files into the device: done
  Writing superblocks and filesystem accounting information: done
$ du -Lbks /var/tmp/wic/build/rootfs_root.2.ext4
  155933


I figured out that when I run fsck.ext4 it will perform a directory 
optimizing which leads to a non-zero error code of 1 (File system errors 
corrected). Also, I figured out that this optimizing only occurres on 
the first boot and not after creating a lot of new files and dirs. After 
checking the fs it contains more blocks than before.

root@phyboard-wega-am335x-2:~# fsck.ext4 -V
e2fsck 1.43 (17-May-2016)
         Using EXT2FS Library version 1.43, 17-May-2016
root@phyboard-wega-am335x-2:~# fsck.ext4 
/dev/disk/by-id/mmc-NCard_0x2519026e-part2
e2fsck 1.43 (17-May-2016)
Superblock last write time (Mon Mar 13 10:53:39 2017,
         now = Wed Jan 25 11:07:23 2017) is in the future.
Fix<y>? yes
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 3A: Optimizing directories
Pass 4: Checking reference counts
Pass 5: Checking group summary information

root: ***** FILE SYSTEM WAS MODIFIED *****
root: 5221/19520 files (0.9% non-contiguous), 105503/155932 blocks
root@phyboard-wega-am335x-2:~# fsck.ext4 
/dev/disk/by-id/mmc-NCard_0x2519026e-part2
e2fsck 1.43 (17-May-2016)
root: clean, 5221/19520 files, 105503/155932 blocks


Can anyone give me more informations about what's wrong with our fs and 
if I can forbid (without problems) the directory optimization?

Thanks

-- 
Mit freundlichen Grüßen,
With best regards,
   Daniel Schultz

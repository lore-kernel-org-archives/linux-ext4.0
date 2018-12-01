Return-Path: <SRS0=IALa=OK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45250 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726778AbeLBC3K (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 21:29:10 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7FB382DA10
        for <linux-ext4@vger.kernel.org>; Sat,  1 Dec 2018 15:16:25 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sat, 01 Dec 2018 15:16:24 +0000
Message-ID: <bug-201685-13602-jbhMIt9Qz0@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Marc Koschewski (marc@osknowledge.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |marc@osknowledge.org

--- Comment #109 from Marc Koschewski (marc@osknowledge.org) ---
(In reply to Guenter Roeck from comment #107)
> #104: Possibly, but it doesn't explain why I see the problem only on two of
> four systems, all running the same kernel.

Could it be hardware related like ie. blacklisted "trim" for ie. Samsung 850
Pro? Are the 4 machines absoutely equal hardware-wise (at least on the block
layer)? Maybe such a quirk is needed for just another device...

Running ext4 on 4.19.{5,4,3,2,1,0} with not one error with the following setup:

root@marc:~ # lsblk /dev/sda
NAME           MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda              8:0    0  477G  0 disk  
├─sda1           8:1    0    1G  0 part  /boot
├─sda2           8:2    0    2M  0 part  
├─sda3           8:3    0    2M  0 part  
├─sda4           8:4    0    2M  0 part  
├─sda5           8:5    0    1G  0 part  
├─sda6           8:6    0  408G  0 part  
│ └─crypt-home 254:1    0  408G  0 crypt /home
├─sda7           8:7    0   59G  0 part  /
└─sda8           8:8    0    8G  0 part  
  └─crypt-swap 254:0    0    8G  0 crypt 

root@marc:~ # mount | grep home
/dev/mapper/crypt-home on /home type ext4
(rw,nosuid,noatime,nodiratime,quota,usrquota,grpquota)

root@marc:~ # cryptsetup status crypt-home 
/dev/mapper/crypt-home is active and is in use.
  type:    LUKS1
  cipher:  aes-xts-plain64
  keysize: 512 bits
  key location: dm-crypt
  device:  /dev/sda6
  sector size:  512
  offset:  4096 sectors
  size:    855633920 sectors
  mode:    read/write

root@marc:~ # egrep -i "(ext4|dax)" /boot/config-4.19.5loc64 
CONFIG_DAX=y
# CONFIG_DEV_DAX is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT2=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_ENCRYPTION is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_DAX=y

root@marc:~ # parted --list 
Modell: ATA Samsung SSD 860 (scsi)
Festplatte  /dev/sda:  512GB
Sektorgröße (logisch/physisch): 512B/512B
Partitionstabelle: gpt
Disk-Flags: 

Nummer  Anfang  Ende    Größe   Dateisystem  Name  Flags
 1      1049kB  1075MB  1074MB  ext4
 2      1075MB  1077MB  2097kB                     boot, esp
 3      1077MB  1079MB  2097kB
 4      1079MB  1081MB  2097kB
 5      1081MB  2155MB  1074MB  ext4
 6      2155MB  440GB   438GB
 7      440GB   504GB   63,4GB  ext4
 8      504GB   512GB   8518MB
...
...
...
Modell: Linux device-mapper (crypt) (dm)
Festplatte  /dev/mapper/crypt-home:  438GB
Sektorgröße (logisch/physisch): 512B/512B
Partitionstabelle: loop
Disk-Flags: 

Nummer  Anfang  Ende   Größe  Dateisystem  Flags
 1      0,00B   438GB  438GB  ext4

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

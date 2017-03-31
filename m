From: Reindl Harald <h.reindl@thelounge.net>
Subject: 4.10.7: systemd-fsck: data: Inode 14681437 Erweiterung tree (at level
 1) could be shorter. IGNORIERT
Date: Fri, 31 Mar 2017 13:30:18 +0200
Message-ID: <4c156024-0570-0c05-3a72-ffe3f34a878a@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.thelounge.net ([91.118.73.15]:21795 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752489AbdCaLa2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Mar 2017 07:30:28 -0400
Received: from rh.thelounge.net  (Authenticated sender: h.reindl@thelounge.net) by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 3vvfSC1mB6zXNF
        for <linux-ext4@vger.kernel.org>; Fri, 31 Mar 2017 13:30:19 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

what are the messages below for which i get when reboot with /forcefsck 
at least on kernel 4.10.7?
___________________________________________________

and no, i can't unmount the device because after repeated "umount 
/dev/md2" which are unmounting some bind-mounts i get the following 
message while nothing (lsof, fuser with all sort of options) shows any 
open filehandle and all processes are stopped - so no way just enter 
"fsck" with params and that issue exists for years

target is busy (In some cases useful info about processes that use the 
device is found by lsof(8) or fuser(1).
___________________________________________________

Mar 31 12:55:40 rh systemd-fsck: system: clean, 214548/1921360 files, 
1888521/7679232 blocks
Mar 31 12:55:43 rh systemd-fsck: Please pass 'fsck.mode=force' on the 
kernel command line rather than creating /forcefsck on the root file system.
Mar 31 12:55:43 rh systemd-fsck: Please pass 'fsck.mode=force' on the 
kernel command line rather than creating /forcefsck on the root file system.
Mar 31 12:55:43 rh systemd-fsck: boot: 375/128016 Dateien (1.3% nicht 
zusammenhängend), 50000/511988 Blöcke
Mar 31 12:55:47 rh systemd-fsck: data: Inode 14681437 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:55:47 rh systemd-fsck: data: Inode 15073688 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:55:47 rh systemd-fsck: data: Inode 15991040 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:55:48 rh systemd-fsck: data: Inode 17170787 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:55:48 rh systemd-fsck: data: Inode 18088064 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:55:49 rh systemd-fsck: data: Inode 21758420 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:55:50 rh systemd-fsck: data: Inode 22675780 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:55:50 rh systemd-fsck: data: Inode 23855220 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:55:50 rh systemd-fsck: data: Inode 24642524 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:55:51 rh systemd-fsck: data: Inode 25821208 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:55:51 rh systemd-fsck: data: Inode 28312065 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:55:52 rh systemd-fsck: data: Inode 29229111 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:55:52 rh systemd-fsck: data: Inode 31326708 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:55:53 rh systemd-fsck: data: Inode 33030483 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:55:53 rh systemd-fsck: data: Inode 35127422 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:55:54 rh systemd-fsck: data: Inode 36962716 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:55:54 rh systemd-fsck: data: Inode 37749004 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:55:59 rh systemd-fsck: data: Inode 40108093 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:56:00 rh systemd-fsck: data: Inode 40894470 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:56:01 rh systemd-fsck: data: Inode 52822304 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:56:03 rh systemd-fsck: data: Inode 63045758 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:56:06 rh systemd-fsck: data: Inode 108790765 Erweiterung tree 
(at level 1) could be shorter.  IGNORIERT.
Mar 31 12:56:08 rh systemd-fsck: data: Inode 162529337 Erweiterung tree 
(at level 1) could be narrower.  IGNORIERT.
Mar 31 12:56:08 rh systemd-fsck: data: Inode 162531692 Erweiterung tree 
(at level 1) could be narrower.  IGNORIERT.
Mar 31 12:56:51 rh systemd-fsck: data: 745984/242204672 Dateien (0.7% 
nicht zusammenhängend), 193226508/968805632 Blöcke

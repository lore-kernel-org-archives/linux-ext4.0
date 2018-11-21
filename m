Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:52284 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729303AbeKVFUJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Nov 2018 00:20:09 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0C5782BD2E
        for <linux-ext4@vger.kernel.org>; Wed, 21 Nov 2018 18:44:39 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 21 Nov 2018 18:44:38 +0000
Message-ID: <bug-201685-13602-0YcRPg2Lcb@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #18 from Jimmy.Jazz@gmx.net ---
kernel 4.19.2
md0 (formerly md_d0)

is a raid1 GPT bootable device

md0 : active raid1 sda[0] sdb[1]
      499976512 blocks super 1.2 [2/2] [UU]
      bitmap: 3/4 pages [12KB], 65536KB chunk

md0p1 is the grub boot partition

# fdisk -l /dev/md0                                                    
Disque /dev/md0 : 476,8 GiB, 511975948288 octets, 999953024 secteurs
Unités : secteur de 1 × 512 = 512 octets
Taille de secteur (logique / physique) : 512 octets / 512 octets
taille d'E/S (minimale / optimale) : 512 octets / 512 octets
Type d'étiquette de disque : gpt
Identifiant de disque : 9A6C46CD-3B9C-4C64-AE3C-EDB416548134

Périphérique   Début       Fin  Secteurs Taille Type
/dev/md0p1        40      2088      2049     1M Amorçage BIOS
/dev/md0p2      2096    264240    262145   128M Système de fichiers Linux
/dev/md0p3    264248   2361400   2097153     1G Système de fichiers Linux
/dev/md0p4   2361408   6555712   4194305     2G Système de fichiers Linux
/dev/md0p5   6555720 999952984 993397265 473,7G Système de fichiers Linux

# fdisk -l /dev/sdb                                                    
Disque /dev/sdb : 477 GiB, 512110190592 octets, 1000215216 secteurs
Modèle de disque : MKNSSDRE512GB   
Unités : secteur de 1 × 512 = 512 octets
Taille de secteur (logique / physique) : 512 octets / 512 octets
taille d'E/S (minimale / optimale) : 512 octets / 512 octets
Type d'étiquette de disque : dos
Identifiant de disque : 0x58e9a5ac

Périphérique Amorçage Début        Fin   Secteurs Taille Id Type
/dev/sdb1                 8 1000215215 1000215208   477G fd RAID Linux
autodétec

idem for second computer same configuration but one HGST Travelstar 7K1000 disk
attached and kernel cmdline has mdraid=forced

If I missed something just let me know.

Thx for your help.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

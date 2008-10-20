From: Richard Kojedzinszky <krichy@tvnetwork.hu>
Subject: linux 2.6.26/minix fs
Date: Mon, 20 Oct 2008 09:45:48 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.0810200938380.24043@krichy.tvnetwork.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from krichy.tvnetwork.hu ([80.95.68.194]:34420 "HELO
	krichy.tvnetwork.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752221AbYJTHpw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Oct 2008 03:45:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear developers,

I did not found the maintainers of the minix fs in the kernel, so I send 
this mail to you, please forward it to the appropriate people.
Anyway, my problem is that something went wrong in minix fs, as 
illustrated below:

krichy:~# mkfs.minix -v /dev/ram0
1376 inodes
4096 blocks
Firstdatazone=90 (90)
Zonesize=1024
Maxsize=2147483647

krichy:~# mount /dev/ram0 /mnt
krichy:~# cd /mnt
krichy:/mnt# for i in `seq 1 200`; do touch $i ; done
krichy:/mnt# ls -l | wc -l
127
krichy:/mnt# ls -l 200
-rw-r--r-- 1 root root 0 2008-10-20 09:42 200
krichy:/mnt# ls -l 194
-rw-r--r-- 1 root root 0 2008-10-20 09:42 194
krichy:/mnt# ls -l | grep 194
krichy:/mnt#

Any help appreciated.

Regards,
Kojedzinszky Richard
TvNetWork Nyrt.
E-mail: krichy (at) tvnetwork [dot] hu
PGP: 0x24E79141
   Fingerprint = 6847 ECFF EF58 0C09 18A5  16CF 270F 0C6F 24E7 9141

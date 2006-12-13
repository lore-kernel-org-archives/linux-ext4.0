From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] ext4-locality-groups patch
Date: Wed, 13 Dec 2006 17:51:01 +0300
Message-ID: <m3slfjzw6i.fsf@bzzz.home.net>
References: <m3vekwtqnp.fsf@bzzz.home.net> <45800965.2080005@bull.net>
	<m3wt4vzxje.fsf@bzzz.home.net> <45801018.1090001@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.248.82] ([80.71.248.82]:48027 "EHLO gw.home.net"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S964982AbWLMOvs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Dec 2006 09:51:48 -0500
To: Valerie Clement <valerie.clement@bull.net>
In-Reply-To: <45801018.1090001@bull.net> (Valerie Clement's message of "Wed\,
	13 Dec 2006 15\:37\:12 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Valerie Clement (VC) writes:

 VC> Alex Tomas wrote:
 >>>>>>> Valerie Clement (VC) writes:
 >>=20
 VC> Hi Alex,
 VC> I did the following test:
 VC> # mkfs /dev/sdc1
 VC> # mount -t ext4dev -o extents,mballoc,delalloc /dev/sdc1 /test
 VC> # dumpe2fs -h /dev/sdc1
 VC> # cp linux.tar /test
 VC> # tar xf /test/linux.tar
 VC> # dumpe2fs -h /dev/sdc1
 >>=20
 VC> The "Free blocks" and "Free inodes" counters in the dumpe2fs outpu=
t
 VC> did not change after running the cp and tar commands.
 >>=20
 >> sync should help, I think.

 VC> No, I've just tried, it does not change anything.
 VC>   Val=E9rie

not sure ....

[root@tom ~]# mke2fs -m0 -j /dev/sda1 >&/dev/null
[root@tom ~]# mount -t ext4dev -o extents,mballoc,delalloc /dev/sda1 /t=
est
[root@tom ~]# dumpe2fs /dev/sda1 >/tmp/before
dumpe2fs 1.39.cfs1 (29-May-2006)
[root@tom ~]# dd if=3D/dev/zero of=3D/test/f bs=3D1M count=3D20
20+0 records in
20+0 records out
[root@tom ~]# dumpe2fs /dev/sda1 >/tmp/after1
dumpe2fs 1.39.cfs1 (29-May-2006)
[root@tom ~]# sync
[root@tom ~]# dumpe2fs /dev/sda1 >/tmp/after2
dumpe2fs 1.39.cfs1 (29-May-2006)
[root@tom ~]# diff -pu /tmp/before /tmp/after1=20
--- /tmp/before 2006-12-13 14:39:42.541828787 +0300
+++ /tmp/after1 2006-12-13 14:39:59.602086138 +0300
@@ -45,9 +45,9 @@ Group 0: (Blocks 0-32767)
   Reserved GDT blocks at 2-245
   Block bitmap at 246 (+246), Inode bitmap at 247 (+247)
   Inode table at 248-752 (+248)
-  15607 free blocks, 16149 free inodes, 2 directories
+  15607 free blocks, 16148 free inodes, 2 directories
   Free blocks: 17161-32767
-  Free inodes: 12-16160
+  Free inodes: 13-16160
 Group 1: (Blocks 32768-65535)
   Backup superblock at 32768, Group descriptors at 32769-32769
   Reserved GDT blocks at 32770-33013
[root@tom ~]# diff -pu /tmp/after1 /tmp/after2=20
--- /tmp/after1 2006-12-13 14:39:59.602086138 +0300
+++ /tmp/after2 2006-12-13 14:40:05.592176495 +0300
@@ -45,8 +45,8 @@ Group 0: (Blocks 0-32767)
   Reserved GDT blocks at 2-245
   Block bitmap at 246 (+246), Inode bitmap at 247 (+247)
   Inode table at 248-752 (+248)
-  15607 free blocks, 16148 free inodes, 2 directories
-  Free blocks: 17161-32767
+  10487 free blocks, 16148 free inodes, 2 directories
+  Free blocks: 17161-22527, 27648-32767
   Free inodes: 13-16160
 Group 1: (Blocks 32768-65535)
   Backup superblock at 32768, Group descriptors at 32769-32769
[root@tom ~]#=20


try to repeat with a single file?

thanks, Alex

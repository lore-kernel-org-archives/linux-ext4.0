Return-Path: <SRS0=7vaa=OF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49944 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726224AbeK0Cnn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 26 Nov 2018 21:43:43 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 58AE429E59
        for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2018 15:49:13 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 26 Nov 2018 15:49:13 +0000
Message-ID: <bug-201685-13602-9c1PIyw9b6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #52 from Jimmy.Jazz@gmx.net ---
FYI, I need 2 patches for my initramfs to generate and IMO should not
interfere.

drivers/tty/vt/defkeymap.map to get the fr kbd mapping
usr/Makefile due to shell evaluation

--- usr/Makefile.orig   2017-02-19 23:34:00.000000000 +0100
+++ usr/Makefile        2017-02-22 23:44:24.554921038 +0100
@@ -43,7 +43,7 @@
 targets := $(datafile_y)

 # do not try to update files included in initramfs
-$(deps_initramfs): ;
+$(deps_initramfs): ; 

 $(deps_initramfs): klibcdirs
 # We rebuild initramfs_data.cpio if:
@@ -52,5 +52,6 @@
 # 3) If gen_init_cpio are newer than initramfs_data.cpio
 # 4) arguments to gen_initramfs.sh changes
 $(obj)/$(datafile_y): $(obj)/gen_init_cpio $(deps_initramfs) klibcdirs
-       $(Q)$(initramfs) -l $(ramfs-input) > $(obj)/$(datafile_d_y)
+       $(Q)$(initramfs) -l $(ramfs-input) | \
+       sed '2,$$s/:/\\:/g' > $(obj)/$(datafile_d_y)
        $(call if_changed,initfs)


[quote]
I don't want to break T.Tso rules, but I remember, I have encountered a similar
issue when I initially tried partitionable array with major 9. At that time I
switched to major 254 as explain in comment 8 and the problem didn't come up
since... until the recent kernel 4.19 with mdadm 4.1 and kernel devtmpfs that
switched the metadevices to major 9. Also, why? A big mystery.
[/quote]

Now to the fact,
I was able to reboot in rescue mode, I use the world service to illustrate the
process. Nothing to do with Debian.

# service mdraid start
# service vg0 start
# cd /dev/mapper
# for i in *-*; do fsck /dev/mapper/$i; done
All clean except sys-scm (f  word)
the usb stick is clean too.
I need a terminal for interactive repairs so I write the beginning by hand.

Inode 58577 has extra size (103) which is invalid
Fix<y>? yes
Timestamp(s) on inode 58577 beyond 2310-04-04 are likely pre-1970
+ 9 others
Inodes that were part of corrupted orphan linked list found. Fix<y>?yes
+ 3 others
i_size is 139685221367808, shoud be 0.
i_blocks is 32523, should be 0.
+ 22 others
Pass 2: checking directory structure
Inode 58577 (/git/toolkit.git/objects/e0) has invalid mode (0150)
+ 9 others
Unattached inode 17013
Connect to /lost+found
Inode 17013 ref count is 2, should be 1
+ 35 others
Inode 58586 (...) has invalid mode (0122)
+ 5 others
[...]
Unattached inode 262220
Connect to /lost+found<y>? yes
Inode 262220 ref count is 2, should be 1.  Fix<y>? yes
Pass 5: Checking group summary information
Block bitmap differences:  -(9252--9255) -10490 -(10577--10578) -(16585--16589)
-295391 -(682164--682165)
Fix<y>? yes
Free blocks count wrong for group #0 (2756, counted=2768).
Fix<y>?
Block bitmap differences:  -(9252--9255) -10490 -(10577--10578) -(16585--16589)
-295391 -(682164--682165)
Fix<y>? yes
Free blocks count wrong for group #0 (2756, counted=2768).
Fix<y>? yes
Free blocks count wrong for group #9 (2784, counted=2785).
Fix<y>? yes
Free blocks count wrong for group #20 (14702, counted=14704).
Fix<y>? yes
Free blocks count wrong (718736, counted=718751).
Fix<y>? yes
Inode bitmap differences:  -58591
Fix<y>? yes
Free inodes count wrong for group #7 (6283, counted=6284).
Fix<y>? yes
Directories count wrong for group #7 (1133, counted=1121).
Fix<y>? yes
Free inodes count wrong (322025, counted=322026).
Fix<y>? yes

scm: ***** FILE SYSTEM WAS MODIFIED *****
scm: 71190/393216 files (0.1% non-contiguous), 854113/1572864 blocks
fsck from util-linux 2.32.1
e2fsck 1.44.4 (18-Aug-2018)

service vg0 stop
service mdraid stop

ctrl-alt-del

I was able to reboot with init 1 from grub then init 4 from tty1 as root with
kernel 4.19.4. Filesystems were clean.

exit from tty1

log in again as normal user under X
su - root
next bisect in action

I must admit, it is time consuming.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

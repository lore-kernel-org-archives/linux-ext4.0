From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] New: Suspicious persistent EXT4-fs error (device sda1):
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Mon, 24 Apr 2017 02:40:05 +0000
Message-ID: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50706 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1164211AbdDXCkI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Apr 2017 22:40:08 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 35B6625223
        for <linux-ext4@vger.kernel.org>; Mon, 24 Apr 2017 02:40:07 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

            Bug ID: 195561
           Summary: Suspicious persistent EXT4-fs error (device sda1):
                    ext4_validate_block_bitmap:395: [Proc] bg 17: block
                    557056: invalid block bitmap
           Product: File System
           Version: 2.5
    Kernel Version: 4.4 to 4.11
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: issor.oruam@gmail.com
        Regression: No

Created attachment 255963
  --> https://bugzilla.kernel.org/attachment.cgi?id=255963&action=edit
dmesg on Phy SATA HDD1

While testing Android 7.1 nougat-x86 x86_64 several android-x86 community
members noticed the occurence of EXT4 partition remount RO
which causes a bootloop with continuous kernel panic on Android 7.x
which requires to reinstall Android OS image on EXT4 partitions.

When looking in logcat we would just see that everything stops working because
of the partion has been remounted in Read-Only.

Looking at dmesg output we see the following attached three logs for three test
cases:

Physical Sata HDD 1
Physical Sata HDD 2 
Virtualbox    vdi 3

January, 14th (ASUS motherboard with physical SATA HDD n.1)
[  842.760419] EXT4-fs error (device sda1): ext4_validate_block_bitmap:395:
comm Binder:1454_E: bg 17: block 557056: invalid block bitmap
[  842.873601] Aborting journal on device sda1-8.
[  842.908371] EXT4-fs (sda1): Remounting filesystem read-only
[  842.923638] EXT4-fs error (device sda1) in ext4_do_update_inode:4679:
Journal has aborted

March, 25th (ASUS motherboard with physical SATA HDD n.2, different from n.1)
[ 1510.269945] EXT4-fs error (device sda1): ext4_validate_block_bitmap:395:
comm main: bg 17: block 557056: invalid block bitmap
[ 1510.285464] Aborting journal on device sda1-8.
[ 1510.301047] EXT4-fs (sda1): Remounting filesystem read-only
[ 1510.323400] EXT4-fs error (device sda1) in ext4_do_update_inode:4679:
Journal has aborted

April, 25th (VirtualBox VM with vdi vitual drive n.3, different from n.1 and
n.2)
[ 1510.269945] EXT4-fs error (device sda1): ext4_validate_block_bitmap:395:
comm main: bg 17: block 557056: invalid block bitmap
[ 1510.285464] Aborting journal on device sda1-8.
[ 1510.301047] EXT4-fs (sda1): Remounting filesystem read-only
[ 1510.323400] EXT4-fs error (device sda1) in ext4_do_update_inode:4679:
Journal has aborted

What they all have in common is the bg and block which happen to be exactly the
same, no matter how many attempts on different physical or virtual HDDs.

The problem is intermittent, but happens quite frequently during initial Google
Play updates, so it may become a show stopper for Android and a series of
different OSes.

One catalyzer to let the issue happen is multithreading/processes forking which
Androdi 7.x uses far more than 6.0. Android 6.0 has no issue with the same
kernels. In my understanding there may be a sort block/bg locking issue leading
to concurrent write and validation of bitmaps

Another possible concurring root cause may be 64 bit kernel build,
as on virtualbox the issue is systematic with 64 bit build and I've never saw
it with 32bit builds. This would be coherent with statements in [1]

Doing some research I found reference of this problem in different websites
[1], [2] and [3]

[1] https://community.nxp.com/thread/447695

[2] https://jira.hpdd.intel.com/browse/LU-1026
(at the end EXT4 patch is mentioned)

[3]
https://github.com/tweag/lustre/blob/master/ldiskfs/kernel_patches/patches/rhel7/ext4-corrupted-inode-block-bitmaps-handling-patches.patch

The attached HACK workaround can avoid the problem, tested on top of kernel
4.4.62
but it's not a solution as it uses ext4_warning() instead of ext4_error()
and tricks the callers by pretending there was no error,
we could even put a check on "bg == 16 && block == 557056"
but it would still be a hack to workaround a bug in EXT4 bitmap validation
code.

It is also confirmed that kernel 4.9, 4.10 and 4.11 are also affected.

Mauro

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

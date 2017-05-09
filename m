From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] Suspicious persistent EXT4-fs error:
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Tue, 09 May 2017 03:20:50 +0000
Message-ID: <bug-195561-13602-gD03d7VJJW@https.bugzilla.kernel.org/>
References: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50086 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751130AbdEIDUz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 8 May 2017 23:20:55 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7708E24B5B
        for <linux-ext4@vger.kernel.org>; Tue,  9 May 2017 03:20:54 +0000 (UTC)
In-Reply-To: <bug-195561-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

--- Comment #27 from James tao (tao1hua@aliyun.com) ---
How was the sdcard formatted?
> sdcard formatted by make_ext4fs.

Can you give me a clean reproduction that doesn't involve using AOSP userspace?
> I had try the way you provided. but I can't access to the git
> server(git.kernel).

[taohua@ubuntu-bsp ext4_issue]git clone
git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git fstests
Cloning into 'fstests'...
fatal: unable to connect to git.kernel.org:
git.kernel.org[0: 147.75.110.187]: errno=Connection timed out
git.kernel.org[1: 2604:1380:3000:3500::3]: errno=Network is unreachable

[taohua@ubuntu-bsp ext4_issue]ping git.kernel.org
PING pub.nrt.kernel.org (147.75.110.187) 56(84) bytes of data.
64 bytes from 147.75.110.187: icmp_req=1 ttl=53 time=57.2 ms
64 bytes from 147.75.110.187: icmp_req=2 ttl=53 time=57.1 ms
64 bytes from 147.75.110.187: icmp_req=3 ttl=53 time=57.1 ms

Another way, I have try to run only linux (not Android) on the Broadcom ARM
chipset. and using the same kernel version. the test step as follow.
   1. mkfs.ext4 /dev/mmcblk0                     #format tf card as ext4
   2. mount -t ext4 /dev/mmcblk0 /mnt/hd/        #mount tf card
   3. mount -t ext4 /dev/mmcblk1p14 /mnt/flash/  # mount emmc partition as ext4
   4. cp /mnt/flash/*.data /mnt/hd/              #copy data to tf card

  # df
  Filesystem           1K-blocks      Used Available Use% Mounted on
  rootfs                  106944     10480     96464  10% /
  none                    106944         0    106944   0% /dev
  tmpfs                   118076         8    118068   0% /tmp
  shm                     118076         0    118076   0% /dev/shm
  /dev/mmcblk0           7381352   3124064   3859288  45% /mnt/hd
  /dev/mmcblk1p14        4536544   3116564   1166492  73% /mnt/flash

By the test in the same hardware everything looks good. Is it not an ext4
issue, but a issue of make_ext4fs?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

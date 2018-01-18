From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198505] New: Errors from EXt4 FS when resuming from single
 hibernation image
Date: Thu, 18 Jan 2018 11:12:47 +0000
Message-ID: <bug-198505-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:59992 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752062AbeARLMr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Jan 2018 06:12:47 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 154E3265B9
        for <linux-ext4@vger.kernel.org>; Thu, 18 Jan 2018 11:12:47 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198505

            Bug ID: 198505
           Summary: Errors from EXt4 FS when resuming from single
                    hibernation image
           Product: File System
           Version: 2.5
    Kernel Version: kernel-3.18.49
          Hardware: ARM
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: omkar062@gmail.com
        Regression: No

I am trying to optimize boot time in Android M, using hibernation method.
Finally I am able to do hibernate and resume properly, but for every boot I
should take snapshot image of RAM and have to resume from that image. Here my
requirement is I want to resume every time from single snapshot image. But i am
having problem with that image after 2nd boot onwards.

I am getting ext4 error, seems like block number mismatch and that file-system
on that partition is being remounted into read-only mode.

Below errors i am getting every time after 2nd boot onwards:

[   64.250735] EXT4-fs error (device mmcblk0p24): ext4_mb_generate_buddy:758:
group 9, block bitmap and bg descriptor inconsistent: 31166 vs 31165 free
clusters
[   64.252813] <3> (3)[1507:PackageManager]Aborting journal on device
mmcblk0p24-8.
[   64.267680] <3> (3)[1507:PackageManager]EXT4-fs (mmcblk0p24): Remounting
filesystem read-only
[   64.268667] <3> (1)[1:init]init: Starting service 'media'...
[   64.269479] <3> (3)[1507:PackageManager]EXT4-fs error (device mmcblk0p24) in
ext4_free_blocks:4881: Journal has aborted
[   64.272235] <3> (3)[1507:PackageManager]EXT4-fs error (device mmcblk0p24) in
ext4_reserve_inode_write:4999: Journal has aborted
[   64.278537] <3> (3)[1507:PackageManager]EXT4-fs error (device mmcblk0p24) in
ext4_reserve_inode_write:4999: Journal has aborted
[   64.283132] <3> (3)[1507:PackageManager]EXT4-fs error (device mmcblk0p24) in
ext4_ext_remove_space:3035: Journal has aborted
[   64.286970] <3> (3)[1507:PackageManager]EXT4-fs error (device mmcblk0p24) in
ext4_ext_truncate:4669: Journal has aborted
[   64.291775] <3> (3)[1507:PackageManager]EXT4-fs error (device mmcblk0p24) in
ext4_reserve_inode_write:4999: Journal has aborted
[   64.294465] <3> (3)[1507:PackageManager]EXT4-fs error (device mmcblk0p24) in
ext4_truncate:3894: Journal has aborted
[   64.297764] <3> (3)[1507:PackageManager]EXT4-fs error (device mmcblk0p24) in
ext4_reserve_inode_write:4999: Journal has aborted
[   64.300437] <3> (3)[1507:PackageManager]EXT4-fs error (device mmcblk0p24) in
ext4_orphan_del:2888: Journal has aborted


This is happening because mounted partition meta-data in RAM(old snapshot
image) is not matched with actual data in disk.

Please suggest me some way to overcome this problem.
Also is it possible to update file-system's meta-data to RAM from
partition(mounted and used by some apps)?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

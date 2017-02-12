From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194567] New: ext4 no longer mounts
Date: Sun, 12 Feb 2017 20:55:10 +0000
Message-ID: <bug-194567-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55194 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750882AbdBLUzO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 12 Feb 2017 15:55:14 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 53ACF2711E
        for <linux-ext4@vger.kernel.org>; Sun, 12 Feb 2017 20:55:13 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id AE7B627D4D
        for <linux-ext4@vger.kernel.org>; Sun, 12 Feb 2017 20:55:11 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194567

            Bug ID: 194567
           Summary: ext4 no longer mounts
           Product: File System
           Version: 2.5
    Kernel Version: 4.4.48
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: bugzilla.kernel.org@plan9.de
        Regression: No

I have a single ext4 filesystem on my workstatioon used to host mysql database
files. I don't know how old it is (months, years), but I happen to keep the
mkfs command used to create it (the device is 67108864 sectors):

mke2fs -t ext4 -b 4096 -N 65536 -I 128 -L DB -m 0 -O
dir_index,extent,filetype,flex_bg,^has_journal,large_file,^resize_inode,sparse_super,uninit_bg

It worked fine till 4.4.47. it no longer mounts in 4.4.48:

[  206.596713] EXT4-fs (dm-24): VFS: Can't find ext4 filesystem
[  214.028205] EXT4-fs (dm-24): first meta block group too large: 2 (group
descriptor block count 2)
[  242.185792] EXT4-fs (dm-24): first meta block group too large: 2 (group
descriptor block count 2)

e2fsck -f (from "e2fsck 1.43.4 (31-Jan-2017)") finds no errors. Not sure if
this is a bug in mkfs, e2fsck, or the kernel, but since it is a regression in
the kernel, I reported it here.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

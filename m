From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194607] New: Unable to change passwd upon a hard reboot
Date: Thu, 16 Feb 2017 15:00:32 +0000
Message-ID: <bug-194607-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:57516 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932103AbdBPPAf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 16 Feb 2017 10:00:35 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C9C9228600
        for <linux-ext4@vger.kernel.org>; Thu, 16 Feb 2017 15:00:34 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id CAFF528601
        for <linux-ext4@vger.kernel.org>; Thu, 16 Feb 2017 15:00:32 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194607

            Bug ID: 194607
           Summary: Unable to change passwd upon a hard reboot
           Product: File System
           Version: 2.5
    Kernel Version: 3.18.29
          Hardware: ARM
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: ramanareddy1892@gmail.com
        Regression: No

Hi,

I have an imx6dl based custom board. I compiled OpenWRT Chaos Calmer for this
and generated an image out of u-boot.img, zImage and dtb file in one partition
and rootfs in second partition. First partition is vfat and second(rootfs) is
ext4.

The board can boot from SD card and internal eMMC flash. I tried on both of
them.

Steps to reproduce:

1. Boot the image.
2. Change passwd to a non-empty string
3. Observe there is no passwd+ file in the /etc/ directory
4. Do a hard reboot (Soft reboot doesn't reproduce this)
5. Observe that passwd+ file exists in /etc/ directory. (Happens more than 80%
of the time)
6. Now unless we remove this file, passwd cannot be changed.

    root@OpenWRT:~# passwd 
    Changing password for root
    New password: 
    Bad password: too short
    Retype password: 
    passwd: can't create '/etc/passwd+': File exists
    passwd: can't update password file /etc/passwd

This cannot be a busybox issue. The problem comes because passwd+ file recovers
after it got deleted upon reboot!!

I will upload the required logs/docs/info if specified.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

Return-Path: <SRS0=c0SX=OB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44548 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731109AbeKWCJs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Nov 2018 21:09:48 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8E76D2CEC2
        for <linux-ext4@vger.kernel.org>; Thu, 22 Nov 2018 15:29:57 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Thu, 22 Nov 2018 15:29:56 +0000
Message-ID: <bug-201685-13602-UWLP5dtqjl@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #32 from Azat Khuzhin (a3at.mail@gmail.com) ---
(In reply to Jens Axboe from comment #28)
> If it's not this, another hint might be a discard change. Is everyone
> affected using discard?

And what a coincidence, before upgrading to 4.20-rc2 I enabled discard:

# findmnt /
TARGET SOURCE                FSTYPE OPTIONS
/      /dev/mapper/cryptroot ext4   rw,relatime,discard

# cat /proc/cmdline
cryptdevice=...:cryptroot:allow-discards

# cryptsetup status cryptroot
/dev/mapper/cryptroot is active and is in use.
  ...
  flags:   discards

Plus I triggered fstrim manually at start:

# systemctl status fstrim
Nov 19 00:16:14 azat fstrim[23944]: /boot: 122.8 MiB (128716800 bytes) trimmed
on /dev/nvme0n1p1
Nov 19 00:16:14 azat fstrim[23944]: /: 0 B (0 bytes) trimmed on
/dev/mapper/cryptroot

But what is interesting here is that it did not do any discard for the "/", hm
(does ext4 did it for me at start?)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

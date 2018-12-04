Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55768 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725880AbeLDVRd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 16:17:33 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F138C2C462
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 21:17:31 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 21:17:30 +0000
Message-ID: <bug-201685-13602-xslfc8ZOZn@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #243 from Han Vinke (jfavinke@gmail.com) ---
I have a PC with multiple boot -Windows 10, Arch linux with kernel 4.19.x en
Ubuntu Disco Dingo with 4.19.x. My Arch linux is an encrypted LVM. 

I can actually invoke the EXT4-fs errors on Ubuntu!
Which is not encrypted but has cryptsetup-initramfs installed, because I make
regular backups with partclone from the Arch partitions.

All that is needed on Ubuntu is to run sudo update-initramfs -u

cryptsetup: WARNING: The initramfs image may not contain cryptsetup binaries
nor crypto modules. If that's on purpose, you may want to uninstall the
'crypsetup-initramfs' package in order to disable the cryptsetup initramfs
integration and avoid this warning.

You will get a warning or error that is also subscribed in this bugreport:

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=901830

The problem is that when you reboot you will get all the EXT4-fs errors.
I have to do a e2fsck via Arch, it reports some inode errors and when rebooting
Ubuntu the problem is gone, if there never were any problems.

Also when I am on ARCH cloning the Ubuntu partitions I can reproduce these
errors.
When mistakenly partcloning a read-only mounted partition for instance.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

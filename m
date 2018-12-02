Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44662 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725294AbeLBEUb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 23:20:31 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id DB7F92BCDC
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 04:20:29 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 04:20:19 +0000
Message-ID: <bug-201685-13602-54rhVrIDmo@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #128 from Theodore Tso (tytso@mit.edu) ---
To Guenter, re: #119.

This is just my intuition, but this doesn't "smell" like a problem with a bad
drive.  There are too many reports where people have said that they don't see
the problem with 4.18, but they do see it with 4.19.0 and newer kernels.   The
reports have been with different hardware, from HDD's to SSD's, with some
people reporting NVMe-attached SSD And some reporting SATA-attached SSD's.    

Can hard drives and SSDs nowadays fail silently by reading bad data instead of
reporting read (and/or write) errors?   One of the things I've learned in my
decades of storage experience is to never rule anything out --- hardware will
do some very strange things.  That being said.... no, normally this would be
highly unlikely.   Hard Drive and SSD's have strong error-correcting codes,
parity and super-parity checks in their internal data paths, so silent read
errors are unlikely, unless the firmware is *seriously* screwed up.

In addition, the fact that some of the reports involve complete garbage getting
written into the inode table, it seems more likely the problem is on the
writing side rather than on the read side.

One thing I would recommend is "tune2fs -e remount-ro /dev/sdXX".  This will
set the default mode to remount the file system read-only.  So if the problem
is on the read side, it makes it even more unlikely that the data will be
written back to disk.   Some people may prefer "tune2fs -e panic /dev/sdXX",
especially on production servers.   That way, when the kernel discovers a file
system inconsistency, it will immediately force a reboot, and then the fsck run
on reboot can fix up the problem.  More importantly, by preventing the system
from continuing to operate after a problem has been noticed, it avoids the
problem metastasizing, making things even worse.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

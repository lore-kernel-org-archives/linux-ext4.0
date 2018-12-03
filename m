Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58208 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726014AbeLCSFu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2018 13:05:50 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 96DE92B6D6
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 18:05:47 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 18:05:46 +0000
Message-ID: <bug-201685-13602-C7dtmBQvUG@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #206 from Jimmy.Jazz@gmx.net ---
fsck does i/o itself. It doesn't aggravate or trigger the issue. Also, I can't
believe it is just an hdd, sata or usb hardware problem.

Moreover, it affects other type of file systems zfs or nfs for instance (what
about ext3 and ext2 ?). So it should imply the code they share.

Three ideas I hope not so stupid.

+ log journal
On my computers, vmlinuz is written on an ext2 /boot file system every kernel
upgrade. If I remember well ext2 never failed and the file system stayed clean
during the tests.
If ext2 is not affected, it could involve the journal code instead.

+ if that's not the log, than the cache.
In my case, rsync and rm are involved in the file system corruption. It could
be explained like that. rsync reads inodes and blocs to compare before any
write. The kernel reports an inconsistency independently if the inode/bloc is
read or written from/to the cache. As expected only the changes are sent to the
media. It explains that some of the corruptions never reached the media and the
next reboot fsck declares a disk clean because only read i/o has been done
before the reboot.

+ what about synchronisation
As I mention in other posts, even if the issue still lurks, the patch proposed
here makes the issue less intrusive. 

My tests were made with a vanilla kernel source from gentoo portage
sys-kernel/vanilla-sources

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89621] EXT4-fs error (device dm-1):
 ext4_mb_release_inode_pa:3773: group 24089, free 34, pa_free 32
Date: Mon, 15 Dec 2014 15:21:22 +0000
Message-ID: <bug-89621-13602-tSmiADOTwa@https.bugzilla.kernel.org/>
References: <bug-89621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33181 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbaLOPVZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Dec 2014 10:21:25 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3085420A03
	for <linux-ext4@vger.kernel.org>; Mon, 15 Dec 2014 15:21:24 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 3F5E9209ED
	for <linux-ext4@vger.kernel.org>; Mon, 15 Dec 2014 15:21:23 +0000 (UTC)
In-Reply-To: <bug-89621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89621

--- Comment #4 from John Hughes <john@calva.com> ---
I've seen it 3 times so far.

Once on boot, I ran fsck, the error has not come back (so far).

Once (on another, but similarly configured VM) the error came back almost
immediately after being fixed by fsck.  A second run of fsck and no problems so
far.

I'm not running any odd drivers in these VM's.  The host of one of them has an
Eicon DIVA card with it's drivers, the host of the other doesn't.

The strangest part of my setup is that I have an mdadm raid1 on the host
system, that is made available as a virtio block device to a guest (running
under LVM).  In the guest I have LVM2 volumes, with ext3 formatted filesystems. 

Everything is now running this 3.16 Debian kernel.

One filesystem was mounted with data=journal, the other is the root filesystem
mounted with the default data=ordered.

barriers are not explicitly disabled so they should be enabled by default by
now (yes?)

The virtio block devices have cache=none.

I'll try to schedule the installation of a more up-to-date kernel on at least
one of the machines, but it may take me a few days.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

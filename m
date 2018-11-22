Return-Path: <SRS0=c0SX=OB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53268 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731412AbeKWGTh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 23 Nov 2018 01:19:37 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 55D1C2B6C1
        for <linux-ext4@vger.kernel.org>; Thu, 22 Nov 2018 19:38:49 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Thu, 22 Nov 2018 19:38:49 +0000
Message-ID: <bug-201685-13602-aYUhE6VRVA@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Bart Van Assche (bvanassche@acm.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bvanassche@acm.org

--- Comment #34 from Bart Van Assche (bvanassche@acm.org) ---
I hit filesystem corruption with a desktop system running openSUSE Tumbleweed,
kernel v4.19.3 and ext4 on top of a SATA SSD with scsi_mod.use_blk_mq=Y in
/proc/cmdline. Discard was not enabled in /etc/fstab. After having enabled
fsck.mode=force the following appeared in the system log after a reboot:

/dev/sda2: Inode 12190197 extent tree (at level 2) could be narrower.  IGNORED.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

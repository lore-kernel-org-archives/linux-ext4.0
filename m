Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:42306 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725751AbeLBMDx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 07:03:53 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3E6642BC79
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 00:50:06 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 00:50:05 +0000
Message-ID: <bug-201685-13602-BxqzEUKWuK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #121 from Jimmy.Jazz@gmx.net ---
I have the problem again with kernel 4.19.5 (J. Axboe patches). Sorry I don't
trust 4.19.x without Axboe patch because if some fs corruptions reappear they
will be less violent than without the patch.

OS uptime  8:51, 37 static ext4 mountpoints as they are reported by 'mount'
command.

I have checked with the same kernel 4.19.5 in rescue mode (i.e none of the file
systems are mounted)

summary:
- e2fsck -fy /dev/dm-4 > log.1
- echo 3 > /proc/sys/vm/drop-caches
- e2fsck -fn /dev/dm-4 log.2
- reboot again in normal mode ( / is mounted)
- fsck -TRAC -r -M -p  /dev/dm-X || fsck -f -TRAC -y -s /dev/dm-X
- if there is a new stable release then I compile and test the new release

Result:
The system doesn't see any error (fsck) on reboot (rescue and normal boot).

see attachments.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

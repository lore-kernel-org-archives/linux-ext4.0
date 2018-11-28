Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47302 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727986AbeK1WCO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Nov 2018 17:02:14 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B36F22CFBE
        for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2018 11:00:58 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Wed, 28 Nov 2018 11:00:59 +0000
Message-ID: <bug-201631-13602-CmJayepu3y@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

erhard_f@mailbox.org changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Attachment #279375|0                           |1
        is obsolete|                            |

--- Comment #5 from erhard_f@mailbox.org ---
Created attachment 279691
  --> https://bugzilla.kernel.org/attachment.cgi?id=279691&action=edit
dmesg

Some more lockupgs after re-trying:

[ 2088.802884] INFO: task watch:20375 blocked for more than 120 seconds.
[ 2088.803203]       Tainted: G        W         4.20.0-rc4 #1
[ 2088.803209] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 2088.803215] watch           D    0 20375    762 0x00000000
[ 2088.803224] Call Trace:
[ 2088.803232] [c00000033c50f210] [c00000033c50f2b0] 0xc00000033c50f2b0
(unreliable)
[ 2088.803244] [c00000033c50f3f0] [c0000000000217f0] .__switch_to+0x310/0x510
[ 2088.803256] [c00000033c50f4a0] [c0000000009f0000] .__schedule+0x320/0xcd0
[ 2088.803262] [c00000033c50f590] [c0000000009f09e0] .schedule+0x30/0xb0
[ 2088.803270] [c00000033c50f600] [c000000000365090]
.d_alloc_parallel+0x5d0/0xb00
[ 2088.803277] [c00000033c50f750] [c00000000034bdc8] .__lookup_slow+0xc8/0x250
[ 2088.803284] [c00000033c50f890] [c00000000034bf94] .lookup_slow+0x44/0x70
[ 2088.803291] [c00000033c50f920] [c000000000350928]
.walk_component+0x298/0x4d0
[ 2088.803297] [c00000033c50fa00] [c0000000003516f0] .path_lookupat+0xa0/0x280
[ 2088.803307] [c00000033c50fac0] [c000000000353744]
.filename_lookup+0xb4/0x190
[ 2088.803313] [c00000033c50fc40] [c000000000342df8] .vfs_statx+0xa8/0x190
[ 2088.803320] [c00000033c50fd10] [c0000000003437b4]
.__se_sys_newstat+0x54/0xa0
[ 2088.803332] [c00000033c50fe20] [c00000000000b3a4] system_call+0x5c/0x70
[...]

More info see full dmesg.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

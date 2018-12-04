Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37966 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725867AbeLDUgW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 15:36:22 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4435C2C71C
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 20:36:21 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 20:36:20 +0000
Message-ID: <bug-201685-13602-3mj8OhtWml@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #239 from Marc Burkhardt (marc@osknowledge.org) ---
Could anyone just sum up what needs to be set to trigger the bug (as of the
understanding we have now)?

I use

scsi_mod.use_blk_mq=y

and

dm_mod.use_blk_mq=y

for ages but I do not see the bug. I use the

mq-deadline

scheduler.

#232 somehow suggests it needs additional memory pressure to trigger it,
doesn't it?

Quite confused here...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

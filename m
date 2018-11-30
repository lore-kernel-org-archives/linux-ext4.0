Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49044 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726564AbeLACyX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Nov 2018 21:54:23 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 68572302E5
        for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2018 15:44:38 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Fri, 30 Nov 2018 15:44:38 +0000
Message-ID: <bug-201685-13602-TroX4TGXRE@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #88 from Jimmy.Jazz@gmx.net ---
(In reply to Jens Axboe from comment #77)

> Are you still confident the full patch works? It's interesting since that
> has RCU, and the other changes point in that direction, too.

4.19.4 full patched is stable. I'm just puzzled in its capability to clean a
failed file system with sys-fs/e2fsprogs-1.44.4.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

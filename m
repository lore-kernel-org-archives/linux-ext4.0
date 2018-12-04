Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:52826 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725983AbeLDIYg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 03:24:36 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9DF652AC98
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 08:24:35 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 08:24:34 +0000
Message-ID: <bug-201685-13602-ZUmXj73HVL@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #218 from Guenter Roeck (linux@roeck-us.net) ---
Oh well. It took a long time, but:

v4.19.6, with fs/ext4 from v4.18.20:

[15903.283340] EXT4-fs error (device sdb1): ext4_lookup:1578: inode #5137538:
comm updatedb.mlocat: deleted inode referenced: 5273882
[15903.284896] Aborting journal on device sdb1-8.
[15903.286404] EXT4-fs (sdb1): Remounting filesystem read-only

I guess the next step will be to test v4.18.20 with my test script, to make
sure that this is not a long-time lingering problem. Other than that, I am open
to ideas.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

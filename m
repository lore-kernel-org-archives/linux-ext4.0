Return-Path: <SRS0=EV/E=O6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55072 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730960AbeLULQq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 21 Dec 2018 06:16:46 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 08A582847E
        for <linux-ext4@vger.kernel.org>; Fri, 21 Dec 2018 11:16:46 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Fri, 21 Dec 2018 11:16:44 +0000
Message-ID: <bug-201631-13602-h06tIbQnKP@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #34 from erhard_f@mailbox.org ---
(In reply to Jan Kara from comment #27)
> [...]
> Also it seems you are now able to trigger the warning in under an hour? In
> that case it would be plausible to bisect the kernel if the directed
> debugging fails. We'll see...

For now building llvm-7.0.1-rc2 with tests in my ext4 zram disk (lz4
compressed) triggers the bug reliably. I could try to bisect, but not the next
few days or so. ;)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

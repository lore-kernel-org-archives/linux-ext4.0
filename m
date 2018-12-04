Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56030 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725971AbeLDDfH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2018 22:35:07 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 26FD12A313
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 03:35:07 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 03:35:05 +0000
Message-ID: <bug-201685-13602-Q9FyDILQdW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #214 from Hao Wei Tee (angelsl@in04.sg) ---
(In reply to Guenter Roeck from comment #213)
> I am now at a point where I still see the problem with almost all patches
> since 4.18.20 reverted; the only patch not reverted is the STAT_WRITE patch,
> because it is difficult to revert due to context changes. I'll revert that
> manually for the next round of tests.

Seems more and more likely that it's not a bug in ext4.. except perhaps some
changes in ext4 make it easier to run into the bug.

Do you think you'll be able to reproduce it with the 4.18 ext4?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

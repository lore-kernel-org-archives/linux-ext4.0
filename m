Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:59800 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725801AbeLBLlV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 06:41:21 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 497A02B069
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 11:41:17 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 11:41:16 +0000
Message-ID: <bug-201685-13602-fHD7NhGUQs@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #135 from jaapbuurman@gmail.com ---
Doesn't the Linux kernel team have any procedures in place for when such a
critical bug is found? There are many people running this "stable" 4.19 branch,
many of whom are unaware of this bug. Shouldn't the stable branch be rolled
back to the last known good version? Going back to 4.18 is certainly a better
option, but people unaware of this bug might still be running 4.19.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:52012 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725616AbeLBT3b (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 14:29:31 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5A54F2A7FA
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 19:29:28 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 19:29:27 +0000
Message-ID: <bug-201685-13602-7rZxDRuR1b@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #162 from Guenter Roeck (linux@roeck-us.net) ---
As next step, I am going to try v4.19.6 with the following reverts:

Revert "ext4: readpages() should submit IO as read-ahead"
Revert "ext4: improve code readability in ext4_iget()"

Those with btrfs problems might consider reverting commit 5e9d398240b2 ("btrfs:
readpages() should submit IO as read-ahead") and report the results.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196223] jdb2 journal - hung after suspend-resume test
Date: Sat, 08 Jul 2017 18:58:25 +0000
Message-ID: <bug-196223-13602-D0FLF2pTBZ@https.bugzilla.kernel.org/>
References: <bug-196223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40554 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752975AbdGHS62 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Jul 2017 14:58:28 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 581AF283BB
        for <linux-ext4@vger.kernel.org>; Sat,  8 Jul 2017 18:58:27 +0000 (UTC)
In-Reply-To: <bug-196223-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196223

--- Comment #11 from Theodore Tso (tytso@mit.edu) ---
Do you have any problems with 4.12?  Or is it only with the linux-next branch?

Can you try the dev branch of ext4: ff95015648df44

Does it reproduce on this commit?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196223] jdb2 journal - hung after suspend-resume test
Date: Mon, 10 Jul 2017 05:04:39 +0000
Message-ID: <bug-196223-13602-uf14UL2VgP@https.bugzilla.kernel.org/>
References: <bug-196223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53324 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750785AbdGJFEl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 10 Jul 2017 01:04:41 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 845F028405
        for <linux-ext4@vger.kernel.org>; Mon, 10 Jul 2017 05:04:40 +0000 (UTC)
In-Reply-To: <bug-196223-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196223

--- Comment #15 from Tomi Sarvela (tomi.p.sarvela@intel.com) ---
This S3 issue has appeared only on linux-next tree. Agree that it might be
timing or ordering problem on resume and not jbd2/ext4 issue.

I'm running linus' tree on every rc-tag. Most of the testing here is with
DRM-Tip tree, which will pick the 4.12 changes in short time.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

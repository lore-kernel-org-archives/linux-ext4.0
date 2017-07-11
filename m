From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196223] jdb2 journal - hung after suspend-resume test
Date: Tue, 11 Jul 2017 08:12:00 +0000
Message-ID: <bug-196223-13602-f7L6BFNUIy@https.bugzilla.kernel.org/>
References: <bug-196223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40982 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754510AbdGKIMI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 11 Jul 2017 04:12:08 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id EC84E2843B
        for <linux-ext4@vger.kernel.org>; Tue, 11 Jul 2017 08:12:07 +0000 (UTC)
In-Reply-To: <bug-196223-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196223

--- Comment #20 from Tomi Sarvela (tomi.p.sarvela@intel.com) ---
Most of our CI machines have standard SATA SSD disks, from 3 different vendors.
I picked just this one to test manually because it's the fastest to boot.

I'm trying to reproduce the issue on todays linux-next on other machines and
get a trace what's going on.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

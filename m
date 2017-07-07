From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196223] jdb2 journal - hung after suspend-resume test
Date: Fri, 07 Jul 2017 14:14:10 +0000
Message-ID: <bug-196223-13602-aOuTUYofmU@https.bugzilla.kernel.org/>
References: <bug-196223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60724 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750883AbdGGOON (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Jul 2017 10:14:13 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F1741286B1
        for <linux-ext4@vger.kernel.org>; Fri,  7 Jul 2017 14:14:12 +0000 (UTC)
In-Reply-To: <bug-196223-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196223

Tomi Sarvela (tomi.p.sarvela@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tomi.p.sarvela@intel.com

--- Comment #10 from Tomi Sarvela (tomi.p.sarvela@intel.com) ---
Out of linux-next builds, 20170626 is known good, results copied out:

https://intel-gfx-ci.01.org/CI/next-issues.html
https://intel-gfx-ci.01.org/CI/next-all.html

20170627 couldn't be tested because the locking issue (IOMMU panic)

20170628 has been tested bad earlier.

The newest build 20170707 has collected the following traces:

https://intel-gfx-ci.01.org/CI/next-20170707/fi-ivb-3520m/dmesg-149942861_Panic_1.log
https://intel-gfx-ci.01.org/CI/next-20170707/fi-hsw-4770r/dmesg-149942860_Panic_1.log
https://intel-gfx-ci.01.org/CI/next-20170707/fi-bxt-j4205/dmesg-149942868_Panic_1.log
https://intel-gfx-ci.01.org/CI/next-20170707/fi-skl-x1585l/dmesg-149942869_Panic_1.log
https://intel-gfx-ci.01.org/CI/next-20170707/fi-glk-2a/dmesg-149942868_Panic_1.log

Marta has left for vacation. I probably don't have time for bisection before
next Tuesday.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

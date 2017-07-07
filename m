From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196223] jdb2 journal - hung after suspend-resume test
Date: Fri, 07 Jul 2017 08:20:08 +0000
Message-ID: <bug-196223-13602-mQ3v6mrkUr@https.bugzilla.kernel.org/>
References: <bug-196223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44606 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750848AbdGGIUY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Jul 2017 04:20:24 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4D852285A4
        for <linux-ext4@vger.kernel.org>; Fri,  7 Jul 2017 08:20:23 +0000 (UTC)
In-Reply-To: <bug-196223-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196223

--- Comment #9 from Marta Löfstedt (marta.lofstedt@intel.com) ---
I have had no luck with bisecting, ending up with a commit only changing docs.
So, I guess my reproducer isn't good, which I have already discussed above.
I.e. I believe I have failed to establish a good base. Anyways, the back-traces
speak for themselves, we just don't know when this issue started. We will be
trying to do some runs on earlier tags on the next branch to establish a good
base.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

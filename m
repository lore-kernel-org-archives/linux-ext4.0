From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196223] jdb2 journal - hung after suspend-resume test
Date: Mon, 03 Jul 2017 13:49:12 +0000
Message-ID: <bug-196223-13602-Kk2U7tC61O@https.bugzilla.kernel.org/>
References: <bug-196223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41474 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933780AbdGCNtN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Jul 2017 09:49:13 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BA71D2850D
        for <linux-ext4@vger.kernel.org>; Mon,  3 Jul 2017 13:49:12 +0000 (UTC)
In-Reply-To: <bug-196223-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196223

--- Comment #5 from Marta Löfstedt (marta.lofstedt@intel.com) ---
Unfortunately, this is not a fast way to bisect. Running the testlist takes ~20
minutes. I usually hit the issue on the second repetition and usually on a
suspend-resume related tests. So, I am still searching for a reasonably new
good commit to start git bisect.

4.12.0-rc7-next-20170703 is bad
4.12.0-rc7-next-20170628 is bad 

I will spin 4.12.0-rc7-next-20170627 over night.

Are there some fs/ext4 specific test that may give a faster reproducer?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187051] "orphan list check failed" error in ext4
Date: Thu, 05 Oct 2017 11:00:59 +0000
Message-ID: <bug-187051-13602-YMrAIWMwTA@https.bugzilla.kernel.org/>
References: <bug-187051-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39700 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751931AbdJELBF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Oct 2017 07:01:05 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 638D328C66
        for <linux-ext4@vger.kernel.org>; Thu,  5 Oct 2017 11:01:05 +0000 (UTC)
In-Reply-To: <bug-187051-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=187051

--- Comment #22 from Tomasz Goliński (tomaszg@math.uwb.edu.pl) ---
I can't reproduce it. So far it was only a single occurrence and I don't even
know what caused it. It was also during compilation but it didn't see any
problem, only the information in the log.

I didn't want to reopen the problem and I'm well aware that it is to transient
to be debugged in a systematic way. In light of this I didn't want to open a
new bug, it would be mostly pointless. However since it is something that
"should never happen" another example of it might (or might not ;) ) shed some
light on the issue.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

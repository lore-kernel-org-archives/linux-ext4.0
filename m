From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187051] "orphan list check failed" error in ext4
Date: Thu, 05 Oct 2017 02:27:33 +0000
Message-ID: <bug-187051-13602-G67D6hiuEM@https.bugzilla.kernel.org/>
References: <bug-187051-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:57808 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751213AbdJEC1h (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Oct 2017 22:27:37 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BB1A428C06
        for <linux-ext4@vger.kernel.org>; Thu,  5 Oct 2017 02:27:36 +0000 (UTC)
In-Reply-To: <bug-187051-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=187051

--- Comment #21 from Theodore Tso (tytso@mit.edu) ---
Can you try to see if you can reliably reproduce the problem?   

And then can you see if you can reproduce it on some other hardware?

Note that one of the reasons why it's unfortunate when people reopen bugs,
especially when the original reporter has concluded it was probably caused by a
hardware issue in his case, is that it can sometimes be hard to disambiguate
data from the first report and successive reports.   (This is why I hate it
when Ubuntu users, in particular, glom on to reports by googling by symptom,
and assume that just because it has the same symptom, that it must be related
to every other problem with the same symptom, and all pile onto the same
Launchpad bug.  It's also why I believe Launchpad is mostly hopeless for a
developer....)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

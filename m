From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196223] jdb2 journal - hung after suspend-resume test
Date: Sun, 09 Jul 2017 05:27:32 +0000
Message-ID: <bug-196223-13602-MOODgLT0B5@https.bugzilla.kernel.org/>
References: <bug-196223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58616 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750759AbdGIF1e (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 9 Jul 2017 01:27:34 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 67C6C27C0B
        for <linux-ext4@vger.kernel.org>; Sun,  9 Jul 2017 05:27:33 +0000 (UTC)
In-Reply-To: <bug-196223-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196223

--- Comment #14 from Theodore Tso (tytso@mit.edu) ---
Also for the record, there is also no difference in any ext4/jbd2 code between
next-20170626, next-20170627, next-20170628, and next-20170630.   So if
next-20170726 is working for you, and next-201706028 is not, it very well be
the case that the fact that we are blocked waiting for I/O in ext4 code is a
symptom, not the cause of the problem, and if ext4 is the cause of the problem,
it must be indirectly.

So I'm not sure there's anything more I can do, especially since I don't have a
reliable repro that I can run at this point.

Something else that might be worth trying.  What's in linux-next is slowing
getting picked up by Linus.  You might see if the tip of Linus's tree is
passing your tests or not.  If not, it will be much easier to do a true git
bisection, unlike with linux-next since many patches get rebased.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

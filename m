From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196223] jdb2 journal - hung after suspend-resume test
Date: Sun, 09 Jul 2017 05:05:42 +0000
Message-ID: <bug-196223-13602-tr8oCAtFDz@https.bugzilla.kernel.org/>
References: <bug-196223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58114 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751014AbdGIFF6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 9 Jul 2017 01:05:58 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5CE9228113
        for <linux-ext4@vger.kernel.org>; Sun,  9 Jul 2017 05:05:57 +0000 (UTC)
In-Reply-To: <bug-196223-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196223

--- Comment #13 from Theodore Tso (tytso@mit.edu) ---
I tried downloading intel-gpu-tools and tried running the igt tests using
piglet and the instructions in the README on my Lenovo T470 laptop (which has
an intel graphics chipset).  The results were not promising:

4.9: got to around test 55 (out of some 60,000+ tests) before the system reset
into the BIOS

4.11.0: got to test 17 before the test locked up the kernel so hard that
magic-sysrq wasn't working

4.12 plus the ext4 patches in linux-next: got to test 45 before test locked up
the kernel so hard that magic-sysrq wasn't working

Given that it's not working on 4.9 and 4.11, I'm not going to be able to
distinguish the regression you're seeing with the natural failure to run the
tests on a Lenovo T470.

I will say that on both my Lenovo T470 and T540p, for the past year or two
(since 4.4 or perhaps earlier) suspend resume after docking with using a MST
dock talking to a Dell 30" monitor has always had about a 10-20% chance of
locking up on resume.   It used to work just fine, but sometime in the early
4.x kernels there was a regression.

I tried reporting it as a bug on various i915 and drm lists back when I first
noticed, but it seems that MST doesn't get much love, and so I've never
considered the i915 driver in combination with the Dock and an MST display to
be terribly stable.  And I've been too cheap to spend a thousand bucks or so to
get a new 30" monitor which is non-MST, assuming it would work with the Lenovo
Dock, which I guess there is no guarantee.  :-(

(And hmm, come to think of it I guess I was running the tests while docked to
the Dell 30" monitor.  I've just gotten so used to the fact that if I suspend
while being docked and using the Dell monitor, the laptop might never come
back, so I just save all my buffers beforehand and hope I get lucky on resume. 
I've gotten so used to the lossage I forgot I probably should have tried the
test repro experiment without the dock and the Dell monitor attached.   I guess
when I have time later this week I can try rerunning the tests when I'm not
docked and see if I have any better luck.)

If anyone can give me more specific repro instructions for IGT --- is there a
specific test or subtest I should be running, to avoid running into other i915
bugs that might be unrelated?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

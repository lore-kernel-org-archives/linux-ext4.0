Return-Path: <SRS0=IALa=OK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50446 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725734AbeLBI0o (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 03:26:44 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id DD39C2C676
        for <linux-ext4@vger.kernel.org>; Sat,  1 Dec 2018 21:13:17 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sat, 01 Dec 2018 21:13:17 +0000
Message-ID: <bug-201685-13602-PLYassiiV3@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #114 from Theodore Tso (tytso@mit.edu) ---
So I've gotten a query off-line about whether I'm still paying attention to
this bug.   The answer is that I'm absolutely paying attention.   The reason
why I haven't commented much is because there's not much else to say, and I'm
still waiting for more information.

On that front --- I am *absolutely* grateful for people who are still trying to
debug this issue, especially when it may be coming at the risk of their data.  
However, one of the challenges is that it's very easy for reports to be either
false positives or false negatives.

False positives come from booting a kernel which might be fine, but the file
system was corrupted from running a previous kernel.   Remember, when you get
an EXT4-fs error report, that's when the kernel discovers the file system
corruption; it doesn't necessarily mean that the currently running kernel is
buggy.   To prevent this false positives, please run "e2fsck -fy /dev/sdXX >
/tmp/log.1" to make sure the file system is clear before rebooting into the new
kernel.  If e2fsck -fy shows any problems that are fixed, please then run "echo
3 > /proc/sys/vm/drop_caches ; e2fsck -fn /dev/sdXX > /tmp/log.2" to make sure
the file system is really clean.

False negatives come from booting a kernel which is buggy, but since this bug
seems to be a bit flakey, you're getting lucky/unlucky enough to such that
after N hours/days, you just haven't tripped over the bug --- or you *have*
tripped over the bug, but the kernel hasn't noticed the problem yet, and so it
hasn't reported the EXT4-fs error yet.     There's not a lot we can do to
absolutely avoid all false negatives, but if you are running a kernel which you
report is OK, and then a day later, it turns out you see corruption, please
don't forget to submit a comment to bugzilla, saying, "my comment in #NNN,
where I said a particular kernel was problem-free; turns out I have seen a
problem with it."


Again, my thanks for trying to figure out what's going on.  Rest assure that
Jens Axboe and I are both paying very close attention.   This bug is a really
scary one, both because of how the severity of its consequences, *and* because
neither of us can reproduce it on our own systems or regression tests --- so we
 are utterly reliant on those people who *can* reproduce the issue to give us
data.   We very much want to make sure this gets fixed ASAP!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

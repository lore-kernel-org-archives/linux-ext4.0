From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Fri, 21 Jul 2017 21:14:09 +0000
Message-ID: <bug-196405-13602-BmmPTk38Dt@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51566 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753502AbdGUVOL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 21 Jul 2017 17:14:11 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id CA6C320499
        for <linux-ext4@vger.kernel.org>; Fri, 21 Jul 2017 21:14:10 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #20 from michelbach94@gmail.com ---
(In reply to Theodore Tso from comment #18)
> > More accurately, we've gone ten years before people connected the dots.
> This
> > time, the original bug report was about 'ls'.
> 
> Can you give me a pointer to the original bug report?  I'm curious how
> things were misbehaving.
> [...]
> The problem withdrawing the feature is that it would break a lot of
> users who want to have more than 65,000 subdirectories.  Ext4 has been
> out there for a long time, and while it's true that many people don't
> create directory trees which are that bushy, I've gotten people
> screaming at us for much more minor bugs.  So that's why I'm curious
> to see the original ls bug.

Don't get your hopes up. I filed the original bug report
https://debbugs.gnu.org/cgi/bugreport.cgi?bug=27739 because I noticed that `ll`
(an alias to `ls -alF`) prints something that doesn't make sense. That's also
why I filed the bug report on the GNU bug tracker: Clearly, I was still able to
access my directories, so they definitely still existed, but `ll` printed `1`
which didn't make sense to me, especially not as I never saw a directory with a
hard link count lower than 2 before. After successfully replicating¹ it on
different machines in an as-simple-as-possible way and thereby already having
written bash code capable of replicating the bug, I provided them with that
simple example which just creates empty folders.

After the GNU guys said it's not their bug, Paul replicated it on his machine
(different distro) and filed this bug report:
https://bugzilla.redhat.com/show_bug.cgi?id=1471967 After Red Hat said it's not
their bug, he filed the one whose discussion you're reading right now.


-----
¹ Well, kind of. I actually tried it on a third system (didn't mention it until
now, afaik) which runs FreeBSD but the code failed because either FreeBSD or
its default FS (or whatever FS that machine uses) doesn't support enough
subdirectories or something like that (it failed to create the high number of
subdirectories for some reason, so I didn't even get to run `ls` under the
right conditions) (ergo: Linux > FreeBSD). But it didn't fail in any way
related to `ls` and worked on 2 different machines, so I filed the original bug
report.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

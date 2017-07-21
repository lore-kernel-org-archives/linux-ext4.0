From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Fri, 21 Jul 2017 08:22:05 +0000
Message-ID: <bug-196405-13602-bJWI1wtsC4@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55044 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750737AbdGUIWH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 21 Jul 2017 04:22:07 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BD3E028782
        for <linux-ext4@vger.kernel.org>; Fri, 21 Jul 2017 08:22:06 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #17 from Paul Eggert (eggert@cs.ucla.edu) ---
(In reply to Theodore Tso from comment #15)
> I don't think you need to disable the optimization for all of Linux.  All
> you need to do is to disable the optimization if the link count on the
> directory is 1.
Yes, that makes sense, and I plan to do that: these are steps 3 and 4 in my
Comment 13 for this bug. Unfortunately, there is a reasonable amount of code
that assumes the traditional Unix behavior (not just in glibc), and I doubt
whether I will be able to track it all down.

> I thought this was a regression in find is because you said
> that code which understood the n_links=1 convention was in the old find code?
Yes it was. The current 'find' code does not know about the convention.
Although 'find' happens to work as a matter of luck for this particular test
case, I have the sneaking suspicion that there are other test cases where it
does not work. The assumption is used in multiple places in 'find' and I have
not checked them all. Similarly for 'tar' and other GNU applications.

> allowing tune2fs to clear the dir_nlink flag is not a safe thing to do.
That depends on what the dir_nlink flag is supposed to mean. (Since the flag
does not work now, we can define it to mean what we like. :-) If dir_nlink 1
means "set a directory link count to 1 if it would overflow", and if a link
count of 1 never changes regardless of what dir_nlink is set to, then why would
it be a problem to allow tunefs to alter the dir_nlink flag? dir_nlink would
affect only future calls to mkdir, not past ones.

> ftw will break for Linux's /proc/sys directories as well
Yes. However, ftw is normally applied to user files, so it's significantly more
important that ftw work there.

> As far as other programs who might make the same mistake glibc did, since
> Posix does not guarantee that
I'm worried about code intended to run on traditional Unix and GNU/Linux, not
about portable POSIX code. There is a reasonable amount of code that uses
st_nlink as a way to avoid unnecessary stat calls when traversing a file
system. This provides a significant performance boost on traditional Unix and
GNU/Linux, and it would be a shame to lose this performance benefit.

> The fact that we've gone ten years without anyone noticing or complaining
More accurately, we've gone ten years before people connected the dots. This
time, the original bug report was about 'ls'. This isn't a bug in 'ls' so it
got turned into a bug report for 'lstat'. But this isn't about lstat either, so
it got turned into a bug report for ext4. I'm sure other people have noticed
the problem before, it's just that few people are dogged and expert enough to
track the bug down to the actual cause.

>From my point of view The worst thing about all this, is that the dir_nlink
feature is misdocumented and does not work as intended (i.e., it's a flag that
in effect cannot be turned off). Either dir_nlink needs to be documented and
fixed; or failing that, the dir_nlink flag should be withdrawn and the ext4
documentation should clearly say that the link count of a directory is
permanently set to 1 after it overflows past 64999. If you take the latter
approach, you needn't update the ext4 code at all, just the documentation
(though the documentation should note that 64999 is off-by-one compared to the
65000 that is nominally the maximum link count).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

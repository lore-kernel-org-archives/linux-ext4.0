From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sat, 31 Oct 2009 16:16:45 GMT
Message-ID: <200910311616.n9VGGjQv000306@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39225 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZJaQQl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 31 Oct 2009 12:16:41 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9VGGjF1000307
	for <linux-ext4@vger.kernel.org>; Sat, 31 Oct 2009 16:16:45 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #163 from Eric Sandeen <sandeen@redhat.com>  2009-10-31 16:16:32 ---
(In reply to comment #161)

> Step 1) Sanity check that commit 0a80e986 shows the problem.  This is
> immediately after the first batch of ext4 patches which I sent to
> Linus during the post-2.6.31 merge window.  Given that patches in the
> middle of this first patch have been reported by Avery as showing the
> problem, and while we may have some "git bisect good" revisions that
> were really bad, in general if a revision is reported bad, the problem
> is probably there at that version and successive versions.  Hence, I'm
> _pretty_ sure that 0a80e986 should demonstrate the problem.
> 
> Step 2) Sanity check that commit ab86e576 does _not_ show the problem.
> This commit corresponds to 2.6.31-git6, and there are no ext4 patches
> that I pushed before that point.  There are three commits that show up
> in response to the command "git log v2.6.31..v2.6.31-git6 -- fs/ext4
> fs/jbd2", but they weren't pushed by me.  Although come to think of
> it, Jan Kara's commit 0d34ec62, "ext4: Remove syncing logic from
> ext4_file_write" is one we might want to look at very carefully if
> commit ab86e576 also shows the problem....

Ok, I'm testing these.

I'm really starting to think, though, that this might be a latent problem
exposed by other changes; I can't otherwise explain my utter failure at trying
to run git-bisect over larger ranges...

-Eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

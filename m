From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Mon, 21 Mar 2016 13:04:06 +0000
Message-ID: <bug-102731-13602-PkMyMrx761@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33884 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162AbcCUNEN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Mar 2016 09:04:13 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 66973202BE
	for <linux-ext4@vger.kernel.org>; Mon, 21 Mar 2016 13:04:12 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 6EAB220306
	for <linux-ext4@vger.kernel.org>; Mon, 21 Mar 2016 13:04:06 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #43 from Theodore Tso <tytso@mit.edu> ---
Vaclav, I want to really, really thank you for doing the bisect.   Looking at
the testing procedure you used for the git bisect here:

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=818502

I'm quite confident you've found the commit that needs to be backported into
the Debian 3.16 kernel.  Given that the commit was added in 3.17, it should be
fairly easy to backport it into the Debian kernel.

It's really too bad this commit hadn't been marked with a
cc:stable@vger.kernel.org tag, but to be fair I've sometimes made this mistake,
either out of sheer forgetfulness or because I didn't recognize the seriousness
of the bugs that a commit could address.   To be fair to the KVM maintainers,
the commit description doesn't really list the potential impacts of the bug it
was fixing.

Also with 20-20 hindsight, it's perhaps unfortunate that during this time
period there is a real divergence[1] of kernels that were used by
distributions.  So a bug that would only show up on certain generations of
Intel chipsets, and only when used in virtualization as a host, is precisely
the sort of bug that it is not likely to be noticed until it goes into
enterprise-wide deployment --- and so the fact that other distributions didn't
standardize on a single kernel in this time period (and Debian standardized on
the oldest kernel in this rough time period, 3.16, and the bug in question was
fixed in 3.17) meant that it's not all that surprising that this slipped
through.   And while it would have been more convenient if Debian had been
willing to switch over to a 3.18 based stable series, it wasn't compatible with
their release schedule.

[1] Ubuntu 14.04 LTS stayed on 3.16 for only 18 months before moving to 3.19; 
Fedora 20 was on 3.11, and Fedora 21 jumped to 3.17, etc.

Vaclav, thanks again for finding a simple/easy repro, and then bisecting until
you found the commit that is needed for the 3.16 debian kernel!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

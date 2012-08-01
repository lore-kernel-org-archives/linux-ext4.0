From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Wed,  1 Aug 2012 02:43:13 +0000 (UTC)
Message-ID: <20120801024313.5EE4511FC6C@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40819 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab2HACnQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jul 2012 22:43:16 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7F7A020322
	for <linux-ext4@vger.kernel.org>; Wed,  1 Aug 2012 02:43:15 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id B444C202A6
	for <linux-ext4@vger.kernel.org>; Wed,  1 Aug 2012 02:43:14 +0000 (UTC)
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895





--- Comment #22 from Theodore Tso <tytso@mit.edu>  2012-08-01 02:43:12 ---
Nicolas,

The problem you are describing is not really related to the other problems (and
I use plural, because this bug has suffered from Ubuntu Launchpad disease ---
people are glomming onto a bug without understanding whether what they have are
the same bug or a different bug).

I don't know what is causing your freeze events, but by posting here, you're
only going to get the attention of ext4 developers.  The fact that you're not
seeing an exact correlation with jbd2 events means it's probably something
else.  The fact is that jbd2 activity is correlated with *any* change to the
file system.  So if you have something doing lots of unnecessary file system
writes, it's going to cause jbd2 activity.  That doesn't mean a jbd2 bug; it
just means the userspace is doing something unnecessary.

As far as your complaint is concerned, it's not at all obvious whether it's a
memory shortage problem, perhaps only in certain cgroup containers, or
something else entirely different.

I'm certainly not seeing any problems with my Debian wheezy laptop, but I'm
using Xfce, not GNOME 3, and I'm not using systemd.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

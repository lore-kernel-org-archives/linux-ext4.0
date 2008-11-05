From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11960] Oops in ext4_mb_poll_new_transaction
Date: Wed,  5 Nov 2008 12:55:55 -0800 (PST)
Message-ID: <20081105205555.A6F0711D107@picon.linux-foundation.org>
References: <bug-11960-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755707AbYKEU40 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 15:56:26 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA5KttbD008519
	for <linux-ext4@vger.kernel.org>; Wed, 5 Nov 2008 12:55:56 -0800
In-Reply-To: <bug-11960-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=11960





------- Comment #1 from tytso@mit.edu  2008-11-05 12:55 -------
Note, -stable is a stale branch pointer.  It reflects commits that Linus has
pulled into mainline, so there's nothing _wrong_ with it, but it accidentally
got published.  You probably want either ext4-stable (which is the latest
patches that have been accepted into mainline against the stable 2.6.27 kernel)
or for-stable, which is a set of patches we're going to be sending to the
2.6.27.x kernel when I have a chance.

It's almost certain that the bug won't show up in the ext4-stable branch, since
in the latest mainline kernel we've dropped ext4_mb_poll_new_transaction and
replaced it with something else that is far clearly.  However, the code is
still in the for-stable and 2.6.27.x branches, though.  So if there is a bug in
2.6.27, we do want to track it down and fix it.

Hmm... at a guess, looking at the symptoms, I suspect it happens when there are
so many inodes on the orphaned inode list that it requries more than one
transaction to clear all of the inoes on the orphaned inode list.  How big is
the journal on your filesystem?   What does "dumpe2fs -h /dev/sdb1 | grep
Journal" report?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

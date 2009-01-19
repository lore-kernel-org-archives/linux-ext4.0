From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11688] Oops while writing on a newly ext4 formated 1TB partition on a external USB drive
Date: Sun, 18 Jan 2009 18:28:13 -0800 (PST)
Message-ID: <20090119022813.765DE108042@picon.linux-foundation.org>
References: <bug-11688-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756774AbZASC2Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Jan 2009 21:28:16 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0J2SDSc021559
	for <linux-ext4@vger.kernel.org>; Sun, 18 Jan 2009 18:28:14 -0800
In-Reply-To: <bug-11688-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=11688


tytso@mit.edu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|fs_ext4@kernel-bugs.osdl.org|fs_ext3@kernel-bugs.osdl.org
          Component|ext4                        |ext3




------- Comment #7 from tytso@mit.edu  2009-01-18 18:28 -------
So you only have 2 megabytes of memory....  Yeah, this sounds like a low-memory
pressure situation.   Ext4's delayed allocation will definitely use more
memory, and it looks like you are tickling an ext3 memory pressure bug.   Is
there a reason why you aren't mounting your filesystems with noatime?   That's
undoubtedly responsible for the ext3 journal activity, and I suspect mounting
/home with noatime will make the problem go away.  It might also be interesting
disabling quotas on /home, to see if the problem goes away or moves to
something else.

What is happening is that when ext4 starts writing, it needs memory for the
page cache.  To get that space, the VM system is trying to get space, so it
calls among other things, shrink_icache_memory, to shrink the inode cache,
which then calls clear_inode, which ended up calling ext3_dquot_drop, through
the quota code.  Ext3_dquot_drop() calls journal_start(), which then trips over
a sanity check.   In any case, given what you've told me, I'm even more
convinced this is an ext3 and/or a quota system bug, which is getting triggered
to severe memory pressure caused by ext4 and the fact that you have a very tiny
amount of memory.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

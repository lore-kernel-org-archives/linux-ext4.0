From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47731] Null pointer dereference at strchr
Date: Thu, 20 Sep 2012 01:21:11 +0000 (UTC)
Message-ID: <20120920012111.5D7DA11FAE2@bugzilla.kernel.org>
References: <bug-47731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53890 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab2ITBVO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Sep 2012 21:21:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9F37E20287
	for <linux-ext4@vger.kernel.org>; Thu, 20 Sep 2012 01:21:13 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id B58052027F
	for <linux-ext4@vger.kernel.org>; Thu, 20 Sep 2012 01:21:12 +0000 (UTC)
In-Reply-To: <bug-47731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47731


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #1 from Theodore Tso <tytso@mit.edu>  2012-09-20 01:21:10 ---
Is this repeatable?   I'm having a lot of trouble figuring out the stack trace,
since strchr isn't used anywhere in the code path involved with printing the
ext4 mount options while returning the contents of /proc/mounts (which is
obviously what is going on).

The only strchr that looks even vaguely possible is the one used by
seq_escape() in fs/seq_file, which is called by mangle() and which is called by
show_vfsmnt() in fs/namespace.c.   But the stack trace doesn't look consistent
with that, either.   Part of the problem is between the inline functions, and
the function pointers used by show_vfsmnt, the stack dump in the OOPS message
can be quite misleading.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

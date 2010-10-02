From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17361] Watchdog detected hard LOCKUP in
 jbd2_journal_get_write_access
Date: Sat, 2 Oct 2010 16:42:51 GMT
Message-ID: <201010021642.o92Ggp1A007965@demeter1.kernel.org>
References: <bug-17361-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53046 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab0JBQmv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Oct 2010 12:42:51 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o92GgpYh007966
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 2 Oct 2010 16:42:51 GMT
In-Reply-To: <bug-17361-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=17361


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #14 from Theodore Tso <tytso@mit.edu>  2010-10-02 16:42:45 ---
People may not be paying attention to this due to the subject line.

Except for the initial bug report, none of the other stack traces have anything
to do with ext4/jbd2.    And in the initial ext4 trace, we see the complaint
that we're calling might_sleep() in ext4_mark_inode_dirty(), in a code path
where we are manifestly not taking any spinlocks.    And in fact we don't see
any spinlocks being taken at the point where the complaint is mode in
ext4_mark_inode_dirty().   Yet preempt_count > 1.

It looks to me like some unrelated piece of code is bumping preempt_count, and
not decrementing it.  Maybe in some code which is called from an interrupt
handler, in some device driver?   That might explain why you're getting
failures all over the kernel.

It may be worth closing this report, and opening several new ones, one for each
failure, and make it clear this is not an ext4-related problem, since the
subject line and component assigned for this bug is highly misleading.

Including your kernel config would also be useful when you do that.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

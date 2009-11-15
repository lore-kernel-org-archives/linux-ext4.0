From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14602] JBD2 journal abort / checkpoint creation racy?
Date: Sun, 15 Nov 2009 22:28:01 GMT
Message-ID: <200911152228.nAFMS1B4032449@demeter.kernel.org>
References: <bug-14602-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46036 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbZKOW14 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Nov 2009 17:27:56 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAFMS1Au032450
	for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2009 22:28:01 GMT
In-Reply-To: <bug-14602-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14602


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #1 from Theodore Tso <tytso@mit.edu>  2009-11-15 22:27:58 ---
If the journal is aborted, then any attempts to destroy the journal, checkpoint
the journal, create a new transaction, etc., will result in -EIO being
returned.   In the code that you quoted, the EIO is being returned because
is_journal_aborted(journal) returns true.

The normal reason why the journal gets aborted is because ext4_error() has
called ext4_handle_error(), which then calls jbd2_journal_abort() and the
errors behavior is remount-read-only.   The basic idea is that if some kind of
file system error or corruption has been detected, we want to stop the file
system from any further modifications, which might cause more damage and/or
user data loss.

We don't have a good errno value to use, so we just use EIO, and the error
handling after an aborted journal is admittedly not great.   It triggers a lot
of scary, and to someone who isn't an ext3/ext4 veteran, misleading, error
messages, and unfortunately it can cause the key initial failure to scroll off
of a VT console.

So it's not a race condition; the system is functioning as designed, although
at some point we may put in better error handling and some earlier tests for an
aborted journal in some of the upper layers of various ext4 functions.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

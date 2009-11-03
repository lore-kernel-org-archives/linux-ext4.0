From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 3 Nov 2009 23:39:45 GMT
Message-ID: <200911032339.nA3NdjK5028991@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35646 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbZKCXjk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Nov 2009 18:39:40 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA3NdjwC028993
	for <linux-ext4@vger.kernel.org>; Tue, 3 Nov 2009 23:39:45 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #174 from Eric Sandeen <sandeen@redhat.com>  2009-11-03 23:39:40 ---
Tidbit; after turning on checksums but disabling any action on a mismatch, and
adding a little instrumentation, I got something like:

checksum error 1293235, (not) breaking
normal scan finish, setting end_transaction to 1293246
(fs/jbd2/recovery.c, 388): do_one_pass: Starting recovery pass 1
(fs/jbd2/recovery.c, 388): do_one_pass: Starting recovery pass 2
(fs/jbd2/recovery.c, 257): jbd2_journal_recover: JBD: recovery, exit status 0,
recovered transactions 1293215 to 1293246

IOW, the checksum error was far from the last transaction in the log; it was
somewhere in the middle-ish of what needed to be replayed.

So this more or less explains the corruption (many transactions were not
replayed because recovery was aborted when the bad checksum was found), and it
doesn't necessarily point to a problem with the transaction in flight when the
power-fail occurred... we had about 10 transactions after that.  Hrm.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

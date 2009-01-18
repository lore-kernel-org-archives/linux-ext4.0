From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9817] oops in jbd2_journal_commit_transaction after journal abort
Date: Sat, 17 Jan 2009 18:14:52 -0800 (PST)
Message-ID: <20090118021452.6EED4108041@picon.linux-foundation.org>
References: <bug-9817-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753534AbZARCOz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Jan 2009 21:14:55 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0I2EqNs023367
	for <linux-ext4@vger.kernel.org>; Sat, 17 Jan 2009 18:14:53 -0800
In-Reply-To: <bug-9817-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=9817


tytso@mit.edu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |REJECTED
         Resolution|                            |UNREPRODUCIBLE




------- Comment #12 from tytso@mit.edu  2009-01-17 18:14 -------
This bug report so old, and I've seen multiple cases where we don't oops after
the journal is aborted, so I'm going to close this bug. If you can reproduce
this with a newer kernel, please open a new bug.  Thanks!!


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

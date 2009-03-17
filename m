From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12885] kernel BUG at fs/jbd/transaction.c:1376!
Date: Tue, 17 Mar 2009 14:49:32 -0700 (PDT)
Message-ID: <20090317214932.F1969108049@picon.linux-foundation.org>
References: <bug-12885-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752984AbZCQVuk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Mar 2009 17:50:40 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2HLnX5W013271
	for <linux-ext4@vger.kernel.org>; Tue, 17 Mar 2009 14:50:09 -0700
In-Reply-To: <bug-12885-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12885





------- Comment #2 from tytso@mit.edu  2009-03-17 14:49 -------
The BUG is caused by the following in journal_stop() in transaction.c:

        J_ASSERT(journal_current_handle() == handle);

Somehow the journal handle got corrupted, or we screwed up in the refcount of
open handles and allowed a journal transaction to commit even though
ext3_mkdir() and ext3_creat() was in the middle of doing something with a
handle.  This is one of these should-never-happen situations.

What was the system doing at the time of the crash?  And we have to wonder why
you are seeing it but apparently not others.  Is this a completely unmodified,
stock 2.6.28 kernel?   Have there been any patches applied?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

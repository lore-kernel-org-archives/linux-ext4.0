From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12885] kernel BUG at fs/jbd/transaction.c:1376!
Date: Wed, 18 Mar 2009 12:13:20 -0700 (PDT)
Message-ID: <20090318191320.6CD11108040@picon.linux-foundation.org>
References: <bug-12885-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895AbZCRTOZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Mar 2009 15:14:25 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2IJDKCn004801
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2009 12:13:56 -0700
In-Reply-To: <bug-12885-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12885





------- Comment #14 from tytso@mit.edu  2009-03-18 12:13 -------
In answer to your question in comment #12, yes, it's expected that processes
accessing the problematic directory might hang after a reboot, since when the
process died after the BUG, it probably left some locks locked, and so
processes would end up waiting forever for the locks to get unlocked (which
they won't since the process that held them died after the OOPS message).

But if this was caused by the unrar, then this might be harder to replicate....

In any case, if you haven't rebooted yet, I would try rebooting, and then
running e2fsck on the filesystem to make sure it is consistent.  Then the next
trick is to see what is needed to replicate the BUG/oops message.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

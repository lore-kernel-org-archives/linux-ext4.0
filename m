From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Wed, 2 May 2012 16:08:49 GMT
Message-ID: <201205021608.q42G8nHM019903@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:51822 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab2EBQIu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 May 2012 12:08:50 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q42G8nVd019904
	for <linux-ext4@vger.kernel.org>; Wed, 2 May 2012 16:08:49 GMT
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #3 from Theodore Tso <tytso@mit.edu>  2012-05-02 16:08:48 ---
It sounds like something in userspace is simply calling fsync() very
frequently.  Can you try the following:

echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_sync_file_enter/enable 

... then wait for a minute or so, and then capture the output of:

cat /sys/kernel/debug/tracing/trace

That should allow us to see what is causing the excess commits.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

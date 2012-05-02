From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Wed, 2 May 2012 16:10:21 GMT
Message-ID: <201205021610.q42GAL52020043@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:51832 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab2EBQKV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 May 2012 12:10:21 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q42GAL6x020044
	for <linux-ext4@vger.kernel.org>; Wed, 2 May 2012 16:10:21 GMT
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895





--- Comment #4 from Theodore Tso <tytso@mit.edu>  2012-05-02 16:10:21 ---
Oh, the above requires that CONFIG_FTRACE be enabled, and that your
distribution is mounting the debugfs file system on /sys/kernel/debug.  If not,
you may need to recompile your kernel to enable FTRACE, and/or manually mount
the debugfs filesystem before you try the above experiment.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

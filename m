From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51391] BUG: unable to handle kernel NULL pointer dereference
Date: Fri,  7 Dec 2012 17:12:21 +0000 (UTC)
Message-ID: <20121207171221.D8D3111FB81@bugzilla.kernel.org>
References: <bug-51391-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51855 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422888Ab2LGRMZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Dec 2012 12:12:25 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B45172035B
	for <linux-ext4@vger.kernel.org>; Fri,  7 Dec 2012 17:12:24 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id DB13920358
	for <linux-ext4@vger.kernel.org>; Fri,  7 Dec 2012 17:12:21 +0000 (UTC)
In-Reply-To: <bug-51391-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51391





--- Comment #4 from Theodore Tso <tytso@mit.edu>  2012-12-07 17:12:21 ---
Hmm, I looked at the stack trace again, and I see "sys_inotify_rm_watch" in the
stack trace.  I wonder if this is a generic VFS-level inotify bug, perhaps?   I
don't have an easy way of setting up an inotify in my bare-bones KVM
environment.  Can you tell me a bit more about your environment and what you
might be using that might be setting an inotify on something on your file
system?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

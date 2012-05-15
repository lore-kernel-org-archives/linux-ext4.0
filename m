From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Tue, 15 May 2012 14:54:40 +0000 (UTC)
Message-ID: <20120515145440.C99DC11FCF0@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53503 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab2EOOys (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 May 2012 10:54:48 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A5CA820548
	for <linux-ext4@vger.kernel.org>; Tue, 15 May 2012 14:54:42 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id D1166204A8
	for <linux-ext4@vger.kernel.org>; Tue, 15 May 2012 14:54:40 +0000 (UTC)
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895





--- Comment #12 from Jan Kara <jack@suse.cz>  2012-05-15 14:54:40 ---
(In reply to comment #11)
> Enabling ext4_mark_inode_dirty gives me constant flood of events where
> xfce4-terminal dirties mostly two same inodes:
> http://paste.ubuntu.com/988896/
> Is it expected behavior? This is default terminal in Xubuntu.
  Yeah, forgot about it. Sorry for extra work. Terminal writes to some pipe
inode or socket when it outputs to the screen... Just create tmpfs if you don't
have one (e.g. mkdir /tmp/mem; mount -t tmpfs none /tmp/mem/) and then gather
the output like "cat /sys/kernel/debug/tracing/trace_pipe
>/tmp/mem/dirty_trace".

BTW writing to sockets or named pipes is often source of filesystem
modifications because mtime of those inodes change - e.g. postfix is causing
these relatively frequently, xfce4-terminal is another such case. It's a bit
tricky to avoid these because I'd be recluctant to completely stop updating
mtime on socket/pipe inodes as some strange tool may rely on that. But I've got
some idea which may work so if this is indeed the problem, I can look at it
again.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

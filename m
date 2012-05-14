From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Mon, 14 May 2012 21:43:40 +0000 (UTC)
Message-ID: <20120514214340.5B64C11F973@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53856 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258Ab2ENVnm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 May 2012 17:43:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 422D7204CE
	for <linux-ext4@vger.kernel.org>; Mon, 14 May 2012 21:43:41 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 62EA120497
	for <linux-ext4@vger.kernel.org>; Mon, 14 May 2012 21:43:40 +0000 (UTC)
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz




--- Comment #10 from Jan Kara <jack@suse.cz>  2012-05-14 21:43:40 ---
(In reply to comment #8)
> Is there a way to find a cause of flush and jbd2 writes? Like apllication name
> or PID?
> Preferably without need to patch/compile new kernel, so that as many people as
> possible can use it.
  If you have tracepoints enabled in your kernel (they usually are) and you
have relatively recent kernel, then you can enable tracepoint in
ext4_mark_inode_dirty() by:
echo 1 >/sys/kernel/debug/tracing/events/ext4/ext4_mark_inode_dirty/enable

Then you can run:
cat /sys/kernel/debug/tracing/trace_pipe
and watch how inodes are dirtied. That should catch practically all cases where
JBD2 eventually ends up doing some IO.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

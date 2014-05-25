From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76821] jbd2 write on disk each 2/3 seconds
Date: Sun, 25 May 2014 12:15:58 +0000
Message-ID: <bug-76821-13602-5ZguBB2OI0@https.bugzilla.kernel.org/>
References: <bug-76821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55694 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbaEYMQD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 May 2014 08:16:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7FD44201EC
	for <linux-ext4@vger.kernel.org>; Sun, 25 May 2014 12:16:01 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B1460201BB
	for <linux-ext4@vger.kernel.org>; Sun, 25 May 2014 12:15:58 +0000 (UTC)
In-Reply-To: <bug-76821-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76821

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |INVALID

--- Comment #5 from Theodore Tso <tytso@mit.edu> ---
You can try running "journalctl -f" and see what kind of log messages you are
seeing.  But in any case, this isn't an ext4 bug, but rather a systemd,
journald, or some system daemon or distro-level bug.

If userspace shovels stuff for us to write, we have to write it!   So for that
reason, I've closed out this bug.  If this isn't a configuration issue, please
open a bug with the appropriate distribution or systemd bug tracking system.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51391] BUG: unable to handle kernel NULL pointer dereference
Date: Mon, 11 Feb 2013 10:04:51 +0000 (UTC)
Message-ID: <20130211100451.D64AC11FF22@bugzilla.kernel.org>
References: <bug-51391-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53250 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193Ab3BKKFB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 05:05:01 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AFBFA20204
	for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2013 10:04:56 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 22ABB201EE
	for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2013 10:04:52 +0000 (UTC)
In-Reply-To: <bug-51391-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51391


Alexey Khoroshilov <khoroshilov@linuxtesting.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |khoroshilov@linuxtesting.or
                   |                            |g




--- Comment #10 from Alexey Khoroshilov <khoroshilov@linuxtesting.org>  2013-02-11 10:04:51 ---
(In reply to comment #4)
> Hmm, I looked at the stack trace again, and I see "sys_inotify_rm_watch" in the
> stack trace.  I wonder if this is a generic VFS-level inotify bug, perhaps?   

It looks like it is actually a data race in VFS layer:
https://patchwork.kernel.org/patch/1685431/

We observed the same issue with JFS file system.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 66821] "BUG: soft lockup" in proc_fd_link, causing freeze
Date: Tue, 10 Dec 2013 20:02:15 +0000
Message-ID: <bug-66821-13602-b7sRy40WkY@https.bugzilla.kernel.org/>
References: <bug-66821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37743 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab3LJUCS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Dec 2013 15:02:18 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 76B892062C
	for <linux-ext4@vger.kernel.org>; Tue, 10 Dec 2013 20:02:17 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 66E7C2061E
	for <linux-ext4@vger.kernel.org>; Tue, 10 Dec 2013 20:02:15 +0000 (UTC)
In-Reply-To: <bug-66821-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=66821

--- Comment #1 from Andreas Reis <andreas.reis@gmail.com> ---
Created attachment 118021
  --> https://bugzilla.kernel.org/attachment.cgi?id=118021&action=edit
dmesg output during progressing freeze, 2

Another freeze. This time it's:

proc_cwd_link+0x5d/0xd0
proc_pid_readlink+0x3f/0xe0
SyS_readlinkat+0xeb/0x130
SyS_readlink+0x1b/0x20
system_call_fastpath+0x1a/0x1f

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

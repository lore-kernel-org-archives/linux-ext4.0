From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 65701] oops: fs/ext4/ext4_jbd2.c
Date: Mon, 25 Nov 2013 09:38:07 +0000
Message-ID: <bug-65701-13602-10RNyYX6A2@https.bugzilla.kernel.org/>
References: <bug-65701-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38866 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab3KYJiV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Nov 2013 04:38:21 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7798A2024D
	for <linux-ext4@vger.kernel.org>; Mon, 25 Nov 2013 09:38:16 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 7174A20221
	for <linux-ext4@vger.kernel.org>; Mon, 25 Nov 2013 09:38:07 +0000 (UTC)
In-Reply-To: <bug-65701-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=65701

Dmitry Monakhov <dmonakhov@openvz.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dmonakhov@openvz.org

--- Comment #1 from Dmitry Monakhov <dmonakhov@openvz.org> ---
In fact this is not ext4's issue, this is generic fs issue.
pipe_write() do not accuire sb_start_write(), as far as I understand this is
because pipe should not touch fs's data. But it is not completely correct
because pipe want update file's time. Let's use same trick as we use in
touch_time()
pipe_write will call sb_start_write_try() and skip time update on frozen fs.
See proposed patch.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

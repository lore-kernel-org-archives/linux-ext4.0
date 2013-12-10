From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 66821] "BUG: soft lockup" in proc_fd_link, causing freeze
Date: Tue, 10 Dec 2013 20:11:06 +0000
Message-ID: <bug-66821-13602-WP1IIwUzOV@https.bugzilla.kernel.org/>
References: <bug-66821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38108 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab3LJULJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Dec 2013 15:11:09 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 035A520614
	for <linux-ext4@vger.kernel.org>; Tue, 10 Dec 2013 20:11:08 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 15EA720591
	for <linux-ext4@vger.kernel.org>; Tue, 10 Dec 2013 20:11:07 +0000 (UTC)
In-Reply-To: <bug-66821-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=66821

Andreas Reis <andreas.reis@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|ext4                        |Other
            Product|File System                 |Other

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

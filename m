From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 59801] kernel BUG at /kernel/fs/ext4/extents.c:1996!
Date: Mon, 17 Jun 2013 02:22:56 +0000 (UTC)
Message-ID: <20130617022256.3FEC911FB56@bugzilla.kernel.org>
References: <bug-59801-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36845 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846Ab3FQCW7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Jun 2013 22:22:59 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D74E52017C
	for <linux-ext4@vger.kernel.org>; Mon, 17 Jun 2013 02:22:58 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 428E62017E
	for <linux-ext4@vger.kernel.org>; Mon, 17 Jun 2013 02:22:56 +0000 (UTC)
In-Reply-To: <bug-59801-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=59801





--- Comment #1 from yyl810 <yang.yulin@zte.com.cn>  2013-06-17 02:22:55 ---
Created an attachment (id=104911)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=104911)
log

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 59801] kernel BUG at /kernel/fs/ext4/extents.c:1996!
Date: Mon, 17 Jun 2013 05:32:43 +0000 (UTC)
Message-ID: <20130617053243.273CC11FB51@bugzilla.kernel.org>
References: <bug-59801-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41162 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834Ab3FQFcp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Jun 2013 01:32:45 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B311120169
	for <linux-ext4@vger.kernel.org>; Mon, 17 Jun 2013 05:32:44 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 34EF72015C
	for <linux-ext4@vger.kernel.org>; Mon, 17 Jun 2013 05:32:43 +0000 (UTC)
In-Reply-To: <bug-59801-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=59801





--- Comment #3 from yyl810 <yang.yulin@zte.com.cn>  2013-06-17 05:32:42 ---
Thank you so much.
I was using 1.41.11, do you have e2fsprogs 1.42.7 bin file for ARM? if yes,
could you kindly share with me?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

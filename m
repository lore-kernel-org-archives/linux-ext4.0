From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51391] BUG: unable to handle kernel NULL pointer dereference
Date: Mon, 10 Dec 2012 08:23:04 +0000 (UTC)
Message-ID: <20121210082304.666A211FC70@bugzilla.kernel.org>
References: <bug-51391-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54880 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab2LJIXH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Dec 2012 03:23:07 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2C9CB201F8
	for <linux-ext4@vger.kernel.org>; Mon, 10 Dec 2012 08:23:06 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 8D034201D2
	for <linux-ext4@vger.kernel.org>; Mon, 10 Dec 2012 08:23:04 +0000 (UTC)
In-Reply-To: <bug-51391-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51391





--- Comment #9 from Karen <ktsirunyan@gmail.com>  2012-12-10 08:23:04 ---
I couldn't replicate the problem without Spruce yet, but still I am trying.

Also I want to notice that You are using 3.2.29 but my kernel is 3.2.0.-29.
I will try to send this problem to Canonical too.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

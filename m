From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51391] BUG: unable to handle kernel NULL pointer dereference
Date: Fri,  7 Dec 2012 16:25:32 +0000 (UTC)
Message-ID: <20121207162532.498DF11FB81@bugzilla.kernel.org>
References: <bug-51391-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50569 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422743Ab2LGQZi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Dec 2012 11:25:38 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 68E792033F
	for <linux-ext4@vger.kernel.org>; Fri,  7 Dec 2012 16:25:35 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 4DCD22030D
	for <linux-ext4@vger.kernel.org>; Fri,  7 Dec 2012 16:25:32 +0000 (UTC)
In-Reply-To: <bug-51391-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51391





--- Comment #2 from Karen <ktsirunyan@gmail.com>  2012-12-07 16:25:31 ---
Created an attachment (id=88611)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=88611)
kernel log file

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

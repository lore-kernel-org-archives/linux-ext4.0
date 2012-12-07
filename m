From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51391] BUG: unable to handle kernel NULL pointer dereference
Date: Fri,  7 Dec 2012 18:15:42 +0000 (UTC)
Message-ID: <20121207181542.0661F11FB80@bugzilla.kernel.org>
References: <bug-51391-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54198 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423669Ab2LGSPp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Dec 2012 13:15:45 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 02F7F20380
	for <linux-ext4@vger.kernel.org>; Fri,  7 Dec 2012 18:15:43 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 3143F20367
	for <linux-ext4@vger.kernel.org>; Fri,  7 Dec 2012 18:15:42 +0000 (UTC)
In-Reply-To: <bug-51391-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51391





--- Comment #7 from Karen <ktsirunyan@gmail.com>  2012-12-07 18:15:41 ---
I was using a base kernel which is coming with Ubuntu 12.04

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

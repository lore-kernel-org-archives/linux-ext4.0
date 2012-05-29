From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43305] Deleting a folder with 500 000 small files causes
 deadlock in start_this_handle.irsa.7
Date: Tue, 29 May 2012 15:38:48 +0000 (UTC)
Message-ID: <20120529153848.045C611FD19@bugzilla.kernel.org>
References: <bug-43305-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53177 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab2E2Piu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 May 2012 11:38:50 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B1466203B4
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2012 15:38:49 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 077482031F
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2012 15:38:48 +0000 (UTC)
In-Reply-To: <bug-43305-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43305





--- Comment #2 from Aigars Mahinovs <aigarius@gmail.com>  2012-05-29 15:38:47 ---
Created an attachment (id=73458)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=73458)
Kernel log after pressing SysRq+w twice during the lockup

Note that I first pressed the Sysrq+w on the keyboard and after that ran the
command to also execute it via /proc

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

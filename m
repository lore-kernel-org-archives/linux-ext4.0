From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61601] rootflags=noatime causes kernel panic when booting
 without initrd.
Date: Mon, 11 Aug 2014 04:17:44 +0000
Message-ID: <bug-61601-13602-VNI8kZB2Zp@https.bugzilla.kernel.org/>
References: <bug-61601-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39409 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbaHKERs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Aug 2014 00:17:48 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7BDAD201BC
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2014 04:17:47 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id BA0DD2015D
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2014 04:17:44 +0000 (UTC)
In-Reply-To: <bug-61601-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61601

--- Comment #9 from xerofoify@gmail.com ---
I need you to check if your system is running dual  initrd/ramload setup,
as the lines I am tracing to our ,
520         if (rd_doload==2) {
521             if (rd_load_disk(1)) {
522                 ROOT_DEV = Root_RAM1;
523                 root_device_name = NULL;
524             }
And you may be loading the wrong ram disk and this needs to be changed from 1
to 0.
Regards Nick

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

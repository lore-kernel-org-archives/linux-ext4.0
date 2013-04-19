From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 56831] RHEL Linux Data Corruption found with EXT4 system
Date: Fri, 19 Apr 2013 13:42:28 +0000 (UTC)
Message-ID: <20130419134228.0C03211FB51@bugzilla.kernel.org>
References: <bug-56831-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58718 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030356Ab3DSNmb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Apr 2013 09:42:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 23C1520674
	for <linux-ext4@vger.kernel.org>; Fri, 19 Apr 2013 13:42:30 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 0DF822067B
	for <linux-ext4@vger.kernel.org>; Fri, 19 Apr 2013 13:42:28 +0000 (UTC)
In-Reply-To: <bug-56831-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=56831





--- Comment #1 from searchfordave@gmail.com  2013-04-19 13:42:27 ---
Created an attachment (id=99321)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=99321)
File "random_multi_write_read.c" gives data corruption on ext4

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

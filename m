From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 100321] General protection fault (stalls the machine) with jbd2
 and raid456
Date: Mon, 22 Jun 2015 19:53:52 +0000
Message-ID: <bug-100321-13602-VK4B64azpJ@https.bugzilla.kernel.org/>
References: <bug-100321-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57731 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbbFVTxz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Jun 2015 15:53:55 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 273A3205E4
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2015 19:53:54 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 674D4205DB
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2015 19:53:52 +0000 (UTC)
In-Reply-To: <bug-100321-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=100321

--- Comment #1 from Jouni Karvo <jouni.karvo@iki.fi> ---
It seems that it is always /dev/mapper/xpcvg-home that is corrupted after a
crash.

I'll try to attach another crash log

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in

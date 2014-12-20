From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Sat, 20 Dec 2014 01:55:24 +0000
Message-ID: <bug-89511-13602-i2K1Z7rKYR@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51057 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbaLTBz1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Dec 2014 20:55:27 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DDDAF20176
	for <linux-ext4@vger.kernel.org>; Sat, 20 Dec 2014 01:55:26 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 6202920155
	for <linux-ext4@vger.kernel.org>; Sat, 20 Dec 2014 01:55:25 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #23 from Jun Itou <itou_jun@infoseek.jp> ---
I changed the environment of the test to latest kernel and carried it out.

root@sv-server:~# uname -a
Linux sv-server 3.18.1 #1 SMP Sat Dec 20 07:25:21 JST 2014 x86_64 GNU/Linux
r

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

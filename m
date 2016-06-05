From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Sun, 05 Jun 2016 01:46:13 +0000
Message-ID: <bug-118401-13602-FBYeRbquOb@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43219 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbcFEBqR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Jun 2016 21:46:17 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D77D5201D3
	for <linux-ext4@vger.kernel.org>; Sun,  5 Jun 2016 01:46:15 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id DAB1B201C0
	for <linux-ext4@vger.kernel.org>; Sun,  5 Jun 2016 01:46:13 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

--- Comment #25 from Navin <navinp1912@gmail.com> ---
yes grep -i ahci /proc/modules would work . Running modprobe ahci should be
fine . Then again grep -i ahci /proc/modules .
dmesg | tail  should show the last 10 lines and any error.

If an error is thrown it should shown by the dmesg | tail.
If it says successful and loaded.Atleast from your phone screenshots it appears
that the failure is in this part.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

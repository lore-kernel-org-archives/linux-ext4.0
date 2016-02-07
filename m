From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111961] ext4 umount - invalid opcode with PLEXTOR
 PX-128M6G-2242
Date: Sun, 07 Feb 2016 09:14:25 +0000
Message-ID: <bug-111961-13602-7MmwZUggub@https.bugzilla.kernel.org/>
References: <bug-111961-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57101 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbcBGJO3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Feb 2016 04:14:29 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 43C442021B
	for <linux-ext4@vger.kernel.org>; Sun,  7 Feb 2016 09:14:28 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E24AB2022A
	for <linux-ext4@vger.kernel.org>; Sun,  7 Feb 2016 09:14:25 +0000 (UTC)
In-Reply-To: <bug-111961-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=111961

--- Comment #7 from Sebastian <info@dynpages.de> ---
Thanks for the warning, but thankfully I've got no important data on that
device and everything backed up. After the issue occurred I recovered my home
partition manually from systemd recovery shell. I've disabled acpi for the SATA
controller - maybe that's causing the problem. I'll keep an eye on the logs,
though. I attach the full journal.

thank you very much for looking into this!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

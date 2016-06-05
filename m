From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Sun, 05 Jun 2016 12:21:09 +0000
Message-ID: <bug-118401-13602-cVU8mb6wNf@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53581 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbcFEMVQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jun 2016 08:21:16 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 927B5200E9
	for <linux-ext4@vger.kernel.org>; Sun,  5 Jun 2016 12:21:14 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 3D07B2017D
	for <linux-ext4@vger.kernel.org>; Sun,  5 Jun 2016 12:21:10 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

--- Comment #28 from Navin <navinp1912@gmail.com> ---
I get a similar error about ahci "used by field" as 0 only in Virtual Machines
like qemu . I assume yours is on bare hardware. Maybe bios mode is set to IDE
that is why AHCI is not detected. If you change from IDE to AHCI does it work ?

If it still doesn't work

Well can you take the latest 4.7 and if that also doesn't work you should
contact 

 ahci.c - AHCI SATA support
 Maintained by:  Tejun Heo <tj@kernel.org>
 Please ALWAYS copy linux-ide@vger.kernel.org on emails.

saying you have the latest 4.7 mainline . I guess the issue could be easily
resolved by the authors.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

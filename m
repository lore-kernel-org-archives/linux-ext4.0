From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Thu, 02 Jun 2016 18:19:36 +0000
Message-ID: <bug-118401-13602-mnltGAoBFy@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38842 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932392AbcFBSTl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jun 2016 14:19:41 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 44F542026C
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jun 2016 18:19:39 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 553102027D
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jun 2016 18:19:37 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

--- Comment #16 from Navin <navinp1912@gmail.com> ---
If the ahci part fails ie dmesg | grep -i ahci produces no output, then you
need to include in /etc/initramfs-tools/modules
ahci
libahci

and then run update-initramfs -u

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

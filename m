From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Sat, 04 Jun 2016 13:45:15 +0000
Message-ID: <bug-118401-13602-Po7WnQkevD@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55003 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbcFDNpT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Jun 2016 09:45:19 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5329A20219
	for <linux-ext4@vger.kernel.org>; Sat,  4 Jun 2016 13:45:18 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 0656B2021F
	for <linux-ext4@vger.kernel.org>; Sat,  4 Jun 2016 13:45:16 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

--- Comment #23 from Navin <navinp1912@gmail.com> ---
1) First is 

Why does these lines get printed in 4.2
[    0.716610] ahci 0000:00:1f.2: version 3.0
[    0.716620] ahci 0000:00:1f.2: can't find IRQ for PCI INT B; probably buggy
MP table

where as in 4.4 and 4.6 you don't get to see even the "version 3.0".

In your initramfs shell , you should try to see if ahci is actually loaded in
/proc/modules


2)

One more thing is i see in 4.2 you have this in dmesg
libata version 3.00 loaded.

I hope in 4.6 also you get that message.

You can find it out in your initramfs scripts by doing dmesg | grep -i libata


That should tell you that your modules are not loaded/good because of some
changes or some other reason like corruption?

At the end of initramfs you can do modprobe ahci and see that it prints
lsmod | grep ahci


That should tell you the reason why it is not printing those messages in dmesg.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

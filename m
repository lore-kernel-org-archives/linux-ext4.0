From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Sat, 04 Jun 2016 06:28:04 +0000
Message-ID: <bug-118401-13602-mEy9tVmvOc@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47149 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbcFDG2K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Jun 2016 02:28:10 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 81EEF201B9
	for <linux-ext4@vger.kernel.org>; Sat,  4 Jun 2016 06:28:07 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 2B4F02021A
	for <linux-ext4@vger.kernel.org>; Sat,  4 Jun 2016 06:28:05 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

--- Comment #21 from Navin <navinp1912@gmail.com> ---
Can youou have ahci modules present in your initramfs ?

Mine returns like 
1) lsinitramfs  /boot/initrd.img-4.7.0-rc1+  | grep -i ahci

lib/modules/4.7.0-rc1+/kernel/drivers/ata/ahci_platform.ko
lib/modules/4.7.0-rc1+/kernel/drivers/ata/ahci.ko
lib/modules/4.7.0-rc1+/kernel/drivers/ata/libahci.ko
lib/modules/4.7.0-rc1+/kernel/drivers/ata/libahci_platform.ko
lib/modules/4.7.0-rc1+/kernel/drivers/ata/acard-ahci.ko

2) If the above returns that it is present and loaded confirmed by grep -i ahci
/proc/modules from your initramfs

 grep -i ahci /proc/modules 
ahci 36864 2 - Live 0xffffffffc0044000
libahci 32768 1 ahci, Live 0xffffffffc0015000

If  (1) and (2) work as expected like described ie they are loaded and present.

Please post the output of (1) and (2) what it returns in your case.

3)
Then maybe something related to irq like described in 

https://bugzilla.kernel.org/show_bug.cgi?id=111211

where comment 7 says "It works with 'pci=routeirq' parameter" in kernel command
line.

I asked for this because your 4.2 dmesg showed something like 

[    0.716610] ahci 0000:00:1f.2: version 3.0
[    0.716620] ahci 0000:00:1f.2: can't find IRQ for PCI INT B; probably buggy
MP table

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

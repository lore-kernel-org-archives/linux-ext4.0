From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Sat, 04 Jun 2016 09:36:26 +0000
Message-ID: <bug-118401-13602-ObOAwm7t8i@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50513 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbcFDJgb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Jun 2016 05:36:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F02892021F
	for <linux-ext4@vger.kernel.org>; Sat,  4 Jun 2016 09:36:29 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 43C502021A
	for <linux-ext4@vger.kernel.org>; Sat,  4 Jun 2016 09:36:27 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

--- Comment #22 from Kevin Brubeck Unhammer <unhammer+dill@mm.st> ---
re: 1) 

$ lsinitramfs /boot/initrd.img-4.4.0-22-generic |grep -i ahci
lib/modules/4.4.0-22-generic/kernel/drivers/ata/ahci.ko
lib/modules/4.4.0-22-generic/kernel/drivers/ata/libahci.ko
lib/modules/4.4.0-22-generic/kernel/drivers/ata/acard-ahci.ko
lib/modules/4.4.0-22-generic/kernel/drivers/ata/libahci_platform.ko
lib/modules/4.4.0-22-generic/kernel/drivers/ata/ahci_platform.ko

$ lsinitramfs /boot/initrd.img-4.6.0-040600rc6-generic |grep -i ahci
lib/modules/4.6.0-040600rc6-generic/kernel/drivers/ata/ahci.ko
lib/modules/4.6.0-040600rc6-generic/kernel/drivers/ata/libahci.ko
lib/modules/4.6.0-040600rc6-generic/kernel/drivers/ata/acard-ahci.ko
lib/modules/4.6.0-040600rc6-generic/kernel/drivers/ata/libahci_platform.ko
lib/modules/4.6.0-040600rc6-generic/kernel/drivers/ata/ahci_platform.ko

$ lsinitramfs /boot/initrd.img-4.2.8-040208-generic |grep -i ahci
lib/modules/4.2.8-040208-generic/kernel/drivers/ata/ahci.ko
lib/modules/4.2.8-040208-generic/kernel/drivers/ata/libahci.ko
lib/modules/4.2.8-040208-generic/kernel/drivers/ata/acard-ahci.ko
lib/modules/4.2.8-040208-generic/kernel/drivers/ata/libahci_platform.ko
lib/modules/4.2.8-040208-generic/kernel/drivers/ata/ahci_platform.ko

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

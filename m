From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Sun, 05 Jun 2016 13:43:45 +0000
Message-ID: <bug-118401-13602-LOJgeyumO4@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54862 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbcFENnt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jun 2016 09:43:49 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4F51B201BC
	for <linux-ext4@vger.kernel.org>; Sun,  5 Jun 2016 13:43:48 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B30F72017D
	for <linux-ext4@vger.kernel.org>; Sun,  5 Jun 2016 13:43:46 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

--- Comment #29 from Kevin Brubeck Unhammer <unhammer+dill@mm.st> ---
Created attachment 219091
  --> https://bugzilla.kernel.org/attachment.cgi?id=219091&action=edit
BIOS showing AHCI mode

and when 4.2.0 is booted I get


$ lspci |grep -i sata
00:1f.2 SATA controller: Intel Corporation 8 Series SATA Controller 1 [AHCI
mode] (rev 04)

$ dmesg |grep ahci
[    0.719414] ahci 0000:00:1f.2: version 3.0
[    0.719425] ahci 0000:00:1f.2: can't find IRQ for PCI INT B; probably buggy
MP table
[    0.735712] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 6 Gbps 0x1
impl SATA mode
[    0.737592] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo only pio slum
part deso sadm sds apst 
[    0.739623] scsi host0: ahci
[    0.745463] scsi host1: ahci
[    0.747706] scsi host2: ahci
[    0.749662] scsi host3: ahci


so I'll try 4.7

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

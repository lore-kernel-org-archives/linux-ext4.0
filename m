From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Wed, 01 Jun 2016 21:50:35 +0000
Message-ID: <bug-118401-13602-t4zeBy22dq@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55633 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbcFAVuk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Jun 2016 17:50:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 310F620384
	for <linux-ext4@vger.kernel.org>; Wed,  1 Jun 2016 21:50:39 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 104EA2038F
	for <linux-ext4@vger.kernel.org>; Wed,  1 Jun 2016 21:50:37 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

--- Comment #13 from Navin <navinp1912@gmail.com> ---
Your block devices are not being detected due to some problem. Maybe the driver
for it is not getting loaded.

Can you post the complete dmesg from 4.2 working ?

In the initramfs pre mount scripts 

Instead of dmesg | grep -i blocks

you can add

dmesg | grep -i achi
dmesg | grep -i scsi
dmesg | grep -i sata
dmesg | grep -i  ata[0-4]
cat /proc/scsi/scsi

The below device is missing  in your 4.6 .

Below is your 4.2 

[7.6.] SCSI information (from /proc/scsi/scsi)

(from running 4.2)

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST1000LM014-1EJ1 Rev: LIV6
  Type:   Direct-Access                    ANSI  SCSI revision: 05

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

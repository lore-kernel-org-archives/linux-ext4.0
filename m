From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Mon, 06 Jun 2016 07:27:01 +0000
Message-ID: <bug-118401-13602-QgPwIRc87C@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55539 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbcFFH1G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jun 2016 03:27:06 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CFA1F200EC
	for <linux-ext4@vger.kernel.org>; Mon,  6 Jun 2016 07:27:04 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C4AE220122
	for <linux-ext4@vger.kernel.org>; Mon,  6 Jun 2016 07:27:02 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

--- Comment #30 from Kevin Brubeck Unhammer <unhammer+dill@mm.st> ---
Created attachment 219181
  --> https://bugzilla.kernel.org/attachment.cgi?id=219181&action=edit
phone-image initramfs 4.7

This was without ahci/libahci in /etc/initramfs-tools/modules. Doesn't seem too
different from attachemnt 219081 except that /proc/scsi/scsi doesn't exist
(though maybe it's created after modprobing; haven't tried 4.7 with
ahci/libahci in /etc/initramfs-tools/modules yet).

Thanks so much for your help Navin; getting in touch with the ide/ahci list
now.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

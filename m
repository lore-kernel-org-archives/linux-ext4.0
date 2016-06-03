From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Fri, 03 Jun 2016 19:04:42 +0000
Message-ID: <bug-118401-13602-A7DsKDP9oN@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55030 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932684AbcFCTEr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jun 2016 15:04:47 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E51A620259
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jun 2016 19:04:45 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 08DC520274
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jun 2016 19:04:43 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

--- Comment #18 from Kevin Brubeck Unhammer <unhammer+dill@mm.st> ---
Created attachment 218861
  --> https://bugzilla.kernel.org/attachment.cgi?id=218861&action=edit
phone-image of initramfs-script w/ahci, scsi dmesg's, 4.4 signed

Same script/modules as attachment 218851, on
linux-signed-image-4.4.0-22-generic from Ubuntu repos (so signing/secureboot
seems irrelevant?)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

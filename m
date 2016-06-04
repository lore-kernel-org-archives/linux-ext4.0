From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Sat, 04 Jun 2016 22:05:49 +0000
Message-ID: <bug-118401-13602-B2lgLPqxLD@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40340 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbcFDWFz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Jun 2016 18:05:55 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 61E402011E
	for <linux-ext4@vger.kernel.org>; Sat,  4 Jun 2016 22:05:53 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 9C4AC201F2
	for <linux-ext4@vger.kernel.org>; Sat,  4 Jun 2016 22:05:50 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

--- Comment #24 from Kevin Brubeck Unhammer <unhammer+dill@mm.st> ---
Created attachment 219041
  --> https://bugzilla.kernel.org/attachment.cgi?id=219041&action=edit
phone-image of initramfs-script w/libata dmesg's, modprobe ahci, 4.6

It's the same for 4.4, and appending pci=routeirq had no effect :(

What command can I use instead of lsmod after the modprobe? (is grep -i ahci
/proc/modules equivalent? does initramfs modprobe accept --verbose?)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

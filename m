From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Sun, 05 Jun 2016 11:12:08 +0000
Message-ID: <bug-118401-13602-afmmh1EB80@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52751 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbcFELMN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jun 2016 07:12:13 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5B936201CD
	for <linux-ext4@vger.kernel.org>; Sun,  5 Jun 2016 11:12:11 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C8BCE201B9
	for <linux-ext4@vger.kernel.org>; Sun,  5 Jun 2016 11:12:09 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

--- Comment #26 from Kevin Brubeck Unhammer <unhammer+dill@mm.st> ---
Created attachment 219071
  --> https://bugzilla.kernel.org/attachment.cgi?id=219071&action=edit
phone-image initramfs "grep ahci /proc/modules" 4.6 where ahci in etc modules

Here I had ahci and libahci in /etc/initramfs-tools/modules, and 4.6 prints the
same from "grep ahci /proc/modules" before and after the modprobe (and still
not booting). Nothing interesting I can see from dmesg|tail.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

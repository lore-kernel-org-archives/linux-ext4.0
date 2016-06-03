From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Fri, 03 Jun 2016 19:07:12 +0000
Message-ID: <bug-118401-13602-Fl5nE7xhT6@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55089 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964778AbcFCTHS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jun 2016 15:07:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6F77620272
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jun 2016 19:07:16 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 6E3B520274
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jun 2016 19:07:13 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

--- Comment #19 from Kevin Brubeck Unhammer <unhammer+dill@mm.st> ---
Created attachment 218871
  --> https://bugzilla.kernel.org/attachment.cgi?id=218871&action=edit
phone-image of initramfs-script w/ahci, scsi dmesg's, 4.2.8 (the working one)

Snatched an image as the text flew by in one of the working kernels, just for
comparison. (The 4.2.0 I got through regular Ubuntu signed repos, but this
4.2.8 was from http://kernel.ubuntu.com/~kernel-ppa/mainline/ and has no
corresponding "linux-signed-image".)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

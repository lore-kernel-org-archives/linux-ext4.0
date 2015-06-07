From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Sun, 07 Jun 2015 10:22:22 +0000
Message-ID: <bug-89511-13602-IxFzIxiNFV@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53892 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbbFGKWd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Jun 2015 06:22:33 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F1E36205E6
	for <linux-ext4@vger.kernel.org>; Sun,  7 Jun 2015 10:22:30 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 369E8205C2
	for <linux-ext4@vger.kernel.org>; Sun,  7 Jun 2015 10:22:29 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #52 from Markus Rathgeb <maggu2810@gmail.com> ---
> This is up to the SCSI developers.

So, could we CC someone?

So, if we keep the current situation everyone who ones such a buggy hardware
have the following options (IMHO):
1. create a udev rule, that sets "write through" for this hardware
2. using non-journal filesystems only
3. do not use this hardware anymore

But I think all that options are not good ones.

The udev rule will work on my machines then, but a USB drive is designed to be
mobile. And a mobile storage will be used on other machines, too, without
change some system stuff on that (missing permissions, ...).

I could understand if someone states that the hardware is buggy and there is
nothing to do. But I think this does not fit to the Linux Kernel. The kernel is
filled with a lot workarounds for hardware / implementations that is not
correct.

Could someone contact a SCSI developer, perhaps that stuff could comment their
ideas (e.g. for "if SYNCHRONIZE CACHE command is not working, fallback to write
through" and "what should happen when a drive really does have a write cache
but doesn't recognize the SYNCHRONIZE CACHE command").

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

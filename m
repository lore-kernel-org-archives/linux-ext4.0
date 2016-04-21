From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 113781] kernel 4.4.1-2-ARCH, 4.4.3-1-ARCH and Fake RAID array
 setup
Date: Thu, 21 Apr 2016 20:06:57 +0000
Message-ID: <bug-113781-13602-D3dGZ3uIkh@https.bugzilla.kernel.org/>
References: <bug-113781-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58878 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbcDUUHA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Apr 2016 16:07:00 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 535BE2034C
	for <linux-ext4@vger.kernel.org>; Thu, 21 Apr 2016 20:06:59 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 79CC820256
	for <linux-ext4@vger.kernel.org>; Thu, 21 Apr 2016 20:06:57 +0000 (UTC)
In-Reply-To: <bug-113781-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=113781

--- Comment #2 from Andre Hasekamp <hasecomp@aim.com> ---
2016-04-21

Archlinux is now at:

Kernel 4.5.1-1
dmraid 1.0.0.rc16.3-10
device-mapper 2.02.149-1
thin-provisioning-tools 0.6.1-2

At this stage, I can run a linux system again from "Fake RAID array" disks
(RAID 0) on PC 1 (decribed above).

Although it is not clear what caused it, to me it is so much improvement that I
will use "Fake RAID array" disks again. Neverthless, in the meantime, after
having encountered the problems described, I have moved my production work to
Archlinux installations on SSD. At the moment I have 2 PCs, each with a
functioning linux test system on "Fake RAID array" disks. These test systems
are not frequently used. So it may take a while before I consider these test
systems to be reliable enough for production work.

>From my point of view, you may close this bug. Should the "Fake RAID array"
disks present problems again in the future, then I will open a new bugreport.

Since the status of the current bug report is still NEW, I trust that you have
not spent any time on it yet.

Kind regards,
Andre Hasekamp.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

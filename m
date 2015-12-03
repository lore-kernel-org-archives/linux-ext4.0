From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Thu, 03 Dec 2015 23:25:30 +0000
Message-ID: <bug-89511-13602-Ycfm1sVMys@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60970 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbbLCXZf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Dec 2015 18:25:35 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BE3D12056C
	for <linux-ext4@vger.kernel.org>; Thu,  3 Dec 2015 23:25:34 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C1CCB205BC
	for <linux-ext4@vger.kernel.org>; Thu,  3 Dec 2015 23:25:31 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

Christian Kujau <lists@nerdbynature.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lists@nerdbynature.de

--- Comment #70 from Christian Kujau <lists@nerdbynature.de> ---
@bradhaack: "sudo echo ... > /sys/..." won't work, as the ">" redirection
doesn't run as root, but as your own shell, Try "echo ... | sudo tee /sys/..."
instead. Also, lsattr/chattr is for ext2/3/4 file systems, not for sysfs.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

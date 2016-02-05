From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111961] ext4 umount - invalid opcode with PLEXTOR
 PX-128M6G-2242
Date: Fri, 05 Feb 2016 23:09:52 +0000
Message-ID: <bug-111961-13602-n9cW1R47KG@https.bugzilla.kernel.org/>
References: <bug-111961-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48338 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbcBEXJz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Feb 2016 18:09:55 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3BA26203E6
	for <linux-ext4@vger.kernel.org>; Fri,  5 Feb 2016 23:09:54 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B12E8203B8
	for <linux-ext4@vger.kernel.org>; Fri,  5 Feb 2016 23:09:52 +0000 (UTC)
In-Reply-To: <bug-111961-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=111961

--- Comment #3 from Sebastian <info@dynpages.de> ---
Thank you very much for the fast response! dmesg output from current boot
doesn't include any ext4 message. I don't have a syslog daemon running, but I
grepped for fsck and ext4 on journald, hoping that helps.

The problem just occurred once - after manual recovering from systemd recovery
shell the system boots fine again . I'll check on the logs and will provide
more information in case anything fails again. If you miss something or if I
can help you there get back to me anytime.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

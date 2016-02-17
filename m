From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112631] Cannot open encrypted Luks root filesystem
Date: Wed, 17 Feb 2016 20:10:18 +0000
Message-ID: <bug-112631-13602-PePkS9W8N5@https.bugzilla.kernel.org/>
References: <bug-112631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44660 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030237AbcBQUKT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Feb 2016 15:10:19 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 032EE203C0
	for <linux-ext4@vger.kernel.org>; Wed, 17 Feb 2016 20:10:19 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 3EDBD203AB
	for <linux-ext4@vger.kernel.org>; Wed, 17 Feb 2016 20:10:18 +0000 (UTC)
In-Reply-To: <bug-112631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=112631

--- Comment #1 from alex.theoto <alex.theoto@gmail.com> ---
I cannot boot my system.
The root is encrypted with Luks and after booting and enter my password I get
the following error:

    Check that kernel supports aes-xts-plain64 cipher (check syslog for more
info)

and prompts me again the password.

Downgrading into 4.1.17, cryptsetup works fine.

Distro: ArchLinux

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112631] Cannot open encrypted Luks root filesystem
Date: Sun, 21 Feb 2016 14:23:00 +0000
Message-ID: <bug-112631-13602-33DrNVpqIG@https.bugzilla.kernel.org/>
References: <bug-112631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55780 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbcBUSBj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Feb 2016 13:01:39 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A624520443
	for <linux-ext4@vger.kernel.org>; Sun, 21 Feb 2016 14:23:03 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id AB6E3203B5
	for <linux-ext4@vger.kernel.org>; Sun, 21 Feb 2016 14:23:00 +0000 (UTC)
In-Reply-To: <bug-112631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=112631

--- Comment #9 from Henrique de Moraes Holschuh <hmh@hmh.eng.br> ---
It looks like the kernel change actually requires a newer version of cryptsetup
to work.

cryptsetup 1.6.6 (in Debian stable, for example) is broken (at least on
3.18.27).
cryptsetup 1.7.0 has fixes for this, apparently.

Looks like the change in Linux needs a KCONFIG guard (default?), that distros
can change after they get updated userspace...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

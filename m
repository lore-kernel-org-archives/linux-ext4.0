From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112631] Cannot open encrypted Luks filesystem. Cruptsetup
 error.
Date: Tue, 23 Feb 2016 19:41:31 +0000
Message-ID: <bug-112631-13602-R8BYXBFKxb@https.bugzilla.kernel.org/>
References: <bug-112631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41196 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318AbcBWTlf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Feb 2016 14:41:35 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9CB5720383
	for <linux-ext4@vger.kernel.org>; Tue, 23 Feb 2016 19:41:33 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id CEA5D2034A
	for <linux-ext4@vger.kernel.org>; Tue, 23 Feb 2016 19:41:31 +0000 (UTC)
In-Reply-To: <bug-112631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=112631

--- Comment #17 from Karl Sponser <karl.sponser@web.de> ---
Even if there is an update of cryptsetup available in Arch Linux, other distros
doesn't plan to update. E. g. Fedora 23 is on 1.6.8 and I don't know if they
will move to a newer version before F24, because they don't ship kernel 4.1.18
(I'm affected because I the RPI kernel on Fedora, because the one they ship
doesn't support an RPI).

So a workaround/fix for users whose distros won't/can't update cryptsetup is
still desirable.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

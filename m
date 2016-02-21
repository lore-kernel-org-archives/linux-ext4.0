From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112631] Cannot open encrypted Luks root filesystem
Date: Sun, 21 Feb 2016 12:00:27 +0000
Message-ID: <bug-112631-13602-fH8hrFU71D@https.bugzilla.kernel.org/>
References: <bug-112631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55506 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbcBUR4j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Feb 2016 12:56:39 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D9CBB2041A
	for <linux-ext4@vger.kernel.org>; Sun, 21 Feb 2016 12:00:30 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B45822041F
	for <linux-ext4@vger.kernel.org>; Sun, 21 Feb 2016 12:00:27 +0000 (UTC)
In-Reply-To: <bug-112631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=112631

--- Comment #6 from Henrique de Moraes Holschuh <hmh@hmh.eng.br> ---
Meh, cannot fix the bug metadata.  Someone with appropriate ACLs (maybe the bug
submitter?), please fix:

Regression: yes
Kernel versions affected: 3.10.97, 3.14.61, 3.18.27, 4.1.18, 4.3.6, 4.4.2.

It is assigned to the wrong subsystem (ext4 has nothing to do with this).

Remove "root" from bug title, it breaks any attempt to use cryptsetup.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

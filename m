From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112631] Cannot open encrypted Luks filesystem. Cruptsetup
 error.
Date: Sun, 21 Feb 2016 16:19:19 +0000
Message-ID: <bug-112631-13602-iH5HMII87q@https.bugzilla.kernel.org/>
References: <bug-112631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53945 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbcBURgj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Feb 2016 12:36:39 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 685C120412
	for <linux-ext4@vger.kernel.org>; Sun, 21 Feb 2016 16:19:20 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 983FE203DA
	for <linux-ext4@vger.kernel.org>; Sun, 21 Feb 2016 16:19:19 +0000 (UTC)
In-Reply-To: <bug-112631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=112631

--- Comment #11 from alex.theoto <alex.theoto@gmail.com> ---
(In reply to Henrique de Moraes Holschuh from comment #6)
> Meh, cannot fix the bug metadata.  Someone with appropriate ACLs (maybe the
> bug submitter?), please fix:
> 
> Regression: yes
> Kernel versions affected: 3.10.97, 3.14.61, 3.18.27, 4.1.18, 4.3.6, 4.4.2.
> 
> It is assigned to the wrong subsystem (ext4 has nothing to do with this).
> 
> Remove "root" from bug title, it breaks any attempt to use cryptsetup.

Thank you. I'm new here. If there is something wrong, please tell me again.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

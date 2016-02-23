From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112631] Cannot open encrypted Luks filesystem. Cruptsetup
 error.
Date: Tue, 23 Feb 2016 20:52:11 +0000
Message-ID: <bug-112631-13602-CG061UOxzn@https.bugzilla.kernel.org/>
References: <bug-112631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45336 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051AbcBWUwQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Feb 2016 15:52:16 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 382AC20364
	for <linux-ext4@vger.kernel.org>; Tue, 23 Feb 2016 20:52:14 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id BE279202FF
	for <linux-ext4@vger.kernel.org>; Tue, 23 Feb 2016 20:52:12 +0000 (UTC)
In-Reply-To: <bug-112631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=112631

Milan Broz <gmazyland@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |gmazyland@gmail.com

--- Comment #19 from Milan Broz <gmazyland@gmail.com> ---
It is kernel bug and it should be fixed in kernel.
Or there is a new rule to break API and userspace in stable kernels?

See http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg17926.html

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

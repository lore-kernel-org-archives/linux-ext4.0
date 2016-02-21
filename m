From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112631] Cannot open encrypted Luks filesystem. Cruptsetup
 error.
Date: Sun, 21 Feb 2016 21:27:37 +0000
Message-ID: <bug-112631-13602-VPkcPEFD9g@https.bugzilla.kernel.org/>
References: <bug-112631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34176 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbcBUV1m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Feb 2016 16:27:42 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 115C92040F
	for <linux-ext4@vger.kernel.org>; Sun, 21 Feb 2016 21:27:41 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 615D3203DA
	for <linux-ext4@vger.kernel.org>; Sun, 21 Feb 2016 21:27:38 +0000 (UTC)
In-Reply-To: <bug-112631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=112631

--- Comment #14 from Henrique de Moraes Holschuh <hmh@hmh.eng.br> ---
While reporting the issue to Debian, I've been contacted by Milan Broz with
updated information.

http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg17926.html

kernels 4.4.2 and 4.3.6 have a compatibility path that makes them work with old
cryptsetup.

The two patches implementing that compatibility path are missing from the other
kernels, and will require backporting.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

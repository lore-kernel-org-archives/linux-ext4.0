From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112631] Cannot open encrypted Luks root filesystem
Date: Sun, 21 Feb 2016 12:55:56 +0000
Message-ID: <bug-112631-13602-rEHPnfQxG0@https.bugzilla.kernel.org/>
References: <bug-112631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54343 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbcBURlj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Feb 2016 12:41:39 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BD0F320453
	for <linux-ext4@vger.kernel.org>; Sun, 21 Feb 2016 12:55:58 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 221C520426
	for <linux-ext4@vger.kernel.org>; Sun, 21 Feb 2016 12:55:57 +0000 (UTC)
In-Reply-To: <bug-112631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=112631

--- Comment #8 from Andreas Amann <andreas.amann@gmx.de> ---
Also just tested 4.4.2 and unlocking works. Apparently the original patch
c840ac6af3f8713a71b4d2363419145760bd6044 is correct for newer kernels (since
4.3?), but fails for older ones.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Thu, 02 Jun 2016 12:52:26 +0000
Message-ID: <bug-118401-13602-m3dwi01sHy@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38360 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbcFBMwb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jun 2016 08:52:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 926A02038D
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jun 2016 12:52:29 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B0E6D203AC
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jun 2016 12:52:26 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

--- Comment #15 from Navin <navinp1912@gmail.com> ---
Your 4.2 is a signed kernel where as the other two aren't (4.6 and 4.4). I hope
secureboot is disabled in bios already. If not please try that also.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

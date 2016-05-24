From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Tue, 24 May 2016 17:46:34 +0000
Message-ID: <bug-118401-13602-GdMOCZzrs5@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52257 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbcEXRqj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2016 13:46:39 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9F6192034F
	for <linux-ext4@vger.kernel.org>; Tue, 24 May 2016 17:46:37 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D2B7520381
	for <linux-ext4@vger.kernel.org>; Tue, 24 May 2016 17:46:34 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

--- Comment #8 from Navin <navinp1912@gmail.com> ---
Thanks for the information and looks like it has nothing to do with code,
atleast i could simulate the ALERT UUID= with a wrong hex char in kernel
command line  root=UUID and i get the same error. 

Also OP already tried with  CONFIG_EXT4_USE_FOR_EXT2 and it doesn't work for
him as per the diff in this .configs.

output of command blkid  from the initramfs shell would definitely help in
figuring out more about this problem.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

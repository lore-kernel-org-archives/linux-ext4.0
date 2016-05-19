From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Thu, 19 May 2016 08:42:24 +0000
Message-ID: <bug-118401-13602-WK2FVW640m@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40297 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbcESIm2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 May 2016 04:42:28 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6FF1820225
	for <linux-ext4@vger.kernel.org>; Thu, 19 May 2016 08:42:27 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 5D61D20219
	for <linux-ext4@vger.kernel.org>; Thu, 19 May 2016 08:42:25 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

--- Comment #3 from Kevin Brubeck Unhammer <unhammer+dill@mm.st> ---
Created attachment 216691
  --> https://bugzilla.kernel.org/attachment.cgi?id=216691&action=edit
kernel config 4.6.0-040600rc6-generic

kernel config of highest tested (not-booting) kernel version

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

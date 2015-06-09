From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Tue, 09 Jun 2015 20:40:33 +0000
Message-ID: <bug-89511-13602-VvnePeNA11@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58650 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171AbbFIUki (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2015 16:40:38 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8C10120567
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2015 20:40:37 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 133F720555
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2015 20:40:35 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #55 from Alan Stern <stern@rowland.harvard.edu> ---
Created attachment 179321
  --> https://bugzilla.kernel.org/attachment.cgi?id=179321&action=edit
Add NO_SYNCHRONIZE_CACHE flag for usb-storage

This patch will do what Alan suggested.  Isaka and Markus didn't provide the
"lsusb -v" output for their devices, so I couldn't include them in the patch. 
However, it should fix the problem for Jun Itou.

Please let me know if it works.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

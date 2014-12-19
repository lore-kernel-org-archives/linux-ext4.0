From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Fri, 19 Dec 2014 21:19:10 +0000
Message-ID: <bug-89511-13602-J8LztiqGzr@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43227 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbaLSVTO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Dec 2014 16:19:14 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8C67F20145
	for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2014 21:19:13 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 57FC62013D
	for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2014 21:19:11 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #18 from Jun Itou <itou_jun@infoseek.jp> ---
Created attachment 161371
  --> https://bugzilla.kernel.org/attachment.cgi?id=161371&action=edit
cat /sys/kernel/debug/usb/devices > devices.txt

I tried it according to instructions again.

cat /sys/kernel/debug/usb/devices > devices.txt

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

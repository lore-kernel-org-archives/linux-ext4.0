From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Fri, 19 Dec 2014 21:15:54 +0000
Message-ID: <bug-89511-13602-xgJU6ZdyS3@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43023 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbaLSVP6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Dec 2014 16:15:58 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6A34B20160
	for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2014 21:15:56 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D8EC320145
	for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2014 21:15:54 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #16 from Jun Itou <itou_jun@infoseek.jp> ---
Created attachment 161351
  --> https://bugzilla.kernel.org/attachment.cgi?id=161351&action=edit
cat /sys/kernel/debug/usb/usbmon/2u > mon.txt

I tried it according to instructions again.

cat /sys/kernel/debug/usb/usbmon/2u > mon.txt

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

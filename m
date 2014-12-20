From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Sat, 20 Dec 2014 01:50:00 +0000
Message-ID: <bug-89511-13602-u6S1X0BjmV@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50907 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbaLTBuF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Dec 2014 20:50:05 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4C34A20155
	for <linux-ext4@vger.kernel.org>; Sat, 20 Dec 2014 01:50:04 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 9DA022015A
	for <linux-ext4@vger.kernel.org>; Sat, 20 Dec 2014 01:50:00 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #21 from Jun Itou <itou_jun@infoseek.jp> ---
Created attachment 161451
  --> https://bugzilla.kernel.org/attachment.cgi?id=161451&action=edit
dmesg > log.txt

I gave following tests.

echo 'temporary write through' >/sys/block/sdb/device/scsi_disk/*/cache_type
echo 'write through' >/sys/block/sdb/device/scsi_disk/*/cache_type

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

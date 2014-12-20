From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Sat, 20 Dec 2014 01:50:41 +0000
Message-ID: <bug-89511-13602-9rcpVBitcO@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50951 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaLTBuo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Dec 2014 20:50:44 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 181AB20173
	for <linux-ext4@vger.kernel.org>; Sat, 20 Dec 2014 01:50:43 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B26FB20158
	for <linux-ext4@vger.kernel.org>; Sat, 20 Dec 2014 01:50:41 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #22 from Jun Itou <itou_jun@infoseek.jp> ---
Created attachment 161461
  --> https://bugzilla.kernel.org/attachment.cgi?id=161461&action=edit
cat /sys/kernel/debug/usb/usbmon/2u > mon.txt

I gave following tests.

echo 'temporary write through' >/sys/block/sdb/device/scsi_disk/*/cache_type
echo 'write through' >/sys/block/sdb/device/scsi_disk/*/cache_type

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

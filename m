From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Thu, 25 Dec 2014 07:45:02 +0000
Message-ID: <bug-89511-13602-aMjmIm0RgK@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55892 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbaLYHpH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Dec 2014 02:45:07 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 41424201EC
	for <linux-ext4@vger.kernel.org>; Thu, 25 Dec 2014 07:45:06 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 961FF201DD
	for <linux-ext4@vger.kernel.org>; Thu, 25 Dec 2014 07:45:03 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

Jun Itou <itou_jun@infoseek.jp> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |itou_jun@infoseek.jp

--- Comment #24 from Jun Itou <itou_jun@infoseek.jp> ---
Created attachment 161781
  --> https://bugzilla.kernel.org/attachment.cgi?id=161781&action=edit
I tried comment 19.

I tried comment 19.
(echo 'temporary write through' > /sys/block/sdb/device/scsi_disk/*/cache_type)

 amd64 ->OK
 iop32x->NG

Please watch an attached file.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

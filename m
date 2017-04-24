From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] Suspicious persistent EXT4-fs error (device sda1):
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Mon, 24 Apr 2017 02:52:51 +0000
Message-ID: <bug-195561-13602-2Ue2uLd5Nm@https.bugzilla.kernel.org/>
References: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51134 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1164259AbdDXCwx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Apr 2017 22:52:53 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8F93223E64
        for <linux-ext4@vger.kernel.org>; Mon, 24 Apr 2017 02:52:52 +0000 (UTC)
In-Reply-To: <bug-195561-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

--- Comment #4 from Mauro Rossi (issor.oruam@gmail.com) ---
NOTE: April, 25th (VirtualBox VM with vdi vitual drive n.3, different from n.1
and n.2)

April, 25th is typo, that dmesg log was collected on April, 15th

The dmesg log on vbox with kernel 4.11rc8- was collected today and the kernel
has been built without ubifs commit [4]

[4]
https://github.com/torvalds/linux/commit/9ea33c44fb19e6cbacf65021628f8ce393ba9f34

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

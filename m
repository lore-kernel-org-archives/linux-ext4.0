From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] Suspicious persistent EXT4-fs error:
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Tue, 25 Apr 2017 23:16:14 +0000
Message-ID: <bug-195561-13602-RLkhX8i8KQ@https.bugzilla.kernel.org/>
References: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45662 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1429796AbdDYXQR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 25 Apr 2017 19:16:17 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id AE7982848E
        for <linux-ext4@vger.kernel.org>; Tue, 25 Apr 2017 23:16:16 +0000 (UTC)
In-Reply-To: <bug-195561-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

--- Comment #17 from Mauro Rossi (issor.oruam@gmail.com) ---
Created attachment 256035
  --> https://bugzilla.kernel.org/attachment.cgi?id=256035&action=edit
Output of: dd if=/dev/sdc1 of=/tmp/block_skip_xxxx56.dat bs=4k count=1
skip=557056

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

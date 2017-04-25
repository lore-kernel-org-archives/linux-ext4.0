From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] Suspicious persistent EXT4-fs error:
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Tue, 25 Apr 2017 23:14:21 +0000
Message-ID: <bug-195561-13602-wNPlcG52Xt@https.bugzilla.kernel.org/>
References: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45584 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1429520AbdDYXOX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 25 Apr 2017 19:14:23 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 909182857D
        for <linux-ext4@vger.kernel.org>; Tue, 25 Apr 2017 23:14:22 +0000 (UTC)
In-Reply-To: <bug-195561-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

--- Comment #16 from Mauro Rossi (issor.oruam@gmail.com) ---
Created attachment 256033
  --> https://bugzilla.kernel.org/attachment.cgi?id=256033&action=edit
dumpe2fs -h of another RO physical sdc1 60Gb

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

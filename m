From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] Suspicious persistent EXT4-fs error (device sda1):
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Mon, 24 Apr 2017 02:42:28 +0000
Message-ID: <bug-195561-13602-LeGs0uqS0Q@https.bugzilla.kernel.org/>
References: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50842 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758360AbdDXCm3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Apr 2017 22:42:29 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9659221E5A
        for <linux-ext4@vger.kernel.org>; Mon, 24 Apr 2017 02:42:28 +0000 (UTC)
In-Reply-To: <bug-195561-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

--- Comment #2 from Mauro Rossi (issor.oruam@gmail.com) ---
Created attachment 255967
  --> https://bugzilla.kernel.org/attachment.cgi?id=255967&action=edit
dmesg on Virtual vdi n.3

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

Return-Path: <SRS0=0ehA=O2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:57838 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726496AbeLQQvj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 17 Dec 2018 11:51:39 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 55EE42A1E1
        for <linux-ext4@vger.kernel.org>; Mon, 17 Dec 2018 16:51:39 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Mon, 17 Dec 2018 16:51:39 +0000
Message-ID: <bug-201631-13602-shUC1uDiQ3@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #16 from erhard_f@mailbox.org ---
Created attachment 280053
  --> https://bugzilla.kernel.org/attachment.cgi?id=280053&action=edit
dmesg (4.20-rc7 on a PowerMac G5 7,3)

Interesting! Both machines did not trigger the bug yet, but your patch reports
"Clean page (index 0, ino 4223082, flags 3ff00000002014) with dirty PTE
(pte_val c82000025beab386) on unmap!"-like messages during boot. 2 times on the
G5, one time on the Talos II.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

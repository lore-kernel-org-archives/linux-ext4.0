Return-Path: <SRS0=zkt8=OZ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34534 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729822AbeLPN0k (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 16 Dec 2018 08:26:40 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7E04B29CA6
        for <linux-ext4@vger.kernel.org>; Sun, 16 Dec 2018 13:26:39 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Sun, 16 Dec 2018 13:26:38 +0000
Message-ID: <bug-201631-13602-xiqHX53qRF@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #9 from erhard_f@mailbox.org ---
Created attachment 280031
  --> https://bugzilla.kernel.org/attachment.cgi?id=280031&action=edit
dmesg (4.20-rc6 on a PowerMac G5 7,3)

Also seeing this on my G5 with kernel 4.20-rc6.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

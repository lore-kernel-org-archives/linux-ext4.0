Return-Path: <SRS0=tdqe=PQ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49926 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727772AbfAHXAd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jan 2019 18:00:33 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5938D28C92
        for <linux-ext4@vger.kernel.org>; Tue,  8 Jan 2019 23:00:32 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Tue, 08 Jan 2019 23:00:30 +0000
Message-ID: <bug-201631-13602-n6HXPOaXv9@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

erhard_f@mailbox.org changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Attachment #280117|0                           |1
        is obsolete|                            |

--- Comment #41 from erhard_f@mailbox.org ---
Created attachment 280345
  --> https://bugzilla.kernel.org/attachment.cgi?id=280345&action=edit
journalctl -k (5.0-rc1 on a Talos II)

Results with latest patch (20.12.2018).

So far building llvm-7 + tests in my ext4-zramdisk reliably triggers it.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

Return-Path: <SRS0=EV/E=O6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55232 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730960AbeLULRp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 21 Dec 2018 06:17:45 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 86D29286B9
        for <linux-ext4@vger.kernel.org>; Fri, 21 Dec 2018 11:17:45 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Fri, 21 Dec 2018 11:17:45 +0000
Message-ID: <bug-201631-13602-Aol7Kw8rWm@https.bugzilla.kernel.org/>
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
 Attachment #280101|0                           |1
        is obsolete|                            |

--- Comment #35 from erhard_f@mailbox.org ---
Created attachment 280117
  --> https://bugzilla.kernel.org/attachment.cgi?id=280117&action=edit
journalctl -k (4.20-rc7 on a Talos II)

Results with latest patch.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

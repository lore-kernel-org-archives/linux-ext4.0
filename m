Return-Path: <SRS0=pBWG=MZ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:32804 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726329AbeJMXme (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 13 Oct 2018 19:42:34 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id CCEFA296BB
        for <linux-ext4@vger.kernel.org>; Sat, 13 Oct 2018 16:04:51 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 200681] [inline_data] read() does not see what write() has just
 written through different FD in the same thread
Date: Sat, 13 Oct 2018 16:04:52 +0000
Message-ID: <bug-200681-13602-VGekQQaz6p@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200681-13602@https.bugzilla.kernel.org/>
References: <bug-200681-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=200681

Anatoly Trosinenko (anatoly.trosinenko@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Attachment #277603|0                           |1
        is obsolete|                            |
 Attachment #277605|0                           |1
        is obsolete|                            |
 Attachment #277607|0                           |1
        is obsolete|                            |

--- Comment #7 from Anatoly Trosinenko (anatoly.trosinenko@gmail.com) ---
Created attachment 279013
  --> https://bugzilla.kernel.org/attachment.cgi?id=279013&action=edit
Reproducer

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

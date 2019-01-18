Return-Path: <SRS0=pvq6=P2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54844 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727148AbfARHoR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 18 Jan 2019 02:44:17 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1AD8229FF3
        for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2019 07:44:17 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 105121] lseek(SEEK_DATA) hangs for a long time for sparse files
 in the page cache
Date: Fri, 18 Jan 2019 07:44:16 +0000
Message-ID: <bug-105121-13602-WfoP4ZPVCf@https.bugzilla.kernel.org/>
In-Reply-To: <bug-105121-13602@https.bugzilla.kernel.org/>
References: <bug-105121-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=105121

ValdikSS (iam@valdikss.org.ru) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #5 from ValdikSS (iam@valdikss.org.ru) ---
Seems fixed as for 4.19.13.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

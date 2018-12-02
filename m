Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40956 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725743AbeLBL6J (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 06:58:09 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7B8A32B723
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 00:44:22 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 00:44:22 +0000
Message-ID: <bug-201685-13602-IalhZuojb9@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #119 from Guenter Roeck (linux@roeck-us.net) ---
I think I need some education. It has been suggested suggested several times -
both here and elsewhere on the web - that the problem might possibly be caused
by bad drives. Yet, I don't recall a single instance where a disk error was
reported in conjunction with this problem. I most definitely don't see one on
my systems.

Can hard drives and SSDs nowadays fail silently by reading bad data instead of
reporting read (and/or write) errors ? I would find that thought quite scary.
Can someone point me to related literature ?

In this context, it seems odd that this presumed silent disk error would only
show up with v4.19.x, but not with earlier kernels.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60828 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725764AbeLDLqF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 06:46:05 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5649B2B60F
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 11:46:05 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 11:46:04 +0000
Message-ID: <bug-201685-13602-3PZtyOv5XB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

nclauzel@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |nclauzel@gmail.com

--- Comment #222 from nclauzel@gmail.com ---
Hello,

Thank you all for your great work in this investigation.

Just my 2 cents: as mentionned earlier by others, I think it is closely related
to rsync. Or at least it is a good way to reproduce. 

On my machine I had the issue very often when my rsync script was activated at
login. Since I deactivated this task it looks fine so far. 
I could easily see some issues in my rsync log file, even a text editor was
reporting issues on this file.

Hope this helps to find a fix quicker!

Let me know if you need more information from my side.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

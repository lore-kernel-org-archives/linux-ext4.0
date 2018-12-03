Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40560 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbeLCIdi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2018 03:33:38 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3DBC22AE63
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 08:33:34 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 08:33:33 +0000
Message-ID: <bug-201685-13602-7VHmupw2IL@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #190 from Andreas John (himself@derjohn.de) ---
(In reply to Michael Orlitzky from comment #189)
> It takes about a week for the corruption to show up, but if there's some
> test you need me to run I can boot back into 4.19.6 and roll the dice.

Hm, interesting that it happens to my Ubuntu Bionic on bare metal Macbook Pro
(SSD) within minutes - even if I don't habe much I/O load. I am doing the fsck
mit 4.18.20. What could be the difference?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

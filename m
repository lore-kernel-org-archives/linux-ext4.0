Return-Path: <SRS0=yT4f=O7=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56720 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392729AbeLVRsn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 22 Dec 2018 12:48:43 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 53395289D0
        for <linux-ext4@vger.kernel.org>; Sat, 22 Dec 2018 14:13:29 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Sat, 22 Dec 2018 14:13:29 +0000
Message-ID: <bug-201631-13602-VGBhS9sGvE@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #38 from erhard_f@mailbox.org ---
(In reply to Benjamin Herrenschmidt from comment #37)
> I would advise against those DMA patches. If the GPU tries to map an sglist
> entry that crosses a 1G boundary, bad things will happen.
Did not install them, I am running a vanilla kernel. So if they have not been
upstreamed they are not in my kernel. ;)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

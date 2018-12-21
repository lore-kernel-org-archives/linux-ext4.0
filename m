Return-Path: <SRS0=EV/E=O6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45500 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729993AbeLUXrD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 21 Dec 2018 18:47:03 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id DC8DD287CE
        for <linux-ext4@vger.kernel.org>; Fri, 21 Dec 2018 23:47:02 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Fri, 21 Dec 2018 23:47:02 +0000
Message-ID: <bug-201631-13602-Vk7Pri2eyD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #37 from Benjamin Herrenschmidt (benh@kernel.crashing.org) ---
I would advise against those DMA patches. If the GPU tries to map an sglist
entry that crosses a 1G boundary, bad things will happen.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

Return-Path: <SRS0=zkt8=OZ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54202 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726289AbeLPUrn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 16 Dec 2018 15:47:43 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 32A5328800
        for <linux-ext4@vger.kernel.org>; Sun, 16 Dec 2018 20:47:43 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Sun, 16 Dec 2018 20:47:42 +0000
Message-ID: <bug-201631-13602-nAwS8MyKPL@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #11 from Benjamin Herrenschmidt (benh@kernel.crashing.org) ---
Jan, I don't know for sure what problems triggers it here, but there definitely
is a HW bug on POWER9 with the "NestMMU" (the MMU that services coprocessors
and the nvlink), which can cause a dirty bit to be set on a read-only PTE if it
races with the PTE update & invalidation.

It was "assumed" this was ok. If not I don't know how to work around it.

However, at least in the above cases, I don't see how we would be setting dirty
if we don't have RW access permission. A PowerMac G5 uses the hash MMU, we set
dirty atomically with checking the PTE permission when hashing a PTE in.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

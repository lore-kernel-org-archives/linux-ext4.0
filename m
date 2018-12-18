Return-Path: <SRS0=0j4F=O3=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33208 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726316AbeLRIpv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Dec 2018 03:45:51 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C1CA82A13A
        for <linux-ext4@vger.kernel.org>; Tue, 18 Dec 2018 08:45:50 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Tue, 18 Dec 2018 08:45:50 +0000
Message-ID: <bug-201631-13602-gbPaC4W8nw@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #19 from Jan Kara (jack@suse.cz) ---
Hum, interesting. The page we barfed on is:

Clean page (index 92, ino 1163533, flags 3ffe0000002016) with dirty PTE
(pte_val c0000001ef7b3186) on unmap!

Page flags thus decode to: PG_referenced | PG_uptodate | PG_lru | PG_private
PTE bits decode to: _PAGE_WRITE | _PAGE_READ | _PAGE_DIRTY | _PAGE_ACCESSED |
_PAGE_PTE | _PAGE_PRESENT

So indeed the page was writeably mapped. The question now is, how the page
could have been writeably mapped without getting marked dirty or how could the
dirty bit get cleared while the page stayed writeably mapped.

I'll poke more into the code and probably come up with further debugging patch.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

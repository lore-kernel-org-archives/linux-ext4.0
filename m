Return-Path: <SRS0=0j4F=O3=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49732 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726629AbeLRW1u (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Dec 2018 17:27:50 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id CD1362B065
        for <linux-ext4@vger.kernel.org>; Tue, 18 Dec 2018 22:27:49 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Tue, 18 Dec 2018 22:27:49 +0000
Message-ID: <bug-201631-13602-ZM720EUAOJ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #20 from Benjamin Herrenschmidt (benh@kernel.crashing.org) ---
Pardon my ignorance here, but I was under the impression that this was normal
:) The whole point being that the PTE dirty bit gets set when accesses happen,
and latter on gets harvested into the struct page dirty bit.

Otherwise, what would be the point of having a PTE dirty bit in the PTE at all
or transferring a dirty bit from PTE to struct page in try_to_unmap_one() (for
example) if a writable page is always mapped dirty ?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

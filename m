Return-Path: <SRS0=7ScE=O4=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50106 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728109AbeLSNjR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 19 Dec 2018 08:39:17 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 50A05297E5
        for <linux-ext4@vger.kernel.org>; Wed, 19 Dec 2018 13:39:16 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Wed, 19 Dec 2018 13:39:16 +0000
Message-ID: <bug-201631-13602-9EcHd7Mjso@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #21 from Jan Kara (jack@suse.cz) ---
(In reply to Benjamin Herrenschmidt from comment #20)
> Pardon my ignorance here, but I was under the impression that this was
> normal :) The whole point being that the PTE dirty bit gets set when
> accesses happen, and latter on gets harvested into the struct page dirty bit.
> 
> Otherwise, what would be the point of having a PTE dirty bit in the PTE at
> all or transferring a dirty bit from PTE to struct page in
> try_to_unmap_one() (for example) if a writable page is always mapped dirty ?

The PTE dirty bit is used for anonymous pages as you describe. File pages are
marked dirty immediately during page fault (look for example at
mm/memory.c:wp_page_shared() and its call to fault_dirty_shared_page()). When
page gets written back, clear_page_dirty_for_io() is used which writeprotects
all PTEs, clears PTE dirty bits, and then page dirty bit is cleared as well. So
for shared file mappings PTE dirty bits could be ignored.

The reason why PTE dirty bits are not ignored are partly heritage from before
2006 when this mechanism was introduced and party because people do it "just to
be sure"...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

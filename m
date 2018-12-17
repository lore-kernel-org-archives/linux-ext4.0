Return-Path: <SRS0=0ehA=O2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40580 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726505AbeLQK6F (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 17 Dec 2018 05:58:05 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B7309292CC
        for <linux-ext4@vger.kernel.org>; Mon, 17 Dec 2018 10:58:04 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Mon, 17 Dec 2018 10:58:04 +0000
Message-ID: <bug-201631-13602-TASKvSWwTI@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #12 from Jan Kara (jack@suse.cz) ---
Thanks for info Ben! First one slightly off-topic comment: Spuriously setting
dirty bits in page tables is certainly not OK for file systems. This results in
set_page_dirty() being called for a page when it gets unmapped and that means
that file system is told there's new data in the page. But the file system is
not prepared for that - it needs to prepare its structures for data
modification (usually happens in ->page_mkwrite callback during page fault)
like making sure there's enough free space, do COW on the page in case it was
reflinked etc. As you say, this is likely not a problem of this particular
reporter but I wanted to make sure the message gets across :).

Now to this report: It's good to know that setting of PTE dirty bit should be
atomic at least on G5 wrt concurrent invalidation and page write protection.
But something seems to have happened with 4.20-rcs that dirty bits do get set
as Erhard started to see these warnings. I haven't heard any report of this
from x86, this seems to be ppc specific. Since it happens once in couple of
weeks, bisection is not really an option. I guess, I'll write a debug patch to
dump PTE and page state when such problematic situation occurs and maybe
that'll tell us something more to debug this.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

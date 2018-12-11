Return-Path: <SRS0=J55O=OU=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:35762 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726170AbeLKLVS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 11 Dec 2018 06:21:18 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 39D272A472
        for <linux-ext4@vger.kernel.org>; Tue, 11 Dec 2018 11:21:17 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Tue, 11 Dec 2018 11:21:17 +0000
Message-ID: <bug-201631-13602-72DMTbeQQ3@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

Jan Kara (jack@suse.cz) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |benh@kernel.crashing.org,
                   |                            |jack@suse.cz,
                   |                            |michael@ellerman.id.au

--- Comment #8 from Jan Kara (jack@suse.cz) ---
The lockups and ext4 warnings are likely a different thing. So please report
the lockup to linux-fsdevel@vger.kernel.org and also CC Al Viro
<viro@zeniv.linux.org.uk> on it.

The WARN_ON we hit in ext4 is likely:

WARN_ON_ONCE(!PageLocked(page) && !PageDirty(page));

because we don't expect page cache page to be marked dirty when unmapping it
from page tables. It could be a powerpc specific race in handling of page table
entry (PTE) flags as I don't see how PTE could be marked dirty without a page
being already dirty.

Seeing you hit this already twice on 4.20-rc's and never on 4.19.x, it could be
some recent powerpc change that is triggering this. I've skimmed through
powerpc changelogs and didn't find anything obviously matching but there were
quite some mm changes pulled in this merge window. Powerpc guys, any idea how
could _PAGE_DIRTY PTE bit get spuriously set? Normally, we should clear the
_PAGE_DIRTY bit in page_mkclean() together with write-protecting the PTE and we
are marking the page dirty whenever writeable PTE is created... So clean
pagecache page with _PAGE_DIRTY in PTE is an invalid combination.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

Return-Path: <SRS0=XuXQ=NS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:38040 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727127AbeKHHlf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Nov 2018 02:41:35 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3E5E72D1D5
        for <linux-ext4@vger.kernel.org>; Wed,  7 Nov 2018 22:09:14 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Wed, 07 Nov 2018 22:09:13 +0000
Message-ID: <bug-201631-13602-vgwy47pQyP@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

Theodore Tso (tytso@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #2 from Theodore Tso (tytso@mit.edu) ---
Can you reproduce this?   

And you may also want to send a report to linux-mm@kvack.org, since although it
was tripped in ext4_set_page_dirty, the WARN_ON check which is it doing are
fundamentally page specific, so this may very well be an mm problem:


static int ext4_set_page_dirty(struct page *page)
{
        WARN_ON_ONCE(!PageLocked(page) && !PageDirty(page));
        WARN_ON_ONCE(!page_has_buffers(page));
        return __set_page_dirty_buffers(page);
}

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

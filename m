Return-Path: <SRS0=xLGb=PZ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47706 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727973AbfAQKcR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 17 Jan 2019 05:32:17 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D9A182EB2A
        for <linux-ext4@vger.kernel.org>; Thu, 17 Jan 2019 10:32:16 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Thu, 17 Jan 2019 10:32:16 +0000
Message-ID: <bug-201631-13602-u3VjBzQ4iM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #43 from Jan Kara (jack@suse.cz) ---
Thanks for gathering the results and sorry for not replying earlier. I've been
busy with other work... So again I can see in the logs:

Clean page (index 137, ino 1820427, i_size 1144448, flags 3ffe0000002016) with
dirty PTE (pte_val c0000005f899f186) on unmap!
WARNING: CPU: 3 PID: 1532 at fs/ext4/inode.c:3935
.ext4_set_page_dirty+0x80/0x170
...
page 137: b_state 21, b_blocknr 2726281, b_mapped 0, b_cleaned 1498120697108,
now 1498125595648

So the page has been submitted for writeout some 5 ms ago but still we didn't
get b_mapped set at all which would mean that ext4_page_mkwrite() got never
called for the page - which is very weird. I'll ponder more about it possibly
come up with more debugging.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

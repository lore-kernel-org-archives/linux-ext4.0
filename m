Return-Path: <SRS0=Xbv+=M6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55758 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727393AbeJRKed (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Oct 2018 06:34:33 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8BD2420881
        for <linux-ext4@vger.kernel.org>; Thu, 18 Oct 2018 02:35:53 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201461] ext4 journal stalls write system call
Date: Thu, 18 Oct 2018 02:35:53 +0000
Message-ID: <bug-201461-13602-UoBpLav8xT@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201461-13602@https.bugzilla.kernel.org/>
References: <bug-201461-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201461

--- Comment #3 from Theodore Tso (tytso@mit.edu) ---
The writeback code will end up calling ext4_writepages(), which will do block
allocations via ext4_map_blocks() with the flag EXT4_GET_BLOCKS_CREATE(), and
this will take a write lock on i_data_sem.   

I'll let you trace through the call chain that starts in the writeback thread,
through the call to ext4_writepages(), proceeds to mpage_map_one_extent(), and
from there to ext4_map_blocks() which actually holds the write block.

Note that this is distinct from the data=ordered forced writeblock which starts
in fs/jbd2's journal_submit_inode_data_buffer() calling generic_writepages().  
The difference is that generic_writepages() will only call writepage()
function.  For ext4 that's ext4_writepage(), which will never do block
allocation.

But the writeback threads call the address space operation's, writepages()
function, and ext4_writepages() *will* do block allocation for delayed
allocation writes.

This is a subtle point; ext4_writepage() and ext4_writepages() do very
different things.   The first is used by the commit kernel thread; the second
is used by the writeback kernel thread.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

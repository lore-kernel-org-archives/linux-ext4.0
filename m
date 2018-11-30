Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:48014 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726393AbeK3MXK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Nov 2018 07:23:10 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 11F662FBC3
        for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2018 01:15:41 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Fri, 30 Nov 2018 01:15:40 +0000
Message-ID: <bug-201685-13602-U7WrlPfd0h@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #77 from Jens Axboe (axboe@kernel.dk) ---
(In reply to Jimmy.Jazz from comment #76)
> (In reply to Jimmy.Jazz from comment #75)
> 
> > I'm waiting for the next backup tomorrow.
> 
> @J.Axboe
> No need to wait. ext4 error resurfaced on dm-8 this time. block/blk-core.c
> patch doesn't correct the issue.
> 
> [ 3774.584797] EXT4-fs error (device dm-8): ext4_iget:4985: inode #1614666:
> comm emerge: bad extended attribute block 1

Are you still confident the full patch works? It's interesting since that has
RCU, and the other changes point in that direction, too.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

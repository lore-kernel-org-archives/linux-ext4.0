Return-Path: <SRS0=G5ay=OI=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53704 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726393AbeK3J75 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Nov 2018 04:59:57 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id CCF382FB9D
        for <linux-ext4@vger.kernel.org>; Thu, 29 Nov 2018 22:52:51 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Thu, 29 Nov 2018 22:52:51 +0000
Message-ID: <bug-201685-13602-rGK4JqLjzR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #75 from Jimmy.Jazz@gmx.net ---
(In reply to Jens Axboe from comment #64)
> only apply the part to block/blk-core.c

@T.Tso and J.Axboe
e1333462e3 was not able to compile the 4.19.5 kernel.

Long story, gcc begins to complain of missing elfutils package (it was
installed already). I felt also in an old CONFIG_UNWINDER_ORC bug "Cannot
generate ORC metadata". Compilations begin to fail with a "cannot make
executable" error. As unbelievable it is, the bug was reported recently
(https://lkml.org/lkml/2018/11/5/108).
I'm using dev-libs/elfutils-0.175 and the kernel isn't affected by
https://bugs.gentoo.org/671760

The good news. 4.19.4 kernel with the part to 'block/blk-core.c' of your patch
has compiled 4.19.5. It doesn't show any sign of ext4 corruption.

I'm waiting for the next backup tomorrow.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

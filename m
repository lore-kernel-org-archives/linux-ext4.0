Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49876 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726709AbeLAE5f (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Nov 2018 23:57:35 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F0FFA30511
        for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2018 17:47:31 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Fri, 30 Nov 2018 17:47:31 +0000
Message-ID: <bug-201685-13602-I0wia6Agwz@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #92 from Hao Wei Tee (angelsl@in04.sg) ---
(In reply to Néstor A. Marchesini from comment #91)
> For me, the problem started with the release of 4.19.0, and looking at the
> commits of the tree 4.19.0, I see that many things of ext4 have been changed
> ... very many I would say.
> If you search with ext4 within the list of comnits you will find several and
> with very important changes.

There are only 32 new commits in fs/ext4 in v4.19 from v4.18. See [1], count
until commit "ext4: fix check to prevent initializing reserved inodes".

[1]:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/fs/ext4?id=v4.19

> There are several massive, one of the most important is:
> 
>
> https://github.com/torvalds/linux/commit/c140f8b072d16595c83d4d16a05693e72d9b1973

This isn't in v4.19? It only got pulled in the v4.20 merge window.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

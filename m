Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40486 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726292AbeLAEcZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Nov 2018 23:32:25 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id EBBF0304E4
        for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2018 17:22:25 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Fri, 30 Nov 2018 17:22:26 +0000
Message-ID: <bug-201685-13602-fzOg1wQ0Am@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #91 from Néstor A. Marchesini (nestorm_des@hotmail.com) ---
For me, the problem started with the release of 4.19.0, and looking at the
commits of the tree 4.19.0, I see that many things of ext4 have been changed
... very many I would say.
If you search with ext4 within the list of comnits you will find several and
with very important changes.

https://cdn.kernel.org/pub/linux/kernel/v4.x/ChangeLog-4.19

There are several massive, one of the most important is:

https://github.com/torvalds/linux/commit/c140f8b072d16595c83d4d16a05693e72d9b1973

This weekend I will try with git bisect, but it will be a very time-consuming
task due to the large number of ext4 commits.
I'm still using 4.19.5 with the ext4 folder of 4.18.20. I have not had problems
so far.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

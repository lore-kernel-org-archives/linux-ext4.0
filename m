Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60144 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728163AbeK2Eac (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Nov 2018 23:30:32 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 023E42D157
        for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2018 17:28:10 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 28 Nov 2018 17:28:10 +0000
Message-ID: <bug-201685-13602-mdnGkVAasJ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #66 from Jimmy.Jazz@gmx.net ---
(In reply to Jens Axboe from comment #64)

> How certain are you that my 4.19 patch fixes the issue completely for you?

Without your patch the failure was mostly systematic in the time.
Synchronization mechanism is not trivial anyway. But statically there is hope.

> If 100%, can you also try with 4.19.4 + just the first hunk of that patch?

> In other words, only apply the part to block/blk-core.c, not the one to
> block/blk-mq.c

I understand, probably syncronize_rcu was a bit too much :). Let me 24h please.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

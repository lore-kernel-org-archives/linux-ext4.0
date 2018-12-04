Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:42928 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725831AbeLDTZz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 14:25:55 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3566929517
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 19:25:55 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 19:25:53 +0000
Message-ID: <bug-201685-13602-owSwyyFKfC@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #237 from Rainer Fiebig (jrf@mailbox.org) ---
(In reply to Lukáš Krejčí from comment #232)
> Created attachment 279845 [details]
> git bisect between v4.18 and 4.19-rc1
> 
> Hello,
> 
> I am able to reproduce the data corruption under Qemu, the issue usually
> shows itself fairly quickly (within a minute or two). Generally, the bug was
> very likely to appear when (un)installing packages with apt.
> 
> I ran a bisect with the following result (full bisect log is attached):
> # first bad commit: [6ce3dd6eec114930cf2035a8bcb1e80477ed79a8] blk-mq: issue
> directly if hw queue isn't busy in case of 'none'
> 
[...]

Congrats! Good to see progress here. Thanks!

I also feel somewhat vindicated as my idea to catch and bisect this in VM
wasn't so bad after all. ;)

But obviously qemu has more knobs to turn than VB - and you just turned the
right ones. Great!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

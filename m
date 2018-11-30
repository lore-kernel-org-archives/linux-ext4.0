Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:42084 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726572AbeK3Tvi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Nov 2018 14:51:38 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BB6292FCBA
        for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2018 08:43:03 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Fri, 30 Nov 2018 08:43:02 +0000
Message-ID: <bug-201685-13602-pqRPUu5VTM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #83 from Rainer Fiebig (jrf@mailbox.org) ---
(In reply to Hao Wei Tee from comment #82)
> I fear the bug might be caused by some interaction between something new in
> fs/ext4 and something new elsewhere... Sounds unlikely, but it's possible.
> 
> Since 4.18 ext4 seems to work on 4.19 kernel, maybe it's worth trying 4.19
> ext4 on 4.18 kernel (before a bisect), just to make sure the bisect won't
> lead us down a false trail?

Interesting idea. But what works in one direction might not necessarily work
the other way round. Personally, I'd rather like to be on the safe side here.
So before doing this it might be wise to here what Ted Tso thinks about it,
just IMO.

And I don't think that bisecting just fs/ext4 would be misleading. If we find a
bad commit there, Ted and others will look at it anyway and will see whether
this alone explains the problems or whether an interaction with something else
would be necessary to make sense of it.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

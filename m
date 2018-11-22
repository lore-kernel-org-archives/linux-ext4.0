Return-Path: <SRS0=c0SX=OB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43074 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730867AbeKWDpM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Nov 2018 22:45:12 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id ADA402C2BF
        for <linux-ext4@vger.kernel.org>; Thu, 22 Nov 2018 17:04:57 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Thu, 22 Nov 2018 17:04:58 +0000
Message-ID: <bug-201685-13602-NbRWntdV5q@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #33 from Jimmy.Jazz@gmx.net ---
(In reply to Jens Axboe from comment #28)
> If it's not this, another hint might be a discard change. Is everyone
> affected using discard?

All 'cat /sys/block/dm-*/dm/use_blk_mq' are zero. Could MQ still be a suspect ?

I reproduced the issue with 4.19.3 as well but without your patch.
The difference is, it happens less often but still under heavy load (hours of
work, mostly compilations and monitoring).

The strange is, the affected disks are not obliged to be under load and on the
next reboot fsck -f show some of them as clean despite they were declared with
ext4_iget corruptions (tested during reboot from 4.19.2 to 4.19.3 kernel)!

It's like some shared fs cache failure to me with unpleasant consequences.

Disabling user_xattr seems to be more helpful with 4.20.0-rc3 anyway, no error
since. Actually not under heavy load.

Failures appear also on an plain old HDD device. For me, SSD discard is more a
consequence as a reason but it's worse investigating it.

I will try your patch ASAP.

Thx

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

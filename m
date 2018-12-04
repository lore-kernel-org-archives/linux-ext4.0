Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53128 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725797AbeLDSWm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 13:22:42 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 674AE2C106
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 18:22:41 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 18:22:40 +0000
Message-ID: <bug-201685-13602-xqc5s3y2zD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #228 from Guenter Roeck (linux@roeck-us.net) ---
I guess I should have been more specific. With CONFIG_SCSI_MQ_DEFAULT=y (or
scsi_mod.use_blk_mq=1), cfq is not available. That applies to any kernel
version with CONFIG_SCSI_MQ_DEFAULT=y (or scsi_mod.use_blk_mq=1), not just to
4.19, and it doesn't apply to 4.19 if CONFIG_SCSI_MQ_DEFAULT=n (or
scsi_mod.use_blk_mq=0).

It is quite irrelevant if other schedulers are available if
CONFIG_SCSI_MQ_DEFAULT=y (or scsi_mod.use_blk_mq=1). cfq is not available, and
it doesn't matter if it is set as default or not.

I hope this is specific enough this time. My apologies if I missed some other
means to enable or disable blk_mq.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

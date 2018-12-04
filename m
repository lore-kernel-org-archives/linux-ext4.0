Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49134 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725797AbeLDSEC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 13:04:02 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id ADCC82C353
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 18:04:01 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 18:04:00 +0000
Message-ID: <bug-201685-13602-6wa6F71yTZ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #225 from Steven Noonan (steven@uplinklabs.net) ---
(In reply to Manfred from comment #224)
> (In reply to Guenter Roeck from comment #223)
> 
> > There is a key difference, though: With 4.18.20, cfq is active.
> > 
> > $ cat /sys/block/sd*/queue/scheduler
> > noop deadline [cfq] 
> > noop deadline [cfq] 
> > 
> > In 4.19, cfq is not available    <--- ?
> 
> # grep  -i cfq    config-4.19.3-gentoo
> 
> CONFIG_IOSCHED_CFQ=y                       < --- !
> # CONFIG_CFQ_GROUP_IOSCHED is not set
> CONFIG_DEFAULT_CFQ=y
> CONFIG_DEFAULT_IOSCHED="cfq"
> 

When scsi_mod.use_blk_mq=1 (i.e. result of CONFIG_SCSI_MQ_DEFAULT=y), the I/O
scheduler is just "none", and you cannot set a different scheduler.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

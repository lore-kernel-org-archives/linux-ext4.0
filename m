Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60238 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725797AbeLDSes (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 13:34:48 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9C0FF2C4AF
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 18:34:47 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 18:34:45 +0000
Message-ID: <bug-201685-13602-HDn3mfgQXK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #231 from Steven Noonan (steven@uplinklabs.net) ---
(In reply to Jens Axboe from comment #227)
> (In reply to Steven Noonan from comment #225)
> > When scsi_mod.use_blk_mq=1 (i.e. result of CONFIG_SCSI_MQ_DEFAULT=y), the
> > I/O scheduler is just "none", and you cannot set a different scheduler.
> 
> That's not true, you can set MQ capable schedulers. CFQ is from the legacy
> stack, it doesn't support MQ. But you can set none/bfq/mq-deadline/kyber,
> for instance.

My bad. I was basing my response on outdated information:

https://mahmoudhatem.wordpress.com/2016/02/08/oracle-uek-4-where-is-my-io-scheduler-none-multi-queue-model-blk-mq/

(Also didn't want to risk turning on MQ on one of my machines just to word my
response, especially if not having CFQ is somehow involved in this corruption
bug!)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

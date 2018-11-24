Return-Path: <SRS0=yRHK=OD=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54018 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726407AbeKYA71 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 24 Nov 2018 19:59:27 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 6F0CF2AB16
        for <linux-ext4@vger.kernel.org>; Sat, 24 Nov 2018 14:10:56 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sat, 24 Nov 2018 14:10:55 +0000
Message-ID: <bug-201685-13602-iAzhw4k6FV@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #40 from Rainer Fiebig (jrf@mailbox.org) ---
(In reply to AdamB from comment #39)
> I also experienced an ext4 file system corruption with 4.19.1, after
> resuming from suspend-to-ram.
> 
> I've ran 4.12, 13, 14, 16, 17, and 18 on the same machine with near
> identical .config and never had a file system corruption.
> 
> For all those kernels, I've had CONFIG_SCSI_MQ_DEFAULT=y.

I can say the same for CONFIG_SCSI_MQ_DEFAULT=n.
But this is not exactly the same as running 4.19.x with
CONFIG_SCSI_MQ_DEFAULT=n.

As someone already pointed out: the best way to find out what's behind this is
bisecting between 4.18 and 4.19 by someone affected by the problem. This is
time consuming but in the end may also be the fastest way. A backup is IMO
mandatory in this case.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

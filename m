Return-Path: <SRS0=z94b=OO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56832 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbeLEIst (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Dec 2018 03:48:49 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 6A9572BDFF
        for <linux-ext4@vger.kernel.org>; Wed,  5 Dec 2018 08:48:48 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 05 Dec 2018 08:48:45 +0000
Message-ID: <bug-201685-13602-RbXtTItOxH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #263 from Rainer Fiebig (jrf@mailbox.org) ---
(In reply to Guenter Roeck from comment #240)
> As mentioned earlier, I only ever saw the problem on two of four systems
> (see #57), all running the same kernel and the same version of Ubuntu. The
> only differences are mainboard, CPU, and attached drive types.
> 
> I don't think we know for sure what it takes to trigger the problem. We have
> seen various guesses, from gcc version to l1tf mitigation to CPU type,
> broken hard drives, and whatnot. At this time evidence points to the block
> subsystem, with bisect pointing to a commit which relies on the state of the
> HW queue (empty or not) in conjunction with the 'none' io scheduler. This
> may suggest that drive speed and access timing may be involved. That guess
> may of course be just as wrong as all the others.
> 
> Let's just hope that Jens will be able to track down and fix the problem.
> Then we may be able to get a better idea what it actually takes to trigger
> it.

It would indeed be nice to get a short summary *here* of what happened and why,
once the dust has settled.

It would also be interesting to know why all the testing in the run-up to 4.19
didn't catch it, including rc-kernels. It's imo for instance unlikely that
everybody just tested with CONFIG_SCSI_MQ_DEFAULT=n.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

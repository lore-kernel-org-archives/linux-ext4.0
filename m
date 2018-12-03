Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39402 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726014AbeLCOWJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2018 09:22:09 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 28A6A2AF0C
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 14:20:58 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 14:20:56 +0000
Message-ID: <bug-201685-13602-c8debzjRO1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #199 from Ortwin Glück (odi@odi.ch) ---
(In reply to Rainer Fiebig from comment #195)
> My VirtualBox-VM seems immune to this issue. Perhaps VMs have just the right
> "hardware".

Yeah, I've been wondering. Qemu only exposes single-queue devices (virtio_blk)
so bugs in MQ can not trigger here I guess. Also "hardware" timing is much
different in VMs so race conditions may not trigger with the same frequency.
Also CPU assignment/scheduling may be different with respect to barriers, so
memory safety problems (RCU bugs, missing barriers) may behave differently.

I had no luck with vastly overcommitting vCPUs either.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

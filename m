Return-Path: <SRS0=jmd0=OE=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:57190 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726021AbeKZJQz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 26 Nov 2018 04:16:55 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 058B1298A5
        for <linux-ext4@vger.kernel.org>; Sun, 25 Nov 2018 22:24:47 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 25 Nov 2018 22:24:46 +0000
Message-ID: <bug-201685-13602-H6AaTmpvWJ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #45 from Henrique Rodrigues (henrique.rodrigues@ist.utl.pt) ---
(In reply to Rainer Fiebig from comment #38)
> what *I* would do if I were in your shoes is 
> 
> - run a kernel < 4.19, make sure the fs is OK and *backup important data* 
> - compile 4.19.3 with CONFIG_SCSI_MQ_DEFAULT *not* set
> 
> and see what happens.


This is what I did: recompile my 4.19.3 kernel with CONFIG_SCSI_MQ_DEFAULT=n.
I've used the computer normally, ran some heavy read/write operations, rebooted
a bunch of times and had no problems since then. I'm on Ubuntu 18.10 with an
SSD, encrypted LUKS root partition.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

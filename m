Return-Path: <SRS0=F3Rs=OG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33100 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726535AbeK0M2W (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 27 Nov 2018 07:28:22 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4820A2A477
        for <linux-ext4@vger.kernel.org>; Tue, 27 Nov 2018 01:32:15 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 27 Nov 2018 01:32:15 +0000
Message-ID: <bug-201685-13602-GYD4PZ7oFG@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #54 from Henrique Rodrigues (henrique.rodrigues@ist.utl.pt) ---
(In reply to Theodore Tso from comment #46)
> So Henrique, the only difference between the 4.19.3 kernel that worked and
> the one where you didn't see corruption was CONFIG_SCSI_MQ_DEFAULT?   Can
> you diff the two configs to be sure?

The bad news is that I've seemed to have made a mistake and there are more
changes than that one.

The other bad news is that I got another corruption even with
CONFIG_SCSI_MQ_DEFAULT=n.


> What can you tell us about the SSD?  Is it a SATA-attached SSD, or
> NVMe-attached?

It's a SATA attached SSD.

I'll attach more information (dmesg, lspci, kernel config, etc). Unfortunately
fsck now tells me I've got a bad magic number in super-block, so I think I
better start copying some stuff over to another disk before attempting anything
else.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

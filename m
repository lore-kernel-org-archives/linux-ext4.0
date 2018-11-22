Return-Path: <SRS0=c0SX=OB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43214 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391821AbeKWCCB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Nov 2018 21:02:01 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8D0042CEBF
        for <linux-ext4@vger.kernel.org>; Thu, 22 Nov 2018 15:22:12 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Thu, 22 Nov 2018 15:22:12 +0000
Message-ID: <bug-201685-13602-Xu8Srkd79a@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Azat Khuzhin (a3at.mail@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |a3at.mail@gmail.com

--- Comment #31 from Azat Khuzhin (a3at.mail@gmail.com) ---
I'm also running 4.20-rc2 but does not experience any corruption for now
(*crossing fingers*)

(In reply to Theodore Tso from comment #11)
> hmm, my laptop running 4.19.0 plus the ext4 commits landing in 4.20-rc2+ is
> *also* using CONFIG_SCSI_MQ_DEFAULT=n

But I do have CONFIG_SCSI_MQ_DEFAULT:

$ zgrep CONFIG_SCSI_MQ_DEFAULT=y /proc/config.gz
CONFIG_SCSI_MQ_DEFAULT=y
$ head /sys/block/dm-0/dm/use_blk_mq
1

(In reply to Jens Axboe from comment #25)
> Ted, it seems to be affecting nvme as well

And I do have nvme ssd:

nvme0n1       259:0    0 953.9G  0 disk
├─nvme0n1p1   259:1    0   260M  0 part  /boot
└─nvme0n1p2   259:2    0 953.6G  0 part
  └─cryptroot 254:0    0 953.6G  0 crypt /

And as you can see I have dm-crypt

So it looks like that this is not that simple (IOW not every setup/env/hw
affected).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

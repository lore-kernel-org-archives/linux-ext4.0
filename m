Return-Path: <SRS0=G5ay=OI=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44378 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727239AbeK2PwF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 29 Nov 2018 10:52:05 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7BAE72E657
        for <linux-ext4@vger.kernel.org>; Thu, 29 Nov 2018 04:48:03 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Thu, 29 Nov 2018 04:48:03 +0000
Message-ID: <bug-201685-13602-2Tvvvp2F2p@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #70 from Néstor A. Marchesini (nestorm_des@hotmail.com) ---
(In reply to Theodore Tso from comment #59)
> 
> But just to rule things out, I've uploaded the contents of fs/ext4 from
> 4.18.   I've verified it can be transplanted on top of 4.19 kernel.   Could
> the people who are experiencing problems with 4.19 try building a kernel
> with the 4.18 fs/ext4 directory?   If you still see problems, then the
> problem has to be elsewhere.   If you don't, then we can take a closer look
> at the ext4 changes (although I'd then be really puzzled why it's only
> showing up for some folks, but not others).
>

I copied /fs/ext4 from tree 4.18.20 to tree 4.19.5
and compile everything from scratch the tree 4.19.5.
Well, now we'll have to wait and cross our fingers every time I restart the PC.
So far I had no problems, if they appear I would be posted again with data.
Regarding my configuration of CONFIG_SCSI_MQ_DEFAULT it was always enabled for
eons.

# cat /boot/config-4.18.20-gentoo |grep CONFIG_SCSI_MQ_DEFAULT=
CONFIG_SCSI_MQ_DEFAULT=y
# cat /boot/config-4.19.4-gentoo |grep CONFIG_SCSI_MQ_DEFAULT=
CONFIG_SCSI_MQ_DEFAULT=y
# cat /boot/config-4.19.5-gentoo |grep CONFIG_SCSI_MQ_DEFAULT=
CONFIG_SCSI_MQ_DEFAULT=y

# eix -Ic e2fsprogs
[I] sys-fs/e2fsprogs (1.44.4@07/11/18): Standard EXT2/EXT3/EXT4 filesystem
utilities
[I] sys-libs/e2fsprogs-libs (1.44.4@06/11/18): e2fsprogs libraries (common
error and subsystem)
Found 2 matches

Regards

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

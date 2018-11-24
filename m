Return-Path: <SRS0=yRHK=OD=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:42704 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726160AbeKXW4g (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 24 Nov 2018 17:56:36 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id EEEB02AE9B
        for <linux-ext4@vger.kernel.org>; Sat, 24 Nov 2018 12:08:18 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sat, 24 Nov 2018 12:08:18 +0000
Message-ID: <bug-201685-13602-rqVtXMIXm9@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #38 from Rainer Fiebig (jrf@mailbox.org) ---
(In reply to Jimmy.Jazz from comment #37)
> @Jen Axboe
> 
> please read worth not worse in comment 33
> 
> I tried your patch for 4.19.3 and still get quite harmful ext4 errors like
> this one,
> 
> EXT4-fs error (device dm-4): ext4_xattr_ibody_get:592: inode #4881425: comm
> rsync: corrupted in-inode xattr
> 
> The filesystems were clean at boot time and the system was idle.
> 
> tune2fs ends with
> FS Error count:           64
> First error time:         Fri Nov 23 00:19:25 2018
> First error function:     ext4_xattr_ibody_get
> First error line #:       592
> First error inode #:      4881425
> First error block #:      0
> Last error time:          Fri Nov 23 00:19:25 2018
> Last error function:      ext4_xattr_ibody_get
> Last error line #:        592
> Last error inode #:       4881430
> Last error block #:       0
> MMP block number:         9255
> MMP update interval:      5
> 
> If you are interested in its dumpe2fs result let me know.
> 
> I don't use binary modules.

Jimmy,

what *I* would do if I were in your shoes is 

- run a kernel < 4.19, make sure the fs is OK and *backup important data* 
- compile 4.19.3 with CONFIG_SCSI_MQ_DEFAULT *not* set

and see what happens. If you still get corruption, CONFIG_SCSI_MQ_DEFAULT
probably is not the culprit. If not, it has at least something to do with it.

It seems that CONFIG_SCSI_MQ_DEFAULT *not* set was the default <= 4.18.19.

Others here obviously don't have problems with CONFIG_SCSI_MQ_DEFAULT=y and
kernels >= 4.19, but you never know.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

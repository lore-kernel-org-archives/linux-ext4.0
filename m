Return-Path: <SRS0=c0SX=OB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34466 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727713AbeKVMjc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Nov 2018 07:39:32 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 98F582C7C8
        for <linux-ext4@vger.kernel.org>; Thu, 22 Nov 2018 02:02:26 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Thu, 22 Nov 2018 02:02:26 +0000
Message-ID: <bug-201685-13602-Ihut4uy30z@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #25 from Jens Axboe (axboe@kernel.dk) ---
Ted, it seems to be affecting nvme as well, so there's really no escaping for
you. But there has to be some other deciding factor here, or all the block
testing would surely have caught this. Question is just what it is.

What would be the most helpful is if someone who can reproduce this at well
could run a bisect between 4.18 and 4.19 to figure out wtf is going on here.
This commit:

commit 410306a0f2baa5d68970cdcf6763d79c16df5f23
Author: Ming Lei <ming.lei@redhat.com>
Date:   Wed Nov 14 16:25:51 2018 +0800

    SCSI: fix queue cleanup race before queue initialization is done

might explain the SCSI issues seen, but the very first comment is from someone
using nvme that the above patch has no bearing on that at all. It is, however,
possible that some of the queue sync patches caused a blk-mq issue, and that is
why nvme is affected as well, and why the above commit seems to fix things on
the SCSI side.

I'm going to attach a patch here for 4.19 and it'd be great if folks could try
that.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

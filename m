Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:59142 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389115AbeKVGvr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Nov 2018 01:51:47 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id E49FF2C906
        for <linux-ext4@vger.kernel.org>; Wed, 21 Nov 2018 20:15:59 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 21 Nov 2018 20:15:58 +0000
Message-ID: <bug-201685-13602-5jsASK7mGj@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #20 from Theodore Tso (tytso@mit.edu) ---
Can someone try 4.19.3?   I was working with another Ubuntu user who did *not*
have see the problem with 4.19.0, but did see it with 4.19.1, but one of the
differences in his config was:

-# CONFIG_SCSI_MQ_DEFAULT is not set
+CONFIG_SCSI_MQ_DEFAULT=y

Furthermore, he tried 4.19.3 and after two hours of heavy I/O, he's no longer
seeing problems.   Based on the above observation, his theory is this commit
may have fixed things, and it *is* blk-mq specific:

commit 410306a0f2baa5d68970cdcf6763d79c16df5f23
Author: Ming Lei <ming.lei@redhat.com>
Date:   Wed Nov 14 16:25:51 2018 +0800

    SCSI: fix queue cleanup race before queue initialization is done

    commit 8dc765d438f1e42b3e8227b3b09fad7d73f4ec9a upstream.

    c2856ae2f315d ("blk-mq: quiesce queue before freeing queue") has
    already fixed this race, however the implied synchronize_rcu()
    in blk_mq_quiesce_queue() can slow down LUN probe a lot, so caused
    performance regression.

    Then 1311326cf4755c7 ("blk-mq: avoid to synchronize rcu inside
blk_cleanup_queue()")
    tried to quiesce queue for avoiding unnecessary synchronize_rcu()
    only when queue initialization is done, because it is usual to see
    lots of inexistent LUNs which need to be probed.

    However, turns out it isn't safe to quiesce queue only when queue
    initialization is done. Because when one SCSI command is completed,
    the user of sending command can be waken up immediately, then the
    scsi device may be removed, meantime the run queue in scsi_end_request()
    is still in-progress, so kernel panic can be caused.

    In Red Hat QE lab, there are several reports about this kind of kernel
    panic triggered during kernel booting.

    This patch tries to address the issue by grabing one queue usage
    counter during freeing one request and the following run queue.

This commit just landed in mainline and is not in 4.20-rc2, so the theory that
it was a blk-mq bug that was fixed by the above commit is consistent with all
of the observations made to date.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

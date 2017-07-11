From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196223] jdb2 journal - hung after suspend-resume test
Date: Tue, 11 Jul 2017 17:17:59 +0000
Message-ID: <bug-196223-13602-SukSUASq7J@https.bugzilla.kernel.org/>
References: <bug-196223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37540 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755585AbdGKRSB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 11 Jul 2017 13:18:01 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 645DE2854A
        for <linux-ext4@vger.kernel.org>; Tue, 11 Jul 2017 17:18:00 +0000 (UTC)
In-Reply-To: <bug-196223-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196223

--- Comment #24 from Tomi Sarvela (tomi.p.sarvela@intel.com) ---
Bisected by marking the merge bases good, and got the commit which looks like a
reasonable culprit:

5c279bd9e40624f4ab6e688671026d6005b066fa is the first bad commit
commit 5c279bd9e40624f4ab6e688671026d6005b066fa
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Jun 16 10:27:55 2017 +0200

    scsi: default to scsi-mq

    Remove the SCSI_MQ_DEFAULT config option and default to the blk-mq I/O
    path now that we had plenty of testing, and have I/O schedulers for
    blk-mq.  The module option to disable the blk-mq path is kept around for
    now.

    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

:040000 040000 57ec7d5d2ba76592a695f533a69f747700c31966
c79f6ecb070acc4fadf6fc05ca9ba32bc9c0c665 M      drivers

I'm using 'make olddefconfig' on kernel. Will doublecheck with different
kconfig options tomorrow.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

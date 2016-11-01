From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 186551] mkfs.ext4 tries to discard sector beyond the end of the
 device
Date: Tue, 01 Nov 2016 19:54:09 +0000
Message-ID: <bug-186551-13602-U6VWfSnm26@https.bugzilla.kernel.org/>
References: <bug-186551-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751743AbcKATyO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 1 Nov 2016 15:54:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 2FE8F20222
        for <linux-ext4@vger.kernel.org>; Tue,  1 Nov 2016 19:54:13 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id CE5D3203B8
        for <linux-ext4@vger.kernel.org>; Tue,  1 Nov 2016 19:54:09 +0000 (UTC)
In-Reply-To: <bug-186551-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=186551

--- Comment #10 from Tamas Vincze <tom@vincze.org> ---
# blkdiscard -v --offset 700G --step 1073741824 /dev/nvme0n1p1 
blkdiscard: /dev/nvme0n1p1: BLKDISCARD ioctl failed: Input/output error

[606050.283746] blk_update_request: I/O error, dev nvme0n1, sector 1547700224

# blkdiscard -v --length=700G /dev/nvme0n1p1
/dev/nvme0n1p1: Discarded 751619276800 bytes from the offset 0

Looks like it's having problems above 700G.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

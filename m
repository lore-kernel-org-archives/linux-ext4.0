From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 186551] mkfs.ext4 tries to discard sector beyond the end of the
 device
Date: Tue, 01 Nov 2016 19:04:40 +0000
Message-ID: <bug-186551-13602-ozXgbGOkMr@https.bugzilla.kernel.org/>
References: <bug-186551-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751469AbcKATEo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 1 Nov 2016 15:04:44 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 55C8620412
        for <linux-ext4@vger.kernel.org>; Tue,  1 Nov 2016 19:04:43 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 38BBF20437
        for <linux-ext4@vger.kernel.org>; Tue,  1 Nov 2016 19:04:41 +0000 (UTC)
In-Reply-To: <bug-186551-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=186551

--- Comment #5 from Tamas Vincze <tom@vincze.org> ---
It isn't in use yet, so here you go:

# blkdiscard -v /dev/nvme0n1p1 
blkdiscard: /dev/nvme0n1p1: BLKDISCARD ioctl failed: Input/output error

[602663.440080] blk_update_request: I/O error, dev nvme0n1, sector 1518338648
[602663.440106] blk_update_request: I/O error, dev nvme0n1, sector 1543504448
[602663.440124] blk_update_request: I/O error, dev nvme0n1, sector 1509950048
[602663.440143] blk_update_request: I/O error, dev nvme0n1, sector 1501561448
[602663.440160] blk_update_request: I/O error, dev nvme0n1, sector 1526727248
[602663.440178] blk_update_request: I/O error, dev nvme0n1, sector 1535115848
[602663.440196] blk_update_request: I/O error, dev nvme0n1, sector 1560281648
[602663.440234] blk_update_request: I/O error, dev nvme0n1, sector 1551893048

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

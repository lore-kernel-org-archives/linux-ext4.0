From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 186551] mkfs.ext4 tries to discard sector beyond the end of the
 device
Date: Tue, 01 Nov 2016 19:47:29 +0000
Message-ID: <bug-186551-13602-EreNYHTTTx@https.bugzilla.kernel.org/>
References: <bug-186551-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751280AbcKATrf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 1 Nov 2016 15:47:35 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 5E4D4203A4
        for <linux-ext4@vger.kernel.org>; Tue,  1 Nov 2016 19:47:33 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 3B17620454
        for <linux-ext4@vger.kernel.org>; Tue,  1 Nov 2016 19:47:30 +0000 (UTC)
In-Reply-To: <bug-186551-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=186551

--- Comment #9 from Tamas Vincze <tom@vincze.org> ---
# cat /sys/block/nvme0n1/discard_alignment
4096
# cat /sys/block/nvme0n1/queue/discard_granularity
4096
# cat /sys/block/nvme0n1/alignment_offset
0

I ran it with "-v" but wasn't verbose at all.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

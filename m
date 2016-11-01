From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 186551] mkfs.ext4 tries to discard sector beyond the end of the
 device
Date: Tue, 01 Nov 2016 19:41:10 +0000
Message-ID: <bug-186551-13602-Ef3ca9Oc9e@https.bugzilla.kernel.org/>
References: <bug-186551-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751743AbcKATlO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 1 Nov 2016 15:41:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 8F1D720458
        for <linux-ext4@vger.kernel.org>; Tue,  1 Nov 2016 19:41:12 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 77477203A4
        for <linux-ext4@vger.kernel.org>; Tue,  1 Nov 2016 19:41:10 +0000 (UTC)
In-Reply-To: <bug-186551-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=186551

--- Comment #7 from Eric Sandeen <sandeen@sandeen.net> ---
Those seem to be spaced out at roughly 4G boundaries - 4k short of 4G if my
math is right.  Not sure what that implies though.

You might try with "-v" and/or trying smaller step values with blkdiscard to
see if anything works.

What do /sys/block/nvme0n1/discard_alignment and
/sys/block/nvme0n1/queue/discard_granularity contain?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 186551] mkfs.ext4 tries to discard sector beyond the end of the
 device
Date: Tue, 01 Nov 2016 19:42:41 +0000
Message-ID: <bug-186551-13602-Bn0ZQeNqWI@https.bugzilla.kernel.org/>
References: <bug-186551-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751522AbcKATmp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 1 Nov 2016 15:42:45 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 0B6852045A
        for <linux-ext4@vger.kernel.org>; Tue,  1 Nov 2016 19:42:44 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 1F39B20443
        for <linux-ext4@vger.kernel.org>; Tue,  1 Nov 2016 19:42:42 +0000 (UTC)
In-Reply-To: <bug-186551-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=186551

--- Comment #8 from Eric Sandeen <sandeen@sandeen.net> ---
And maybe /sys/block/nvme0n1/alignment_offset as well - perhaps this is some
alignment problem with the discard requests, though I'd expect more than that
small handful if that were the problem.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

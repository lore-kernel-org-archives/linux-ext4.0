Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50198 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727481AbeLAC7C (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Nov 2018 21:59:02 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 50A1F30299
        for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2018 15:49:17 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Fri, 30 Nov 2018 15:49:17 +0000
Message-ID: <bug-201685-13602-JpavcnXDIj@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #89 from Jimmy.Jazz@gmx.net ---
To all,

Please add a large among of read-write mounted file systems attached to your
test system. That will increase the probability of the failure.
My experience is, the issue doesn't affect a specific mountpoint over and over
but rather a random one.

FYI, I didn't have any issue with one of the tmpfs filesystems installed. You
should take it into consideration when creating your VM test environment.

nilfs is stable.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

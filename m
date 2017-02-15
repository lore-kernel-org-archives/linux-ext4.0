From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194567] ext4 no longer mounts
Date: Wed, 15 Feb 2017 23:46:59 +0000
Message-ID: <bug-194567-13602-bxScjYr36I@https.bugzilla.kernel.org/>
References: <bug-194567-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50628 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755832AbdBOXrA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 15 Feb 2017 18:47:00 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D28C828592
        for <linux-ext4@vger.kernel.org>; Wed, 15 Feb 2017 23:46:59 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7D29C284CC
        for <linux-ext4@vger.kernel.org>; Wed, 15 Feb 2017 23:46:59 +0000 (UTC)
In-Reply-To: <bug-194567-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194567

--- Comment #5 from Theodore Tso (tytso@mit.edu) ---
The meta_bg feature allows file system resizing when (a) there is no
resize_inode, OR (b) when the file system has more than 2**32 blocks.   We
don't enable the meta_bg field and turn off resize_inode by default because for
smaller file systems on HDD's, using the meta_bg slows down the mount by a
little (since the block group descriptors get spread out across the disk).   So
in general the strategy is to use the resize_inode until the file system grows
beyond 2**32 blocks, and only then to switch on the meta_bg feature.   So I was
a bit surprised to see your smallish file system with meta_bg.   This is
supported primarily for debugging / development processes (so we can easily
test meta_bg without needing huge test disks), and not something I had
necessarily had intended for use in production.

(But thanks for being a guinea pig so we could find this bug!  :-)  :-)  :-)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

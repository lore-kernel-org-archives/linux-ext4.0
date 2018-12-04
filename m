Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:57516 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725764AbeLDIl1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 03:41:27 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 98B682AA37
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 08:41:26 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 08:41:25 +0000
Message-ID: <bug-201685-13602-9w5SbzPQ1C@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #219 from Ortwin Glück (odi@odi.ch) ---
#211
> Dropping dentry and inode cache (echo 2 > /proc/sys/vm/drop_caches) didn't
> resolve this, but dropping all caches (echo 3 > /proc/sys/vm/drop_caches)
> did.

So we have pagecache corruption. Sounds like a problem in vm code then. Is
anybody seeing the problem when there is no swap?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

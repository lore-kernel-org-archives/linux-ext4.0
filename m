Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54630 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbeK3VqO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Nov 2018 16:46:14 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 49CF62FC6D
        for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2018 10:37:23 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Fri, 30 Nov 2018 10:37:22 +0000
Message-ID: <bug-201685-13602-zFP2b2uIgg@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Andreas John (himself@derjohn.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |himself@derjohn.de

--- Comment #84 from Andreas John (himself@derjohn.de) ---
Hi,
thanks for investigating the issue. I "costed" my some inodes on my ext4 rootfs
, rMBP, SSD, dm-crypt disk. It appeared on 4.19.1 my case.

I just wanted to add that I run btrfs / dmcrypt /samessd on the /home and that
one is not affected by that issue as far as I can tell.

rgds,
j

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

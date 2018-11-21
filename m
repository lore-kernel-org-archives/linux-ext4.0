Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51814 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725903AbeKULKd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Nov 2018 06:10:33 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2D60429C33
        for <linux-ext4@vger.kernel.org>; Wed, 21 Nov 2018 00:38:35 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 21 Nov 2018 00:38:35 +0000
Message-ID: <bug-201685-13602-zN1FqLKaf7@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Jimmy.Jazz@gmx.net changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |Jimmy.Jazz@gmx.net

--- Comment #8 from Jimmy.Jazz@gmx.net ---
I could reproduce the issue. Probably not relevant but I had to modify the
initramfs script, 4.19.0 kernel for any reason changed the mdp raid major
number from 245 to 9 (i.e on a devtmpfs filesystem) and renamed them /dev/mdX
instead of /dev/md_dX as before. Partitions are now major 259. Also the md/lvm
devices became faster by the way. I tried ext4 mmp protection but without
success (i.e not a multi mount issue). 4.20.0-rc3 kernel gives the same sort of
issue. It is reproducible on an other amd64 machine with the same configuration
but different hardware.

Applications used for the test,
sys-fs/lvm2-2.02.173, sys-fs/mdadm-4.1, sys-fs/e2fsprogs-1.44.4,
sys-apps/coreutils-8.30, sys-apps/util-linux-2.33

More info in ext4_iget.txt.xz

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

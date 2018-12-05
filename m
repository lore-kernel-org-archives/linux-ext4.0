Return-Path: <SRS0=z94b=OO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55522 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726092AbeLEBIC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 20:08:02 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D4A942CACC
        for <linux-ext4@vger.kernel.org>; Wed,  5 Dec 2018 01:08:01 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 05 Dec 2018 01:08:00 +0000
Message-ID: <bug-201685-13602-JVWxgY1dpE@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Scott Ellis (scotte@warped.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |scotte@warped.com

--- Comment #259 from Scott Ellis (scotte@warped.com) ---
In my case (kernel 4.19.6 and a 2-vdev/6-drive raidz1) doing an rsync to/from
the same ZFS filesystem would generate ~1 error every 5s or so (on a random
drive on the pool).  With the patch from #255 I have been through 300GB of the
rsync w/o any errors.  Throughput of the rsync is identical before/after the
patch.

#255 feels like a good patch.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

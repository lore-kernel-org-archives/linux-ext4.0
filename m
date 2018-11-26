Return-Path: <SRS0=7vaa=OF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:36378 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726027AbeKZK4X (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 26 Nov 2018 05:56:23 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C296429920
        for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2018 00:04:03 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 26 Nov 2018 00:04:04 +0000
Message-ID: <bug-201685-13602-XctmgqJoeV@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #47 from Theodore Tso (tytso@mit.edu) ---
Bart, in #34, was the only thing which e2fsck reported this:

/dev/sda2: Inode 12190197 extent tree (at level 2) could be narrower.  IGNORED.

That's not a file system problem; it's a potential optimization which e2fsck
detected, which would eliminate a random 4k read when running random read
workload against that inode.  If you don't want to see this, you can use
e2fsck's  "-E fixes_only" option.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54782 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725379AbeLBQ6A (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 11:58:00 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D42182A9A9
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 16:57:57 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 16:57:57 +0000
Message-ID: <bug-201685-13602-QKgx1M949K@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Jukka Santala (donwulff@nic.fi) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |donwulff@nic.fi

--- Comment #150 from Jukka Santala (donwulff@nic.fi) ---
Whole block corrupted at once with each inode/file returning "Structure needs
cleaning" and bad extra_isizes in syslog while three hours in doing plain cp
-ax from ext4 to BTRFS mdraid in Ubuntu 18.04.1 mainline kernel 4.19.6 in init
level 1 (Ubuntu rescue mode with almost nothing else running).

Saved the corrupted block via debugfs, filesystem mounts read-only, dropped
disk caches and block is fine again with files accessible. Seeing if I can find
the corrupted block contents anywhere else in the filesystem. Error first
happened for me in 4.19.5 after running cleanly for days, now it comes
constantly.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

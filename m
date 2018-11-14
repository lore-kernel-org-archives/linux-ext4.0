Return-Path: <SRS0=wBZF=NZ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55922 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725756AbeKOHZh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 15 Nov 2018 02:25:37 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 825DE2BA40
        for <linux-ext4@vger.kernel.org>; Wed, 14 Nov 2018 21:20:44 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 14 Nov 2018 21:20:45 +0000
Message-ID: <bug-201685-13602-kvU6cR1NE1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Jason Gambrel (jaygambrel@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jaygambrel@gmail.com

--- Comment #1 from Jason Gambrel (jaygambrel@gmail.com) ---
Similar problems on Linux Mint 19 Tara using kernels 4.19.0 and 4.19.1

On rebooting my ASUS UX 430U laptop I ended up at the initramfs prompt and had
to run fsck to repair the root file system.  I was then able to continue
booting.  Sorry didn't save the log files.  This has happened randomly twice. 
I will post them if this happens again.

Did not happen under 4.18

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

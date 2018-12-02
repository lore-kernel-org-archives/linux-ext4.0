Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58706 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725290AbeLBDgt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 22:36:49 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 180612BCB2
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 03:36:48 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 03:36:47 +0000
Message-ID: <bug-201685-13602-0BL3dtJHzn@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Eric Benoit (eric@ecks.ca) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |eric@ecks.ca

--- Comment #126 from Eric Benoit (eric@ecks.ca) ---
FWIW I believe this issue is affecting ZFS as well. I'm getting the occasional
checksum error on a random drive of a RAID-Z configuration (five 4T WD Reds). 

I'd initially suspected a chipset (Intel 5400) issue as it's spread more or
less evenly across the devices. However it's definitely a software issue, as it
only occurs running kernel 4.19.[26] and disappears entirely with 4.18.20.

On a different workstation with ZFS and Seagate drives I haven't been able to
reproduce the issue.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

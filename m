Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34366 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725792AbeLCCbp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 21:31:45 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B2A342A91C
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 02:31:42 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 02:31:41 +0000
Message-ID: <bug-201685-13602-TUJxFjjMNx@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #180 from Eric Benoit (eric@ecks.ca) ---
I've been able to reproduce the issue on the other workstation I'd mentioned
earlier with ZFS:

NAME                        STATE     READ WRITE CKSUM
nipigon                     ONLINE       0     0     0 
  mirror-0                  ONLINE       0     0     0 
    wwn-0x5000c5006407e87e  ONLINE       0     0    17 
    wwn-0x5000c5004e4e92a9  ONLINE       0     0     6 

This isn't particularly hard to trigger; just a bunch of files filled with
/dev/urandom (64M*14000) being read back concurrently (eight processes) over
about 90 minutes.

Kernel version is 4.19.6 compiled with gcc 8.2.0 (Gentoo 8.2.0-r5 p1.6).

Have we any other ZFS users experiencing this?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

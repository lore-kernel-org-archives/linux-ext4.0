Return-Path: <SRS0=c0SX=OB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58720 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726280AbeKWGok (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 23 Nov 2018 01:44:40 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 981E02C1CE
        for <linux-ext4@vger.kernel.org>; Thu, 22 Nov 2018 20:03:45 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Thu, 22 Nov 2018 20:03:44 +0000
Message-ID: <bug-201685-13602-E6TjLxzoqx@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #36 from Bart Van Assche (bvanassche@acm.org) ---
(In reply to Reindl Harald from comment #35)
> > /dev/sda2: Inode 12190197 extent tree (at level 2) could be narrower. 
> > IGNORED
> 
> that is completly unrelated, i see that for years now on several machines
> and not cleaned up automatically and wasting my time to boot in rescure mode
> is not worth given the low importance of "could"

That's good to know. The reason I commented on this bug report and that I
replied that I hit data corruption is because my workstation failed to boot due
to fsck not being able to repair the file system automatically. I had to run
fsck manually, answer a long list of scary questions and reboot.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

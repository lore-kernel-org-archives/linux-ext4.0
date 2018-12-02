Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37042 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725729AbeLBLPa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 06:15:30 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 04E542C112
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 00:01:48 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 00:01:46 +0000
Message-ID: <bug-201685-13602-6bVHVd5FN6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #116 from Michael Orlitzky (michael@orlitzky.com) ---
Here are two other data points, just for the record:

  1. Like comment #65, I've only actually seen this corruption on three
physical 
     disks, and all of them were Western Digital Caviar Blacks. There is
another
     disk in my system -- a different model -- that has been lucky so far; but
     this may be pure chance. My /dev/sda has had multiple problems, but
     /dev/sdb only got corrupted once even though they're the same model.

  2. The corruption for me is occurring in files (contained in directories)
that 
     I haven't touched in a long time. They get backed up -- which means that
     they get read -- but few if any have been written recently. In addition,
     all of my mounts are "noatime." Normally I wouldn't expect corruption
     from *reading* files, which is what lead me to start swapping out disks
     and SATA controllers.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

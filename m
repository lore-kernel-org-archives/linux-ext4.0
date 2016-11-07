From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187051] "orphan list check failed" error in ext4
Date: Mon, 07 Nov 2016 10:40:32 +0000
Message-ID: <bug-187051-13602-MNNoK5uJPZ@https.bugzilla.kernel.org/>
References: <bug-187051-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750980AbcKGKkh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 7 Nov 2016 05:40:37 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id A8A6E20222
        for <linux-ext4@vger.kernel.org>; Mon,  7 Nov 2016 10:40:34 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 7EBCD201F2
        for <linux-ext4@vger.kernel.org>; Mon,  7 Nov 2016 10:40:32 +0000 (UTC)
In-Reply-To: <bug-187051-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=187051

--- Comment #2 from Hussam Al-Tayeb <me@hussam.eu.org> ---
I will post a backtrace of the crash if it happens again.
I had written down the output of the inode check on a paper.

debugfs -R 'ncheck 54264316' /dev/dm-0 
debugfs 1.43.3 (04-Sep-2016)
Inode Pathname
54264316 /usr/share/help/oc/totem/figures

I should be more or less correct since I wrote the whole thing on paper.
The folder itself exists.

The only thing I remember which may have touched this folder since it was last
modified on the 25th of october is that I rebooted to the rescue usb disk once
and did a e4defrag. but I do no even remember the date when I did so.

tune2fs -l /dev/mapper/root says:
Mount count:              1
Maximum mount count:      1
My hard disks are all fscked at reboots.

I will monitor if this happens again and post a full log.
Thank you for the instructions.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

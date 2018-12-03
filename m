Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46646 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725785AbeLCBuW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 20:50:22 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 135F02A775
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 01:50:20 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 01:50:19 +0000
Message-ID: <bug-201685-13602-AU33UMExcF@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #179 from Theodore Tso (tytso@mit.edu) ---
Michael Orlitzky: In your report, you've indicated that you've only been seeing
bugs in files that are being *read* and that these were files that were written
long ago.    If you reboot, or drop caches using "echo 3 >
/proc/sys/vm/drop_caches" do the files stay corrupted?    Some of the reports
(but not others) seem to indicate the problem is happening on read, not on
write.  Of course, some of the reports are relating to metadata blocks getting
corrupted on read, while your report is about data blocks getting reported on
read. 

Thanks!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

Return-Path: <SRS0=z94b=OO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56036 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726037AbeLEGbi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Dec 2018 01:31:38 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 668DB2C7EB
        for <linux-ext4@vger.kernel.org>; Wed,  5 Dec 2018 06:31:38 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 05 Dec 2018 06:31:36 +0000
Message-ID: <bug-201685-13602-EK59iQZOn1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #262 from Néstor A. Marchesini (nestorm_des@hotmail.com) ---
I have patched with #255 Jens Axboe 4.19/4.20 patch v3 to my trees 4.19.0
4.19.5 4.19.6 and I can say that for the first time I am able to use 4.19.0
reading #259 reminds me that every time I updated I started having problems
with rsync and I had to do it several times to get it right ... I innocently
thought it was a problem in the repository.
I was investigating my hdds in case they did not have real physical problems
but:

# smartctl -H /dev/sda
SMART overall-health self-assessment test result: PASSED

# smartctl -H /dev/sdb
SMART overall-health self-assessment test result: PASSED

Very glad that the cause of the evils has been found ...to see that it
continues now.

$ uname -r
Linux pc-user 4.19.0-gentoo

Regards

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43220 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725904AbeLDWMJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 17:12:09 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 951BB2C88E
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 22:12:08 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 22:12:06 +0000
Message-ID: <bug-201685-13602-APfI0zbCL6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #251 from Guenter Roeck (linux@roeck-us.net) ---
#248: Looks like you may be running my reproducer script. It tends to do that,
especially on slow drives (ie anything but nvme), depending on the io scheduler
used. I have seen it with "cfq", but not with "none". iostat would probably
show you 90+ % iowait when it happens. That by itself does not indicate the
error we are trying to track down here.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

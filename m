Return-Path: <SRS0=vjzE=OW=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40378 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729093AbeLMQMV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Dec 2018 11:12:21 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 231622C637
        for <linux-ext4@vger.kernel.org>; Thu, 13 Dec 2018 16:12:21 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 151491] free space lossage on busy system with bigalloc enabled
 and 128KB cluster
Date: Thu, 13 Dec 2018 16:12:21 +0000
Message-ID: <bug-151491-13602-VXACgmQuVT@https.bugzilla.kernel.org/>
In-Reply-To: <bug-151491-13602@https.bugzilla.kernel.org/>
References: <bug-151491-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=151491

--- Comment #22 from Eric Whitney (enwlinux@gmail.com) ---
Very good - thanks for the testing!  I'll close this bug out at the end of the
4.20 release cycle if no negative test results are reported by then.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

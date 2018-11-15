Return-Path: <SRS0=JALT=N2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34420 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387839AbeKPCvi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 15 Nov 2018 21:51:38 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3A2782CB62
        for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2018 16:43:05 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Thu, 15 Nov 2018 16:43:04 +0000
Message-ID: <bug-201685-13602-415HyBjm3c@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #4 from Theodore Tso (tytso@mit.edu) ---
Thanks for pointing out that bug.   I'll note that the poster who
authoritatively claimed that 4.19 is safe, and the bug obviously was introduced
in 4.19.1 didn't bother to do a "git log --stat v4.19 v4.19.1".   This would
show that the changes were all in the Sparc architecture support, networking
drivers, the networking stack, and a one-line change in the crypto
subsystem....

This is why I always tell users to report symptoms, not diagnosis.   And for
sure, not to bias their observations by their their certainty that they have
diagnosed the problem.    (If they think they have diagnosed the problem, send
me a patch, preferably with a reliable repro so we can add a regression test. 
:-)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

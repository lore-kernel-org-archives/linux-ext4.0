Return-Path: <SRS0=J55O=OU=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:38192 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726340AbeLKS57 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 11 Dec 2018 13:57:59 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5AB9A2B64B
        for <linux-ext4@vger.kernel.org>; Tue, 11 Dec 2018 18:57:58 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 151491] free space lossage on busy system with bigalloc enabled
 and 128KB cluster
Date: Tue, 11 Dec 2018 18:57:58 +0000
Message-ID: <bug-151491-13602-3pkwdh5Y9f@https.bugzilla.kernel.org/>
In-Reply-To: <bug-151491-13602@https.bugzilla.kernel.org/>
References: <bug-151491-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=151491

--- Comment #21 from Betacentauri (betacentauri@arcor.de) ---
Thanks for the patches!

In kvm-xfstests environment with a 4.20-rc6 kernel I cannot reproduce the bug
anymore. I also created a tmpfs with several big files to reduce free memory,
but still there are no problems :-)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41834 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725792AbeLCCxq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 21:53:46 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 63D6D2A914
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 02:53:44 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 02:53:43 +0000
Message-ID: <bug-201685-13602-C2HMocpd3E@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #182 from Guenter Roeck (linux@roeck-us.net) ---
As for where problems are seen, for my part the problem is seen mostly when
trying to read files created recently as part of kernel builds. The problems
are reported with reads, but writes are definitely involved, at least for me.

As for blaming gcc, or Ubuntu, or both, I would kindly like to remind people
that I see the problem on two systems out of four running v4.19.x kernels, all
with the same kernel build and configuration.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

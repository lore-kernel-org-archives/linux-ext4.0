Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49752 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726116AbeLCPKN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2018 10:10:13 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7BBB32B15D
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 15:10:08 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 15:10:07 +0000
Message-ID: <bug-201685-13602-W7qTw8l9lR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #201 from Eric Benoit (eric@ecks.ca) ---
Is it remotely possible this has to do with SPECTRE mitigation updates?

I'm assuming everyone has these enabled. Anyone with this issue that doesn't?
Have we seen it with AMD processors, or non-x86 even?

I should note the affected systems I've mentioned are Intel Core2 era. I
haven't been able to trigger it on an older AMD system, but that's using ext4.

I'll pull up my sleeves and put in some effort to sort this out later today.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

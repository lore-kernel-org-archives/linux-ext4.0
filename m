Return-Path: <SRS0=7vaa=OF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47994 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726260AbeK0D3T (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 26 Nov 2018 22:29:19 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 6F6B8294D2
        for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2018 16:34:41 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 26 Nov 2018 16:34:40 +0000
Message-ID: <bug-201685-13602-Bd7XD4BPUp@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #53 from Rainer Fiebig (jrf@mailbox.org) ---
[...]
> 
> I must admit, it is time consuming.

You have been warned. ;)

But in the end you will be rewarded with something like this:

> git bisect good
1234xx56789yy is the first bad commit
...

And honors and glory will rain down on you!
OK, this may be a bit exaggerated. ;)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

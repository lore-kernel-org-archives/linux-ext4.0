Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51866 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725811AbeLCDei (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 22:34:38 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 329702A94B
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 03:34:34 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 03:34:33 +0000
Message-ID: <bug-201685-13602-FWmzxRozuV@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #185 from Eric Benoit (eric@ecks.ca) ---
(In reply to Guenter Roeck from comment #181)
> #180: Eric, would you mind sharing the script used to create the files and
> to read them back ?

Just a pair of trivial one-liners:

for i in {00000..13999}; do echo dd bs=1M count=64 if=/dev/urandom of=urand.$i;
done

for i in urand.*; do echo dd bs=1M if=$i of=/dev/null; done | parallel -j8

I'm using /dev/urandom since I have lz4 compression enabled. I imagine
/dev/zero would be just as effective if you don't.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

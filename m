Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56468 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725790AbeLCEGU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 23:06:20 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 896022AB3B
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 04:06:19 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 04:06:18 +0000
Message-ID: <bug-201685-13602-L4gQNsj8RN@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #188 from Eric Benoit (eric@ecks.ca) ---
(In reply to Eric Benoit from comment #185)
> for i in {00000..13999}; do echo dd bs=1M count=64 if=/dev/urandom
> of=urand.$i; done

Er whoops, might want to remove the echo or pipe it to parallel.

I'm repeating things under 4.18.20 just for comparison. It's been about an hour
now without a single checksum error reported.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

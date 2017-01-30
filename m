From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187051] "orphan list check failed" error in ext4
Date: Mon, 30 Jan 2017 02:21:28 +0000
Message-ID: <bug-187051-13602-j5PrG69DdB@https.bugzilla.kernel.org/>
References: <bug-187051-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750900AbdA3C3c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 29 Jan 2017 21:29:32 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 844C3202FF
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 02:21:30 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 67A05202AE
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 02:21:28 +0000 (UTC)
In-Reply-To: <bug-187051-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=187051

--- Comment #17 from Theodore Tso <tytso@mit.edu> ---
So you're seeing it on both 4.9 and 4.8, correct?

How reliably can you reproduce the failure?

It's possible turning off metadata_csum might make a difference, although it
would seem surprising since the expected failure modes would involve checksum
failures, and that's not what you're seeing.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

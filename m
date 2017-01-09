From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 192131] Hang up at boot time [<c0c4d1ac>] (io_schedule_timeout)
 from [<c0c4e344>] (bit_wait_i)
Date: Mon, 09 Jan 2017 06:00:08 +0000
Message-ID: <bug-192131-13602-Ro208uTJHT@https.bugzilla.kernel.org/>
References: <bug-192131-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752139AbdAIGAM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 9 Jan 2017 01:00:12 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 631FB20306
        for <linux-ext4@vger.kernel.org>; Mon,  9 Jan 2017 06:00:10 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 27550202EC
        for <linux-ext4@vger.kernel.org>; Mon,  9 Jan 2017 06:00:09 +0000 (UTC)
In-Reply-To: <bug-192131-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=192131

--- Comment #1 from Myy <bugux@miouyouyou.fr> ---
It turns out that compiling kernels up to the following commit work:

92c020d08d83673ecd15a9069d4457378668da31

Then after this one, I got the reported problem:

7b9dc3f75fc8be046e76387a22a21f421ce55b53

It seems that it's really a scheduler problem, and not a filesystem problem. If
you're administrator, feel free to move this to the right section.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

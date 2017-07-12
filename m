From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196223] jdb2 journal - hung after suspend-resume test
Date: Wed, 12 Jul 2017 14:17:57 +0000
Message-ID: <bug-196223-13602-9dYlqa4shP@https.bugzilla.kernel.org/>
References: <bug-196223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45234 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750927AbdGLOR7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 12 Jul 2017 10:17:59 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A3F17285E7
        for <linux-ext4@vger.kernel.org>; Wed, 12 Jul 2017 14:17:58 +0000 (UTC)
In-Reply-To: <bug-196223-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196223

--- Comment #26 from Theodore Tso (tytso@mit.edu) ---
OK, so this is a block_mq failure.   I recommend you send a report to
linux-block@vger.kernel.org and cc Jens Axboe <axboe@kernel.dk>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

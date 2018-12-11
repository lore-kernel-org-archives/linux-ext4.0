Return-Path: <SRS0=J55O=OU=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40056 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727280AbeLKQo4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 11 Dec 2018 11:44:56 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id DB46C2B4E7
        for <linux-ext4@vger.kernel.org>; Tue, 11 Dec 2018 16:44:55 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 151491] free space lossage on busy system with bigalloc enabled
 and 128KB cluster
Date: Tue, 11 Dec 2018 16:44:56 +0000
Message-ID: <bug-151491-13602-o2dkz0OUvH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-151491-13602@https.bugzilla.kernel.org/>
References: <bug-151491-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=151491

--- Comment #20 from Eric Whitney (enwlinux@gmail.com) ---
4.20 contains patches that correct delalloc cluster accounting for bigalloc
file systems.  They were merged at the beginning of the release cycle. See
"ext4: generalize extents status tree search functions" (ad431025aecd) and the
following five patches.  They should address all the problems described in this
bugzilla.

Any independent testing would be appreciated.  I'd recommend working with the
latest mainline rc available at this time, which is 4.20-rc6.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

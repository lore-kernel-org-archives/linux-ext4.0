From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197045] renameat2 rename_noreplace
Date: Tue, 24 Oct 2017 19:22:10 +0000
Message-ID: <bug-197045-13602-QXwwiX9iFo@https.bugzilla.kernel.org/>
References: <bug-197045-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:38072 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751280AbdJXTWZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 24 Oct 2017 15:22:25 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B04CA289F6
        for <linux-ext4@vger.kernel.org>; Tue, 24 Oct 2017 19:22:24 +0000 (UTC)
In-Reply-To: <bug-197045-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=197045

--- Comment #5 from Elvis Stansvik (elvstone@gmail.com) ---
Martin: I've just discovered that I only see this problem when on my eCryptfs
encrypted home directory, not when testing in e.g. /tmp (unencrypted). Are you
also using eCryptfs?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

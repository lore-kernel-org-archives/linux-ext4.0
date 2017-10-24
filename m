From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197045] renameat2 rename_noreplace
Date: Tue, 24 Oct 2017 21:42:06 +0000
Message-ID: <bug-197045-13602-h4GPZrvH2g@https.bugzilla.kernel.org/>
References: <bug-197045-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53966 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751277AbdJXVmJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 24 Oct 2017 17:42:09 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B709428A5F
        for <linux-ext4@vger.kernel.org>; Tue, 24 Oct 2017 21:42:08 +0000 (UTC)
In-Reply-To: <bug-197045-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=197045

--- Comment #13 from Elvis Stansvik (elvstone@gmail.com) ---
Indeed, I'll file an LP bug and try to ping Tyler. Who knows, perhaps they're
already planning to switch to encrypted ext4 (thanks for testing that Ted).

And thanks to Thiago for being so quick with the Qt fix (I ran into this
behavior by way of Qt).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

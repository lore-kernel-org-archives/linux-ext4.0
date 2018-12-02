Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60634 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725710AbeLBUri (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 15:47:38 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A30732A77F
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 20:47:34 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 20:47:33 +0000
Message-ID: <bug-201685-13602-ZDz3o04gOj@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #166 from Jukka Santala (donwulff@nic.fi) ---
However, at least here:
cat /proc/version
Linux version 4.19.6-041906-generic (kernel@gloin) (gcc version 8.2.0 (Ubuntu
8.2.0-9ubuntu1)) #201812010432 SMP Sat Dec 1 09:34:07 UTC 2018

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

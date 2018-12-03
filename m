Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44236 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725785AbeLCA2r (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 19:28:47 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id DFE692A22E
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 00:28:42 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 00:28:41 +0000
Message-ID: <bug-201685-13602-fFJ1lxTm9C@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #171 from Guenter Roeck (linux@roeck-us.net) ---
To reiterate, I use gcc version "5.4.0-6ubuntu1~16.04.10" to build my kernels.
Also, I build the kernels on a system not affected by the problem. It may well
be that a compiler problem in gcc 8.2.0 causes additional trouble, but it is
not the trouble observed on my affected systems.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

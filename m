From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111961] ext4 umount - invalid opcode with PLEXTOR
 PX-128M6G-2242
Date: Mon, 06 Mar 2017 20:29:04 +0000
Message-ID: <bug-111961-13602-4XgqyKlwSe@https.bugzilla.kernel.org/>
References: <bug-111961-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40522 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932118AbdCFU3F (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Mar 2017 15:29:05 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id ABEFB2841D
        for <linux-ext4@vger.kernel.org>; Mon,  6 Mar 2017 20:29:04 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 65E6928427
        for <linux-ext4@vger.kernel.org>; Mon,  6 Mar 2017 20:29:04 +0000 (UTC)
In-Reply-To: <bug-111961-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=111961

--- Comment #10 from Szőgyényi Gábor (szg0000@freemail.hu) ---
Please try to reproduce this bug with latest kernel image.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

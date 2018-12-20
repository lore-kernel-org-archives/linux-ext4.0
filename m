Return-Path: <SRS0=ry50=O5=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44180 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725710AbeLTIfG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 20 Dec 2018 03:35:06 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F3990285BD
        for <linux-ext4@vger.kernel.org>; Thu, 20 Dec 2018 08:35:05 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Thu, 20 Dec 2018 08:35:06 +0000
Message-ID: <bug-201631-13602-3oQRwokKjM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #30 from Aneesh Kumar KV (aneesh.kumar@linux.ibm.com) ---
Dez 19 23:53:25 T1000 kernel: Clean page (index 72, ino 681324, i_size 715000,
flags 3ffe0000002016) with dirty PTE (pte_val c0000006d3ea9186) on unmap!

Those pte bits value doesn't look correct. We expect the pfn value to be  64k
aligned. ie, I should have found the last 4 values to be 0186. What is the page
size configured? is that 64K?

-aneesh

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

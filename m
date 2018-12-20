Return-Path: <SRS0=ry50=O5=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50962 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727694AbeLTEVm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 19 Dec 2018 23:21:42 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 37E9F28824
        for <linux-ext4@vger.kernel.org>; Thu, 20 Dec 2018 04:21:42 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Thu, 20 Dec 2018 04:21:41 +0000
Message-ID: <bug-201631-13602-OYzYHxizAH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #26 from aneesh.kumar@linux.ibm.com ---
Dez 19 23:53:09 T1000 kernel: BUG: Bad rss-counter state mm:0000000065804292
idx:1 val:2
Dez 19 23:53:09 T1000 kernel: BUG: non-zero pgtables_bytes on freeing mm: 16384

I am wondering whether we have a wrong usage of a page here? One of the feature
we enabled in the the recent kernel is THP migration
(a0820ff33451aa1a12ec66812e229ac58beb3f24) . But I guess we are not using that
feature. Maybe to isolate this further, can we disable transparent huge page
for all the tests?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

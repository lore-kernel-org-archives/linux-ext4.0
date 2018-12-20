Return-Path: <SRS0=ry50=O5=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50442 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727694AbeLTEPQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 19 Dec 2018 23:15:16 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 488392866F
        for <linux-ext4@vger.kernel.org>; Thu, 20 Dec 2018 04:15:16 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Thu, 20 Dec 2018 04:15:15 +0000
Message-ID: <bug-201631-13602-vLhTCyuRHs@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

aneesh.kumar@linux.ibm.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |aneesh.kumar@linux.ibm.com

--- Comment #25 from aneesh.kumar@linux.ibm.com ---
(In reply to Benjamin Herrenschmidt from comment #24)
> Out of curiosity, how does this work in the context of pages that are GUPed
> either by a driver or by KVM when using file backed guest memory ?
> 
> GUP will not "see" the mkclean or attempt at making read only...

page_mkclean_one do call
        mmu_notifier_invalidate_range_start(vma->vm_mm, start, end);

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

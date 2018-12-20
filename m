Return-Path: <SRS0=ry50=O5=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40576 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbeLTHtD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 20 Dec 2018 02:49:03 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id EAC28283AD
        for <linux-ext4@vger.kernel.org>; Thu, 20 Dec 2018 07:49:02 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Thu, 20 Dec 2018 07:49:03 +0000
Message-ID: <bug-201631-13602-M8ddelnow1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #28 from Jan Kara (jack@suse.cz) ---
(In reply to Benjamin Herrenschmidt from comment #24)
> Out of curiosity, how does this work in the context of pages that are GUPed
> either by a driver or by KVM when using file backed guest memory ?
> 
> GUP will not "see" the mkclean or attempt at making read only...

That's a good question :) Well behaved GUP users use mmu notifiers as Aneesh
wrote to "see" mkclean. Badly behaved GUP users (and there's quite a few of
them) don't and that can result in kernel crashes, data loss, or checksum
failures in storage stack. The latest discussion on this topic is here if
you're interested: https://lwn.net/Articles/774411/

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

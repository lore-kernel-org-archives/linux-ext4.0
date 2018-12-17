Return-Path: <SRS0=0ehA=O2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58670 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726767AbeLQMPm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 17 Dec 2018 07:15:42 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 99F56298BE
        for <linux-ext4@vger.kernel.org>; Mon, 17 Dec 2018 12:15:41 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Mon, 17 Dec 2018 12:15:41 +0000
Message-ID: <bug-201631-13602-5XPvGsQ3az@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #15 from Jan Kara (jack@suse.cz) ---
rc6 or rc7 doesn't really matter. You can apply the patch as any other kernel
patch:

cd "kernel-source-directory"
patch -p1 <"downloaded-patch"

now compile & install the kernel - I'm assuming that since you test rcs, you
know how to do that. If not, I can dig out some instructions for that.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

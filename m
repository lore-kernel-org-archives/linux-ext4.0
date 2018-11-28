Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58956 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729103AbeK2EV7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Nov 2018 23:21:59 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A15EF2D9A7
        for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2018 17:19:38 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Wed, 28 Nov 2018 17:19:39 +0000
Message-ID: <bug-201631-13602-dUHSKjHOgl@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #7 from erhard_f@mailbox.org ---
Created attachment 279715
  --> https://bugzilla.kernel.org/attachment.cgi?id=279715&action=edit
kernel config (4.20-rc4)

The 2nd lockup from this bug seems reproducible. Happens every time at a
certain stage when I try to build clang-7.0.1-rc2 when running the Talos II on
kernel 4.20-rc4. I need to sigkill the build process or it stalls forever. When
I run the machine on kernel 4.19.5 the build runs flawlessly, no lockups.

Building takes place on a zram-partition (842 compressed, ext4), root
filesystem is btrfs (zstd compressed).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

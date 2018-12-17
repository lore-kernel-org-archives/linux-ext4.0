Return-Path: <SRS0=0ehA=O2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45502 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726660AbeLQRua (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 17 Dec 2018 12:50:30 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 288732A20E
        for <linux-ext4@vger.kernel.org>; Mon, 17 Dec 2018 17:50:30 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Mon, 17 Dec 2018 17:50:28 +0000
Message-ID: <bug-201631-13602-vxcTtVw9oQ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #18 from erhard_f@mailbox.org ---
Created attachment 280057
  --> https://bugzilla.kernel.org/attachment.cgi?id=280057&action=edit
journalctl -k (4.20-rc7 on a Talos II)

Ok, here we go now. The bug has been triggered again by building a large
project (llvm), seemingly during the install phase. Building takes place on a
zram-partition (lz4 compressed, ext4), root filesystem is btrfs (zstd
compressed).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

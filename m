Return-Path: <SRS0=EV/E=O6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34542 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729720AbeLUA0P (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 20 Dec 2018 19:26:15 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2723427F60
        for <linux-ext4@vger.kernel.org>; Fri, 21 Dec 2018 00:26:15 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Fri, 21 Dec 2018 00:26:15 +0000
Message-ID: <bug-201631-13602-tUbLDvhdb6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #33 from Benjamin Herrenschmidt (benh@kernel.crashing.org) ---
Jan,

For KVM, it can... you can back the guest using a file, and there's some
interest in doing just that to back guests using large "new memory" pmem stuff
for example.

This actually leads to more generic variant of that issue which is the need to
be able to provide proper "pinned" memory for some adapters in guest even if
they use ATSD, as not all adapters can deal with faults on everything (for
example they might be able to deal with fault on user buffers but not the
descriptor ring).

A discussion for another day I suppose..

As for AMD, I was looking at attachment
https://bugzilla.kernel.org/attachment.cgi?id=280057 posted in comment 18

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

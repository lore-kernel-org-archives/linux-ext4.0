Return-Path: <SRS0=0ehA=O2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43514 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726660AbeLQLaB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 17 Dec 2018 06:30:01 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 593EC29B82
        for <linux-ext4@vger.kernel.org>; Mon, 17 Dec 2018 11:30:00 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Mon, 17 Dec 2018 11:30:00 +0000
Message-ID: <bug-201631-13602-orn9ezDr1w@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #13 from Jan Kara (jack@suse.cz) ---
Created attachment 280051
  --> https://bugzilla.kernel.org/attachment.cgi?id=280051&action=edit
mm: Dump page and PTE state

Erhard, could you please run your machines with this patch applied and report
what gets recorded when the warning hits again? Thanks!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

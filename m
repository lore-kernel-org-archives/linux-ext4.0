Return-Path: <SRS0=xLGb=PZ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39454 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726952AbfAQLs4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 17 Jan 2019 06:48:56 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7F19D2C2C7
        for <linux-ext4@vger.kernel.org>; Thu, 17 Jan 2019 11:48:55 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Thu, 17 Jan 2019 11:48:54 +0000
Message-ID: <bug-201631-13602-iBWFEVeMeS@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

Jan Kara (jack@suse.cz) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Attachment #280103|0                           |1
        is obsolete|                            |

--- Comment #44 from Jan Kara (jack@suse.cz) ---
Created attachment 280551
  --> https://bugzilla.kernel.org/attachment.cgi?id=280551&action=edit
mm: Dump page and PTE state and some history (v3)

OK, new version of the debug patch that also tracks when last PTE for a page
got set and dumps some more information about VMA and the page. Please report
what the kernel prints now. Thanks a lot!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

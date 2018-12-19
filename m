Return-Path: <SRS0=7ScE=O4=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:48130 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729603AbeLSRDd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 19 Dec 2018 12:03:33 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 607952B57E
        for <linux-ext4@vger.kernel.org>; Wed, 19 Dec 2018 17:03:32 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Wed, 19 Dec 2018 17:03:32 +0000
Message-ID: <bug-201631-13602-8daAlnZ2qn@https.bugzilla.kernel.org/>
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
 Attachment #280051|0                           |1
        is obsolete|                            |

--- Comment #22 from Jan Kara (jack@suse.cz) ---
Created attachment 280097
  --> https://bugzilla.kernel.org/attachment.cgi?id=280097&action=edit
mm: Dump page and PTE state and some history

New debug patch to try which will also dump more about what was happening with
the page. Can you please try running with this patch and report when the
warning hits? Thanks!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

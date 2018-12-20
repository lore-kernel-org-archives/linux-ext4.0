Return-Path: <SRS0=ry50=O5=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40058 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728949AbeLTHla (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 20 Dec 2018 02:41:30 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C2AC328646
        for <linux-ext4@vger.kernel.org>; Thu, 20 Dec 2018 07:41:29 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Thu, 20 Dec 2018 07:41:28 +0000
Message-ID: <bug-201631-13602-UQ4TvPeg1m@https.bugzilla.kernel.org/>
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
 Attachment #280097|0                           |1
        is obsolete|                            |

--- Comment #27 from Jan Kara (jack@suse.cz) ---
Created attachment 280103
  --> https://bugzilla.kernel.org/attachment.cgi?id=280103&action=edit
mm: Dump page and PTE state and some history (v2)

I'm sorry but the patch had a bug and didn't set time when page_mkwrite() has
been called for the most common ext4 path which is taken on your machine. Here
is a fixed up patch. Can you please test again!

Also it seems you are now able to trigger the warning in under an hour? In that
case it would be plausible to bisect the kernel if the directed debugging
fails. We'll see...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

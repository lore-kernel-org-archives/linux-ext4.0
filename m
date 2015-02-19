From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 93491] Kernel crashes every 10 minutes. Computer stalls
Date: Thu, 19 Feb 2015 16:13:47 +0000
Message-ID: <bug-93491-13602-Lzk0OY39BZ@https.bugzilla.kernel.org/>
References: <bug-93491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43748 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbbBSQNv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Feb 2015 11:13:51 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B896820274
	for <linux-ext4@vger.kernel.org>; Thu, 19 Feb 2015 16:13:50 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 42C82202BE
	for <linux-ext4@vger.kernel.org>; Thu, 19 Feb 2015 16:13:48 +0000 (UTC)
In-Reply-To: <bug-93491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=93491

Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com

--- Comment #1 from Eric Sandeen <sandeen@redhat.com> ---
in static void ext4_mb_use_inode_pa(),

    BUG_ON(start < pa->pa_pstart);
    BUG_ON(end > pa->pa_pstart + EXT4_C2B(sbi, pa->pa_len));
    BUG_ON(pa->pa_free < len);  <<<<---- here

It'd be good to have full dmesg etc, this is a pretty sparse bug report.  Did a
fedora bug get filed from abrt?

It might be worth booting a rescue environment and capturing an e2image -r or
e2iamge -q of the filesystem, to see if this is caused by on-disk corruption
somehow.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

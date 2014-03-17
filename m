From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 72181] ext4_mb_generate_buddy:free block calculation seems to
 overflow
Date: Mon, 17 Mar 2014 02:08:42 +0000
Message-ID: <bug-72181-13602-peq0OKLQhX@https.bugzilla.kernel.org/>
References: <bug-72181-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36600 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129AbaCQCIo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Mar 2014 22:08:44 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E66B5201F5
	for <linux-ext4@vger.kernel.org>; Mon, 17 Mar 2014 02:08:43 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 8ABEA201DD
	for <linux-ext4@vger.kernel.org>; Mon, 17 Mar 2014 02:08:42 +0000 (UTC)
In-Reply-To: <bug-72181-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=72181

--- Comment #2 from WeiZhang <zweiustc@gmail.com> ---
(In reply to WeiZhang from comment #1)
> usually, we just get a wrong number of "free" from bitmap while bitmap is
> corrupted. but it should not larger than "max = EXT4_CLUSTERS_PER_GROUP(sb)"
> right?

i add some printk and confirmed there is some wrong in ext4_grp_locked_error.
the "free" is in the right range. Seems that the bitmap is still corrupted with
the patch(ext4: fix the free blocks calculation for ext3 file systems w/
uninit_bg). I will look into it right now. Thx

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

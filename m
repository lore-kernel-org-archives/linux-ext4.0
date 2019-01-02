Return-Path: <SRS0=jZge=PK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53558 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727864AbfABPKL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jan 2019 10:10:11 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 19DA428932
        for <linux-ext4@vger.kernel.org>; Wed,  2 Jan 2019 15:10:11 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Wed, 02 Jan 2019 15:10:10 +0000
Message-ID: <bug-201631-13602-xKaJXT0Sp2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #39 from Jan Kara (jack@suse.cz) ---
(In reply to erhard_f from comment #35)
> Created attachment 280117 [details]
> journalctl -k (4.20-rc7 on a Talos II)
> 
> Results with latest patch.

Thanks for the results! Erhard, are you sure this kernel was with the latest
version of the patch? Because the line:

page 137: b_state 21, b_blocknr 2726281, b_mapped 0, b_cleaned 1498120697108,
now 1498125595648

shows that b_mapped is zero effectively meaning that ext4_block_mkwrite() was
never called for the page. Which would be very strange for a page that has
writeable PTE.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

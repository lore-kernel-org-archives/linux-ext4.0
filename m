From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] Suspicious persistent EXT4-fs error:
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Mon, 24 Apr 2017 16:53:34 +0000
Message-ID: <bug-195561-13602-haykqp8imm@https.bugzilla.kernel.org/>
References: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44388 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1173486AbdDXQxh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 24 Apr 2017 12:53:37 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B74F426B41
        for <linux-ext4@vger.kernel.org>; Mon, 24 Apr 2017 16:53:36 +0000 (UTC)
In-Reply-To: <bug-195561-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

--- Comment #8 from Andreas Dilger (adilger.kernelbugzilla@dilger.ca) ---
Also, I don't think the "Lustre HACK that avoids the ext4_error() and signals
an ext4_warning()" patch is all that bad, and I wouldn't be against landing it.
 I think bitmap corruption can happen for a large number of reasons, and
localizing the problems to a single block group can avoid taking the whole
server out.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

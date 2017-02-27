From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194695] size overflow detected in function ext4_mb_new_group_pa
Date: Mon, 27 Feb 2017 20:55:18 +0000
Message-ID: <bug-194695-13602-Ue2yLGB1fr@https.bugzilla.kernel.org/>
References: <bug-194695-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:52808 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751039AbdB0VMm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 27 Feb 2017 16:12:42 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8A655282E8
        for <linux-ext4@vger.kernel.org>; Mon, 27 Feb 2017 20:55:26 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 580D9282E8
        for <linux-ext4@vger.kernel.org>; Mon, 27 Feb 2017 20:55:26 +0000 (UTC)
In-Reply-To: <bug-194695-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194695

Andreas Dilger (adilger.kernelbugzilla@dilger.ca) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |adilger.kernelbugzilla@dilg
                   |                            |er.ca

--- Comment #1 from Andreas Dilger (adilger.kernelbugzilla@dilger.ca) ---
Definitely looks like a real bug in:

        pa->pa_pstart = ext4_grp_offs_to_block(sb, &ac->ac_b_ex);
        pa->pa_lstart = pa->pa_pstart;

pa_pstart is 64-bit, pa_lstart is 32-bit.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

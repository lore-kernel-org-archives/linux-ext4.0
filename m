From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194739] fallocate --collapse-range causes temporal data
 corruption on fragmented file
Date: Wed, 15 Mar 2017 17:48:30 +0000
Message-ID: <bug-194739-13602-8sHD4Telsc@https.bugzilla.kernel.org/>
References: <bug-194739-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56250 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751100AbdCOR47 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 15 Mar 2017 13:56:59 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D9E1928665
        for <linux-ext4@vger.kernel.org>; Wed, 15 Mar 2017 17:48:40 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 077BC28665
        for <linux-ext4@vger.kernel.org>; Wed, 15 Mar 2017 17:48:40 +0000 (UTC)
In-Reply-To: <bug-194739-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194739

Ivan Kalvachev (iive@yahoo.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #1 from Ivan Kalvachev (iive@yahoo.com) ---
With kernel-4.10.2 I cannot reproduce the bug anymore.

The following commit looks like it might be the one fixing the issue:
---
commit 011fe6ade610c2ca5a609c83c509f1fc8e4c8b7f
Author: Roman Pen <roman.penyaev@profitbricks.com>
Date:   Sun Jan 8 21:00:35 2017 -0500

    ext4: do not polute the extents cache while shifting extents

    commit 03e916fa8b5577d85471452a3d0c5738aa658dae upstream.

    Inside ext4_ext_shift_extents() function ext4_find_extent() is called
    without EXT4_EX_NOCACHE flag, which should prevent cache population.

    This leads to oudated offsets in the extents tree and wrong blocks
    afterwards.

    Patch fixes the problem providing EXT4_EX_NOCACHE flag for each
    ext4_find_extents() call inside ext4_ext_shift_extents function.

    Fixes: 331573febb6a2
---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194567] ext4 no longer mounts
Date: Wed, 15 Feb 2017 06:29:12 +0000
Message-ID: <bug-194567-13602-VloytOnjIW@https.bugzilla.kernel.org/>
References: <bug-194567-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60314 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751294AbdBOG3P (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 15 Feb 2017 01:29:15 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id CA2F12844A
        for <linux-ext4@vger.kernel.org>; Wed, 15 Feb 2017 06:29:14 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7327F2842E
        for <linux-ext4@vger.kernel.org>; Wed, 15 Feb 2017 06:29:14 +0000 (UTC)
In-Reply-To: <bug-194567-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194567

Theodore Tso (tytso@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #3 from Theodore Tso (tytso@mit.edu) ---
Created attachment 254761
  --> https://bugzilla.kernel.org/attachment.cgi?id=254761&action=edit
ext4: fix fencepost in s_first_meta_bg validation

Oops, thanks for reporting the bug.  This fix should take care of your issue.

I was able to reproduce such a file system using:


export MKE2FS_FIRST_META_BG=2
mke2fs -t ext4 -b 4096 -N 90112 -I 128 -L DB -m 0 -O
dir_index,extent,filetype,flex_bg,^has_journal,large_file,^resize_inode,sparse_super,uninit_bg,meta_bg,^metadata_csum,^64bit
/tmp/test.img 8388608

I'm not sure how it got into that state, but I'm guess it involved online
resizing?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194567] ext4 no longer mounts
Date: Mon, 13 Feb 2017 14:59:38 +0000
Message-ID: <bug-194567-13602-yV4f5n3jd5@https.bugzilla.kernel.org/>
References: <bug-194567-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:38426 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752099AbdBMO7l (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 13 Feb 2017 09:59:41 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 98A682833B
        for <linux-ext4@vger.kernel.org>; Mon, 13 Feb 2017 14:59:40 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A9E582833B
        for <linux-ext4@vger.kernel.org>; Mon, 13 Feb 2017 14:59:38 +0000 (UTC)
In-Reply-To: <bug-194567-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194567

--- Comment #2 from bugzilla.kernel.org@plan9.de ---
dumpe2fs 1.43.4 (31-Jan-2017)
Filesystem volume name:   DB
Last mounted on:          /db
Filesystem UUID:          68f492ad-4c47-49ea-9ad9-3948f14b2ce3
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      ext_attr dir_index filetype meta_bg extent flex_bg
sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    user_xattr acl
Filesystem state:         not clean
Errors behavior:          Remount read-only
Filesystem OS type:       Linux
Inode count:              90112
Block count:              8388608
Reserved block count:     0
Free blocks:              1628674
Free inodes:              90022
First block:              0
Block size:               4096
Fragment size:            4096
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         352
Inode blocks per group:   11
First meta block group:   2
Flex block group size:    16
Filesystem created:       Wed Dec  4 13:14:34 2013
Last mount time:          Mon Feb 13 12:13:01 2017
Last write time:          Mon Feb 13 12:13:01 2017
Mount count:              3
Maximum mount count:      -1
Last checked:             Sun Feb 12 21:36:42 2017
Check interval:           0 (<none>)
Lifetime writes:          2525 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               128
Default directory hash:   half_md4
Directory Hash Seed:      01f2a95d-8a5d-488a-b5ce-d2f1a810edc3

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:52418 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725991AbeLAFLg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 00:11:36 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2532A301DD
        for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2018 18:01:31 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Fri, 30 Nov 2018 18:01:31 +0000
Message-ID: <bug-201685-13602-ueJd0EajTi@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #93 from Guenter Roeck (linux@roeck-us.net) ---
Most of the ext4 patches in v4.19 have been backported to v4.18.y. Since
v4.18.20 is reported to be stable, it is quite likely that the problem lies
with one or more of the patches which have _not_ been backported. This would be
one of the following patches.

ext4: close race between direct IO and ext4_break_layouts()
ext4: add nonstring annotations to ext4.h
ext4: readpages() should submit IO as read-ahead
dax: remove VM_MIXEDMAP for fsdax and device dax
ext4: remove unneeded variable "err" in ext4_mb_release_inode_pa()
ext4: improve code readability in ext4_iget()
ext4: handle layout changes to pinned DAX mappings
ext4: use swap macro in mext_page_double_lock
ext4: check allocation failure when duplicating "data" in ext4_remount()
ext4: fix warning message in ext4_enable_quotas()
ext4: super: extend timestamps to 40 bits
ext4: use timespec64 for all inode times
ext4: use ktime_get_real_seconds for i_dtime
ext4: use 64-bit timestamps for mmp_time
block: Define and use STAT_READ and STAT_WRITE

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

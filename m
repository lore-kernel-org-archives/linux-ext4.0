From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89621] EXT4-fs error (device dm-1):
 ext4_mb_release_inode_pa:3773: group 24089, free 34, pa_free 32
Date: Thu, 28 May 2015 00:27:29 +0000
Message-ID: <bug-89621-13602-HHFUboNHQT@https.bugzilla.kernel.org/>
References: <bug-89621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53386 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbbE1A1c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 May 2015 20:27:32 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A018E20739
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2015 00:27:30 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 709B220737
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2015 00:27:29 +0000 (UTC)
In-Reply-To: <bug-89621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89621

--- Comment #11 from Theodore Tso <tytso@mit.edu> ---
Why are you still using v3.16.0?    The latest 3.16 kernel is v3.16.7.  I
believe the bug in question was fixed in a backport that first showed up in
v3.16.2:

commit 868be28e321b764da29592cfd9fd659434e823aa
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Jul 30 22:17:17 2014 -0400

    ext4: fix ext4_discard_allocated_blocks() if we can't allocate the pa
struct

    commit 86f0afd463215fc3e58020493482faa4ac3a4d69 upstream.

    If there is a failure while allocating the preallocation structure, a
    number of blocks can end up getting marked in the in-memory buddy
    bitmap, and then not getting released.  This can result in the
    following corruption getting reported by the kernel:

    EXT4-fs error (device sda3): ext4_mb_generate_buddy:758: group 1126,
    12793 clusters in bitmap, 12729 in gd

    In that case, we need to release the blocks using mb_free_blocks().

    Tested: fs smoke test; also demonstrated that with injected errors,
        the file system is no longer getting corrupted

    Google-Bug-Id: 16657874

    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

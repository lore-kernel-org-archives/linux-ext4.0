From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 82201] ext4 crash in ext4_superblock_csum
Date: Wed, 13 Aug 2014 02:34:37 +0000
Message-ID: <bug-82201-13602-fGaCCbqK4I@https.bugzilla.kernel.org/>
References: <bug-82201-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40901 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbaHMCek (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Aug 2014 22:34:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 960C3201D3
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2014 02:34:39 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 66718201BC
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2014 02:34:37 +0000 (UTC)
In-Reply-To: <bug-82201-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=82201

kun.chen <kun.chen@mediatek.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |INVALID

--- Comment #2 from kun.chen <kun.chen@mediatek.com> ---
I already checked that this is because ext4 super block memory was corrupted,
because we didn't set EXT4_FEATURE_RO_COMPAT_METADATA_CSUM, but it skip the
checking and enter ext4_superblock_csum.

ext4_super_block was stored in r1:c406d400, from stack the s_feature_ro_compat
value is c53e05e6, so it can skip the checking in ext4_superblock_csum_set.

And refer to r1 stack data, we already find it related to selinux.

"And did this happen after an unclean shutdown (so the journal had to be
replayed)"
Yes, it happened after a software watchdog reset. I'm not sure whether the
journal data corrupt related to memory corrupt, because next reboot it can
mount successful.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 50981] ext4 : DATA CORRUPTION read and write on same 4096 page
 range
Date: Mon, 26 Nov 2012 10:16:20 +0000 (UTC)
Message-ID: <20121126101620.32D0911FB81@bugzilla.kernel.org>
References: <bug-50981-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35381 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829Ab2KZKQX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 05:16:23 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D2E0D20207
	for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2012 10:16:21 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 3CE1720203
	for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2012 10:16:20 +0000 (UTC)
In-Reply-To: <bug-50981-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=50981


Zheng Liu <gnehzuil.liu@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |gnehzuil.liu@gmail.com




--- Comment #3 from Zheng Liu <gnehzuil.liu@gmail.com>  2012-11-26 10:16:19 ---
IMHO, the reason seems to be that no any locking is taken by
generic_file_aio_read().  When ext4 does a buffered write, it will take i_mutex
to ensure that there is no other writer.  But ext4 (ext3, btrfs, and vfat) uses
generic_file_aio_read() to do a buffered read, and it doesn't take i_mutex.  So
it is easy to read a inconsistent data while doing a write.  I am not very
familiar with xfs, but a rwlock will be taken when a read and/or a write is
being done.  So that is why xfs hasn't this problem.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

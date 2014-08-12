From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 82201] ext4 crash in ext4_superblock_csum
Date: Tue, 12 Aug 2014 15:25:22 +0000
Message-ID: <bug-82201-13602-1hZ5O4UQ0j@https.bugzilla.kernel.org/>
References: <bug-82201-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46846 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbaHLPZY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Aug 2014 11:25:24 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 83D0F2015E
	for <linux-ext4@vger.kernel.org>; Tue, 12 Aug 2014 15:25:23 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C837520115
	for <linux-ext4@vger.kernel.org>; Tue, 12 Aug 2014 15:25:22 +0000 (UTC)
In-Reply-To: <bug-82201-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=82201

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
Can you attach a copy of dumpe2fs -h?

And did this happen after an unclean shutdown (so the journal had to be
replayed), by any chance?

-- Ted

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

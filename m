From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 50981] generic_file_aio_read ?: No locking means DATA
 CORRUPTION read and write on same 4096 page  range
Date: Mon, 26 Nov 2012 12:26:08 +0000 (UTC)
Message-ID: <20121126122608.4F2FC11FB80@bugzilla.kernel.org>
References: <bug-50981-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39873 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590Ab2KZM0P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 07:26:15 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BA1E52026B
	for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2012 12:26:14 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 5413E20269
	for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2012 12:26:08 +0000 (UTC)
In-Reply-To: <bug-50981-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=50981


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|ext4                        |Other
         AssignedTo|fs_ext4@kernel-bugs.osdl.or |akpm@linux-foundation.org
                   |g                           |
            Product|File System                 |Memory Management
            Summary|ext4 : DATA CORRUPTION read |generic_file_aio_read ?: No
                   |and write on same 4096 page |locking means DATA
                   | range                      |CORRUPTION read and write
                   |                            |on same 4096 page  range




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

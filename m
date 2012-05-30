From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12629] EXT3-fs error (device dm-1): ext3_new_block: Allocating
 block in system zone
Date: Wed, 30 May 2012 12:48:53 +0000 (UTC)
Message-ID: <20120530124853.EA32011FD1B@bugzilla.kernel.org>
References: <bug-12629-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55532 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab2E3Ms5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 May 2012 08:48:57 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E0DBC203BB
	for <linux-ext4@vger.kernel.org>; Wed, 30 May 2012 12:48:55 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id F20E8203C7
	for <linux-ext4@vger.kernel.org>; Wed, 30 May 2012 12:48:53 +0000 (UTC)
In-Reply-To: <bug-12629-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=12629


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|                            |OBSOLETE
         Regression|---                         |No




--- Comment #2 from Alan <alan@lxorguk.ukuu.org.uk>  2012-05-30 12:48:53 ---
Closing as obsolete, please re-open if seen with recent kernels.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

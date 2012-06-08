From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43354] Corruption on a small loopback ext4 file system with
 Linux 3.4
Date: Fri,  8 Jun 2012 04:58:37 +0000 (UTC)
Message-ID: <20120608045837.BD29411FC43@bugzilla.kernel.org>
References: <bug-43354-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60789 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab2FHE6k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jun 2012 00:58:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6634C203D5
	for <linux-ext4@vger.kernel.org>; Fri,  8 Jun 2012 04:58:39 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id C6BCD203D0
	for <linux-ext4@vger.kernel.org>; Fri,  8 Jun 2012 04:58:37 +0000 (UTC)
In-Reply-To: <bug-43354-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43354


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #2 from Eric Sandeen <sandeen@redhat.com>  2012-06-08 04:58:37 ---
Does it go any better w/ a 4k fs block size?  (-b 4096?)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 92271] Provide a way to really delete files, please
Date: Thu, 29 Jan 2015 21:20:00 +0000
Message-ID: <bug-92271-13602-i0VFjOm8ME@https.bugzilla.kernel.org/>
References: <bug-92271-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34041 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbbA2VUF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Jan 2015 16:20:05 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0A7E220225
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jan 2015 21:20:03 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 802F520251
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jan 2015 21:20:00 +0000 (UTC)
In-Reply-To: <bug-92271-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=92271

Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com

--- Comment #6 from Eric Sandeen <sandeen@redhat.com> ---
As long as you don't truncate the file first, overwriting an existing ext4 file
will indeed overwrite the existing blocks allocated to that file.  Ext4 is not
a copy on write filesystem.

FWIW, recent kernels and recent util-linux also have "fstrim --secure" to issue
a secure discard post-deletion.

-Eric

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

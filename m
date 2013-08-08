From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60721] Rsync crashes due to ext4_ext_find_extent bug
Date: Thu, 08 Aug 2013 15:39:03 +0000
Message-ID: <bug-60721-13602-M60sV5nEcw@https.bugzilla.kernel.org/>
References: <bug-60721-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50234 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757899Ab3HHPjH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Aug 2013 11:39:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 214CA20317
	for <linux-ext4@vger.kernel.org>; Thu,  8 Aug 2013 15:39:06 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 10A882037F
	for <linux-ext4@vger.kernel.org>; Thu,  8 Aug 2013 15:39:05 +0000 (UTC)
In-Reply-To: <bug-60721-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=60721

Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com

--- Comment #2 from Eric Sandeen <sandeen@redhat.com> ---
You probably have on-disk corruption; I'd run e2fsck.

Aside from that, the upstream bugtracker really isn't for (old) distro bugs I'm
afraid.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

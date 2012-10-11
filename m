From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47151] provide a file system block size of 8KB for certain
 SSDs.
Date: Thu, 11 Oct 2012 20:58:41 +0000 (UTC)
Message-ID: <20121011205841.CA29C11F7F6@bugzilla.kernel.org>
References: <bug-47151-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34826 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755431Ab2JKU6t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Oct 2012 16:58:49 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 957A62047F
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2012 20:58:47 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id D3E3020478
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2012 20:58:46 +0000 (UTC)
In-Reply-To: <bug-47151-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47151





--- Comment #17 from Elmar Stellnberger <estellnb@elstel.org>  2012-10-11 20:58:41 ---
The question is whether we need to support these few 8K drives that are out
that do not have a 4K emulation. I believe the Linux support of SSDs is already
very well; f.i. on Win only Windows 7 has a trim mount support (afaik).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

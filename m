From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48751] ext3: ctime changes with no reason in 30 seconds after a
 file change
Date: Wed, 17 Oct 2012 22:53:14 +0000 (UTC)
Message-ID: <20121017225314.5233111FC3E@bugzilla.kernel.org>
References: <bug-48751-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38221 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab2JQWxT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Oct 2012 18:53:19 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DD9FF2023A
	for <linux-ext4@vger.kernel.org>; Wed, 17 Oct 2012 22:53:15 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 552B1201E4
	for <linux-ext4@vger.kernel.org>; Wed, 17 Oct 2012 22:53:14 +0000 (UTC)
In-Reply-To: <bug-48751-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=48751


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|fs_ext3@kernel-bugs.osdl.or |jack@suse.cz
                   |g                           |




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

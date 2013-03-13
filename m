From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 55081] BUG while unlinking inode with an xattr
Date: Wed, 13 Mar 2013 14:23:32 +0000 (UTC)
Message-ID: <20130313142332.A4C1111FA4E@bugzilla.kernel.org>
References: <bug-55081-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38039 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab3CMOXh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Mar 2013 10:23:37 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 64D4F202D0
	for <linux-ext4@vger.kernel.org>; Wed, 13 Mar 2013 14:23:34 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id D1284202CC
	for <linux-ext4@vger.kernel.org>; Wed, 13 Mar 2013 14:23:32 +0000 (UTC)
In-Reply-To: <bug-55081-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=55081





--- Comment #1 from Jan Kara <jack@suse.cz>  2013-03-13 14:23:32 ---
Created an attachment (id=95331)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=95331)
Fix BUG_ON in evict()

This patch fixes the issue for me. I've added it to my tree and will push it to
Linus soon.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

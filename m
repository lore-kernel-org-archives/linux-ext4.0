From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Wed, 16 May 2012 19:29:54 +0000 (UTC)
Message-ID: <20120516192954.B338211FCF6@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43537 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670Ab2EPT35 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 May 2012 15:29:57 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B3BC02056A
	for <linux-ext4@vger.kernel.org>; Wed, 16 May 2012 19:29:55 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id BB43520537
	for <linux-ext4@vger.kernel.org>; Wed, 16 May 2012 19:29:54 +0000 (UTC)
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895





--- Comment #14 from Jan Kara <jack@suse.cz>  2012-05-16 19:29:54 ---
I've looked at the results and they look normal. Different processes dirty some
inodes - after a while jbd2 journal thread writes these changes to the journal
(it checks once per 5s). The journal thread writes somewhat more because there
are some descriptor blocks etc.

Also once per 5s, flusher wakes up and writes all dirty data older than 30s.

So really sources of all the activity are those few processes (gedit,
NetworkManager, xfconfd) which do dirtying and the rest is just triggered by
that.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Wed, 12 Aug 2015 09:11:39 +0000
Message-ID: <bug-102731-13602-rHdixuJbEr@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59033 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934016AbbHLJLn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Aug 2015 05:11:43 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D2E5820712
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2015 09:11:40 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 8E3F12070D
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2015 09:11:39 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #3 from John Hughes <john@calva.com> ---
What is the guest doing?

It's a NFSv4 server for my home directories.

It's my email server (sendmail and cyrus imap).

I've seen the problem (bug 89621) on the root filesystem, the home filesystem
and the imap filesystem.

Most often on the root, a little less frequently the homedir filesystem.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

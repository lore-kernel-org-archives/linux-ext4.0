From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 56091] kernel oops when copying data to ext4 fs
Date: Tue,  2 Apr 2013 09:44:10 +0000 (UTC)
Message-ID: <20130402094410.E29CD11FB79@bugzilla.kernel.org>
References: <bug-56091-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52049 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759928Ab3DBJoO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Apr 2013 05:44:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CA72F2042F
	for <linux-ext4@vger.kernel.org>; Tue,  2 Apr 2013 09:44:12 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id E5DCB2042A
	for <linux-ext4@vger.kernel.org>; Tue,  2 Apr 2013 09:44:10 +0000 (UTC)
In-Reply-To: <bug-56091-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=56091





--- Comment #2 from David Maciejak <dmaciejak@fortinet.com>  2013-04-02 09:44:10 ---
i used xz instead of gz to compress the file

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

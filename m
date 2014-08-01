From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81461] EXT-4 kernel panic
Date: Fri, 01 Aug 2014 12:50:38 +0000
Message-ID: <bug-81461-13602-4FfNmziJXd@https.bugzilla.kernel.org/>
References: <bug-81461-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39888 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755040AbaHAMum (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Aug 2014 08:50:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B593420200
	for <linux-ext4@vger.kernel.org>; Fri,  1 Aug 2014 12:50:41 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 684FB2020E
	for <linux-ext4@vger.kernel.org>; Fri,  1 Aug 2014 12:50:39 +0000 (UTC)
In-Reply-To: <bug-81461-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=81461

Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz

--- Comment #1 from Jan Kara <jack@suse.cz> ---
This is really old kernel. Can you reproduce the problem with something more
recent?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 50021] ext4 discard option not working on journal dissabled
 filesystem
Date: Mon,  5 Nov 2012 13:58:10 +0000 (UTC)
Message-ID: <20121105135810.4F04911FB6C@bugzilla.kernel.org>
References: <bug-50021-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46210 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343Ab2KEN6O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Nov 2012 08:58:14 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D19CC202BF
	for <linux-ext4@vger.kernel.org>; Mon,  5 Nov 2012 13:58:12 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id E9B4F202B8
	for <linux-ext4@vger.kernel.org>; Mon,  5 Nov 2012 13:58:10 +0000 (UTC)
In-Reply-To: <bug-50021-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=50021


Lukas Czerner <lczerner@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lczerner@redhat.com




--- Comment #2 from Lukas Czerner <lczerner@redhat.com>  2012-11-05 13:58:09 ---
The discard in no-journal mode has been re-enabled with commit

b5e2368baeddf401bf3da9e364fc1c96676279cd ext4: re-enable -o discard
functionality in no-journal mode

so you probably have older kernel than that.

Thanks!
-Lukas

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

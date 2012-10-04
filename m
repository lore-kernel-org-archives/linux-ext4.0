From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48301] Kernel panic when try delete really big file (3,3TB)
Date: Thu,  4 Oct 2012 11:41:29 +0000 (UTC)
Message-ID: <20121004114129.F1E0511FC25@bugzilla.kernel.org>
References: <bug-48301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46157 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128Ab2JDLlc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Oct 2012 07:41:32 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 69BA9202D4
	for <linux-ext4@vger.kernel.org>; Thu,  4 Oct 2012 11:41:31 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id F34B1202B1
	for <linux-ext4@vger.kernel.org>; Thu,  4 Oct 2012 11:41:29 +0000 (UTC)
In-Reply-To: <bug-48301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=48301


Lukas Czerner <lczerner@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lczerner@redhat.com




--- Comment #3 from Lukas Czerner <lczerner@redhat.com>  2012-10-04 11:41:29 ---
This has been fixed with v3.6-rc1-5-g89a4e48

89a4e48f8479f8145eca9698f39fe188c982212f ext4: fix kernel BUG on large-scale rm
-rf commands

-Lukas

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

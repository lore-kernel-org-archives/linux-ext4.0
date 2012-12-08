From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51431] ext4_mb_generate_buddy self ext4 errors
Date: Sat,  8 Dec 2012 16:35:08 +0000 (UTC)
Message-ID: <20121208163508.4DB5911FC70@bugzilla.kernel.org>
References: <bug-51431-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50186 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373Ab2LHQfL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Dec 2012 11:35:11 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F06D4201A7
	for <linux-ext4@vger.kernel.org>; Sat,  8 Dec 2012 16:35:09 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 50306201AA
	for <linux-ext4@vger.kernel.org>; Sat,  8 Dec 2012 16:35:08 +0000 (UTC)
In-Reply-To: <bug-51431-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51431


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #1 from Eric Sandeen <sandeen@redhat.com>  2012-12-08 16:35:07 ---
The messages you see are telling you about a message which happened int the
past.

ext4 stores errors, and reports them again every 24h, which seems to be a
source of confusion for most people who encounter it.  :(

this:

> initial error at 1354656587

means that it happened at that unix timestamp, i.e. 

# date -u --date="1970-01-01 1354656587 sec GMT"
Tue Dec  4 21:29:47 UTC 2012

Newer e2fsck should clear the message, as of about version 1.41.14 IIRC.  Older
e2fsck does not, and the kernel message will repeat every 24h ad infinitum
until it gets cleared.

-Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

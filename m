From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 52521] hibernations problems: ext4 errors after some
 hibernation cycles
Date: Wed,  9 Jan 2013 19:13:30 +0000 (UTC)
Message-ID: <20130109191330.1BB0F11FB82@bugzilla.kernel.org>
References: <bug-52521-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38310 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932435Ab3AITNe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Jan 2013 14:13:34 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EFCED203BF
	for <linux-ext4@vger.kernel.org>; Wed,  9 Jan 2013 19:13:32 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 287022039E
	for <linux-ext4@vger.kernel.org>; Wed,  9 Jan 2013 19:13:31 +0000 (UTC)
In-Reply-To: <bug-52521-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=52521


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz




--- Comment #1 from Jan Kara <jack@suse.cz>  2013-01-09 19:13:29 ---
Hum, I guess you mean 3.7.1 kernel but more importantly: Can you please attach
fsck log when fsck fixes the corrupted filesystem?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

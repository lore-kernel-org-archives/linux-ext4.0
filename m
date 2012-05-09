From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42723] EXT4-fs error: ext4_mb_generate_buddy
Date: Wed,  9 May 2012 18:03:56 +0000 (UTC)
Message-ID: <20120509180356.F1BBA11FCCF@bugzilla.kernel.org>
References: <bug-42723-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60719 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab2EISD7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 May 2012 14:03:59 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 57B772023C
	for <linux-ext4@vger.kernel.org>; Wed,  9 May 2012 18:03:58 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 69DFC20239
	for <linux-ext4@vger.kernel.org>; Wed,  9 May 2012 18:03:57 +0000 (UTC)
In-Reply-To: <bug-42723-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42723


Peter Meier <peter.meier+kernel@immerda.ch> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |peter.meier+kernel@immerda.
                   |                            |ch




--- Comment #4 from Peter Meier <peter.meier+kernel@immerda.ch>  2012-05-09 18:03:56 ---
I encounter the same problems with an Intel SSD and ext4 using the latest
kernel of Ubuntu 12.04 (3.2.0.24.26) or even a 3.4.0-030400rc4 version.

Going back to the Kernel release 3.0.0-19 of Ubuntu 11.10 makes the problems
going away.

More information https://bugs.launchpad.net/ubuntu/+source/linux/+bug/992424

If you need any more information please let me know.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42512] [BUG] D state process after unplug and umount usb disk
Date: Mon, 27 Feb 2012 12:04:01 GMT
Message-ID: <201202271204.q1RC41G4003936@bugzilla.kernel.org>
References: <bug-42512-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:38851 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2B0MEC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Feb 2012 07:04:02 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1RC41ad003937
	for <linux-ext4@vger.kernel.org>; Mon, 27 Feb 2012 12:04:01 GMT
In-Reply-To: <bug-42512-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42512


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz




--- Comment #3 from Jan Kara <jack@suse.cz>  2012-02-27 12:04:01 ---
Hmm, this doesn't look like an ext3 problem. The hanging command is waiting for
page to be unlocked which, given it is 'cat' reading a file, is likely because
read command interrupted by device unplug was not properly completed... So I'd
blame either USB or SCSI layer. Or Greg, what made you think it's an ext3 bug?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

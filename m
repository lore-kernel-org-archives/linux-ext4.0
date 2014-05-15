From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76261] ext4_da_writepages err -30 after remount ro during
 shutdown
Date: Thu, 15 May 2014 15:11:11 +0000
Message-ID: <bug-76261-13602-kqZZ2JBay9@https.bugzilla.kernel.org/>
References: <bug-76261-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53846 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbaEOPLO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 May 2014 11:11:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5FC1820380
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2014 15:11:13 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id CFBE92034B
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2014 15:11:11 +0000 (UTC)
In-Reply-To: <bug-76261-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76261

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
Does upstream android really handle a shutdown using "echo u >
/proc/sysrq-trigger", or is that something you added locally?   If it's
upstream, I need to have some words with the Google Android team....

sysrq-u is documented to be "Emergency Remount R/O".  It's not something that
is designed to be used under normal circumstances.  So if upstream android is
doing this, it's arguably a bug.

sysrq-u is implemented using do_emergency_remount() in fs/super.c, and it calls
do_remount_sb with force set to 1 (the last argument is "force").

            do_remount_sb(sb, MS_RDONLY, NULL, 1);

The "force" option omits the call to sb_prepare_remount_readonly(), which is
what forces the writeback to happen.  The reason why it is omitted is that
sysrq-u is designed to be used when the system is unstable, and so the
writeback for one of the superblocks might block forever, and this would
prevent the subsequent superblocks from getting remounted read-only.

So people who use sysrq-u are usually advised to do an sysrq-s, which is an
"emergency sync".   (This is avoids doing a data integrity writeback, since
again it's designed for emergencies, when part of the system may be partially
deadlocked, and so the goal is to save what you can, not to try to save
everything.  Perfection, if it causes the sync to stop and never complete, and
hence not sync out some buffers that could be saved, is the enemy of the good
here.)

The real issue here is that sysrq-u and sysrq-u is designed for emergency war
room triage, what Dr. Hawkeye Pierce in M*A*S*H referred to as "meatball
surgery".  It is battlefield surgery, and it is *not* what you would expect in
a hospital surgery room located thousands of miles from a war zone.  So if
android is using this under normal situations, it's an abuse of what these
interfaces are intended to be used for.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

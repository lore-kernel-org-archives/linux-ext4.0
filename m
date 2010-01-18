From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15018] ext4 backtraces out of nowhere
Date: Mon, 18 Jan 2010 23:06:08 GMT
Message-ID: <201001182306.o0IN68F9004917@demeter.kernel.org>
References: <bug-15018-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58712 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab0ARXGL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jan 2010 18:06:11 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0IN69W9004918
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jan 2010 23:06:09 GMT
In-Reply-To: <bug-15018-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15018


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz, tytso@mit.edu




--- Comment #2 from Jan Kara <jack@suse.cz>  2010-01-18 23:06:07 ---
Ah, inlining and such stuff made reading this stack trace quite difficult.
Anyway, the problem is that we just should not call write_inode_now() in
ext4_da_reserve_space() when we have transaction already started. And as
Andreas correctly points out, the patch even introduces a deadlock because it
can call write_inode_now with wait==1. Moreover we hold page lock when holding
write_inode_now which introduces a plenty of nasty locking issues I believe.
The bug has been introduced by commit 0637c6f4135f592f094207c7c21e7c0fc5557834.

Ted, I think that if we are failing to do the write because of ENOSPC, the only
reasonable non-deadlocky thing to do is to restart the write completely - i.e.,
bail out up to ext4_da_write_begin, stop the transaction, drop the page, *do
some magic*, and start again...

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76261] ext4_da_writepages err -30 after remount ro during
 shutdown
Date: Fri, 16 May 2014 13:44:36 +0000
Message-ID: <bug-76261-13602-AQO6iw4Kin@https.bugzilla.kernel.org/>
References: <bug-76261-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50550 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932423AbaEPNoi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 May 2014 09:44:38 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6BB0F2038D
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2014 13:44:37 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 5EE5520379
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2014 13:44:36 +0000 (UTC)
In-Reply-To: <bug-76261-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76261

--- Comment #11 from Theodore Tso <tytso@mit.edu> ---
Hi Ken, commit 807612db2f9940 is not going to help you, since
emergency_remount() is calling do_remount_sb with force == 0.

Note that if applications are still writing to the file system at the time of
the shutdown, the application files are at risk of getting corrupted.   It
doesn't actually really matter if sb_prepare_readonly_remount() causes those
writes to return EROFS as opposed to returning success and then having the
writes fail.  It might quiet the the error messages in the system log, but it's
not going to allow the applications to shutdown cleanly --- because if this
patch was going to make a difference, it implies that applications are not
getting shut down cleanly before android triggers the emergency_remount.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

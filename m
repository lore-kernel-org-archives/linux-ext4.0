From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Mon, 19 Oct 2009 21:07:41 GMT
Message-ID: <200910192107.n9JL7fbI000492@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43779 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbZJSVHh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Oct 2009 17:07:37 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9JL7fDT000493
	for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2009 21:07:41 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #92 from Theodore Tso <tytso@mit.edu>  2009-10-19 21:07:37 ---
Created an attachment (id=23468)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23468)
Testing patch; ro-diff with a WARN_ON(1)

Could you try this patch on top of a stock 2.6.32-rc kernel? 
ext4_write_inode() should not be called before the journal is set up, and I'm
not able to see how this could work.  Yet if the ro-diff.patch in attachment
#23458 makes a difference working, then that must be what's happening.

This is a variant on that patch that executes a printk and a WARN_ON(1) when if
the conditional triggers; that will allow me to figure out how
ext4_write_inode() is getting called early.  I'm not able to replicate this on
my system with this patch, but if it's working for you, then this should allow
me to see what's actually happening.   If we need to simply revert the change
to ext4_write_inode(), I can do that, but I'd really like to see what's going
on first.   If in fact there is a patch where ext4_write_inode() can get called
before ext4_load_journal(), which is what sets EXT4_SB(sb)->s_journal, then
there's opportunities for other mischief/data corruption.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

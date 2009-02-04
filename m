From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12630] EXT3-fs error (device dm-1): ext3_new_block: Allocating block in system zone
Date: Wed,  4 Feb 2009 01:08:46 -0800 (PST)
Message-ID: <20090204090847.3C7A211D109@picon.linux-foundation.org>
References: <bug-12630-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbZBDJJP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Feb 2009 04:09:15 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1498lNC023989
	for <linux-ext4@vger.kernel.org>; Wed, 4 Feb 2009 01:08:48 -0800
In-Reply-To: <bug-12630-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12630


juris.krumins@ctco.lv changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |DUPLICATE




------- Comment #1 from juris.krumins@ctco.lv  2009-02-04 01:08 -------


*** This bug has been marked as a duplicate of bug 12629 ***


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13369] kernel BUG at fs/ext4/inode.c:3123
Date: Sun, 24 May 2009 05:08:06 GMT
Message-ID: <200905240508.n4O586uZ003262@demeter.kernel.org>
References: <bug-13369-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36149 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbZEXFIF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 May 2009 01:08:05 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4O586pt003263
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2009 05:08:06 GMT
In-Reply-To: <bug-13369-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13369





--- Comment #6 from Theodore Tso <tytso@mit.edu>  2009-05-24 05:08:05 ---
I've tried replicating using fsstress, fsx, and dbench using a stock 2.6.30-rc6
on a dual-core netbook and a 1k block filesystem; no luck.

I tried replicating using fsstress, fsx, and dbench using 2.6.30-rc6 + the ext4
patch queue on a x61s Lenovo laptop (Intel Core 2 Duo L7500), again with a 1k
block filesystem.  No luck.  I'm now trying to do a bittorrent download using
transmission onto the 1k block filesystem.

How easily can you reproduce the problem on your system?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

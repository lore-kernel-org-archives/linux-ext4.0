From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15579] ext4 -o discard produces incorrect blocks of zeroes in
 newly created files under heavy read+truncate+append-new-file load
Date: Tue, 23 Mar 2010 11:10:20 GMT
Message-ID: <201003231110.o2NBAKbu009990@demeter.kernel.org>
References: <bug-15579-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39885 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab0CWLKX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Mar 2010 07:10:23 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2NBAL3m009992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 23 Mar 2010 11:10:21 GMT
In-Reply-To: <bug-15579-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15579





--- Comment #5 from Andreas Beckmann <kernel-bugs@abeckmann.de>  2010-03-23 11:10:15 ---
(In reply to comment #4)
> Just for what it's worth, I've had trouble reproducing this on another brand of
> SSD... something like this (don't let the xfs_io throw you; it's just a
> convenient way to generate the IO).  I did this on a 512M filesystem.

Might be a probability issue. For the 250 GB case I did in total about 200000
truncations on about 250 files and found in the output file 8 and 13 corrupt
blocks (I only kept detailed numbers for two cases). Reducing the block size
might "help" by increasing the number of I/Os.

I can't test your script right now, the disks are all busy with some long
running experiments. There should be another one just back from RMA on my desk,
so I can try it tomorrow when I'm back there (was travelling for a week).

What do you do on the remaining space of the SSD? Try putting a file system
there and fill it with something so that the SSD is 99% filled so it can't that
easily remap the blocks you are writing to.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

From: Gary Hawco <ghawco@cox.net>
Subject: delalloc filesystem corruption
Date: Tue, 01 Jul 2008 10:54:17
Message-ID: <3.0.6.32.20080701105417.01ce4958@pop.west.cox.net>
References: <3.0.6.32.20080701000046.025249e0@pop.west.cox.net>
 <3.0.6.32.20080626221227.0242af78@pop.west.cox.net>
 <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
 <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
 <3.0.6.32.20080626221227.0242af78@pop.west.cox.net>
 <3.0.6.32.20080701000046.025249e0@pop.west.cox.net> <20080701160236.GG22717@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: Theodore Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fed1rmmtao105.cox.net ([68.230.241.41]:59559 "EHLO
	fed1rmmtao105.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbYGARyS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jul 2008 13:54:18 -0400
In-Reply-To: <20080701160236.GG22717@mit.edu>
References: <3.0.6.32.20080701000046.025249e0@pop.west.cox.net>
 <3.0.6.32.20080626221227.0242af78@pop.west.cox.net>
 <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
 <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
 <3.0.6.32.20080626221227.0242af78@pop.west.cox.net>
 <3.0.6.32.20080701000046.025249e0@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,

Thanks for your quick reply.  With the newest rc8-based snapshots I am no
longer getting segfaults, unless you wanted me to roll back to the
rc6-based snapshots to reproduce the segfaults.

Per your latest request I disabled delalloc, and voila, no more data
corruption! Then I enabled delalloc and disabled mballoc and file
corruption to /lib/rc/init.d/nettree returned. So delalloc is the culprit.

I hope this will help figure this out.

Thanks again,
Gary


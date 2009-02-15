From: Zlatko Calusic <zlatko.calusic@iskon.hr>
Subject: Dump/restore not functional on ext4
Date: Sun, 15 Feb 2009 13:04:48 +0100
Message-ID: <87d4djucrj.fsf@atlas.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mxout2.iskon.hr ([213.191.128.81]:60787 "HELO mxout2.iskon.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755798AbZBOMLa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Feb 2009 07:11:30 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello list!

Cca 2 months ago I switched to ext4 on all of my machines/partitions and
has been a very happy customer ever since. Except one little thing...

Dump/restore is not working on ext4 filesystem. Actually... it's even
worse, it appears that it's working, but if you try to restore files,
only garbage gets restored. Obviously wrong fs blocks are dumped (or
restored) rendering backup completely useless.

As this could be bug in e2fslibs, I'm reporting all versions relevant:

Distribution: Debian sid
Kernel: 2.6.28 Linus virgin (FS made with 2.6.28-rc9)
File system: ext4 (w/ extents, w/o xattr)
e2fsprogs: 1.41.3-1
dump: 0.4b41-6

And I'm slightly dissapointed that there's so little users of dump, it
has a feature set that I can't replace with any other backup system (I
tried). Or is it maybe that ext4 is slow to adapt?

This was also reported as Debian bug #511651 a month ago, but without
any progress so far, so I decided to report it to this list, too (I'm
not subscribed).

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=511651

Thanks for any help you can provide!
-- 
Zlatko

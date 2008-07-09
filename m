From: Gary Hawco <ghawco@cox.net>
Subject: Segfaults--they're back!
Date: Wed, 09 Jul 2008 15:00:04
Message-ID: <3.0.6.32.20080709150004.01bd9858@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>, Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fed1rmmtao101.cox.net ([68.230.241.45]:34731 "EHLO
	fed1rmmtao101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbYGIWAF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jul 2008 18:00:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Segfaults have returned with snapshots compiled after 070908--0010hrs GMT.

That one worked fine.

The next one I tried (070908/0025hrs GMT) caused segfaults in both Gentoo &
Slackware (a first for Slackware) when trying to untar
linux-2.6.26-rc9.tar.bz2 tarball)

I then rolled back two snapshots to 070908/0012hrs GMT) and it segfaulted
in both operating systems doing same untarring function.

So, apparently, since 0010snapshot
(ext4-patch-queue-bfb23cf4cd345552c774142cb10ac1225caf35f5.tar.gz) works fine

and 0012snapshot
(ext4-patch-queue-be66b0c5c3f4293176301c0ddcb8db95b0576cb4.tar.gz)
segfaults, the 
Add ext4-fix-mb_find_next_bit-return.patch must be the culprit.

Thanks,
Gary

P.S. The latest snapshot from today @ 0303hrs GMT segfaults as well.


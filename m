From: "H. Peter Anvin" <hpa@zytor.com>
Subject: e2fsck running extremely slowly
Date: Sun, 21 Jul 2013 15:45:20 -0700
Message-ID: <51EC6480.6000200@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:37299 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab3GUWpl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Jul 2013 18:45:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have a large filesystem (14 TB) which suffered a RAID failure which
seems to have corrupted some inodes.  Unfortunately as a result there
are now a number of inodes with "false extents" which result in a very
large number of multiply claimed blocks.

I have tried to run e2fsck on this filesystem, and it gets as far as
phase 1D, at which point it starts running at a glacial pace.  After 48
hours -- most of it sitting at 100% CPU executing no system calls at all
-- it claims to have processed a single file out of almost 10000.

Anything I can do (to rescue the filesystem or try to debug the problem)
other than "wipe and start over"?

I believe this is e2fsck 1.42.3 from Fedora 17.

	-hpa

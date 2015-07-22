From: Pavel Machek <pavel@ucw.cz>
Subject: two fsck.ext4's needed to clean filesystem
Date: Wed, 22 Jul 2015 16:18:06 +0200
Message-ID: <20150722141806.GA21181@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.com, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34989 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933234AbbGVOSI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Jul 2015 10:18:08 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

pavel@amd:~/misc$ /sbin/fsck.ext4 -y -f delme
...
delme: ***** FILE SYSTEM WAS MODIFIED *****
delme: 2054/25064 files (0.1% non-contiguous), 98231/100000 blocks
pavel@amd:~/misc$ /sbin/fsck.ext4 -y -f delme
e2fsck 1.42.12 (29-Aug-2014)
Backing up journal inode block information.

Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

delme: ***** FILE SYSTEM WAS MODIFIED *****
delme: 2054/25064 files (0.5% non-contiguous), 98231/100000 blocks
pavel@amd:~/misc$ cp delme.fsck.original-damaged delme.report-1
pavel@amd:~/misc$ /sbin/fsck.ext4 -V
 e2fsck 1.42.12 (29-Aug-2014)
 Using EXT2FS Library version 1.42.12, 29-Aug-2014
pavel@amd:~/misc$
		  
Is that considered ok? Should fsck restart itself or report
'filesystem still has errors' in this case?

Thanks and best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

From: Pavel Machek <pavel@ucw.cz>
Subject: Re: two fsck.ext4's needed to clean filesystem
Date: Wed, 22 Jul 2015 16:21:59 +0200
Message-ID: <20150722142159.GA21742@amd>
References: <20150722141806.GA21181@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.com, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35028 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674AbbGVOWB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Jul 2015 10:22:01 -0400
Content-Disposition: inline
In-Reply-To: <20150722141806.GA21181@amd>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

> Is that considered ok? Should fsck restart itself or report
> 'filesystem still has errors' in this case?

It definitely should in this case:

Free inodes count wrong (22999, counted=23011).
Fix? yes


delme.fsck.damaged: ***** FILE SYSTEM WAS MODIFIED *****
delme.fsck.damaged: 2053/25064 files (0.1% non-contiguous),
97825/100000 blocks
Second check...
e2fsck 1.42.12 (29-Aug-2014)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  +18015
Fix? yes

Free blocks count wrong for group #2 (36, counted=35).
Fix? yes

Free blocks count wrong (2175, counted=2174).
Fix? yes


delme.fsck.damaged: ***** FILE SYSTEM WAS MODIFIED *****
delme.fsck.damaged: 2053/25064 files (0.2% non-contiguous),
97826/100000 blocks
Fsck lied about its success (result = 1)
pavel@amd:~/misc$ cp delme.fsck.original-damaged delme.report-2

(I can make the images public. Yes, it is artificial test.)

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

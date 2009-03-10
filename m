From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12821] filesystem corrupts on heavy I/O
Date: Tue, 10 Mar 2009 03:03:07 -0700 (PDT)
Message-ID: <20090310100307.B4759108043@picon.linux-foundation.org>
References: <bug-12821-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754619AbZCJKDl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Mar 2009 06:03:41 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2AA38Vl021452
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2009 03:03:09 -0700
In-Reply-To: <bug-12821-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12821





------- Comment #13 from ddi@dubex.dk  2009-03-10 03:03 -------
dd'd the problematic file to /dev/null just now.  Yielded no complaints in the
syslog about unexpected eh_depths.  Maybe the reboot+fsck had some effect.

In retrospect, I should probably have found a network mount (since write speed
suffered badly when the problem hit) and done the e2image before reboot/fsck,
so we'd have a pristine image.  A quick HOWTO on the subject with best
practices for ad-hoc network mounting (using random kernel/distro) plus a copy
of relevant parts of the e2image man page would be helpful to others in the
same situation.

comment #8:
Priceless information.  Thanks!

comment #11:
Transcripts are great; I'm learning a bit of ext4 debugging as we go along.  I
take it that there's no on-disk problem (now), then.  Confirmed by running fsck
1.41.4 as requested in comment #9:

e2fsck 1.41.4 (27-Jan-2009)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

    7648 inodes used (0.01%)
    2994 non-contiguous files (39.1%)
      17 non-contiguous directories (0.2%)
         # of inodes with ind/dind/tind blocks: 0/0/0
         Extent depth histogram: 3710/3891/35/2
273816895 blocks used (75.92%)
       0 bad blocks
       7 large files

    7593 regular files
      46 directories
       0 character device files
       0 block device files
       0 fifos
       0 links
       0 symbolic links (0 fast symbolic links)
       0 sockets
--------
    7639 files

comment #10:
Thanks!  Used above.  There's some Ubuntu-related issues, I'll try my luck with
Launchpad for those *cross fingers*.

comment #11 (again):
Will try the patch ASAP, meaning once I've figured out how to best "inject" it
into the local Ubuntu eco-system without disrupting the package management,
updates etc.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

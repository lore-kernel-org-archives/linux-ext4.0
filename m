From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12821] filesystem corrupts on heavy I/O
Date: Fri, 13 Mar 2009 00:11:46 -0700 (PDT)
Message-ID: <20090313071146.4B541108042@picon.linux-foundation.org>
References: <bug-12821-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbZCMHMw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Mar 2009 03:12:52 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2D7BkL7031720
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2009 00:12:22 -0700
In-Reply-To: <bug-12821-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12821





------- Comment #14 from lucent+lkml@gmail.com  2009-03-13 00:11 -------
I'm seeing a similar error with heavy read/write I/O on a 1TB ext4 volume. It's
not clear what behavior triggers the error for me. Occasionally I see the error
in dmesg...

[ 7829.004269] EXT4-fs error (device sdb1): ext4_ext_search_right: bad header
in inode #2491097: unexpected eh_depth - magic f30a, entries 78, max 340(0),
depth 1(2)
[ 7829.012197] mpage_da_map_blocks block allocation failed for inode 2491097 at
logical offset 2788227 with max blocks 7 with error -5
[ 7829.012220] This should not happen.!! Data will be lost

...and sync does not complete. It's not clear from the discussion if e2image
needs to be done before the error occurs on a clean mount, or afterward while
the system is up.

When this happens the reboot procedure does not complete, and I power cycle the
machine. After a power cycle, the journal replays and fsck completes, no
inconsistencies. The files affected by data loss are part of a BitTorrent
network download and after a Torrent data consistency check, I confirm that
data has been lost. If I leave the Torrent active downloading for more than an
hour or so, the ext4 errors occur.

So, "me too" with linux-image-2.6.28-8-generic 2.6.28-8-generic #28-Ubuntu SMP
Thu Mar 5 21:49:36 UTC 2009 i686 GNU/Linux. I'm willing to provide debug info
to an interested developer, privately.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12579] ext4 filesystem hang
Date: Thu, 12 Feb 2009 16:42:52 -0800 (PST)
Message-ID: <20090213004252.8FE62108040@picon.linux-foundation.org>
References: <bug-12579-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756939AbZBMAnX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2009 19:43:23 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1D0gqs2013692
	for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2009 16:42:53 -0800
In-Reply-To: <bug-12579-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12579





------- Comment #6 from sandeen@redhat.com  2009-02-12 16:42 -------
dJust for the record; here are the paths we're stuck on:

livecd:

sys_fdatasync
        do_fsync
                vfs_fsync
                        filemap_fdatawrite
                                __filemap_fdatawrite_range
                                        do_writepage
                                                ext4_da_writepages
                                                        write_cache_pages
                                                                lock page
(currently locked by pdflush)

pdflush:

pdflush
        background_writeout
                writeback_inodes
                        generic_sync_sb_inodes
                                __writeback_single_inode
                                        do_writepages
                                                ext4_da_writepages
                                                        write_cache_pages
                                                                lock page
(currently loscked by livecd)

the pdflush wbc looks like:

[1]kdb> wbc 0xffff88007d4abe10
struct writeback_control at  0xffff88007d4abe10
 bdi = (null) sync_mode 0 (NONE)
 nr_to_write = 992 pages_skipped = 0
 range_start 0, range_end 0
 nonblocking 1   congestion 0 kupdate 0   reclaim 0
  writepages 1 range_cyclic 1 more_io 0 no_update 1

and the livecd-creator fsync wbc looks like:

[1]kdb> wbc 0xffff880012821ea8
struct writeback_control at  0xffff880012821ea8
 bdi = (null) sync_mode 1 (ALL)
 nr_to_write = 9223372036854775689 pages_skipped = 0
 range_start 0, range_end 9223372036854775807
 nonblocking 0   congestion 0 kupdate 0   reclaim 0
  writepages 1 range_cyclic 0 more_io 0 no_update 1


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

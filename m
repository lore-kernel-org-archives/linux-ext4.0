From: Jan Kara <jack@suse.cz>
Subject: [PATCH 00/22 v1] Fixes and improvements in ext4 writeback path
Date: Mon,  8 Apr 2013 23:32:05 +0200
Message-ID: <1365456754-29373-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760614Ab3DHVc6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Apr 2013 17:32:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

  this is my series of patches improving ext4 writeback path and somewhat
cleaning up that code. Some things this patch set achieves:
* ext4_io_end structure doesn't contain page pointers anymore so it is
  significantly smaller (by about 1KB) (patch 1)
* bio splitting is now handled properly so we no longer hit warnings
  about extents changed while IO was in progress (patch 2)
* JBD2 supports transaction reservations - a way to start a transaction
  without blocking on journal (patch 12)
* cleanups of ext4_da_writepages() and connected stuff (patches 14-18)
* we clear PageWriteback bit only after extents are converted (PATCHES 22)
* we can thus remove waits for unwritten extent conversion

  I've tested patches with xfstests in different configurations (default,
dioread_nolock, nojournal, blocksize 1KB). The patches are based on ext4
development branch (and actually depend on some of the fixes there from Dmitry
and Zheng). Now I understand this might be a too big chunk to swallow at once.
So I could maybe split out some easier parts for the nearest merge window.
But for now I wanted to post everything anyway for people to review.

								Honza


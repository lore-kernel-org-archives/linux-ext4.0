From: Jan Kara <jack@suse.cz>
Subject: [PATCH 00/22 v2] Fixes and improvements in ext4 writeback path
Date: Fri, 31 May 2013 11:42:33 +0200
Message-ID: <1369993379-13017-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42963 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab3EaJnH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 May 2013 05:43:07 -0400
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
dioread_nolock, nojournal, blocksize 1KB). The patches are based on recent
Linus' tree.

Since v1 I've fixed couple of bugs found during testing:
* Changed transaction reservation API because it had inherent deadlocks when
  the journal got frozen
* I've fixed some issues in my writeback patches resulting in bad extent
  conversion

The timing of the submission isn't perfect since I'm leaving for two weeks
of vacation (out of email) so I won't be able to react but it took me much
longer than I expected to nail down all the bugs I found.

The patch set needs a serious testing so please beat it as much as you can.
I once hit a fs corruption (used block marked as freed) which I was not able
to explain in nojournal mode and I didn't reproduce it since so there may be
bugs hiding (or it may have been completely unrelated bug).

								Honza


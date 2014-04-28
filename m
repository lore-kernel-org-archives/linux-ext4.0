From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/2 -v2] resize2fs: fix up minimum size calculations
Date: Mon, 28 Apr 2014 07:26:34 -0400
Message-ID: <1398684396-32689-1-git-send-email-tytso@mit.edu>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36917 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108AbaD1L0q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2014 07:26:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The second patch fixes up situations where the flex_bg calculations were
being over-optimistic.  We now assume that all of the metadata blocks in
the last flex_bg must be counted as overhead, since they can't be used
while we are shrinking the file system (so we can more easily recover if
resize2fs aborts for some reason).

I did say that fixing this was low priority, but why it was failing was
nagging at me, and I finally figured out what needed to be fixed.  :-)

Theodore Ts'o (2):
  resize2fs: fix overly-pessimistic calculation of minimum size required
  resize2fs: refine minimum required blocks for flex_bg file systems

 resize/resize2fs.c        | 106 +++++++++++++++++++++++++++++-----------------
 tests/scripts/resize_test |  22 ++++++----
 2 files changed, 82 insertions(+), 46 deletions(-)

-- 
1.9.0


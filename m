From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12568] BUG: filefrag errors on non-journal ext4 filesystem
Date: Thu, 29 Jan 2009 21:02:00 -0800 (PST)
Message-ID: <20090130050201.08F74108040@picon.linux-foundation.org>
References: <bug-12568-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779AbZA3FCb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Jan 2009 00:02:31 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0U521EF004571
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jan 2009 21:02:02 -0800
In-Reply-To: <bug-12568-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12568





------- Comment #1 from tytso@mit.edu  2009-01-29 21:02 -------
Here's the patch to fix this issue.

                                        - Ted

>From b9ec63f78b425c0e16cc95605b5d4ff2dc228b97 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Fri, 30 Jan 2009 00:00:24 -0500
Subject: [PATCH] ext4: Remove bogus BUG() check in ext4_bmap()

The code to support journal-less ext4 operation added a BUG to
ext4_bmap() which fired if there was no journal and the
EXT4_STATE_JDATA bit was set in the i_state field.  This caused
running the filefrag program (which uses the FIMBAP ioctl) to trigger
a BUG().

The EXT4_STATE_JDATA bit is only used for ext4_bmap(), and it's
harmless for the bit to be set.  We could add a check in
__ext4_journalled_writepage() and ext4_journalled_write_end() to only
set the EXT4_STATE_JDATA bit if the journal is present, but that adds
an extra test and jump instruction.  It's easier to simply remove the
BUG check.

http://bugzilla.kernel.org/show_bug.cgi?id=12568

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
---
 fs/ext4/inode.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b4386da..03ba20b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2821,9 +2821,6 @@ static sector_t ext4_bmap(struct address_space *mapping,
sector_t block)
                filemap_write_and_wait(mapping);
        }

-       BUG_ON(!EXT4_JOURNAL(inode) &&
-              EXT4_I(inode)->i_state & EXT4_STATE_JDATA);

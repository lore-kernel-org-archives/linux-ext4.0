From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] jbd2: fix regression where we fail to initialize checksum
 seed when loading
Date: Mon, 1 Dec 2014 16:22:23 -0800
Message-ID: <20141202002223.GT10043@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Whitney <enwlinux@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45295 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbaLBAWd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2014 19:22:33 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're enabling journal features, we cannot use the predicate
jbd2_journal_has_csum_v2or3() because we haven't yet set the sb
feature flag fields!  Moreover, we just finished loading the shash
driver, so the test is unnecessary; calculate the seed always.

Without this patch, we fail to initialize the checksum seed the first
time we turn on journal_checksum, which means that all journal blocks
written during that first mount are corrupt.  Transactions written
after the second mount will be fine, since the feature flag will be
set in the journal superblock.  xfstests generic/{034,321,322} are the
regression tests.

(This is important for 3.18.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.coM>
Reported-by: Eric Whitney <enwlinux@gmail.com>
---
 fs/jbd2/journal.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index e4dc747..1df94fa 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1853,13 +1853,12 @@ int jbd2_journal_set_features (journal_t *journal, unsigned long compat,
 				journal->j_chksum_driver = NULL;
 				return 0;
 			}
-		}
 
-		/* Precompute checksum seed for all metadata */
-		if (jbd2_journal_has_csum_v2or3(journal))
+			/* Precompute checksum seed for all metadata */
 			journal->j_csum_seed = jbd2_chksum(journal, ~0,
 							   sb->s_uuid,
 							   sizeof(sb->s_uuid));
+		}
 	}
 
 	/* If enabling v1 checksums, downgrade superblock */

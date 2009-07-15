From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd: Fail to load a journal if it is too short
Date: Wed, 15 Jul 2009 21:05:16 +0200
Message-ID: <1247684717-16662-1-git-send-email-jack@suse.cz>
Cc: tytso@mit.edu, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172AbZGOTFV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Jul 2009 15:05:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Due to on disk corruption, it can happen that journal is too short. Fail
to load it in such case so that we don't oops somewhere later.

Reported-by: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/journal.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 737f724..94a64a1 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -848,6 +848,12 @@ static int journal_reset(journal_t *journal)
 
 	first = be32_to_cpu(sb->s_first);
 	last = be32_to_cpu(sb->s_maxlen);
+	if (first + JFS_MIN_JOURNAL_BLOCKS > last + 1) {
+		printk(KERN_ERR "JBD: Journal too short (blocks %lu-%lu).\n",
+		       first, last);
+		journal_fail_superblock(journal);
+		return -EINVAL;
+	}
 
 	journal->j_first = first;
 	journal->j_last = last;
-- 
1.6.0.2


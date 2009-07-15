From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd2: Fail to load a journal if it is too short
Date: Wed, 15 Jul 2009 21:05:17 +0200
Message-ID: <1247684717-16662-2-git-send-email-jack@suse.cz>
References: <1247684717-16662-1-git-send-email-jack@suse.cz>
Cc: tytso@mit.edu, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:40243 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932222AbZGOTFV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Jul 2009 15:05:21 -0400
In-Reply-To: <1247684717-16662-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Due to on disk corruption, it can happen that journal is too short. Fail
to load it in such case so that we don't oops somewhere later.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/journal.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index e378cb3..a8a358b 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1187,6 +1187,12 @@ static int journal_reset(journal_t *journal)
 
 	first = be32_to_cpu(sb->s_first);
 	last = be32_to_cpu(sb->s_maxlen);
+	if (first + JBD2_MIN_JOURNAL_BLOCKS > last + 1) {
+		printk(KERN_ERR "JBD: Journal too short (blocks %llu-%llu).\n",
+		       first, last);
+		journal_fail_superblock(journal);
+		return -EINVAL;
+	}
 
 	journal->j_first = first;
 	journal->j_last = last;
-- 
1.6.0.2


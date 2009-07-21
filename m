From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/5] jbd: Fail to load a journal if it is too short
Date: Tue, 21 Jul 2009 12:04:15 +0200
Message-ID: <1248170659-11771-2-git-send-email-jack@suse.cz>
References: <1248170659-11771-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36319 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584AbZGUKEV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jul 2009 06:04:21 -0400
In-Reply-To: <1248170659-11771-1-git-send-email-jack@suse.cz>
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


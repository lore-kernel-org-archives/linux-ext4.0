From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/5] ext4: Fix setting of referenced bit in ext4_es_lookup_extent()
Date: Thu,  3 Mar 2016 11:23:47 +0100
Message-ID: <1457000631-10215-2-git-send-email-jack@suse.cz>
References: <1457000631-10215-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51039 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838AbcCCKXj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Mar 2016 05:23:39 -0500
In-Reply-To: <1457000631-10215-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We were setting referenced bit on the extent structure we return from
ext4_es_lookup_extent() which is just a private structure on stack. Thus
setting had no effect. Set the bit in the structure in the status tree
instead.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents_status.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index ac748b3af1c1..e38b987ac7f5 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -823,8 +823,8 @@ out:
 		es->es_lblk = es1->es_lblk;
 		es->es_len = es1->es_len;
 		es->es_pblk = es1->es_pblk;
-		if (!ext4_es_is_referenced(es))
-			ext4_es_set_referenced(es);
+		if (!ext4_es_is_referenced(es1))
+			ext4_es_set_referenced(es1);
 		stats->es_stats_cache_hits++;
 	} else {
 		stats->es_stats_cache_misses++;
-- 
2.6.2


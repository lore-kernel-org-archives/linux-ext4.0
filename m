From: Cong Wang <amwang@redhat.com>
Subject: [PATCH 01/12] jbd2: remove the second argument of kmap_atomic
Date: Sat, 23 Jun 2012 18:04:12 +0800
Message-ID: <1340445863-16111-2-git-send-email-amwang@redhat.com>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Cong Wang <amwang@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565Ab2FWKEp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Jun 2012 06:04:45 -0400
In-Reply-To: <1340445863-16111-1-git-send-email-amwang@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Cong Wang <amwang@redhat.com>

---
 fs/jbd2/commit.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 216f429..af5280f 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -349,12 +349,12 @@ static void jbd2_block_tag_csum_set(journal_t *j, journal_block_tag_t *tag,
 		return;
 
 	sequence = cpu_to_be32(sequence);
-	addr = kmap_atomic(page, KM_USER0);
+	addr = kmap_atomic(page);
 	csum = jbd2_chksum(j, j->j_csum_seed, (__u8 *)&sequence,
 			  sizeof(sequence));
 	csum = jbd2_chksum(j, csum, addr + offset_in_page(bh->b_data),
 			  bh->b_size);
-	kunmap_atomic(addr, KM_USER0);
+	kunmap_atomic(addr);
 
 	tag->t_checksum = cpu_to_be32(csum);
 }
-- 
1.7.7.6


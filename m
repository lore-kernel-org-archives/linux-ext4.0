From: Cong Wang <amwang@redhat.com>
Subject: [PATCH 35/60] jbd: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:39:56 +0800
Message-ID: <1328852421-19678-36-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Cong Wang <amwang@redhat.com>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Cong Wang <amwang@redhat.com>
---
 fs/jbd/journal.c     |   12 ++++++------
 fs/jbd/transaction.c |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 59c09f9..e49e81b 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -328,7 +328,7 @@ repeat:
 		new_offset = offset_in_page(jh2bh(jh_in)->b_data);
 	}
 
-	mapped_data = kmap_atomic(new_page, KM_USER0);
+	mapped_data = kmap_atomic(new_page);
 	/*
 	 * Check for escaping
 	 */
@@ -337,7 +337,7 @@ repeat:
 		need_copy_out = 1;
 		do_escape = 1;
 	}
-	kunmap_atomic(mapped_data, KM_USER0);
+	kunmap_atomic(mapped_data);
 
 	/*
 	 * Do we need to do a data copy?
@@ -354,9 +354,9 @@ repeat:
 		}
 
 		jh_in->b_frozen_data = tmp;
-		mapped_data = kmap_atomic(new_page, KM_USER0);
+		mapped_data = kmap_atomic(new_page);
 		memcpy(tmp, mapped_data + new_offset, jh2bh(jh_in)->b_size);
-		kunmap_atomic(mapped_data, KM_USER0);
+		kunmap_atomic(mapped_data);
 
 		new_page = virt_to_page(tmp);
 		new_offset = offset_in_page(tmp);
@@ -368,9 +368,9 @@ repeat:
 	 * copying, we can finally do so.
 	 */
 	if (do_escape) {
-		mapped_data = kmap_atomic(new_page, KM_USER0);
+		mapped_data = kmap_atomic(new_page);
 		*((unsigned int *)(mapped_data + new_offset)) = 0;
-		kunmap_atomic(mapped_data, KM_USER0);
+		kunmap_atomic(mapped_data);
 	}
 
 	set_bh_page(new_bh, new_page, new_offset);
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 7fce94b..b2a7e52 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -718,9 +718,9 @@ done:
 			    "Possible IO failure.\n");
 		page = jh2bh(jh)->b_page;
 		offset = offset_in_page(jh2bh(jh)->b_data);
-		source = kmap_atomic(page, KM_USER0);
+		source = kmap_atomic(page);
 		memcpy(jh->b_frozen_data, source+offset, jh2bh(jh)->b_size);
-		kunmap_atomic(source, KM_USER0);
+		kunmap_atomic(source);
 	}
 	jbd_unlock_bh_state(bh);
 
-- 
1.7.7.6

From: "Patrick J. LoPresti" <lopresti@gmail.com>
Subject: [PATCH 2/2] OCFS2: Allow huge (> 16 TiB) volumes to mount
Date: Sun, 11 Jul 2010 10:04:38 -0700
Message-ID: <87zkxyvtjt.fsf@patl.com>
References: <871vbax86w.fsf@patl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: ocfs2-devel@oss.oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48996 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab0GKREq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Jul 2010 13:04:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The OCFS2 developers have already done all of the hard work to allow
volumes larger than 16 TiB.  But there is still a "sanity check" in
fs/ocfs2/super.c that prevents the mounting of such volumes, even when
the cluster size and journal options would allow it.

This patch replaces that sanity check with a more sophisticated one to
mount a huge volume provided that (a) it is addressable by the raw
word/address size of the system (borrowing a test from ext4); (b) the
volume is using JBD2; and (c) the JBD2_FEATURE_INCOMPAT_64BIT flag is
set on the journal.

I factored out the sanity check into its own function.  I also moved it
from ocfs2_initialize_super() down to ocfs2_check_volume(); any earlier,
and the journal will not have been initialized yet.

This patch is one of a pair, and it depends on the other ("JBD2: Allow
feature checks before journal recovery").

I have tested this patch on small volumes, huge volumes, and huge
volumes without 64-bit block support in the journal.  All of them appear
to work or to fail gracefully, as appropriate.

Signed-off-by: Patrick LoPresti <lopresti@gmail.com>


diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0eaa929..b809508 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1991,6 +1991,47 @@ static int ocfs2_setup_osb_uuid(struct ocfs2_super *osb, const unsigned char *uu
 	return 0;
 }
 
+/* Check to make sure entire volume is addressable on this system.
+   Requires osb_clusters_at_boot to be valid and for the journal to
+   have been initialized by ocfs2_journal_init(). */
+static int ocfs2_check_addressable(struct ocfs2_super *osb)
+{
+	int status = 0;
+	u64 max_block =
+		ocfs2_clusters_to_blocks(osb->sb,
+					 osb->osb_clusters_at_boot) - 1;
+
+	/* Absolute addressability check (borrowed from ext4/super.c) */
+	if ((max_block >
+	     (sector_t)(~0LL) >> (osb->sb->s_blocksize_bits - 9)) ||
+	    (max_block > (pgoff_t)(~0LL) >> (PAGE_CACHE_SHIFT -
+					     osb->sb->s_blocksize_bits))) {
+		mlog(ML_ERROR, "Volume too large "
+		     "to mount safely on this system");
+		status = -EFBIG;
+		goto out;
+	}
+
+	/* 32-bit block number is always OK. */
+	if (max_block <= (u32)~0UL)
+		goto out;
+
+	/* Volume is "huge", so see if our journal is new enough to
+	   support it. */
+	if (!(OCFS2_HAS_COMPAT_FEATURE(osb->sb,
+				       OCFS2_FEATURE_COMPAT_JBD2_SB) &&
+	      jbd2_journal_check_used_features(osb->journal->j_journal, 0, 0,
+					       JBD2_FEATURE_INCOMPAT_64BIT))) {
+		mlog(ML_ERROR, "The journal cannot address the entire volume. "
+		     "Enable the 'block64' journal option with tunefs.ocfs2");
+		status = -EFBIG;
+		goto out;
+	}
+
+ out:
+	return status;
+}
+
 static int ocfs2_initialize_super(struct super_block *sb,
 				  struct buffer_head *bh,
 				  int sector_size,
@@ -2215,14 +2256,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		goto bail;
 	}
 
-	if (ocfs2_clusters_to_blocks(osb->sb, le32_to_cpu(di->i_clusters) - 1)
-	    > (u32)~0UL) {
-		mlog(ML_ERROR, "Volume might try to write to blocks beyond "
-		     "what jbd can address in 32 bits.\n");
-		status = -EINVAL;
-		goto bail;
-	}

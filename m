Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF8D3033DE
	for <linux-ext4@vger.kernel.org>; Mon, 15 Jun 2026 18:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781547946; cv=none; b=Lh0krSwBtD3i2gZDVliubA5cbGinKwwXLg2PVUWCCNRxTdaBoUD9z+YN4ZzwgG5CrwKE+BfUqtcg+DCSoU3FHBQqqVbp5aixYfJ9Uh0dwVS+W35rtSxEO0jH0/mfnDzmW/jxPb+THpHReftzJHZSDUnqF5BLmBsPWIL8JpqmFrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781547946; c=relaxed/simple;
	bh=+yhl2j/hxcVIwjj56PNgFacBkc5RHbvikXpYyqtYj7U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mF1WryT4+71hwyJz4L/D62NrXiwbUsHAMAlLsVcis2klBtVsUHXlnwQXf7NymesYBxDvZd51Xfh/RkLC8EciTwTVdGEFVMLQ1z7iF3hScgiR1n62NToL2a5J7gMJM2+bqudG0Luhi/5sjzTPTVPDd+D7FOl6iNCBu3W2ugmAnAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=E1z3xUq0; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E1z3xUq0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=9HseYDs+9tAqqk99ld1ikUHazfvOBvhyuR6kFOkZOY0=; b=E1z3xUq0HqcvYhOgGxQmfh54Bp
	2CmnUFedcL14X6W/E/X5GOntT475hiSiZGK1vO4XfVE9lSgcrflLMZ2kjR20/0vda3rJkiYoZWpU1
	0RBmvavilDtK1KFeHH7aEZbaGLMdV0mMJVB+T3lRLYnWcSTZbDrt2B64NV7bZl9ENrPLGEScAO9IO
	fjwX+mIZkUPjPG0fKwIx9iKocCM8F3Q9yGsCYomnsBw2BssK3bDk9MvxwwV7MRtLW89YeeRVKcKFb
	HmlRMhcnov4NAnQKgrRhBZ+LBd/MzvNO1SC/q2C6Z3fKOILy2QiFY4fx2qYzyYvbn8YE1Tm81jSjl
	VFrAisCA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZC08-00000009GXu-2msG;
	Mon, 15 Jun 2026 18:25:36 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org
Subject: [PATCH] ext4: Remove ext4_end_buffer_io_sync()
Date: Mon, 15 Jun 2026 19:25:25 +0100
Message-ID: <20260615182527.2208479-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's no need for a custom end_io routine here.  We lose some
tracing of I/O completions, but we gain better error handling.
Well, consistent error handling anyway.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ext4/fast_commit.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 5773b85e43cb..6b00a7285344 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -184,25 +184,6 @@
 #include <trace/events/ext4.h>
 static struct kmem_cache *ext4_fc_dentry_cachep;
 
-static void ext4_end_buffer_io_sync(struct bio *bio)
-{
-	struct buffer_head *bh;
-	bool uptodate = bio_endio_bh(bio, &bh);
-
-	BUFFER_TRACE(bh, "");
-	if (uptodate) {
-		ext4_debug("%s: Block %lld up-to-date",
-			   __func__, bh->b_blocknr);
-		set_buffer_uptodate(bh);
-	} else {
-		ext4_debug("%s: Block %lld not up-to-date",
-			   __func__, bh->b_blocknr);
-		clear_buffer_uptodate(bh);
-	}
-
-	unlock_buffer(bh);
-}
-
 static inline void ext4_fc_reset_inode(struct inode *inode)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
@@ -662,7 +643,7 @@ static void ext4_fc_submit_bh(struct super_block *sb, bool is_tail)
 	lock_buffer(bh);
 	set_buffer_dirty(bh);
 	set_buffer_uptodate(bh);
-	bh_submit(bh, REQ_OP_WRITE | write_flags, ext4_end_buffer_io_sync);
+	bh_submit(bh, REQ_OP_WRITE | write_flags, bh_end_write);
 	EXT4_SB(sb)->s_fc_bh = NULL;
 }
 
-- 
2.47.3


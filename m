Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05D2331A7B
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jul 2026 04:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783054494; cv=none; b=SMKIvTXmVqTv0PfJsHxhOp7TxSae1Y2LcIX5a2yMw8LwGofDHKg54XGjZjq8lBlCc39nEKmPurqsOd8WIe+mh92ZB1g82r48vrq/mwMhr0LIf723o/7hkmOaclMWcnWmazCLz/iQgDpTztgZ+5G+5GxY+/v7pKxHzt9pq35BsVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783054494; c=relaxed/simple;
	bh=HDzAhATYxRzS5JprzltqSD7mNW7p2WeIZkiPo4++51Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fgF3jcRKzno25jHTd/wXZ8YVwXSIvJq5f41KoN+FiRpUHFGv0aWiomJhyuCokDUXXf9MHRG2cvnGq1EbBAWZNMY7n/KlHvjt0Qe6lebKZjQ+hdbD7sPy/M4Uzf7MKGOMRpgTZr3lopxFmHL8qxzpSCs7em+xDvoRJkag2Q48SLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ouMUC7os; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ouMUC7os"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2c82538b6b0so1019185ad.1
        for <linux-ext4@vger.kernel.org>; Thu, 02 Jul 2026 21:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783054483; x=1783659283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D5ikfH7B/13WQxyOlzL4BmCTKB0fEMAdj0mk6w9hYYE=;
        b=ouMUC7osSfvsueO9wzApQdql1lbQOuf8A5/i2NjBwTjHVbF9WnI3cSajNerXwhcnlQ
         MSB8C+cMt2rDVCd0KahkG+unDuZM0gVrZK/ey3DmphS5yvFD2b8c051NdM4Zjuo3ltFy
         T5pyQ3Qpw2J/J9oXfp/PDerKjitdAkzd8q2EKvTXwrjUYW1gs5eznB+fXswQOsBRy4g3
         +fNkcWQDJya8/v/MFvagnM3IoBHouvVyhKK3dQAwyOMSn1/XsdSDsyln1ayh2zKU5ost
         NYLpMCiluJiYEk9iXddEMZk9vkha8JsGPS2loT0nXWEmWomfAsLvcx38r5Stb2qEg0iR
         Fn9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783054483; x=1783659283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D5ikfH7B/13WQxyOlzL4BmCTKB0fEMAdj0mk6w9hYYE=;
        b=eH7uYzyRlBQBIs3hwAjUKHuxFhhjf/AvzmH4UiQEyAIQS5r95aS61fCToub147he0j
         H4aofQv+z7ZzUbHHpvDug0LrSiCLlqq3Au5FReou15/3jUFjMCLMeCBL4I0/Eom1SUab
         FmVqgR1yX0zoh+MAXDQDEzY7sMyHDI6QUk7GefHZ2uUH5wTF9+gADXtvxhmY/RF3vq64
         u97QX6nTPkXRNNjfHWqqMxSv77sPvjXq0UR6iW7SWLKxvxHmUCEWZm6ZvUnqeWMOfd4n
         kjYGW/1E88uoXTKLRDMoI9BjQS1xsFVW2Gf1bmv3C0ByLWBbScHoaq+dvvqppmUE+0ZQ
         JklQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr1PfMuGoYpdCWlik5mRTQIyCgBPtPtruX4KLUj3sa3aU11b0CGeaiGU+WAtMNN5ZAnR9p+0/Q1HIm5@vger.kernel.org
X-Gm-Message-State: AOJu0YxvlidCnOjTnE4IZjFMjjpHwzMAKVHIfeg/3oZoS6IpwUeMHoN3
	yvsf3ZS8H4rlFP5rYZmhGqWM3HeZzZgyH7/MryFmr5q88rmbvrIqA9sH
X-Gm-Gg: AfdE7cmYPAzvEZLXnVQ1vCwvw2r+SQtxTfHMDGi1+fpe4It7Uw3vAPoDy8Iw8JNcflr
	GHe/7vzCcGNinsyNpNJcSTJWZz8FzAs/gE571ZI8fccJgrY56spFljxtcv+zIjXTvY5BRBzmZrL
	HBwjqfeuBKHYgsuaGhRytkFlLTW8NJGgkd5fH9U+9y4tt0CEY9+6hiAuKw27Qe9t99YIfPp5SGC
	vK4UXWJAwswhRvSvVPPw/1jyrxlEiVzWq8j5ZxMAzHgqSRaivOh8PUeBUlT5SHG+dmIMGIqWPrm
	2N+mIt8JB2MaVDcYCoxQ1LsJ1iUQOWCnoGJv35oSQo4YeBLr1eaKbzt0xX2pOKacgDRv10t3Z11
	qgsJKvHLnKnALSnvgn8TdGsV2yfaOYm11HrcR7lPM373/Q4PWw68QzJBUkvx0C3X00ij1WbXI5i
	n9LSFabBHCnnAAqccuo3n6M2ddbcLkLuDKOgzX2FiSGHKa1pjQe5machOemcVXvF8lyw6F06BBL
	aXe6wWZkpbh7xKj/jBJNEXETFfVwshra6+t9oprvosv88JIgIsUD6En+ySQ6GhzDOIahs7xauMT
	owKV/5eXK+D5tBetajDllgY=
X-Received: by 2002:a17:902:e5c1:b0:2ca:c68:c554 with SMTP id d9443c01a7336-2ca7e90cea8mr96189345ad.38.1783054482619;
        Thu, 02 Jul 2026 21:54:42 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (213.28.87.34.bc.googleusercontent.com. [34.87.28.213])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b3c7fa65asm15615643c88.6.2026.07.02.21.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 21:54:42 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Tao Ma <boyu.mt@taobao.com>,
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH v4 2/2] ext4: cleanup unused CONVERT_INLINE_DATA flag
Date: Fri,  3 Jul 2026 04:54:13 +0000
Message-ID: <20260703045414.1768-2-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260703045414.1768-1-aditya.ansh182@gmail.com>
References: <20260703045414.1768-1-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

After implementing bitwise flags for tracking the inline data write
state in the address space fsdata parameter, the CONVERT_INLINE_DATA
state flag is left unused and can be removed.

Perform this clean-up by:
1) Deleting the CONVERT_INLINE_DATA definition from ext4.h.
2) Removing the void **fsdata argument from both the forward
   declaration and the definition of the internal helper
   ext4_da_convert_inline_data_to_extent().
3) Removing the void **fsdata argument from the declaration and
   definition of ext4_generic_write_inline_data() and updating
   the caller ext4_try_to_write_inline_data() and the internal
   re-alloc retry logic accordingly.
4) Updating ext4_da_write_begin() to call
   ext4_generic_write_inline_data() without the fsdata parameter.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
---
Changes in v4:
- Resent as Patch 2/2 of the v4 series, as suggested by Jan Kara.

Changes in v3:
- Initial version of the cleanup patch.

 fs/ext4/ext4.h   |  5 ++---
 fs/ext4/inline.c | 13 +++++--------
 fs/ext4/inode.c  |  2 +-
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9e6f6467bdeb..c2e4262406a7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3137,8 +3137,7 @@ int do_journal_get_write_access(handle_t *handle, struct inode *inode,
 				struct buffer_head *bh);
 void ext4_set_inode_mapping_order(struct inode *inode);
 #define FALL_BACK_TO_NONDELALLOC 1
-#define CONVERT_INLINE_DATA	 2
-#define EXT4_WRITE_DATA_INLINE	 4
+#define EXT4_WRITE_DATA_INLINE	 2
 
 typedef enum {
 	EXT4_IGET_NORMAL =	0,
@@ -3749,7 +3748,7 @@ extern int ext4_generic_write_inline_data(struct address_space *mapping,
 					  struct inode *inode,
 					  loff_t pos, unsigned len,
 					  struct folio **foliop,
-					  void **fsdata, bool da);
+					  bool da);
 extern int ext4_try_add_inline_entry(handle_t *handle,
 				     struct ext4_filename *fname,
 				     struct inode *dir, struct inode *inode);
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index cfd591dc1d9c..0cb2dc195d23 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -22,8 +22,7 @@
 
 
 static int ext4_da_convert_inline_data_to_extent(struct address_space *mapping,
-						 struct inode *inode,
-						 void **fsdata);
+						 struct inode *inode);
 
 static int ext4_get_inline_size(struct inode *inode)
 {
@@ -697,7 +696,7 @@ int ext4_generic_write_inline_data(struct address_space *mapping,
 					  struct inode *inode,
 					  loff_t pos, unsigned len,
 					  struct folio **foliop,
-					  void **fsdata, bool da)
+					  bool da)
 {
 	int ret;
 	handle_t *handle;
@@ -728,7 +727,7 @@ int ext4_generic_write_inline_data(struct address_space *mapping,
 			return ext4_convert_inline_data_to_extent(mapping, inode);
 		}
 
-		ret = ext4_da_convert_inline_data_to_extent(mapping, inode, fsdata);
+		ret = ext4_da_convert_inline_data_to_extent(mapping, inode);
 		if (ret == -ENOSPC &&
 		    ext4_should_retry_alloc(inode->i_sb, &retries))
 			goto retry_journal;
@@ -788,7 +787,7 @@ int ext4_try_to_write_inline_data(struct address_space *mapping,
 	if (pos + len > ext4_get_max_inline_size(inode))
 		return ext4_convert_inline_data_to_extent(mapping, inode);
 	return ext4_generic_write_inline_data(mapping, inode, pos, len,
-					      foliop, NULL, false);
+					      foliop, false);
 }
 
 int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
@@ -895,8 +894,7 @@ int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
  *    need to start the journal since the file's metadata isn't changed now.
  */
 static int ext4_da_convert_inline_data_to_extent(struct address_space *mapping,
-						 struct inode *inode,
-						 void **fsdata)
+						 struct inode *inode)
 {
 	int ret = 0, inline_size;
 	struct folio *folio;
@@ -934,7 +932,6 @@ static int ext4_da_convert_inline_data_to_extent(struct address_space *mapping,
 	folio_mark_dirty(folio);
 	folio_mark_uptodate(folio);
 	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
-	*fsdata = (void *)CONVERT_INLINE_DATA;
 
 out:
 	up_read(&EXT4_I(inode)->xattr_sem);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4e1bf54e511d..9a0fbaf73ce2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3160,7 +3160,7 @@ static int ext4_da_write_begin(const struct kiocb *iocb,
 
 	if (ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
 		ret = ext4_generic_write_inline_data(mapping, inode, pos, len,
-						     foliop, fsdata, true);
+						     foliop, true);
 		if (ret < 0)
 			return ret;
 		if (ret == 1) {
-- 
2.47.3


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794811678;
	b=uYMb/xIGmpwGYJ98vtZmGovmWexNEd54k4U5Svk4xPl+Rhavn0gklW/hTdouWK/th9oP
	 lbSLZ9FVebnjK79wpCVglde646qajuSgxf5P+/Q4uxqKNbOEPbSZlnQGB5zhwicYhLnfD
	 jgAqtATJyyjH+bOTaHLvA993JIUGY4DvboC/W3DyFvaEJB1FhbUKwGYuy33vMifmKgWqJ
	 aIRzgEr3sra5ctrIqHJ6GmZkfvjYIN8r+hQQc4uOCF5Vfqez0zSEB4RGQUj9akZapG7mD
	 z/SUgV2Ksc9f3XasKIDU2DzHEKcEV9iNSu+NdZjWXNbcwJB4v7rjO2kc1U57dYQHVRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794811678;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=eVhP3LRqJHhYEsx9ZbvkWC6JNUlGUl5WelJoGcAFuTs=;
	b=aQ1wAIFEvbmt2LdVOu5xGjsFuYOkF8YqFVRxCMudDoRp1SlOxoJ41smpG4O/U3w8t1Ze
	 tvftaNzHnmg+Q2AuFZsFqvE7yXrb/Bb4Lqd+YaHKwl3clgTAzfh9c9G8tjJxg67b8HcaM
	 ecAGRMxmifwi5SjM7dZTyc3Ayn9J44TLoVJmP5pdJaS4wEJ+97pUwVU1GsWmtOK/suwQH
	 KVc1Hjg5Uqr/n4kWTEG2fKKpWKjOo8CL/PXDlmSHYGokQm3aNtkA+ZJ3BeA+4XhhQAIN5
	 gHmFAncrhlt+BgEvLb5thmnEpLsO7mux7I/+tGe3OVvskHDki9q1FuJslegbinJyyZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=QQJmFZ1m;
	arc=none smtp.remote-ip=209.85.210.182
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D479606A334
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 06:47:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D479606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=QQJmFZ1m
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8b600fae14dso1347625b3a.2
        for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2026 22:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794811677; x=1795416477; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eVhP3LRqJHhYEsx9ZbvkWC6JNUlGUl5WelJoGcAFuTs=;
        b=QQJmFZ1mQkBPIp3OJJ2QCPQFH5/DyJE+fgUmGyBP68cYKRqJ6zFiUSkJ6JEYd/SP4z
         Yn30IflMFmyF2SUhbm4cVra/PKBeQO1egLwXmTNC/Hg+EzM9cs7RwUYmWA1v82Wk9ibD
         CTWGx18jPLCIWaGa3po41ONPO1WJh/HwVSaMksPM6hrT+BYiOAB0Uv24G304c+SQWURr
         APsnb3ob+7LD6zo+167QJ7p7Dv4t/vBpxCdV1VLXUGxA8WCZ0OjOzFjcdgHw3re+b9ZO
         hdBQNFytM3dVZEQyWsI8rRt4prl/PxjLvVH9WPPmlkoAUlojUO/Krj/wOobL+NihAb2z
         k8wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794811677; x=1795416477;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eVhP3LRqJHhYEsx9ZbvkWC6JNUlGUl5WelJoGcAFuTs=;
        b=ixlItQZ94f3NUEa26gVZNTnPznnqWGobmbO31laQPfU9gGtDM+Z9dEDDg5TvqE3vWV
         htADLfYuUNdjNpD0l8Tm1LeXScnmbMQ4LyoxHG6sKMWfuf98uBECzT1dtkU3F5v30JxJ
         7AX/Ahqk3Td+cAOr5MCFmSTX1JTy71TwhlG3QQQFRe5wP7xU8sGDLWHPMTlDbK/fMgG7
         MuiW6i1vGZuy5g/DGNgY2Fmxt6Daxp1vJJQpFKYpO8J7ZqNNKsXkJyr/ux4NSXva2Ue1
         B67mp5+bjSE1h8cQr5t7s0L6UH0EYUYe11mveZ+IUx//aft1gQNkWofRJLfP9u8h1fz/
         zsQg==
X-Gm-Message-State: APuU4Z8oV5h/2lfgh5WcyJ5MyETDxTw2SsLwC53z4chIh300dWKHAlwS
	qvm18IFBuIVEVhYopZblHUKpXv4jVj6pKrTWXXjUGsws7kiFPWPEL+eJhrfLD8c84bBSvm0PbP2
	bKC7Vcls=
X-Gm-Gg: AYBFou0f7DIi8SDH/95dA9VbEI8JAnhZeVpJFB0xlPu1EC6hGbdTNX3yWB0cCVEHOzu
	nfGQ3Xplv1eu41vtimZOr7AIFA8udYFfLR/BMoqQsahal0UCsqS010X2vA81/kSZa4K9aaJ8rUw
	RzJRkqMLli0hz8jRzg31oQ6oyKNjA5FwXixWpHbihI3wXPMSGFUT96Gpi1etGSTYhSDocrf2hhC
	+1BgxTfAWe587OgptQ6alP1Na46nNAjTEQMYY5Ulucrf3V/gQzvbDCve76Qv8iVxRDlkqRcoR1R
	TsW7oa0vfE1SPlR3ewaD9EDvnJFDaYvcVhWBG1c8xisWAtIs6IoSM3QMwu+mSv8z1bgPVITpMNP
	lR5reQ54DV2E0lE/bNRiZ15JDRu9Mwv33JRoSz8E0f3F94hzoq84wO+sHosfp8qqWQPQx/33W2A
	Lbn+BEWsnknV542R9geq5EZ5o8e1mm8WjuUGk9aEIqyfAajFfds08TADBMp+DjL6ca50J2uAXNB
	jl7nPpC8vBr5cGKdcfHaLMBFu5Nm0vT3Y2IypdC4TAArDRvuoprheM6ehV78DOO6eTJnpl0vRmo
	Qb1VhHqppdtq4Fn6rCIPKxM33qxG/BlMywI=
X-Received: by 2002:a05:6a00:3d01:b0:8a0:1a6b:59fa with SMTP id d2e1a72fcca58-8beb6b70127mr8802507b3a.37.1794811677400;
        Sun, 15 Nov 2026 22:47:57 -0800 (PST)
Received: from localhost ([116.132.239.133])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed2b199cesm3380526b3a.52.2026.11.15.22.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 22:47:57 -0800 (PST)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-ext4@vger.kernel.org
Cc: yi.zhang@huaweicloud.com,
	jack@suse.cz,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	ojaswin@linux.ibm.com,
	riteshh@linux.ibm.com
Subject: [PATCH v3 3/3] ext4: use atomic bitops for io_end flags
Date: Mon, 16 Nov 2026 14:47:49 +0800
Message-Id: <20261116064749.194146-2-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261116064404.189911-1-sunjunchao@bytedance.com>
References: <20261116064404.189911-1-sunjunchao@bytedance.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before EXT4_IO_END_FAILED was added, the writeback thread set
EXT4_IO_END_UNWRITTEN and final completion cleared it after the last
io_end reference was dropped. Adding EXT4_IO_END_FAILED introduced a
concurrent writer in failed-bio completion. Successful bio completions
do not update the flags.

An io_end can cover already-mapped folios submitted before a later
unwritten extent is mapped. An earlier bio can fail while writeback
first sets UNWRITTEN. The non-atomic updates can then lose a bit:

  Bio completion                  Writeback thread
  --------------                  ----------------
  read flag = 0
                                  attach reserved handle to io_end
                                  flag |= UNWRITTEN
  write flag = 0 | FAILED
  /* UNWRITTEN is lost */

With data_err=ignore, losing UNWRITTEN makes
ext4_io_end_defer_completion() return false. When the io_end reference
count reaches zero, ext4_end_io_end() and its reserved-handle cleanup
are therefore skipped.
ext4_release_io_end() only warns about the remaining handle before
freeing io_end. The leaked reservation keeps j_reserved_credits nonzero,
so jbd2_journal_lock_updates() can wait indefinitely.

The reverse interleaving can lose FAILED and skip a requested journal
abort.

Use atomic bit operations to fix the race.

Fixes: e856f93e0fb2 ("ext4: do not convert the unwritten extents if data writeback fails")
Cc: stable@vger.kernel.org
Reviewed-by: Zhang Yi <yi.zhang@huaweicloud.com>
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 fs/ext4/ext4.h    | 16 ++++++----------
 fs/ext4/page-io.c | 20 +++++++++++---------
 2 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bf0325ecbec7..8469c4b11648 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -272,12 +272,10 @@ struct ext4_system_blocks {
 };
 
 /*
- * Flags for ext4_io_end->flags
+ * Bit numbers for ext4_io_end->flag
  */
-#define EXT4_IO_END_UNWRITTEN	0x0001
-#define EXT4_IO_END_FAILED	0x0002
-
-#define EXT4_IO_END_DEFER_COMPLETION (EXT4_IO_END_UNWRITTEN | EXT4_IO_END_FAILED)
+#define EXT4_IO_END_UNWRITTEN	0
+#define EXT4_IO_END_FAILED	1
 
 struct ext4_io_end_vec {
 	struct list_head list;		/* list of io_end_vec */
@@ -296,7 +294,7 @@ typedef struct ext4_io_end {
 	struct inode		*inode;		/* file being written to */
 	struct bio		*bio;		/* Linked list of completed
 						 * bios covering the extent */
-	unsigned int		flag;		/* unwritten or not */
+	unsigned long		flag;		/* EXT4_IO_END_* bits */
 	refcount_t		count;		/* reference counter */
 	struct list_head	list_vec;	/* list of ext4_io_end_vec */
 } ext4_io_end_t;
@@ -4096,14 +4094,12 @@ extern int ext4_resize_end(struct super_block *sb, bool update_backups);
 
 static inline void ext4_set_io_unwritten_flag(struct ext4_io_end *io_end)
 {
-	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN))
-		io_end->flag |= EXT4_IO_END_UNWRITTEN;
+	set_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag);
 }
 
 static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
 {
-	if (io_end->flag & EXT4_IO_END_UNWRITTEN)
-		io_end->flag &= ~EXT4_IO_END_UNWRITTEN;
+	clear_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag);
 }
 
 DECLARE_IOMAP_ITER_NEXT(ext4_iomap_next);
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 734d856a6d47..437f28c56b72 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -146,7 +146,7 @@ static void ext4_release_io_end(ext4_io_end_t *io_end)
 	struct bio *bio, *next_bio;
 
 	BUG_ON(!list_empty(&io_end->list));
-	BUG_ON(io_end->flag & EXT4_IO_END_UNWRITTEN);
+	BUG_ON(test_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag));
 	WARN_ON(io_end->handle);
 
 	for (bio = io_end->bio; bio; bio = next_bio) {
@@ -183,7 +183,7 @@ static int ext4_end_io_end(ext4_io_end_t *io_end)
 	 * or stale data may be exposed.
 	 */
 	io_end->handle = NULL;  /* Following call will use up the handle */
-	if (unlikely(io_end->flag & EXT4_IO_END_FAILED)) {
+	if (unlikely(test_bit(EXT4_IO_END_FAILED, &io_end->flag))) {
 		ret = -EIO;
 		if (handle)
 			jbd2_journal_free_reserved(handle);
@@ -194,7 +194,7 @@ static int ext4_end_io_end(ext4_io_end_t *io_end)
 		ret = ext4_convert_unwritten_io_end_vec(handle, io_end);
 	}
 	if (ret < 0 && !ext4_emergency_state(sb) &&
-	    io_end->flag & EXT4_IO_END_UNWRITTEN) {
+	    test_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag)) {
 		ext4_msg(sb, KERN_EMERG,
 			 "failed to convert unwritten extents to written "
 			 "extents -- potential data loss!  "
@@ -231,11 +231,11 @@ static void dump_completed_IO(struct inode *inode, struct list_head *head)
 
 static bool ext4_io_end_defer_completion(ext4_io_end_t *io_end)
 {
-	if (io_end->flag & EXT4_IO_END_UNWRITTEN &&
+	if (test_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag) &&
 	    !list_empty(&io_end->list_vec))
 		return true;
 	if (test_opt(io_end->inode->i_sb, DATA_ERR_ABORT) &&
-	    io_end->flag & EXT4_IO_END_FAILED &&
+	    test_bit(EXT4_IO_END_FAILED, &io_end->flag) &&
 	    !ext4_emergency_state(io_end->inode->i_sb))
 		return true;
 	return false;
@@ -250,8 +250,9 @@ static void ext4_add_complete_io(ext4_io_end_t *io_end)
 	unsigned long flags;
 
 	/* Only reserved conversions or pending IO errors will enter here. */
-	WARN_ON(!(io_end->flag & EXT4_IO_END_DEFER_COMPLETION));
-	WARN_ON(io_end->flag & EXT4_IO_END_UNWRITTEN &&
+	WARN_ON(!test_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag) &&
+		!test_bit(EXT4_IO_END_FAILED, &io_end->flag));
+	WARN_ON(test_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag) &&
 		!io_end->handle && sbi->s_journal);
 	WARN_ON(!io_end->bio);
 
@@ -279,7 +280,8 @@ static int ext4_do_flush_completed_IO(struct inode *inode,
 
 	while (!list_empty(&unwritten)) {
 		io_end = list_entry(unwritten.next, ext4_io_end_t, list);
-		BUG_ON(!(io_end->flag & EXT4_IO_END_DEFER_COMPLETION));
+		BUG_ON(!test_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag) &&
+		       !test_bit(EXT4_IO_END_FAILED, &io_end->flag));
 		list_del_init(&io_end->list);
 
 		err = ext4_end_io_end(io_end);
@@ -365,7 +367,7 @@ static void ext4_end_bio(struct bio *bio)
 			     bio->bi_status, inode->i_ino,
 			     (unsigned long long)
 			     bi_sector >> (inode->i_blkbits - 9));
-		io_end->flag |= EXT4_IO_END_FAILED;
+		set_bit(EXT4_IO_END_FAILED, &io_end->flag);
 		mapping_set_error(inode->i_mapping,
 				blk_status_to_errno(bio->bi_status));
 	}
-- 
2.39.5

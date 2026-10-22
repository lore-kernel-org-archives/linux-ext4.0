Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792681981;
	b=HnjeJfpcg/kF6RIwGXCIuBOFNH+RAZINSxS3/WbStGo/RCxcufhLGLmJZnR7O+aBiP71
	 dp7cs/X029JM/ZYF2Obpg8MljH+1/JkuleV722haS990ud+z7SY9XupcJG+3cfjftJ23+
	 q/S4jvlrGjjIYeC4IE3k8Ao+i8Abl0wbj5LagdrUrWzWpALatBhO/KWge4hPOEL5bBSrN
	 H0VxQ96cw2beh5j0MKYYkdElYt2oECHigNO2KXWenedHZQS1uhdpCVjldvp2TLbCoDajg
	 niygia8N3/hTvq3rPEkN4PHPgHzn0FBoAS0ni//TaH9gh9R7LOl106GjUPGhMwO/5Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792681981;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Obpvp7NZLISSu4jDDns1BcAmC0ORyjMNblKyG8JlxnM=;
	b=WGDchliEu9bVXDNJb0XblSzGn0KdcroKhLsw9HSNJCptlOK8I/5z6VOlm2rdgC61jhm/
	 EFiIHgpZDnCtRgl84Ttr7u3zp5TtCCACaVnhgVZJg+IY6PhYDQCVXLho7d0egs2D7oCOo
	 GdMFhBRnALbnEbXn62WhDvDbUT/uI7kM3n7rQNe1M85RQhtePEueIfHq90Z/PpHFYqv7W
	 /XxcAM7SNvjLAberWASRz+SK0FjMYJb9LdQ5QJ9Dli7ITxGQCdEgb/UoUoedqewDOPdGF
	 o7VlVy1WhZgVfeI/gVNzTCVzzkq9MXY54ucwJ7TLxSYVsC+GDAkFU6mrTO+jrA8aHpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=eWMIW98H;
	arc=none smtp.remote-ip=209.85.210.182
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EC5606ACC6
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 15:13:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13EC5606ACC6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=eWMIW98H
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8a06c60065fso1350822b3a.1
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 08:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792681980; x=1793286780; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Obpvp7NZLISSu4jDDns1BcAmC0ORyjMNblKyG8JlxnM=;
        b=eWMIW98HPvKw99dNGvfyyuh5iSAy96jY5RAEEpBQu27LawRv0shnP6rNg2MC1vcrei
         3kXP2sOp8FKrQz96AQXHyaTz+0/iFqYFiGfN9QftjF8WOngYT2C1CNZb1tjzBvNQJjt2
         zEzab+oC8LIsP4EyFKiReXpYatvfUnjLANMl183YfMwpn0gWCFjCUJWNJfRm+bO7Wc3D
         gBwyNIJN7S92dWEL13VcA/EjzYqoEx8xxVwnlTNU9ChA/Z5EpXlTlPm7D1e2uCU6tFX4
         I24EtSn/oRkKUIDTl71uU/yVDid5EWyN+uJ8pLVRKDrU7/DQdmHRDztwBR3jYoM07ILC
         HFMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792681980; x=1793286780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Obpvp7NZLISSu4jDDns1BcAmC0ORyjMNblKyG8JlxnM=;
        b=EYIi9cjrJCEvLcPqw5VtOCK5rPs23LX4B0KWR9LiiwBW+nfYBOphJ94cxGrG4fCMTA
         XNoHmvx7fL3sXFrlEI2zjfYpXt+9pmUh2b3WI1/6LSZXbZNKfFsBxzJzaGr6MImNdl/P
         Wl2IfddIA4BBCh3e1r09Wd2SxasJgKkHY3HlfbozVvPzOlbuzK7s1v3FjPggbofnRDZU
         09gH26mKpOM3PDRWMD3y0p4Vm40cc51ZeQwdISy03CwVeiwL34bfnQsGGoZMINumzYEG
         +nsKkYUNWIcsAlBC7t6PaJNN5W6wUkcjo+J7od2Ik84W/bOJFBEJ6OdYTS1AL89kJYuG
         4FrA==
X-Gm-Message-State: AFq9FYIwWApPJdLymU+vpAjJ8/hU/Y1wZKfwGPyYMOVSEb7LnmVRHE8X
	m7ItKXNsXF/j7cT4ZxqHHqC03riGgHQNWbj9hDmzayy+H8ZtXUmW/UoN9W3BBlH5l2QNYkDWx6K
	BYx7Sg6c=
X-Gm-Gg: AYBFou2k4mjgCrz06BzsRqaLhjuBctHk7mq/1ku+MNyJX2nVqeymhV2m7YLgSR8cqmy
	+9b5kS9mm3oMBBtv/Da3kXuLJIw6O924JbC9Akb5t28IrHaFND6hYqcYznkd7rE/hRxOLGykMB2
	qNBSUyrdCrRK9yuV2a9OIEGnsl1P4K9keEZ3ghppEF10aZsZ+6Fl0EupJSc0ppoyyU4UrBruZQm
	wZKvP3w9/zpxE70OOD3/PxT1wMlM2pmTrH93/etAGUb0r0YrCHnUzgSdlkXwv7YhIOGQ/xfVQcs
	f2LXXwuGKfoEeOmYNZR1hf3ICEVuRYznm0mhpKJOvqGsba8lZZ7mzvr/YmUik7ys5fWLBQBZVSV
	pBtou6yH7uIDXZAjuR3Tyt0fkXD21WkbEnnKu6vOLUfnhOGGspUdP0kFLlNYc0rrUtqPy5Kp5CP
	fAEsNtJ1sZTtToM04qjMpMfx5QO8IveTcRBIgEAoeB+xw1mhPXutM7+Unu9Ywh/ZDt9vxxQvVWr
	MWRDUOlJdBntuv8LPTE6cCEqbevZnfh+7OlQItLwu+NJE+g57X0tx8BFQMy
X-Received: by 2002:a05:6a00:368d:b0:880:4b56:dc2c with SMTP id d2e1a72fcca58-8a089d2269cmr3782659b3a.34.1792681980246;
        Thu, 22 Oct 2026 08:13:00 -0700 (PDT)
Received: from localhost ([106.38.226.183])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a08933e245sm2364010b3a.7.2026.10.22.08.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 08:12:55 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	riteshh@linux.ibm.com
Subject: [PATCH 6/6] ext4: use atomic bitops for io_end flags
Date: Thu, 22 Oct 2026 23:12:39 +0800
Message-Id: <20261022151239.2981745-2-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261022151239.2981745-1-sunjunchao@bytedance.com>
References: <20261022145241.2950379-1-sunjunchao@bytedance.com>
 <20261022151239.2981745-1-sunjunchao@bytedance.com>
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
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 fs/ext4/ext4.h    | 16 ++++++----------
 fs/ext4/page-io.c | 20 +++++++++++---------
 2 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1ee5733e2b31..3332a19746eb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -271,12 +271,10 @@ struct ext4_system_blocks {
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
@@ -295,7 +293,7 @@ typedef struct ext4_io_end {
 	struct inode		*inode;		/* file being written to */
 	struct bio		*bio;		/* Linked list of completed
 						 * bios covering the extent */
-	unsigned int		flag;		/* unwritten or not */
+	unsigned long		flag;		/* EXT4_IO_END_* bits */
 	refcount_t		count;		/* reference counter */
 	struct list_head	list_vec;	/* list of ext4_io_end_vec */
 } ext4_io_end_t;
@@ -4030,14 +4028,12 @@ extern int ext4_resize_end(struct super_block *sb, bool update_backups);
 
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
 
 extern const struct iomap_ops ext4_iomap_ops;
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index d25179938487..917a052f9733 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -143,7 +143,7 @@ static void ext4_release_io_end(ext4_io_end_t *io_end)
 	struct bio *bio, *next_bio;
 
 	BUG_ON(!list_empty(&io_end->list));
-	BUG_ON(io_end->flag & EXT4_IO_END_UNWRITTEN);
+	BUG_ON(test_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag));
 	WARN_ON(io_end->handle);
 
 	for (bio = io_end->bio; bio; bio = next_bio) {
@@ -180,7 +180,7 @@ static int ext4_end_io_end(ext4_io_end_t *io_end)
 	 * or stale data may be exposed.
 	 */
 	io_end->handle = NULL;  /* Following call will use up the handle */
-	if (unlikely(io_end->flag & EXT4_IO_END_FAILED)) {
+	if (unlikely(test_bit(EXT4_IO_END_FAILED, &io_end->flag))) {
 		ret = -EIO;
 		if (handle)
 			jbd2_journal_free_reserved(handle);
@@ -195,7 +195,7 @@ static int ext4_end_io_end(ext4_io_end_t *io_end)
 		mapping_set_error(inode->i_mapping, ret);
 
 	if (ret < 0 && !ext4_emergency_state(sb) &&
-	    io_end->flag & EXT4_IO_END_UNWRITTEN) {
+	    test_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag)) {
 		ext4_msg(sb, KERN_EMERG,
 			 "failed to convert unwritten extents to written "
 			 "extents -- potential data loss!  "
@@ -232,11 +232,11 @@ static void dump_completed_IO(struct inode *inode, struct list_head *head)
 
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
@@ -251,8 +251,9 @@ static void ext4_add_complete_io(ext4_io_end_t *io_end)
 	unsigned long flags;
 
 	/* Only reserved conversions or pending IO errors will enter here. */
-	WARN_ON(!(io_end->flag & EXT4_IO_END_DEFER_COMPLETION));
-	WARN_ON(io_end->flag & EXT4_IO_END_UNWRITTEN &&
+	WARN_ON(!test_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag) &&
+		!test_bit(EXT4_IO_END_FAILED, &io_end->flag));
+	WARN_ON(test_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag) &&
 		!io_end->handle && sbi->s_journal);
 	WARN_ON(!io_end->bio);
 
@@ -280,7 +281,8 @@ static int ext4_do_flush_completed_IO(struct inode *inode,
 
 	while (!list_empty(&unwritten)) {
 		io_end = list_entry(unwritten.next, ext4_io_end_t, list);
-		BUG_ON(!(io_end->flag & EXT4_IO_END_DEFER_COMPLETION));
+		BUG_ON(!test_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag) &&
+		       !test_bit(EXT4_IO_END_FAILED, &io_end->flag));
 		list_del_init(&io_end->list);
 
 		err = ext4_end_io_end(io_end);
@@ -366,7 +368,7 @@ static void ext4_end_bio(struct bio *bio)
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


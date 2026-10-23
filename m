Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792736361;
	b=YlxeRMcJU9UEbWQxQmVuKCq2mUDsJ97D3v5/n3x/dhbnK+uyu8fDszqxgD/ZZ+Z9o2Gj
	 C/EJmqZvshtYX8JFxSAGVQc5igt+f5v4nNfp9AeniCcsObEZS0a3HhDje8UJ8zG6i59Ed
	 BnZ/qQ1ZK6JMft3MkZGHuafwWdiCgcMhMFQAy9BVkNm++io8CmFiir406HeWBvZuIsNYW
	 WGpVXiuARyLXbnT7WEARRH3n4jJvVcczpvy7bIaXhySl+KIlYgfyAzpXniNpaed5fiGLB
	 Ssp1OlSRDE8z5s7tiN593Zm6PSQGJPKoUSRiBihOubwVY1Vk/gr1WdZJjc2xyYaOUGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792736361;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zKtuQICDHVThdqg2YYHu5IdQ1Zecz+4ZB2BzVslfsEw=;
	b=ts3yT3iUE4dTnsUZNRCygUKWr1NuNNVyqJ22lq+wx3nIchmz187EyvqfhCGMKXTtpb4f
	 Pfm1Iq0wRk0PKm+5/eMwXeW1QbMByJ9RZb1Cq5LpA4FT8NJTkKmB6kQfVLzOTwwM0RsXQ
	 qpkg/b3zly6vy9n4GRBvfNMkVO1TF0H492S3v8euxggQpGgY2a8PRZaVihpk8UVH0ZAVI
	 l9MhW2TvTF+ZxNVVt79qbpOznsX7h5uvtnAbew9cKBijzWdYUMZ4q5weYDYtja02mMx1E
	 s23IB9h6mZ7DT4mqtJFAW3zeLeZaD3ytA47wp0u3kfBgnGj4kc8hRZEKrKWQ+mMO4hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Vcq4j9DO;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E30606A31A
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 06:19:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6E30606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Vcq4j9DO
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3ab2cb8d577so395382a91.1
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 23:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792736360; x=1793341160; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zKtuQICDHVThdqg2YYHu5IdQ1Zecz+4ZB2BzVslfsEw=;
        b=Vcq4j9DOwRGn4f379EGrQhJq2n7S78zYibDxn66wO62hvOEBUscZb+qUcK6eDQ+OgS
         XLTHEoXScsK2KOVWEmSgwYRiutCU1eJTP1tponV8k2nqPtCEU0RMxAZDdqwUSebBaXQ4
         uMLgSiGR3XXBETWZ2jC9Dg9rlmOyid+Wepl39IjmVdV1ynUMpKmRJFXVycGoQh/24wVr
         AUXqpLrs4FxaQ3DsVaxm6/6BPldzisPpXpdjdMcLG5fyhTrKL9Cq0/W2IYIyHPfAYg0v
         eOqjvP2CaheNLEx2NNlflpPhGiLrekvpb6q+mpg1pDeI7yhIJjSG2G9YE+6VMs0gVgs1
         eYpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792736360; x=1793341160;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zKtuQICDHVThdqg2YYHu5IdQ1Zecz+4ZB2BzVslfsEw=;
        b=ecYMh2sGWA/xdKjjl5fm0kxFkC8Caagj1ZcYLf8eGoyg6oa71MslrkzBwQ2tevxc0l
         WrkPsiPIAhC5JTFFBoPwyZfNh2xj9tFIVRAgbuAkFBqLqMVTuRmTNhzgxZypS1/Awktk
         ywz3gqEQHgiHJdLKKeezxbBhdXUPd6GBNQn4Rd2Nm4PkUpiTHikJE8LvABhPRp0JhNxZ
         Ye9B3akeWwaf1rDbUjNfbOeRs0LNjKBgDIx4GV+JZxTdZ+SAqzqpD9VvZEEI/d8/Zxc7
         CGI4sxm1mgYzuhUEDvZLo5xELmj5F1pCeznKYNqiPBY20DYKDI/MDq+1GKBCJF7kGhxY
         w8VA==
X-Gm-Message-State: AFq9FYKsBA1vZrxTA7k94SYJy7N8DlRq+nrAMnYdJjQNeSlviFmGD6+q
	+xD6UDOMV1/nerMfEsVTCIFDH87KIkUQ32mMtdNeaYITd/N5gqg6g+bzLW/hYSpK0aKBGp/xKVN
	7AhjSZRw=
X-Gm-Gg: AYBFou1hF3SeROTfiAuuopeVXJkZKLwCvlvzIj2LTqBvOHlf0U4heoIxAOS1CKZRC64
	Fz+OMbCNf7aj5oTyvcBtK7bZje7px7PGZ+r/Fi8u5lzhJeezqXCAMRKsWfExfUybE0AuHCBQtJC
	hstKQ56ne1uBkvA5WKT0gtX1kaHcG8oZuVBLAu8ea06vw+uAtOxVW5AaRSdXoj3tQ1TN0g0mlYD
	R5aaD3QUqdwgqrQszpKF1CYDmp1vJXU9sZ2eY4EpBnPcPiRpQdXMMA061jrB3HJOKSXPRMw7lBC
	f5jDZELebunIYH2b3yMhAPsnAG2N8tgsH0E9UxFR0KMkY9cCarANUDvcoUhc1Cn/Z7OCuRy7pxG
	zBY9p+DVKCbOGr1nG/nt7QkMMv6v5T2E2MkYRHkRzBDjMXE9tDgotgY9GA1vKZoYdhAygFPwxri
	n++K2ygW3GnLI6sVAH7tFH7IIsKx9uw//ZnqUp2+WPIdvq4TpHUgqepQmXutjTMUnaMHTIWbLpU
	yVAB6CDWdtJJ4yK9rSU448/PBicCOQYCNUQyE4O/PjuOYvI+LXAtVTcQZgn
X-Received: by 2002:a17:90a:e18e:b0:3ac:4291:f569 with SMTP id 98e67ed59e1d1-3adcddb48f6mr987686a91.8.1792736359942;
        Thu, 22 Oct 2026 23:19:19 -0700 (PDT)
Received: from localhost ([106.38.226.237])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3add264ca70sm424413a91.1.2026.10.22.23.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 23:19:19 -0700 (PDT)
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
Subject: [PATCH v2 6/6] ext4: use atomic bitops for io_end flags
Date: Fri, 23 Oct 2026 14:18:51 +0800
Message-Id: <20261023061851.45579-7-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261023061851.45579-1-sunjunchao@bytedance.com>
References: <20261023061851.45579-1-sunjunchao@bytedance.com>
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
index 8d3af062a830..f6b2901fc8ba 100644
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
@@ -4093,14 +4091,12 @@ extern int ext4_resize_end(struct super_block *sb, bool update_backups);
 
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
index d409821fefa2..3604292e8a5e 100644
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
@@ -198,7 +198,7 @@ static int ext4_end_io_end(ext4_io_end_t *io_end)
 		mapping_set_error(inode->i_mapping, ret);
 
 	if (ret < 0 && !ext4_emergency_state(sb) &&
-	    io_end->flag & EXT4_IO_END_UNWRITTEN) {
+	    test_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag)) {
 		ext4_msg(sb, KERN_EMERG,
 			 "failed to convert unwritten extents to written "
 			 "extents -- potential data loss!  "
@@ -235,11 +235,11 @@ static void dump_completed_IO(struct inode *inode, struct list_head *head)
 
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
@@ -254,8 +254,9 @@ static void ext4_add_complete_io(ext4_io_end_t *io_end)
 	unsigned long flags;
 
 	/* Only reserved conversions or pending IO errors will enter here. */
-	WARN_ON(!(io_end->flag & EXT4_IO_END_DEFER_COMPLETION));
-	WARN_ON(io_end->flag & EXT4_IO_END_UNWRITTEN &&
+	WARN_ON(!test_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag) &&
+		!test_bit(EXT4_IO_END_FAILED, &io_end->flag));
+	WARN_ON(test_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag) &&
 		!io_end->handle && sbi->s_journal);
 	WARN_ON(!io_end->bio);
 
@@ -283,7 +284,8 @@ static int ext4_do_flush_completed_IO(struct inode *inode,
 
 	while (!list_empty(&unwritten)) {
 		io_end = list_entry(unwritten.next, ext4_io_end_t, list);
-		BUG_ON(!(io_end->flag & EXT4_IO_END_DEFER_COMPLETION));
+		BUG_ON(!test_bit(EXT4_IO_END_UNWRITTEN, &io_end->flag) &&
+		       !test_bit(EXT4_IO_END_FAILED, &io_end->flag));
 		list_del_init(&io_end->list);
 
 		err = ext4_end_io_end(io_end);
@@ -369,7 +371,7 @@ static void ext4_end_bio(struct bio *bio)
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


Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4ED45BD4C
	for <linux-ext4@vger.kernel.org>; Wed,  6 May 2026 13:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778075505; cv=none; b=G7j7wYJKirAeda3XpQ2mAQ+UCCuKD70DROzKwJ8l9bTh6cL3KAj8mXjEyZZvN+vUDDAF0vRmFIDAXfkiQCnAya0/xpv8UJAbgsGiwfCYp4YYLvpnEFoE2BJjemtriLOE/dCgp98m+7iCtoqszLCVe32VLS30iEEKWLAySB3FrM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778075505; c=relaxed/simple;
	bh=LWjVTnJKRNj7G/2V9+mHhYoW1hPBBC7V7osckVb59wM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J4Vpgr07pTVjNqHlJGt10Ni8ZOk3oQxspfl1c5Mj8R8hADvCc/NJaBbj9qAWrXAf/e8GnLNJqTdD//Ex5oYfLywHyTK4XelWMyrCXMTHE+x6s1JswrJbldjb8b5JYFlQBg+Qdlbabc9FPMybhJLdfpkx2MYpO9dM6TLjZ8fDg/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zh6cZmmA; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zh6cZmmA"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ad21f437eeso7761325ad.0
        for <linux-ext4@vger.kernel.org>; Wed, 06 May 2026 06:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778075503; x=1778680303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ezuaXNEegTO67jS4OHIKFoL/ovNqxQxNcS5nsfNqawM=;
        b=Zh6cZmmAvS5XBNIeiulwryrmV7gt+ffs6d7PXDJfU6hVI0TW2ipcDrjn6Pi40Om41J
         xyPeUP5No7CUj1sjlGDhGdsb3A9Zn+j6ssAkt2FdPOILemb9aKCJyPWEKvue4gJZLgG0
         jEh7ihmQQ8VKyDqoBrBu67Nj7ZFbU+zYKpJsaL3cp1W30qeO+iSiYy1c1DNuExB3SSUa
         f9RwIa+i/L2YDxWpgUelNpoouFuTxi98rHJmPjJX4JyA9n9k8bq6RkrLuZnF3DhnQCGp
         NULSvgxpvuJfmbpE+2DFRQo5IjEVyOkax5MWxtX4B1FOBaKex4zS+a834oZmf/4amipv
         bFdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778075503; x=1778680303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ezuaXNEegTO67jS4OHIKFoL/ovNqxQxNcS5nsfNqawM=;
        b=i2V/Wq+yvfJTrkcGZeZJWwmFnNp3uTK4zonTS2s5FnhvQOTrb2mPr76kH3A8aQtXMO
         WXvb2DXlPcOquiy651XYujx0W/Fll+jEUD/W4xa5bNPAmTrQ8KVIpQXj8VOgZsOOLl4p
         p229Nle3Vb+xKPbk9eg+Fza8DdKRASGZdTipSCYZwtzq2CE63XmhHdMoCa3xo1O5xiey
         h/XYvrDRK55aX5UE37K8yTzmQdkkwdiopgh0u+KnAyzAOGdUqlOzSekafazXFZ4Gd9aF
         THBaPdNonrIPR2dgJTWPclLo5PabQFdunKRBzEx42Kyjpp9n2e3hmKaQ08JyrTXnGWuH
         mpbw==
X-Forwarded-Encrypted: i=1; AFNElJ9L+Hi6XFmu1W1L2+R4k8RgH26ijgqyq7bdHymj7cRB4y8/ESE4WYECfc5xo0IEFensMEYfILac32nU@vger.kernel.org
X-Gm-Message-State: AOJu0YwC1jSs3CDyapWuwWASY5G92ETtLUUd7W5rStcT9ZzKDjWBiXln
	Au4yJrI7may1JS8SYpI/pZgSZkNZJLSgcaYi+e7H6LI2OHVtPd9FaklXf+PFSMh0EtU=
X-Gm-Gg: AeBDieuw2CBnX2kOOqyeu5+vtacEBZfBVT3qKi95FM6Mz5qb9U68cg9bp8pRuy4qJg5
	9j9xhI8LesllyJjIYajRSGtWfvZZXhCzE2dyf1U0+w9NoWLlMv43+/YNfyL+13DghYCCl9UO0JO
	vPuRAOUlfoeHZNMeiih7qjqY/G23stLo9Sc6C1YSrX2FtSS9QOTZxLtUJGevP1e6VnwZfTQnuIX
	S8qbGmTXpcSFKZVks4PGx6T6jubGJ19tOd3IPkNkbydZE+2XBossK/tLJe5qk5S8Fj2i0VNBKGx
	PXQGhJku+oNF3akIRjApbwkSq9eJvB9XWXgETMDdajei1+di8kRncgtlCf+ermNjdUQgZeUe4sE
	NIM+69m2H6DYadR7sYm4P/lO2FzI4AtxmNokWZTSOOqmSR1mRMrTkyF7J3X69OyvmQS961lG3nO
	w06Qse6YCtJzHqkLgc4s4G4Q==
X-Received: by 2002:a17:903:3dce:b0:2b0:4fb3:c771 with SMTP id d9443c01a7336-2ba4d68d5dcmr52292415ad.6.1778075502374;
        Wed, 06 May 2026 06:51:42 -0700 (PDT)
Received: from n37-098-250.byted.org ([240e:83:200::738])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ba7bf330a0sm26970375ad.31.2026.05.06.06.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 06:51:41 -0700 (PDT)
From: Diangang Li <diangangli@gmail.com>
To: axboe@kernel.dk,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org
Cc: linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	changfengnan@bytedance.com,
	Diangang Li <lidiangang@bytedance.com>
Subject: [RFC v1 1/1] buffer_head: fail fast on repeated reads after I/O errors
Date: Wed,  6 May 2026 21:50:47 +0800
Message-Id: <20260506135047.2670453-2-diangangli@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260506135047.2670453-1-diangangli@gmail.com>
References: <20260506135047.2670453-1-diangangli@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Diangang Li <lidiangang@bytedance.com>

A failed buffer_head read leaves the buffer !Uptodate. If multiple
threads hit that same buffer_head, they serialize on BH_Lock and each
one re-submits the same read after the previous owner drops the lock.
If the device is slow to return the error, this can turn one bad block
into long stalls and repeated slow I/O.

Trying to remember bad LBAs in block or drivers would need a generic
per-device table with lookup, eviction, and lifetime rules. For buffer_head
users, keep the failure state with the cached buffer_head instead.

Track non-readahead read I/O errors in buffer_head with a dedicated bit
and a failure timestamp. Update this state from the bio completion path.
Add an optional per-bdev retry window: within the window, non-readahead
submit_bh() reads complete immediately with failure for a buffer_head
that recently saw a non-readahead read error. A successful read or
rewrite clears the state.

The timestamp is recorded on the first error only, so repeated failures do
not extend the window. Once the window expires, the next read is submitted
normally and can discover that the device or media has recovered.

Configure per block device via sysfs:

  /sys/block/<disk>/read_err_retry_sec
  /sys/block/<disk>/<part>/read_err_retry_sec

Default is 0, preserving existing behavior. Disk and partition values are
independent, and values larger than MAX_JIFFY_OFFSET / HZ are rejected to
avoid jiffies overflow.

Link: https://lore.kernel.org/linux-ext4/20260325093349.630193-1-diangangli@gmail.com/
Signed-off-by: Diangang Li <lidiangang@bytedance.com>
---
 Documentation/ABI/stable/sysfs-block | 26 +++++++++++
 block/genhd.c                        | 24 ++++++++++
 block/partitions/core.c              | 24 ++++++++++
 fs/buffer.c                          | 65 ++++++++++++++++++++++++++++
 include/linux/blk_types.h            |  3 ++
 include/linux/buffer_head.h          | 10 +++++
 6 files changed, 152 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
index 900b3fc4c72d0..b850f96fa048e 100644
--- a/Documentation/ABI/stable/sysfs-block
+++ b/Documentation/ABI/stable/sysfs-block
@@ -185,6 +185,32 @@ Description:
 		unsigned integer, but only "0" and "1" are valid values.
 
 
+What:		/sys/block/<disk>/read_err_retry_sec
+What:		/sys/block/<disk>/<partition>/read_err_retry_sec
+Date:		May 2026
+Contact:	linux-block@vger.kernel.org
+Description:
+		(RW) Configure the fail-fast window, in seconds, for repeated
+		buffer_head reads after read I/O errors.
+
+		The default value is 0, which disables the fail-fast behavior and
+		preserves the existing retry behavior. When this value is non-zero,
+		a buffer_head that has recently seen a non-readahead read I/O error
+		can fail another read immediately within the configured window,
+		instead of submitting another bio for the same buffer_head.
+
+		This only applies to buffer_head reads submitted through submit_bh().
+		It is not a generic block layer read retry policy, and it does not
+		affect direct I/O or non-buffer_head bio submissions.
+
+		Disk and partition attributes are independent. Setting the disk
+		attribute does not change the value for existing or future
+		partition block devices.
+
+		The maximum accepted value is MAX_JIFFY_OFFSET / HZ. Larger values
+		are rejected with -ERANGE.
+
+
 What:		/sys/block/<disk>/<partition>/alignment_offset
 Date:		April 2009
 Contact:	Martin K. Petersen <martin.petersen@oracle.com>
diff --git a/block/genhd.c b/block/genhd.c
index 7d6854fd28e95..302dce67d685c 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1159,6 +1159,28 @@ static ssize_t partscan_show(struct device *dev,
 	return sysfs_emit(buf, "%u\n", disk_has_partscan(dev_to_disk(dev)));
 }
 
+static ssize_t read_err_retry_sec_show(struct device *dev,
+				       struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lu\n",
+			  READ_ONCE(dev_to_bdev(dev)->bd_read_err_retry_sec));
+}
+
+static ssize_t read_err_retry_sec_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	unsigned long sec;
+
+	if (kstrtoul(buf, 0, &sec))
+		return -EINVAL;
+	if (sec > MAX_JIFFY_OFFSET / HZ)
+		return -ERANGE;
+
+	WRITE_ONCE(dev_to_bdev(dev)->bd_read_err_retry_sec, sec);
+	return count;
+}
+
 static DEVICE_ATTR(range, 0444, disk_range_show, NULL);
 static DEVICE_ATTR(ext_range, 0444, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, 0444, disk_removable_show, NULL);
@@ -1173,6 +1195,7 @@ static DEVICE_ATTR(inflight, 0444, part_inflight_show, NULL);
 static DEVICE_ATTR(badblocks, 0644, disk_badblocks_show, disk_badblocks_store);
 static DEVICE_ATTR(diskseq, 0444, diskseq_show, NULL);
 static DEVICE_ATTR(partscan, 0444, partscan_show, NULL);
+static DEVICE_ATTR_RW(read_err_retry_sec);
 
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 ssize_t part_fail_show(struct device *dev,
@@ -1224,6 +1247,7 @@ static struct attribute *disk_attrs[] = {
 	&dev_attr_events_poll_msecs.attr,
 	&dev_attr_diskseq.attr,
 	&dev_attr_partscan.attr,
+	&dev_attr_read_err_retry_sec.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
 #endif
diff --git a/block/partitions/core.c b/block/partitions/core.c
index 5d5332ce586b6..62b4c2f70709f 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -205,6 +205,28 @@ static ssize_t part_discard_alignment_show(struct device *dev,
 	return sysfs_emit(buf, "%u\n", bdev_discard_alignment(dev_to_bdev(dev)));
 }
 
+static ssize_t read_err_retry_sec_show(struct device *dev,
+				       struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lu\n",
+			  READ_ONCE(dev_to_bdev(dev)->bd_read_err_retry_sec));
+}
+
+static ssize_t read_err_retry_sec_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	unsigned long sec;
+
+	if (kstrtoul(buf, 0, &sec))
+		return -EINVAL;
+	if (sec > MAX_JIFFY_OFFSET / HZ)
+		return -ERANGE;
+
+	WRITE_ONCE(dev_to_bdev(dev)->bd_read_err_retry_sec, sec);
+	return count;
+}
+
 static DEVICE_ATTR(partition, 0444, part_partition_show, NULL);
 static DEVICE_ATTR(start, 0444, part_start_show, NULL);
 static DEVICE_ATTR(size, 0444, part_size_show, NULL);
@@ -213,6 +235,7 @@ static DEVICE_ATTR(alignment_offset, 0444, part_alignment_offset_show, NULL);
 static DEVICE_ATTR(discard_alignment, 0444, part_discard_alignment_show, NULL);
 static DEVICE_ATTR(stat, 0444, part_stat_show, NULL);
 static DEVICE_ATTR(inflight, 0444, part_inflight_show, NULL);
+static DEVICE_ATTR_RW(read_err_retry_sec);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
 	__ATTR(make-it-fail, 0644, part_fail_show, part_fail_store);
@@ -227,6 +250,7 @@ static struct attribute *part_attrs[] = {
 	&dev_attr_discard_alignment.attr,
 	&dev_attr_stat.attr,
 	&dev_attr_inflight.attr,
+	&dev_attr_read_err_retry_sec.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
 #endif
diff --git a/fs/buffer.c b/fs/buffer.c
index b0b3792b1496e..2a28ab6a51f0e 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -920,6 +920,7 @@ static sector_t folio_init_buffers(struct folio *folio,
 			bh->b_private = NULL;
 			bh->b_bdev = bdev;
 			bh->b_blocknr = block;
+			clear_buffer_read_io_error_state(bh);
 			if (uptodate)
 				set_buffer_uptodate(bh);
 			if (block < end_block)
@@ -1503,6 +1504,7 @@ static void discard_buffer(struct buffer_head * bh)
 	lock_buffer(bh);
 	clear_buffer_dirty(bh);
 	bh->b_bdev = NULL;
+	clear_buffer_read_io_error_state(bh);
 	b_state = READ_ONCE(bh->b_state);
 	do {
 	} while (!try_cmpxchg_relaxed(&bh->b_state, &b_state,
@@ -1997,6 +1999,7 @@ iomap_to_bh(struct inode *inode, sector_t block, struct buffer_head *bh,
 		bh->b_blocknr = (iomap->addr + offset - iomap->offset) >>
 				inode->i_blkbits;
 		set_buffer_mapped(bh);
+		clear_buffer_read_io_error_state(bh);
 		return 0;
 	default:
 		WARN_ON_ONCE(1);
@@ -2663,6 +2666,33 @@ sector_t generic_block_bmap(struct address_space *mapping, sector_t block,
 }
 EXPORT_SYMBOL(generic_block_bmap);
 
+static void bh_update_io_error_state(struct buffer_head *bh, const struct bio *bio)
+{
+	const enum req_op op = bio_op(bio);
+
+	if (op != REQ_OP_READ && op != REQ_OP_WRITE)
+		return;
+
+	/*
+	 * Track non-readahead read failures (timestamped) so submit_bh() can
+	 * fail repeated reads fast. A successful read or rewrite clears the
+	 * state.
+	 */
+	if (!bio->bi_status) {
+		clear_buffer_read_io_error(bh);
+		bh->b_err_timestamp = 0;
+		return;
+	}
+
+	/* Record the first failure; don't extend the window on repeats. */
+	if (op != REQ_OP_READ || (bio->bi_opf & REQ_RAHEAD) ||
+	    buffer_read_io_error(bh))
+		return;
+
+	set_buffer_read_io_error(bh);
+	bh->b_err_timestamp = jiffies;
+}
+
 static void end_bio_bh_io_sync(struct bio *bio)
 {
 	struct buffer_head *bh = bio->bi_private;
@@ -2670,10 +2700,37 @@ static void end_bio_bh_io_sync(struct bio *bio)
 	if (unlikely(bio_flagged(bio, BIO_QUIET)))
 		set_bit(BH_Quiet, &bh->b_state);
 
+	bh_update_io_error_state(bh, bio);
+
 	bh->b_end_io(bh, !bio->bi_status);
 	bio_put(bio);
 }
 
+static bool bh_failfast_read(struct buffer_head *bh)
+{
+	unsigned long retry_sec = READ_ONCE(bh->b_bdev->bd_read_err_retry_sec);
+
+	if (!retry_sec || !buffer_read_io_error(bh))
+		return false;
+
+	/* No timestamp: treat as stale state and re-arm on the next failure. */
+	if (!bh->b_err_timestamp) {
+		clear_buffer_read_io_error(bh);
+		return false;
+	}
+
+	if (time_before(jiffies,
+			bh->b_err_timestamp + secs_to_jiffies(retry_sec))) {
+		test_set_buffer_req(bh);
+		bh->b_end_io(bh, 0);
+		return true;
+	}
+
+	clear_buffer_read_io_error(bh);
+	bh->b_err_timestamp = 0;
+	return false;
+}
+
 static void buffer_set_crypto_ctx(struct bio *bio, const struct buffer_head *bh,
 				  gfp_t gfp_mask)
 {
@@ -2702,6 +2759,14 @@ static void submit_bh_wbc(blk_opf_t opf, struct buffer_head *bh,
 	BUG_ON(buffer_delay(bh));
 	BUG_ON(buffer_unwritten(bh));
 
+	/*
+	 * Fail fast for repeated non-readahead buffer_head reads after a recent
+	 * I/O error. This avoids serializing many callers on BH_Lock while
+	 * re-submitting the same failing read.
+	 */
+	if (op == REQ_OP_READ && !(opf & REQ_RAHEAD) && bh_failfast_read(bh))
+		return;
+
 	/*
 	 * Only clear out a write error when rewriting
 	 */
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 8808ee76e73c0..9437c471ee7d7 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -69,6 +69,9 @@ struct block_device {
 	atomic_t		bd_fsfreeze_count; /* number of freeze requests */
 	struct mutex		bd_fsfreeze_mutex; /* serialize freeze/thaw */
 
+	/* Seconds; 0 disables read fail-fast window for submit_bh(READ). */
+	unsigned long		bd_read_err_retry_sec;
+
 	struct partition_meta_info *bd_meta_info;
 	int			bd_writers;
 #ifdef CONFIG_SECURITY
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index e4939e33b4b51..3ab36429f8f38 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -29,6 +29,7 @@ enum bh_state_bits {
 	BH_Delay,	/* Buffer is not yet allocated on disk */
 	BH_Boundary,	/* Block is followed by a discontiguity */
 	BH_Write_EIO,	/* I/O error on write */
+	BH_Read_EIO,	/* I/O error on read */
 	BH_Unwritten,	/* Buffer is allocated on disk but not written */
 	BH_Quiet,	/* Buffer Error Prinks to be quiet */
 	BH_Meta,	/* Buffer contains metadata */
@@ -79,6 +80,7 @@ struct buffer_head {
 	spinlock_t b_uptodate_lock;	/* Used by the first bh in a page, to
 					 * serialise IO completion of other
 					 * buffers in the page */
+	unsigned long b_err_timestamp;	/* timestamp of last I/O error */
 };
 
 /*
@@ -132,11 +134,18 @@ BUFFER_FNS(Async_Write, async_write)
 BUFFER_FNS(Delay, delay)
 BUFFER_FNS(Boundary, boundary)
 BUFFER_FNS(Write_EIO, write_io_error)
+BUFFER_FNS(Read_EIO, read_io_error)
 BUFFER_FNS(Unwritten, unwritten)
 BUFFER_FNS(Meta, meta)
 BUFFER_FNS(Prio, prio)
 BUFFER_FNS(Defer_Completion, defer_completion)
 
+static inline void clear_buffer_read_io_error_state(struct buffer_head *bh)
+{
+	clear_buffer_read_io_error(bh);
+	bh->b_err_timestamp = 0;
+}
+
 static __always_inline void set_buffer_uptodate(struct buffer_head *bh)
 {
 	/*
@@ -411,6 +420,7 @@ map_bh(struct buffer_head *bh, struct super_block *sb, sector_t block)
 	bh->b_bdev = sb->s_bdev;
 	bh->b_blocknr = block;
 	bh->b_size = sb->s_blocksize;
+	clear_buffer_read_io_error_state(bh);
 }
 
 static inline void wait_on_buffer(struct buffer_head *bh)
-- 
2.39.5

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795496287;
	b=QiJe0ETXQbtQUDXqfTMXPg8wO+tSi1zhgFGU0VHZVY+Ro7usWyQd2KP7oIC3K1zeHMQL
	 x1Io+2eOP6KCT5pjtyQbtKsl+SQ7ZR9nASwgArcybKqOERbXwG9F96h1jEHAkhUvM97yd
	 6F/hhN41IriBnmhO/MWu+n3IyZEgYOmvRRBAcU/ajNydVQlgeV0l07zi2eTq24KxdYNL6
	 udepd664xgCDz0aHWdxRyDO9a7OFhoW6VQlrm6foiaGiKRqge1o6E90+nyFRFXrkJnTP1
	 jAgZhn44dPEQG+KBz6097DulmXSViUaIGAjevW60fOLwPTt+JIegqdszM4GNNElSnyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795496287;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=S8a37teKt/OqnBakAx6vq9yT/xIJtgp1IdnyvBc6+Hw=;
	b=apFzhgxaxjmeh0mggoze7rH9ncFrY7qxGT6fs/ZPdRFqelN0EDzVBhS56ZFTIIL+/FTl
	 8cUcMXo8W6+TZnBhT+xwrQOHOiWRHSoGqF0WvD9axti60g6cqcWHyJKrzQJKUfmiVkDQ6
	 slGvj9LZUyxkzIlgeuME/oy8QXMeOAoRm1NGFiEjioQKLR/fvjyYOP3eDiVRdDIlsxvrH
	 xZH1usMl5WEZcSe/lUhT+1Hi5SUe8zH+v5OZJyJTc712vWV1CgcEQWZEvURcQYO7WXm/r
	 cOqQqzBLbYrvFr7xsFmk7pjtNazV1fB5c4xLAE3OUHPRp0Hx4rmJu2Ke1WaFoqsuiJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.99
Received: from dggmsgout11.his.huawei.com (dggmsgout11.his.huawei.com [124.71.93.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DD9606A31E;
	Tue, 24 Nov 2026 04:58:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58DD9606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout11.his.huawei.com (SkyGuard) with ESMTP id 4jYVtV2JrKz1c1hY;
	Tue, 24 Nov 2026 12:57:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0B1B440561;
	Tue, 24 Nov 2026 12:57:57 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgB3sO9MGQVrKZFRFg--.28424S3;
	Tue, 24 Nov 2026 12:57:56 +0800 (CST)
Message-ID: <9be1cb3e-4417-4609-bc0d-67dcfa24aa10@huaweicloud.com>
Date: Tue, 24 Nov 2026 12:49:19 +0800
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] ext4: silent data loss when a split at I/O
 completion gets ENOSPC
To: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 guolingxing <guolingxing@tju.edu.cn>, Josef Bacik <josef@toxicpanda.com>,
 Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, regressions@lists.linux.dev
References: <d400205a-0d3d-4ec3-a916-6c0a085841b4@linux.dev>
 <d8ac3185-44c8-41e7-9cbf-3d1baa27f272@huaweicloud.com>
 <20261117-jf-ext4-enospc-reply-zhangyi-v9-b19eeb966ad0@linux.dev>
 <10712329-a587-496d-babf-620ebfd0e60e@huaweicloud.com>
 <20261118-jf-ext4-enospc-reply-zhangyi-v13-3886a3248c32@linux.dev>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20261118-jf-ext4-enospc-reply-zhangyi-v13-3886a3248c32@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgB3sO9MGQVrKZFRFg--.28424S3
X-Coremail-Antispam: 1UD129KBjvAXoW3CFy8Gw18ZF47ur4Utr1kZrb_yoW8XrW7Jo
	WxW3Z8Wr48Gwn8trZ5Krn7Kry7uanruw4fJF45ArWrJF9av345W3ySgw43X3W3tw48Crn7
	Ja4xJan8JFZIqFs5n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYz7kC6x804xWl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK
	8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
	AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF
	7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUOB
	MKDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 11/18/2026 10:06 PM, Jose Fernandez (Anthropic) wrote:
> On Wed, Nov 18, 2026 Zhang Yi wrote:
>> Could you provide a reproducer? My guess is that high concurrency causes
>> the blocks freed by my current process to be taken by I/O issued by
>> other processes
> 
> That fits our runs. I'll send you the script off-list.
> 
> - Jose


Thank you for the reproducer. After debugging, I confirmed the cause. On
each failed endio conversion, the retry commits the journal, but the
blocks released by the commit are soon claimed again by the
background fallocate loop, so after 3 retries the DIO finally returns
ENOSPC.

Although Ojaswin's v2 does track the exact ranges when submitting I/Os,
we cannot convert the whole extent after zeroing until all in-flight I/Os
overlapping this extent have finished, which is too expensive to me. So I
think we may still need the split to succeed.

Note that we do reserve space for exactly this case. At mount time we
set aside s_resv_clusters (2% of the clusters, capped at 4096 clusters),
and EXT4_GET_BLOCKS_METADATA_NOFAIL is allowed to use it. The problem is
that this reservation is not effective today. s_freeclusters_counter is
incremented when blocks are freed, but for journaled frees the blocks
only return to the buddy allocator after the freeing transaction
commits. Most allocation paths already run inside a transaction, so we
cannot force a commit from there, and even between retries the released
space can be taken again, as the reproducer shows. So ordinary
allocations can currently consume the reserved pool, and endio extent
splits can be fooled into thinking space is available. This hurts both
endio extent conversion and delalloc writeback.

My idea is to make this a real reservation of currently allocatable
clusters rather than just a counter check. We can subtract
sbi->s_mb_free_pending from free_clusters in ext4_has_free_clusters().
Then a successful check no longer counts clusters that cannot be
allocated yet, ordinary allocations can no longer eat into the reserved
pool, and the endio split can fall back on the reserve without having to
force a commit first. Delalloc reservations benefit as well, since
writeback is less likely to run into ENOSPC.

The downside is that ENOSPC may be returned earlier, e.g. by buffered
writes under the same heavy concurrency. I think that is acceptable
since the retry is best effort anyway, and ext4_should_retry_alloc()
still forces a commit when there are pending frees, so it can cover most
scenarios. Even if it does fail, it is better to fail early than to fail
after the data has already been written. This is also consistent with
the behavior of allocating blocks directly when writing in old
dioread_lock mode.

With the reproducer, this takes the DIO ENOSPC rate from ~11% to 0, and
failed conversion attempts from ~1500-2200 per run to ~0.3 per run.
fallocate ENOSPC did not increase noticeably (2.0% before vs 2.2% after).
However, the probability of returning ENOSPC for pure append writes
increases by about 10%.

Does this approach sounds OK?

Best Regards,
Yi.

----

The specific POC V2 fix code is as follows (based on Ojaswin's v1
series, and in addition to changing the free_cluster accounting, it also
fixes the fsync_tid issue mentioned earlier).


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 778fe8788f06..d4e0bb90a402 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -625,12 +625,14 @@ static int ext4_has_free_clusters(struct ext4_sb_info *sbi,
 				  s64 nclusters, unsigned int flags)
 {
 	s64 free_clusters, dirty_clusters, rsv, resv_clusters;
+	int pending_clusters;
 	struct percpu_counter *fcc = &sbi->s_freeclusters_counter;
 	struct percpu_counter *dcc = &sbi->s_dirtyclusters_counter;

 	free_clusters  = percpu_counter_read_positive(fcc);
 	dirty_clusters = percpu_counter_read_positive(dcc);
 	resv_clusters = atomic64_read(&sbi->s_resv_clusters);
+	pending_clusters = atomic_read(&sbi->s_mb_free_pending);

 	/*
 	 * r_blocks_count should always be multiple of the cluster ratio so
@@ -639,13 +641,23 @@ static int ext4_has_free_clusters(struct ext4_sb_info *sbi,
 	rsv = (ext4_r_blocks_count(sbi->s_es) >> sbi->s_cluster_bits) +
 	      resv_clusters;

+	/*
+	 * Clusters in s_mb_free_pending are already counted in
+	 * s_freeclusters_counter when freed, but they can't be allocated
+	 * until the transaction that freed them commits, so don't count
+	 * them as available.
+	 */
+	free_clusters -= pending_clusters;
 	if (free_clusters - (nclusters + rsv + dirty_clusters) <
 					EXT4_FREECLUSTERS_WATERMARK) {
-		free_clusters  = percpu_counter_sum_positive(fcc);
+		free_clusters  = percpu_counter_sum_positive(fcc) -
+				 pending_clusters;
 		dirty_clusters = percpu_counter_sum_positive(dcc);
 	}
-	/* Check whether we have space after accounting for current
-	 * dirty clusters & root reserved clusters.
+
+	/*
+	 * Check whether we have space after accounting for current
+	 * dirty clusters, pending frees & root reserved clusters.
 	 */
 	if (free_clusters >= (rsv + nclusters + dirty_clusters))
 		return 1;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8069521442a7..441356999594 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1761,6 +1761,7 @@ struct ext4_sb_info {

 	/* workqueue for reserved extent conversions (buffered io) */
 	struct workqueue_struct *rsv_conversion_wq;
+	struct workqueue_struct *iomap_conversion_wq;

 	/* timer for periodic error stats printing */
 	struct timer_list s_err_report;
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 91857b46ce24..f9502d78f86b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3423,10 +3423,29 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
 		if (err)
 			/* ZEROOUT failed, just return original error */
 			goto out_unlock;
+	} else if (flags & EXT4_GET_BLOCKS_SPLIT_NOMERGE) {
+		/*
+		 * The caller wants to split the extent before submitting
+		 * the I/O, but the split failed.  Zeroout the whole extent
+		 * and mark it initialized as the last resort, the upcoming
+		 * I/O will overwrite the map range.
+		 */
+		if (!is_unwrit) {
+			/* Shouldn't happen. Just exit */
+			err = -EINVAL;
+			goto out_unlock;
+		}
+
+		lblk = ee_block;
+		len = ee_len;
+		pblk = ext4_ext_pblock(ex);
+		err = ext4_issue_zeroout(inode, lblk, pblk, len);
+		if (err)
+			/* ZEROOUT failed, just return original error */
+			goto out_unlock;
 	} else {
 		/*
-		 * We no longer perform unwritten to unwritten splits in IO paths.
-		 * Hence this should not happen.
+		 * This should not happen.
 		 */
 		WARN_ON_ONCE(true);
 		err = -EINVAL;
@@ -4073,6 +4092,38 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
 	trace_ext4_ext_handle_unwritten_extents(inode, map, flags,
 						*allocated, newblock);

+	/* get_block() before submitting IO, split the extent */
+	if (flags & EXT4_GET_BLOCKS_SPLIT_NOMERGE) {
+		int depth;
+
+		path = ext4_split_convert_extents(handle, inode, map, path,
+						  flags, allocated);
+		if (IS_ERR(path))
+			return path;
+
+		/*
+		 * shouldn't get a 0 allocated when splitting an extent unless
+		 * m_len is 0 (bug) or extent has been corrupted
+		 */
+		if (unlikely(*allocated == 0)) {
+			EXT4_ERROR_INODE(inode,
+					 "unexpected allocated == 0, m_len = %u",
+					 map->m_len);
+			err = -EFSCORRUPTED;
+			goto errout;
+		}
+		/* Don't mark unwritten if the extent has been zeroed out. */
+		path = ext4_find_extent(inode, map->m_lblk, path, flags);
+		if (IS_ERR(path))
+			return path;
+		depth = ext_depth(inode);
+		if (ext4_ext_is_unwritten(path[depth].p_ext))
+			map->m_flags |= EXT4_MAP_UNWRITTEN;
+		else
+			ext4_update_inode_fsync_trans(handle, inode, 1);
+		goto split_out;
+	}
+
 	/* IO end_io complete, convert the filled extent to written */
 	if (flags & EXT4_GET_BLOCKS_CONVERT) {
 		path = ext4_convert_unwritten_extents_endio(handle, inode,
@@ -4126,7 +4177,7 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
 		err = -EFSCORRUPTED;
 		goto errout;
 	}
-
+split_out:
 	map->m_flags |= EXT4_MAP_NEW;
 map_out:
 	map->m_flags |= EXT4_MAP_MAPPED;
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 52b1fb99484d..96049dc54963 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -450,14 +450,30 @@ static int ext4_dio_write_end_io(struct kiocb *iocb, ssize_t size,
 	loff_t pos = iocb->ki_pos;
 	struct inode *inode = file_inode(iocb->ki_filp);

+	if (!error && size && (flags & IOMAP_DIO_UNWRITTEN)) {
+		int retries = 0;

-	if (!error && size && (flags & IOMAP_DIO_UNWRITTEN) &&
-			(iocb->ki_flags & IOCB_ATOMIC))
-		error = ext4_convert_unwritten_extents_atomic(NULL, inode, pos,
-							      size);
-	else if (!error && size && flags & IOMAP_DIO_UNWRITTEN)
-		error = ext4_convert_unwritten_extents(NULL, inode, pos, size,
-						       NULL, 0);
+retry_convert:
+		if (iocb->ki_flags & IOCB_ATOMIC)
+			error = ext4_convert_unwritten_extents_atomic(NULL,
+					inode, pos, size);
+		else
+			error = ext4_convert_unwritten_extents(NULL, inode,
+					pos, size, NULL, 0);
+
+		/*
+		 * The conversion may have failed to allocate metadata for
+		 * splitting the extent.  Blocks freed by other operations
+		 * (e.g. an unlink) may still be waiting for a journal
+		 * commit, so commit and retry the conversion.
+		 */
+		if (error == -ENOSPC && EXT4_SB(inode->i_sb)->s_journal &&
+		    ext4_count_free_clusters(inode->i_sb) &&
+		    ++retries <= 3) {
+			if (ext4_force_commit(inode->i_sb) == 0)
+				goto retry_convert;
+		}
+	}

 	/*
 	 * If this dio covered an unwritten extent, we would have incremented
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 13449e4ebb6a..03d296f54b6d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -991,7 +991,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 			goto out;
 		if (map->m_flags & EXT4_MAP_UNWRITTEN &&
 		    (flags & EXT4_GET_BLOCKS_UNWRIT_EXT) &&
-		    !(flags & EXT4_GET_BLOCKS_CONVERT)) {
+		    !(flags & (EXT4_GET_BLOCKS_CONVERT |
+			       EXT4_GET_BLOCKS_SPLIT_NOMERGE))) {
 			/* Contains EXT4_GET_BLOCKS_CREATE - mark mapped. */
 			ret = check_block_validity(inode, map);
 			if (!ret)
@@ -2600,8 +2601,17 @@ static int mpage_map_one_extent(handle_t *handle, struct mpage_da_data *mpd)
 			   EXT4_EX_NOCACHE;

 	dioread_nolock = ext4_should_dioread_nolock(inode);
-	if (dioread_nolock)
-		get_blocks_flags |= EXT4_GET_BLOCKS_UNWRIT_EXT;
+	if (dioread_nolock) {
+		get_blocks_flags |= EXT4_GET_BLOCKS_SPLIT_NOMERGE |
+				    EXT4_GET_BLOCKS_UNWRIT_EXT;
+		/*
+		 * The io_end is accounted in i_conv_pending_ios only after
+		 * the first unwritten extent has been mapped, so tell the
+		 * zeroout fallback whether our own count is already included.
+		 */
+		if (!(mpd->io_submit.io_end->flag & EXT4_IO_END_UNWRITTEN))
+			get_blocks_flags |= EXT4_GET_BLOCKS_NO_CONV_ACC;
+	}

 	err = ext4_map_blocks(handle, inode, map, get_blocks_flags);
 	if (err < 0)
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index e99816017a18..35826bd19b51 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -649,7 +649,7 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
 	unsigned long io_mode = (unsigned long)ioend->io_private;
 	bool is_disksize_grow = (io_mode == EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO);
 	handle_t *handle;
-	int credits;
+	int credits, retries = 0;
 	int ret, err;

 	/*
@@ -684,6 +684,8 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
 	/* Wait for disksize-pending zeroed data to be written out. */
 	ext4_iomap_wb_disksize_pending_wait(inode, pos, size);

+retry:
+	ret = 0;
 	/*
 	 * We may need to convert one extent, update the i_disksize and
 	 * dirty the inode.
@@ -702,6 +704,8 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
 						    is_disksize_grow);
 		if (ret)
 			goto out_journal;
+
+		is_disksize_grow = false;
 	}

 	if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
@@ -714,6 +718,12 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
 		ret = err;
 out_err:
 	if (ret < 0 && !ext4_emergency_state(sb)) {
+		if (ret == -ENOSPC && EXT4_SB(sb)->s_journal &&
+		    ext4_count_free_clusters(sb) && ++retries <= 3) {
+			if (ext4_force_commit(sb) == 0)
+				goto retry;
+		}
+
 		ext4_msg(sb, KERN_EMERG,
 			 "failed to convert unwritten extents to written extents or update inode size -- potential data loss! (inode %llu, error %d)",
 			 inode->i_ino, ret);
@@ -768,7 +778,7 @@ void ext4_iomap_end_bio(struct bio *bio)

 	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
 	if (list_empty(&ei->i_rsv_conversion_list))
-		queue_work(EXT4_SB(ioend->io_inode->i_sb)->rsv_conversion_wq,
+		queue_work(EXT4_SB(ioend->io_inode->i_sb)->iomap_conversion_wq,
 			   &ei->i_rsv_conversion_work);
 	list_add_tail(&ioend->io_list, &ei->i_rsv_conversion_list);
 	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3c53bf27da45..859b9c65fc0b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1326,6 +1326,7 @@ static void ext4_put_super(struct super_block *sb)
 	flush_delayed_work(&sbi->s_ea_inode_work);
 	ext4_quotas_off(sb, EXT4_MAXQUOTAS);

+	destroy_workqueue(sbi->iomap_conversion_wq);
 	destroy_workqueue(sbi->rsv_conversion_wq);
 	ext4_release_orphan_info(sb);

@@ -5668,6 +5669,23 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		goto failed_mount4;
 	}

+	/*
+	 * Buffered iomap conversions may have to force a journal commit and
+	 * retry.  That commit can wait for the writeback/endio of a
+	 * buffer_head io_end which is completed on rsv_conversion_wq, so the
+	 * iomap conversions must not share that single-threaded workqueue.
+	 */
+	EXT4_SB(sb)->iomap_conversion_wq =
+		alloc_workqueue("ext4-iomap-conversion",
+				WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
+	if (!EXT4_SB(sb)->iomap_conversion_wq) {
+		ext4_msg(sb, KERN_ERR, "failed to create workqueue");
+		err = -ENOMEM;
+		destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
+		EXT4_SB(sb)->rsv_conversion_wq = NULL;
+		goto failed_mount4;
+	}
+
 	/*
 	 * The jbd2_journal_load will have done any necessary log recovery,
 	 * so we can safely mount the rest of the filesystem now.
@@ -5842,6 +5860,8 @@ failed_mount8: __maybe_unused
 	sb->s_root = NULL;
 failed_mount4:
 	ext4_msg(sb, KERN_ERR, "mount failed");
+	if (EXT4_SB(sb)->iomap_conversion_wq)
+		destroy_workqueue(EXT4_SB(sb)->iomap_conversion_wq);
 	if (EXT4_SB(sb)->rsv_conversion_wq)
 		destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
 failed_mount_wq:
@@ -6543,6 +6563,7 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 		return ret;

 	trace_ext4_sync_fs(sb, wait);
+	flush_workqueue(sbi->iomap_conversion_wq);
 	flush_workqueue(sbi->rsv_conversion_wq);
 	flush_delayed_work(&sbi->s_ea_inode_work);
 	/*







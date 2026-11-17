Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.94.104
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794915446;
	b=QxJGA5/QoPvdXkad0u22nvTsC4devGo0Cj+18XGPwx1peEmytwF3rJBBP4nKFFBJ7E5a
	 vhuPd0M9AXeF4LlaU3oKICBqTautToSHwB6in5NtJDl0qBtYiwc0AUoCEEENhMDuhjodS
	 rAUTxrTyQYLGZKgLq13chi1lo1Eyc6w2Q9T5hbKWWhaLl+F5OFGGIi7LlBgZmeVw9MjRR
	 gsMqjqCVUHFYI6m+oWUjDzWllxliVSEpGI8SqtP/ekxYTh6XQqYKKIKBzJI/a+BsZNOm9
	 kd/4B26xgw/fOITi4Zq7CLjRrTuHZ+abHFwcT7niivhbgd8NlqKWcfGOIMQbw7a7zPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794915446;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=/EcSGYNMgSh+qCKvRusEvJ9hLS49ZL0M7tQX97joMLM=;
	b=z/7KjTXMIfBfG2+mg9l36AY2LTiE+oqIi82HWSyIJAiaQ7zE1klzsdgEn7YafWplLPHt
	 XewMxr2CD+LEKVw2Ye+qaYcX5buOOKSJAEv9HUKp8r4OBWE52koz2bzQqbQZd+gIfxm5g
	 LzW+7xO5O4Z1Ppz7NVKzRBJHFh7g3UX/B5jbN5QO+0UV89C3FAuXyLto0Zr7mXgwVVYgu
	 Ccas09VaCoot4cO4/rs5gu6Gmo5rgHVWxD4dCa33IFe107ocNIiHSruK/2QptlOBnIdsL
	 VWpExFZj+Nd6dv5+KebIsYt0zMa7Ghme7CB0Xbmf4Ju3W8oRgx94A5Kx2NPlx8AdK4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.94.104
Received: from dggmsgout13.his.huawei.com (dggmsgout13.his.huawei.com [124.71.94.104])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E44606A31C;
	Tue, 17 Nov 2026 11:37:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64E44606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout13.his.huawei.com (SkyGuard) with ESMTP id 4jTN3g2zwBz1rq71;
	Tue, 17 Nov 2026 19:36:31 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E5B274056B;
	Tue, 17 Nov 2026 19:37:21 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCXzexmPPxqbMTREg--.29885S3;
	Tue, 17 Nov 2026 19:37:21 +0800 (CST)
Message-ID: <d8ac3185-44c8-41e7-9cbf-3d1baa27f272@huaweicloud.com>
Date: Tue, 17 Nov 2026 19:37:10 +0800
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
 Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 guolingxing <guolingxing@tju.edu.cn>, Josef Bacik <josef@toxicpanda.com>,
 Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, regressions@lists.linux.dev
References: <d400205a-0d3d-4ec3-a916-6c0a085841b4@linux.dev>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <d400205a-0d3d-4ec3-a916-6c0a085841b4@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgCXzexmPPxqbMTREg--.29885S3
X-Coremail-Antispam: 1UD129KBjvAXoW3Cr45GrWUKryrGw4DZr1kKrg_yoW8Gr4DKo
	WfXan8Gr48K34DJrZ5Gr1xtry7u3ZrCw4fJFy5u3yFqFnavryY93yfWw43X3Waqw4Fkrn7
	Ja4xGa15JrsIqF4rn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUY77kC6x804xWl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK
	8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
	AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF
	7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 11/16/2026 10:27 AM, Jose Fernandez (Anthropic) wrote:
> Ojaswin's cover letter [1] explains how, since commit ea96cb5c4ae3
> ("ext4: don't split extent before submitting I/O"), the split of an
> unwritten extent at I/O completion can get ENOSPC. [1] stops the zeroout
> from hitting other writes in flight, and [2] reports the failed
> conversion to fsync(). Neither gives the split its block, so data is
> still lost.
> 
> LLM agents working with me found that it happens with default options
> on a filesystem that is not full, and ran the tests. write() and fsync()
> return success, and after the pages are evicted part of the file reads
> back as zeros.
> 
> Under a load built to run the allocator dry (QEMU without KVM), 42 of
> 72 files lost data at ea96cb5c4ae3, none of 72 at its parent and none
> of 48 on v6.18.63. On mainline at 23c62304dde2 32 of 72 did. With [1]
> rebased on it 42 of 72 still did, now as failed conversions in dmesg.
> With [1] and [2] fsync() failed with ENOSPC on 47 of 72, and the other
> 25 read back intact.
> 

Hi Jose!

I'm sorry for causing this regression. The cause of this problem is that
the transaction freeing the file's space has not yet been committed and
thus cannot be returned to the mb allocator, so the extent cannot be
split at endio time to allocate space for metadata. This is easily
reproduced in scenarios with frequent file creation and deletion, even
though there is still plenty of free space on disk.

I think the solution should be based on Ojaswin's counting approach in
[1] or the PENDING_CONVERSION solution we discussed, and then, after
extent splitting fails, try to flush the journal and retry. My idea is
roughly as follows:

1. For the iomap buffered I/O path and the DIO path, this is relatively
   simple. We just need to add journal flush and retry logic in
   ext4_iomap_finish_ioend() and ext4_dio_write_end_io().

2. For the traditional bh buffered I/O path, we cannot flush the journal
   in ext4_convert_unwritten_io_end_vec(), because this may lead to an
   ABBA deadlock with data=ordered mode. The journal process needs to
   wait for ordered folio writeback, but this folio may contain some
   ranges that need to be converted, and if we flush the journal after
   the conversion fails, it will form a mutual dependency with journal
   flushing. Therefore, we have to fall back to splitting before issuing
   I/O, and when splitting fails, flush the journal and retry via
   jbd2_journal_force_commit_nested() in ext4_do_writepages().

3. Split the workqueues used at the end of iomap and bh writeback to
   avoid deadlocks. Because the filesystem may simultaneously have
   different inodes going through the bh path and the iomap path, if the
   iomap completion worker is flushing the journal, it may need to wait
   for the folio of another inode going through the bh path to finish
   conversion, and that conversion worker still needs to be handled on
   the same wq, thus causing a deadlock.

The current bh buffered I/O handling flow cannot be unified with the
other two, which is indeed not ideal. However, once data=ordered mode is
sunset in the future, we should be able to unify them. What do you all
think of this solution? Any better ideas?

Thanks,
Yi.


The specific POC fix code is as follows. I tested it with the reproducer
and the issue no longer reproduces.


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
index 91857b46ce24..82fcb71330dc 100644
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
@@ -4073,6 +4092,36 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
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
+		goto split_out;
+	}
+
 	/* IO end_io complete, convert the filled extent to written */
 	if (flags & EXT4_GET_BLOCKS_CONVERT) {
 		path = ext4_convert_unwritten_extents_endio(handle, inode,
@@ -4126,7 +4175,7 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
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
index e99816017a18..ceeb15ae9b40 100644
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
@@ -684,6 +684,7 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
 	/* Wait for disksize-pending zeroed data to be written out. */
 	ext4_iomap_wb_disksize_pending_wait(inode, pos, size);

+retry:
 	/*
 	 * We may need to convert one extent, update the i_disksize and
 	 * dirty the inode.
@@ -702,6 +703,8 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
 						    is_disksize_grow);
 		if (ret)
 			goto out_journal;
+
+		is_disksize_grow = false;
 	}

 	if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
@@ -714,6 +717,12 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
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
@@ -768,7 +777,7 @@ void ext4_iomap_end_bio(struct bio *bio)

 	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
 	if (list_empty(&ei->i_rsv_conversion_list))
-		queue_work(EXT4_SB(ioend->io_inode->i_sb)->rsv_conversion_wq,
+		queue_work(EXT4_SB(ioend->io_inode->i_sb)->iomap_conversion_wq,
 			   &ei->i_rsv_conversion_work);
 	list_add_tail(&ioend->io_list, &ei->i_rsv_conversion_list);
 	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3c53bf27da45..9012fce8dd9a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1326,6 +1326,7 @@ static void ext4_put_super(struct super_block *sb)
 	flush_delayed_work(&sbi->s_ea_inode_work);
 	ext4_quotas_off(sb, EXT4_MAXQUOTAS);

+	destroy_workqueue(sbi->iomap_conversion_wq);
 	destroy_workqueue(sbi->rsv_conversion_wq);
 	ext4_release_orphan_info(sb);

@@ -5668,6 +5669,24 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		goto failed_mount4;
 	}

+	/*
+	 * Buffered iomap conversions may have to force a journal commit and
+	 * retry, so they cannot share the single-threaded rsv_conversion_wq
+	 * with the buffer_head path.  That commit may wait for the writeback
+	 * of a buffer_head io_end which is completed on rsv_conversion_wq.
+	 * Allow some concurrency here as a retry can block on the commit.
+	 */
+	EXT4_SB(sb)->iomap_conversion_wq =
+		alloc_workqueue("ext4-iomap-conversion",
+				WQ_MEM_RECLAIM | WQ_UNBOUND, 0);
+	if (!EXT4_SB(sb)->iomap_conversion_wq) {
+		printk(KERN_ERR "EXT4-fs: failed to create workqueue\n");
+		err = -ENOMEM;
+		destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
+		EXT4_SB(sb)->rsv_conversion_wq = NULL;
+		goto failed_mount4;
+	}
+
 	/*
 	 * The jbd2_journal_load will have done any necessary log recovery,
 	 * so we can safely mount the rest of the filesystem now.
@@ -5842,6 +5861,8 @@ failed_mount8: __maybe_unused
 	sb->s_root = NULL;
 failed_mount4:
 	ext4_msg(sb, KERN_ERR, "mount failed");
+	if (EXT4_SB(sb)->iomap_conversion_wq)
+		destroy_workqueue(EXT4_SB(sb)->iomap_conversion_wq);
 	if (EXT4_SB(sb)->rsv_conversion_wq)
 		destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
 failed_mount_wq:
@@ -6543,6 +6564,7 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 		return ret;

 	trace_ext4_sync_fs(sb, wait);
+	flush_workqueue(sbi->iomap_conversion_wq);
 	flush_workqueue(sbi->rsv_conversion_wq);
 	flush_delayed_work(&sbi->s_ea_inode_work);
 	/*



> Nothing our agents have tried fixes it fully. I'm reporting this so you
> are aware of the regression since v7.0. A reproducer is available to the
> maintainers off-list.
> 
> [1] https://lore.kernel.org/linux-ext4/20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com/
> [2] https://lore.kernel.org/linux-ext4/20261101102145.647496-1-guolingxing@tju.edu.cn/
> 
> #regzbot introduced: ea96cb5c4ae3
> 
> 


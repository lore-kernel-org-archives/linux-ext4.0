Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5903F3043CF
	for <linux-ext4@vger.kernel.org>; Tue, 14 Apr 2026 12:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776169634; cv=none; b=LaT1C1uK7cW0uysz5B2SIJxhd16inxm8FrnQ6HQY71rHjrcgJLe3vZUXNkIf+ZhXudW5q1b7najDWe7YFTHRIVL2v/eLqGeY6jfwqkf0rfvHmWslX40SlHwPfWyYqoDZWMoEYRO3gOcWHeHwN5ZB9aW1VbQivMCjlYS0ZdnKJww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776169634; c=relaxed/simple;
	bh=lInK4xg5OPiqmqMrMqo3ff+cEQrecsEeB4QLUNhSHm4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JqMo63tbtuPulukGjSJPvPgnoauolKA3ReLVhDqYimBjZa/8KZxPWdSs1ioRRJDHxU3OUZYQuOSW2MTVQ7GStnjqs3icMvpnAyC8NAbCb/MepCaXzxOckS/W8Qz4zeJQyeXjGo7wP2x71NuQjPvhm3mciEYaexLXAiQbzgoILrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EfN8c0ye; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EfN8c0ye"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a8fba3f769so24626245ad.2
        for <linux-ext4@vger.kernel.org>; Tue, 14 Apr 2026 05:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776169633; x=1776774433; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bEDuvXTH5Zn2XT2X16UjfO2ntfyWS9qDU8ZPsqL80os=;
        b=EfN8c0yet70Tc5H7N3Bs8BIwx1TZ5Sq4ByBNOO39p+trvs3vJhc72sRmk5eAes8b9G
         /QjhQfs8oGr3032yYM1eAVQj/p8BuuvSHGb7dt4OWRJveyMUnN+sJ6OwXCwto6O+RK6M
         52BuqJ7eH7U0f7hiHq8dI3TUcUYywowO559Lyfnvgqqxdj1E73dwG5yJ+DAuiWjHU+OU
         Nvmzo8K5qFRDoQYDPCEsd5QDkTsdExHHogCCvR52M6flw5saMmfPrYWoDLdl432o1wtH
         y/ipTCfZukeu27M8PgSIkeuNKuUP76V9JUYpj5AkP7Y6v3Q4xy60lHbnqQ9SVm/RbfT7
         FyrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776169633; x=1776774433;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bEDuvXTH5Zn2XT2X16UjfO2ntfyWS9qDU8ZPsqL80os=;
        b=XyrSg3JsJoKoHHwkjiXeYIpYlljcaBIp/AwihtU/CU3NksjmjbWj3KYU0OKufRA55q
         N9/u47JHAvvl20IOYuTjD07V+gLAM5BpxgWazk6HuY9LQzS3CMhyt+eILD+Xsa30u+oi
         dFICMLyvFP7S1iYyGwmW7Wzd+ptog5RulftEohWPigtemssw9jxlBlz0mdwEMfrHe4Us
         gItiFqcnQcxeHtXIoZapZ+dFlTNb4+4Qvr85gUcUASmae197yzkj2YdXAaa6RJVQTrYC
         E152jLdtWRkMJFlMya+OlYp++6VstSg9NW+REiSV/+ugAJMX9hJqDLBshmuGqKUTPYJd
         lUCg==
X-Forwarded-Encrypted: i=1; AFNElJ+YrWI8F1kNm3OtfnW4ozxNY9NzWYsCobKFdI9xkt9LFleiyVbv86HlA1Mrl1/lcgXaBbwd1ZMN0Au+@vger.kernel.org
X-Gm-Message-State: AOJu0YzmIvtdMebl3ETyEwGcJLCmnEIAVGdEDc+Shcrw7uUc0Gc0efqV
	v8OabLoHbZO+hgN8vFdEL8ZiRvjSONR7Utq7jaTIR+J8o4RtlNSm2PeW
X-Gm-Gg: AeBDieutYtq8cjbNhLgRTz0L/iRCEQ6qVQC/G2PKtmuKhk0UDOO+8XfhDaBo+SAmNOx
	hGIKVyLCvErh/5vbEUoXuF+G0cFPLsEMchMlzzdQJd7UHR4YRFcYJJJifgOKNUl6obghAk6ehK5
	UdJQA4fMzZ65lVOa7rQqOOT/DtuZhmjfbDOXgAWyz8sPGgV+iAP5kgsHtEBB4AqCvrx6AveKMO1
	vlUdkWgbv6C/imFPLEHNb5doz95QDzEQv6VOjE9u7NNs4dMs6JG3QJH9fMePtheq7WQt4fyJOZB
	in9PRV9M6WM6SRwYm4xUvkQMOpI4bf/u2iASLlrF84sztGr2LuNWwvk26iDATGO7mLf0AL9HV4T
	YToN9rE0WqTdofQD7jvlGMYdl0sPuxOkf4oTmgHL67Pj71tIl11ofx2r4JO2ox6KByvYktaHa9Y
	T19K1M7ZLr5hlueOuC+xy2NgTNW5szcdD3aGyH2Vn2NDynkP27itPNShJVeBRoqdnqUkA=
X-Received: by 2002:a17:903:1250:b0:2ae:54b2:27c7 with SMTP id d9443c01a7336-2b2d5a88d3dmr176156215ad.39.1776169632604;
        Tue, 14 Apr 2026 05:27:12 -0700 (PDT)
Received: from 192.168.5.4 ([2409:8a28:f32:86e4:9161:fb54:c7b3:5567])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2b468273ccfsm62273745ad.43.2026.04.14.05.27.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Apr 2026 05:27:11 -0700 (PDT)
From: Fengnan Chang <fengnanchang@gmail.com>
X-Google-Original-From: Fengnan Chang <changfengnan@bytedance.com>
To: brauner@kernel.org,
	djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Cc: lidiangang@bytedance.com,
	Fengnan Chang <changfengnan@bytedance.com>
Subject: [RFC PATCH] iomap: add fast read path for small direct I/O
Date: Tue, 14 Apr 2026 20:26:47 +0800
Message-Id: <20260414122647.15686-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When running 4K random read workloads on high-performance Gen5 NVMe
SSDs, the software overhead in the iomap direct I/O path
(__iomap_dio_rw) becomes a significant bottleneck.

Using io_uring with poll mode for a 4K randread test on a raw block
device:
taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -X1
-n1 -P1 /dev/nvme10n1
Result: ~3.2M IOPS

Running the exact same workload on ext4 and XFS:
taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -X1
-n1 -P1 /mnt/testfile
Result: ~1.9M IOPS

Profiling the ext4 workload reveals that a significant portion of CPU
time is spent on memory allocation and the iomap state machine
iteration:
  5.33%  [kernel]  [k] __iomap_dio_rw
  3.26%  [kernel]  [k] iomap_iter
  2.37%  [kernel]  [k] iomap_dio_bio_iter
  2.35%  [kernel]  [k] kfree
  1.33%  [kernel]  [k] iomap_dio_complete

I attempted several incremental optimizations in the __iomap_dio_rw()
path to close the gap:
1. Allocating the `bio` and `struct iomap_dio` together to avoid a
   separate kmalloc. However, because `struct iomap_dio` is relatively
   large and the main path is complex, this yielded almost no
   performance improvement.
2. Reducing unnecessary state resets in the iomap state machine (e.g.,
   skipping `iomap_iter_reset_iomap` where safe). This provided a ~5%
   IOPS boost, which is helpful but still falls far short of closing
   the gap with the raw block device.

Since optimizing the heavy generic path did not yield the desired
results for this specific, highly-demanding Gen5 SSD scenario, this
RFC patch introduces a dedicated asynchronous fast path.

The fast path is triggered when the request satisfies:
- Asynchronous READ request only for now.
- I/O size is <= inode blocksize (fits in a single block, no splits).
- Aligned to the block device's logical block size.
- No bounce buffering, fscrypt, or fsverity involved.
- No custom `iomap_dio_ops` (dops) registered by the filesystem.

By using a dedicated bio_set (`iomap_dio_fast_read_pool`) to embed a
much smaller completion state (`struct iomap_dio_fast_read`) directly
in the bio's front padding, we completely eliminate kmalloc/kfree and
drastically shorten the execution path.

After this optimization, the heavy generic functions disappear from the
profile, replaced by a single streamlined execution path:
  4.83%  [kernel]  [k] iomap_dio_fast_read_async.isra.31

With this patch, 4K random read IOPS on ext4 increases from 1.9M to
2.3M.

I am aware that adding a completely separate fast path introduces
duplicate code and may result in iomap_begin being called twice, this
likely unacceptable for merging in its current form.

However, I am submitting this patch to validate whether this
optimization direction is correct and worth pursuing. I would appreciate
feedback on how to better integrate these ideas into the main iomap
execution path.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 fs/iomap/direct-io.c | 275 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 275 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index e911daedff65a..e4183f7c2f962 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -5,10 +5,14 @@
  */
 #include <linux/blk-crypto.h>
 #include <linux/fscrypt.h>
+#include <linux/fsverity.h>
 #include <linux/pagemap.h>
 #include <linux/iomap.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/fserror.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/init.h>
 #include "internal.h"
 #include "trace.h"
 
@@ -880,12 +884,231 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 }
 EXPORT_SYMBOL_GPL(__iomap_dio_rw);
 
+static bool iomap_dio_fast_read_enabled = true;
+
+struct iomap_dio_fast_read {
+	struct kiocb	*iocb;
+	size_t		size;
+	bool		should_dirty;
+	struct work_struct	work;
+	struct bio	bio ____cacheline_aligned_in_smp;
+};
+
+static struct bio_set iomap_dio_fast_read_pool;
+
+static void iomap_dio_fast_read_complete_work(struct work_struct *work)
+{
+	struct iomap_dio_fast_read *fr =
+		container_of(work, struct iomap_dio_fast_read, work);
+	struct kiocb *iocb = fr->iocb;
+	struct inode *inode = file_inode(iocb->ki_filp);
+	bool should_dirty = fr->should_dirty;
+	struct bio *bio = &fr->bio;
+	ssize_t ret;
+
+	WRITE_ONCE(iocb->private, NULL);
+
+	if (likely(!bio->bi_status)) {
+		ret = fr->size;
+		iocb->ki_pos += ret;
+	} else {
+		ret = blk_status_to_errno(bio->bi_status);
+		fserror_report_io(inode, FSERR_DIRECTIO_READ, iocb->ki_pos,
+				  fr->size, ret, GFP_NOFS);
+	}
+
+	if (should_dirty) {
+		bio_check_pages_dirty(bio);
+	} else {
+		bio_release_pages(bio, false);
+		bio_put(bio);
+	}
+
+	inode_dio_end(inode);
+
+	trace_iomap_dio_complete(iocb, ret < 0 ? ret : 0, ret > 0 ? ret : 0);
+	iocb->ki_complete(iocb, ret);
+}
+
+static void iomap_dio_fast_read_end_io(struct bio *bio)
+{
+	struct iomap_dio_fast_read *fr = bio->bi_private;
+	struct kiocb *iocb = fr->iocb;
+
+	if (unlikely(bio->bi_status)) {
+		struct inode *inode = file_inode(iocb->ki_filp);
+
+		INIT_WORK(&fr->work, iomap_dio_fast_read_complete_work);
+		queue_work(inode->i_sb->s_dio_done_wq, &fr->work);
+		return;
+	}
+
+	iomap_dio_fast_read_complete_work(&fr->work);
+}
+
+static inline bool iomap_dio_fast_read_supported(struct kiocb *iocb,
+					  struct iov_iter *iter,
+					  unsigned int dio_flags,
+					  size_t done_before)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	size_t count = iov_iter_count(iter);
+	unsigned int alignment;
+
+	if (!iomap_dio_fast_read_enabled)
+		return false;
+	if (iov_iter_rw(iter) != READ)
+		return false;
+
+	/*
+	 * Fast read is an optimization for small IO. Filter out large IO early
+	 * as it's the most common case to fail for typical direct IO workloads.
+	 */
+	if (count > inode->i_sb->s_blocksize)
+		return false;
+
+	if (is_sync_kiocb(iocb) || done_before)
+		return false;
+	if (dio_flags & (IOMAP_DIO_FORCE_WAIT | IOMAP_DIO_BOUNCE))
+		return false;
+	if (iocb->ki_pos + count > i_size_read(inode))
+		return false;
+	if (IS_ENCRYPTED(inode) || fsverity_active(inode))
+		return false;
+
+	if (count < bdev_logical_block_size(inode->i_sb->s_bdev))
+		return false;
+
+	if (dio_flags & IOMAP_DIO_FSBLOCK_ALIGNED)
+		alignment = i_blocksize(inode);
+	else
+		alignment = bdev_logical_block_size(inode->i_sb->s_bdev);
+
+	if ((iocb->ki_pos | count) & (alignment - 1))
+		return false;
+
+	return true;
+}
+
+static ssize_t iomap_dio_fast_read_async(struct kiocb *iocb,
+					 struct iov_iter *iter,
+					 const struct iomap_ops *ops,
+					 void *private)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	size_t count = iov_iter_count(iter);
+	int nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS);
+	bool should_dirty = user_backed_iter(iter);
+	struct iomap_dio_fast_read *fr;
+	struct iomap_iter iomi = {
+		.inode		= inode,
+		.pos		= iocb->ki_pos,
+		.len		= count,
+		.flags		= IOMAP_DIRECT,
+		.private	= private,
+	};
+	struct bio *bio;
+	ssize_t ret;
+
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		iomi.flags |= IOMAP_NOWAIT;
+
+	ret = kiocb_write_and_wait(iocb, count);
+	if (ret)
+		return ret;
+
+	inode_dio_begin(inode);
+
+	ret = ops->iomap_begin(inode, iomi.pos, count, iomi.flags,
+			       &iomi.iomap, &iomi.srcmap);
+	if (ret) {
+		inode_dio_end(inode);
+		return ret;
+	}
+
+	if (iomi.iomap.type != IOMAP_MAPPED ||
+	    iomi.iomap.offset > iomi.pos ||
+	    iomi.iomap.offset + iomi.iomap.length < iomi.pos + count ||
+	    (iomi.iomap.flags & IOMAP_F_ANON_WRITE)) {
+		ret = -EAGAIN;
+		goto out_iomap_end;
+	}
+
+	if (!inode->i_sb->s_dio_done_wq) {
+		ret = sb_init_dio_done_wq(inode->i_sb);
+		if (ret < 0)
+			goto out_iomap_end;
+	}
+
+	trace_iomap_dio_rw_begin(iocb, iter, 0, 0);
+
+	bio = bio_alloc_bioset(iomi.iomap.bdev, nr_pages,
+			       REQ_OP_READ | REQ_SYNC | REQ_IDLE,
+			       GFP_KERNEL, &iomap_dio_fast_read_pool);
+	fr = container_of(bio, struct iomap_dio_fast_read, bio);
+	fr->iocb = iocb;
+	fr->should_dirty = should_dirty;
+
+	bio->bi_iter.bi_sector = iomap_sector(&iomi.iomap, iomi.pos);
+	bio->bi_ioprio = iocb->ki_ioprio;
+	bio->bi_private = fr;
+	bio->bi_end_io = iomap_dio_fast_read_end_io;
+
+	ret = bio_iov_iter_get_pages(bio, iter,
+				     bdev_logical_block_size(iomi.iomap.bdev) - 1);
+	if (unlikely(ret)) {
+		bio_put(bio);
+		goto out_iomap_end;
+	}
+
+	if (bio->bi_iter.bi_size != count) {
+		iov_iter_revert(iter, bio->bi_iter.bi_size);
+		bio_release_pages(bio, false);
+		bio_put(bio);
+		ret = -EAGAIN;
+		goto out_iomap_end;
+	}
+
+	fr->size = bio->bi_iter.bi_size;
+
+	if (should_dirty)
+		bio_set_pages_dirty(bio);
+
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		bio->bi_opf |= REQ_NOWAIT;
+	if (iocb->ki_flags & IOCB_HIPRI) {
+		bio->bi_opf |= REQ_POLLED;
+		bio_set_polled(bio, iocb);
+		WRITE_ONCE(iocb->private, bio);
+	}
+	submit_bio(bio);
+
+	if (ops->iomap_end)
+		ops->iomap_end(inode, iomi.pos, count, count, iomi.flags,
+			       &iomi.iomap);
+	return -EIOCBQUEUED;
+
+out_iomap_end:
+	if (ops->iomap_end)
+		ops->iomap_end(inode, iomi.pos, count, 0, iomi.flags,
+			       &iomi.iomap);
+	inode_dio_end(inode);
+	return ret;
+}
+
 ssize_t
 iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
 		unsigned int dio_flags, void *private, size_t done_before)
 {
 	struct iomap_dio *dio;
+	ssize_t ret;
+
+	if (!dops && iomap_dio_fast_read_supported(iocb, iter, dio_flags, done_before)) {
+		ret = iomap_dio_fast_read_async(iocb, iter, ops, private);
+		if (ret != -EAGAIN)
+			return ret;
+	}
 
 	dio = __iomap_dio_rw(iocb, iter, ops, dops, dio_flags, private,
 			     done_before);
@@ -894,3 +1117,55 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	return iomap_dio_complete(dio);
 }
 EXPORT_SYMBOL_GPL(iomap_dio_rw);
+
+static ssize_t fast_read_enable_show(struct kobject *kobj,
+				     struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%d\n", iomap_dio_fast_read_enabled);
+}
+
+static ssize_t fast_read_enable_store(struct kobject *kobj,
+				      struct kobj_attribute *attr,
+				      const char *buf, size_t count)
+{
+	bool enable;
+	int ret;
+
+	ret = kstrtobool(buf, &enable);
+	if (ret)
+		return ret;
+
+	iomap_dio_fast_read_enabled = enable;
+	return count;
+}
+
+static struct kobj_attribute fast_read_enable_attr =
+	__ATTR(fast_read_enable, 0644, fast_read_enable_show, fast_read_enable_store);
+
+static struct kobject *iomap_kobj;
+
+static int __init iomap_dio_sysfs_init(void)
+{
+	int ret;
+
+	ret = bioset_init(&iomap_dio_fast_read_pool, 4,
+			  offsetof(struct iomap_dio_fast_read, bio),
+			  BIOSET_NEED_BVECS | BIOSET_PERCPU_CACHE);
+	if (ret)
+		return ret;
+
+	iomap_kobj = kobject_create_and_add("iomap", fs_kobj);
+	if (!iomap_kobj) {
+		bioset_exit(&iomap_dio_fast_read_pool);
+		return -ENOMEM;
+	}
+
+	if (sysfs_create_file(iomap_kobj, &fast_read_enable_attr.attr)) {
+		kobject_put(iomap_kobj);
+		bioset_exit(&iomap_dio_fast_read_pool);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+fs_initcall(iomap_dio_sysfs_init);
-- 
2.39.5 (Apple Git-154)


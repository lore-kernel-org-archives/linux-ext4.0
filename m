Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794596775;
	b=iniopBPPAUXLEy2FolK3xej6PZ+qcThaAexQEqURvYOIYhhqUWAXuaG3RosWvVQSKVaz
	 2AQ/A6aGwrzjuMDrBYFe4jSuidZm9ji5FiJuFLLzxU8JD058lcGRl0SMxyTf+o9C9jhZ1
	 71Hd6sGWDbgoAhgvqrZwMj9l27nLGdtayUneOm8sSRfSqBXKGE9aDftSOmFKX8wIHTP58
	 tJFsizXCmL1X2JmShG83p6MnC5R/DFL/XeI32dsDC2FZxQM4NDSDJ1hiQDZbZDA8NlPxl
	 pRirGfJUV3+hnyhX5ul52YAPFukl5j0vBLoh0gF3HgOliumJm9VQYhuJqGML4x4OgCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794596775;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=LAKAcKEdN+y4KZbfrY/xVImJAQROw218EJMq0a8plLM=;
	b=OCB8PBQBSB9Q7V4nNqr6kLE/DFatVAlelH9vSJf+2v0QQNIQ/EE8NV6U2mkvA9sk9H67
	 3tY5Pd/8zId7j9ysconRDS3rfsBKRLTZmFb1LwFxGYtvjcMe7nkSsl9PCt1gyADf0WmVN
	 KHyfvWIRNJAckfeqG6IcELtf5ySRFmFraitM+hNQg/p9dPM9X1LLD4DNhzfkUU/KXot07
	 6AX9MZs13+zm/uzB6L/6nQ14ktFeD9P8yC5kvv6RrCJ14oF0mlZLcNtfk6Gi0XXfuwrh1
	 DnFzze3qBEXxaeO6HyVJuOlGJ1P6nwKSS1ZIDUfcbnS7XgSvnqySlfhe2AjK86b+EVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oVF2MmRh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DD8606A883;
	Fri, 13 Nov 2026 19:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oVF2MmRh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7A91F000C6;
	Fri, 13 Nov 2026 19:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596775;
	bh=LAKAcKEdN+y4KZbfrY/xVImJAQROw218EJMq0a8plLM=;
	h=From:Date:Subject:To:Cc;
	b=oVF2MmRh/uydGmiSGMxXAeDYsNPAqgMssY4zaLupzTs/vkXr6x3kzkdUzXO3dadcM
	 DSu99AN/oJrvu4r7YbhmoDLTNMwCznEcyqmwNT/fdSxzVPSUTdLHA2HV94/8/0lLSj
	 yXCqaTUTe3NiC0mSQRLyW4u6EB7rW4su7/arM85WhVfz6oRmL8iKlYF5LbKByIMuQp
	 mV5jCOrL4yyHN79YJ04GuPwc9Rzoh+BfvVomzJZQG/oVi9WAh1xEC9CALYDTa+xjWn
	 u5FgbhK71Yu2bqGlO0rWOXsDbYNWljC5jNXxyApv1ahzo2OJfZmagBm/SLoHKptAfh
	 ZRUchueKt9Faw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 20:05:48 +0100
Subject: [PATCH] ext4: don't use the kiocb after a direct read was queued
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-ext4-dio_read_kiocb-v1-1-172a88be803c@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/1XM3QrCMAyG4VsZOTalrWOItyIy+pO5OFglnToYu
 3dbPfLwDV+eDTIJU4Zzs4HQizOnuYQ5NBBGN98IOZYGq21njDniO8mEtC4tRk69kIv9xCl4NG0
 XT4PW0RkL5f0hNPD6pS/XX+env1NYqlcX3mVCL24OYz1VWVVZ/cuq7mDfP578gXasAAAA
X-Change-ID: 20261113-work-ext4-dio_read_kiocb-146d8f00da12
To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>, 
 linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3329; i=brauner@kernel.org;
 h=from:subject:message-id; bh=dsMkD06eOrDzKxAj4WEGQB97gyZrPTZVYCwCxOYxQ2o=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9j1/0fYNl9fUFnz7+fS8vXlf9w/xMY02H5bFTPx/O2
 PFlnf7k6R2lLAxiXAyyYoosDu0m4XLLeSo2G2VqwMxhZQIZwsDFKQATWZPA8E/bq2XbqVqmF4/9
 9T6klHou897u2Xv8uvO2RXHFy/+qfTjE8Fdwz9n/zeKGby7urWEXi1JPvnWt9Wv0/p58ZxHZiS6
 xLEwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ext4_dio_read_iter() calls file_accessed(iocb->ki_filp) after it
submitted the direct read. But once the read was queued the kiocb
belongs to the completion handler. If the read completes before
ext4_dio_read_iter() gets to file_accessed() and the completion handler
frees the kiocb it reads freed memory.

aio and io_uring hold a reference to the kiocb until the submission
returned so they don't have that problem. The fileio backend of the
scsi target with fd_async_io=1 frees the kiocb in the completion
handler:

  BUG: KASAN: slab-use-after-free in ext4_dio_read_iter+0x5e1/0x690
  Workqueue: target_submission target_queued_submit_work
  Call Trace:
   <TASK>
   dump_stack_lvl+0x5d/0x80
   print_report+0x14b/0x4b0
   kasan_report+0x108/0x130
   ext4_dio_read_iter+0x5e1/0x690
   fd_execute_rw+0xd30/0x1700
   __target_execute_cmd+0x53/0x190
   transport_generic_new_cmd+0x65a/0xdb0
   __target_submit+0x12c/0x380
   target_queued_submit_work+0x73/0x270
   process_one_work+0x946/0x1820
   worker_thread+0x4f1/0xd60
   kthread+0x364/0x460
   ret_from_fork+0x525/0x770
   ret_from_fork_asm+0x1a/0x30
   </TASK>

  Allocated by task 59:
   __kmalloc_noprof+0x223/0x830
   fd_execute_rw+0x766/0x1700
   __target_execute_cmd+0x53/0x190
   transport_generic_new_cmd+0x65a/0xdb0
   __target_submit+0x12c/0x380
   target_queued_submit_work+0x73/0x270

  Freed by task 14:
   kfree+0x267/0x6a0
   blk_update_request+0x3f5/0x1260
   blk_mq_end_request+0x59/0x450
   blk_complete_reqs+0xb0/0x130
   handle_softirqs+0x20c/0x860
   run_ksoftirqd+0x31/0x60

Remember the file before the read is submitted. xfs avoids the same
problem by calling file_accessed() before it submits the read.

Fixes: b1b4705d54ab ("ext4: introduce direct I/O read using iomap infrastructure")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
I hit this on v7.4-rc1 while testing the fileio backend of the scsi
target with fd_async_io=1 and the backing file on ext4. KASAN reliably
fires on the first direct reads through the LUN.

The fileio backend gets a fix as well so it doesn't free its kiocb under
the filesystem anymore. But ext4 shouldn't use the kiocb after the read
was queued either.
---
 fs/ext4/file.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 50d3c92709c8b..aefaeb2c51316 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -68,8 +68,9 @@ static bool ext4_should_use_dio(struct kiocb *iocb, struct iov_iter *iter)
 
 static ssize_t ext4_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file_inode(file);
 	ssize_t ret;
-	struct inode *inode = file_inode(iocb->ki_filp);
 
 	if (iocb->ki_flags & IOCB_NOWAIT) {
 		if (!inode_trylock_shared(inode))
@@ -96,7 +97,8 @@ static ssize_t ext4_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		ret = iomap_dio_rw(iocb, to, &ext4_iomap_ops, NULL, 0, NULL, 0);
 	inode_unlock_shared(inode);
 
-	file_accessed(iocb->ki_filp);
+	/* The kiocb may be gone once the read was queued. */
+	file_accessed(file);
 	return ret;
 }
 

---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261113-work-ext4-dio_read_kiocb-146d8f00da12


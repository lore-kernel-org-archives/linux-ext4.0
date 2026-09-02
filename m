Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6F9320CBE;
	Wed,  2 Sep 2026 07:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335245; cv=none; b=O2vqImAzy+rVMkJlECt/I48x3eih3hRPE8bbAkW0OlPeiHM3yKyb5dVKR/KkoVbZG/tU1sGo+3du+7OwfZupUwsLt3c0xWhA+U0ap38b84Qk68i2tPcE1tNnKgZLFX1VpVxOsfKiCRTI46KOFbve/9ELRIOw6FzYJD5Q08XxhnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335245; c=relaxed/simple;
	bh=o8FmgoYdsYjyVB+XJ0H6LCxj3FMwFt8UkvGX+Rj1CnA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dWJldVfjNNrvBJnvMeAaqJyyhreU94mSD3hBybmTRitddkyl4W4MDdFMl+53NSSLag9GfXEBWc4gocOy7fe/TxhLRAtMCRh6cayyDsgz0cfSrGdc88Zq748Mgcu6ov5SPE/cSigfx4EI7WD9VbrdsDpvwWKPb8PmQcuk8nas/ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=QPVIb2HG; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="QPVIb2HG"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=wH2CfQ8NlJ9qjdgD8gOoz1HdGX4QF01Gpzjou8ScRYs=;
	b=QPVIb2HGkXjoGFUlheFPTaFl6nReY9Qp8svTUtzhUBF2/KR5IEjfDKNlMkgpqQw528JiX5MNH
	NseSbq5LHmz/b2fwSENyTgHpUwzro0zhrd/yXzJ37lLWPO6yAK43w8QDF0QRFnjTUarutjn9hxh
	z7R00Tr3pWkTXseMFYuRpEY=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hZZKn47vRz1K96b;
	Wed,  2 Sep 2026 15:36:29 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id AE8CF4057A;
	Wed,  2 Sep 2026 15:47:19 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 2 Sep
 2026 15:47:18 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <bcrl@kvack.org>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>,
	<jack@suse.cz>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<libaokun@linux.alibaba.com>, <ojaswin@linux.ibm.com>,
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, <sforshee@kernel.org>,
	<akpm@linux-foundation.org>, <pmladek@suse.com>, <rostedt@goodmis.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<senozhatsky@chromium.org>, <kees@kernel.org>, <tglx@kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH v3 4/8] fs: Use acquire/release for fdtable resize synchronization
Date: Wed, 2 Sep 2026 15:48:01 +0800
Message-ID: <20260902074805.398540-5-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260902074805.398540-1-ruanjinjie@huawei.com>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf500011.china.huawei.com (7.185.36.131)

Replace the smp_wmb()/smp_rmb() barrier pair with
smp_store_release()/smp_load_acquire() on `files->resize_in_progress`.
The flag is the publish point for fdtable expansion: writers clear it
via release after rcu_assign_pointer(), readers check it via acquire
before rcu_dereference_sched(). Observing it clear guarantees the new
fdt pointer is visible.

This expresses the pattern more clearly and allows cheaper one-way
barriers on weakly-ordered architectures (e.g. arm64 STLR/LDAR vs
DMB ISHST/ISHLD).

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Assisted-by: DeepSeek:DeepSeek-V3
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 fs/file.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 628ca07dc4b1..86c035d459f2 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -273,8 +273,6 @@ static int expand_fdtable(struct files_struct *files, unsigned int nr)
 	rcu_assign_pointer(files->fdt, new_fdt);
 	if (cur_fdt != &files->fdtab)
 		call_rcu(&cur_fdt->rcu, free_fdtable_rcu);
-	/* coupled with smp_rmb() in fd_install() */
-	smp_wmb();
 	return 0;
 }
 
@@ -313,7 +311,8 @@ static int expand_files(struct files_struct *files, unsigned int nr)
 	/* All good, so we try */
 	files->resize_in_progress = true;
 	error = expand_fdtable(files, nr);
-	files->resize_in_progress = false;
+	/* coupled with smp_load_acquire() in fd_install() */
+	smp_store_release(&files->resize_in_progress, false);
 
 	wake_up_all(&files->resize_wait);
 	return error;
@@ -685,13 +684,12 @@ void fd_install(unsigned int fd, struct file *file)
 		return;
 
 	rcu_read_lock_sched();
-	if (unlikely(files->resize_in_progress)) {
+	/* coupled with smp_store_release() in expand_files() */
+	if (unlikely(smp_load_acquire(&files->resize_in_progress))) {
 		rcu_read_unlock_sched();
 		fd_install_slowpath(fd, file);
 		return;
 	}
-	/* coupled with smp_wmb() in expand_fdtable() */
-	smp_rmb();
 	fdt = rcu_dereference_sched(files->fdt);
 	VFS_BUG_ON(rcu_access_pointer(fdt->fd[fd]) != NULL);
 	rcu_assign_pointer(fdt->fd[fd], file);
-- 
2.34.1


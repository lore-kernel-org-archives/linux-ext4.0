Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8603DA5A3;
	Tue, 25 Aug 2026 09:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787651641; cv=none; b=tRc7xd60uc8QmZVfmEVUH3K5gzAWCpSlsBp/WjiVQGO4Ap7fbg2dD6l5WbrDURZljvlqih/UXNd2S+0pCXEd9j3jgGyzqR0X27hYQH4I/ySEfsy0tdzc/TW1RaWsz+lpeYl+GvggYADkKOmZyuYX6GMy0xLbWGpj1TwSCiJosdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787651641; c=relaxed/simple;
	bh=sP8Qz8Eqp5r1urJJ+9qmt0cVBLf49maB2A9Zk+1mGhA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KWD4qrwZyRhv1ZgYE9Adohs/TX/C3YkoS/c/ZhADeSB1/mCSkhqbN3rNYaY7dewzCXo/3EluP8vYaADg0D+/6fiZlo8LpK8qD6xg/nv1DLDRR0RfpGiO78/uLRlj7A9C3ZvEiBgl9HFIO06+xewzE3V2oXFUzKEA16+zrgLHy0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ieTm4NuA; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ieTm4NuA"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=x49gazzv3KYmakJASIQB62Fhc5cLbTaH59g9EycQ3Ms=;
	b=ieTm4NuAnaXbrs5/IKYe8vNVkx5UE9YTzZ+tKb6uw6TSTu6eN3WC4Wm1yav+Xitkcv32zIQbb
	Q0dSnSXnWPi54+9uyCI5IGaQoIdddbqBnSNmSSvwyyjtVgeiBtjR3thAcaP7aR0wyrQVjn5uQeO
	oUNV8fa9Hw/1pEhV1juMAlE=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hTjWW4vcmzLlTm;
	Tue, 25 Aug 2026 17:43:03 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id A9B2A40578;
	Tue, 25 Aug 2026 17:53:48 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 25 Aug
 2026 17:53:46 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<bcrl@kvack.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<libaokun@linux.alibaba.com>, <ojaswin@linux.ibm.com>,
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, <pmladek@suse.com>,
	<rostedt@goodmis.org>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <senozhatsky@chromium.org>,
	<akpm@linux-foundation.org>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <horms@kernel.org>,
	<socketcan@hartkopp.net>, <mkl@pengutronix.de>, <kuniyu@google.com>,
	<willemb@google.com>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
	<kees@kernel.org>, <cyphar@cyphar.com>, <tglx@kernel.org>,
	<liuhangbin@gmail.com>, <sdf@fomichev.me>, <nb@tipi-net.de>,
	<linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-can@vger.kernel.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH 04/11] fs: Use acquire/release for fdtable resize synchronization
Date: Tue, 25 Aug 2026 17:54:15 +0800
Message-ID: <20260825095422.3166067-5-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260825095422.3166067-1-ruanjinjie@huawei.com>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
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


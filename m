Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883873AFCEC;
	Wed,  2 Sep 2026 07:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335245; cv=none; b=RMhF02Kb97Z4AgimqxiOxva6FjAVSGa8ItlSAbaBxfhV/muK/jnCfjEwEip4HbFOYbEAZ6hh5Z/HOqektpm9eBA5YoKsMmvXX4v4mN04zB4dmU6t4s0Y2X28Ecc19xH+QsfUNu+17zGYyQU1DBkZPnOctHZp5AWtQptownfUz9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335245; c=relaxed/simple;
	bh=6PIg64GDnvklPC0UJj5Fh9eYgMI0rQUBw8ZYe1++kd8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qYsvwwplfJM0R7p1IGz+ZM926r5YiIavGVrYRhzPb/y4OLwhwuDfVUgw1rDSsBmE0ZqH1ES2Yo0Vtl0VSMfxlcAs2MYXhzmDwmKL+KOg0bdgiD+HDge2nqho90/il0rsS99905B7DQ8u+b8Bhf26x8FHEl+69doxm7F/sfUTiek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=c9mLb8sr; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="c9mLb8sr"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=J4yJnyqxeHRcmq2Fv8EZ0jwzeTlaVGzNrqh5hfCP6Nw=;
	b=c9mLb8srEPPPQLn8yQD0c0BDviwcWNS55C5KXhKc4Lr6mNPUZ/QWJP9W/S2+92FK4d3gHgR/6
	obYTqC6R8LtPGNDKBwX3FscPqdzkyNC5H6hczFGuWxwrAZrZMKArEzgEpCM04d+2arVNeGGvtZ7
	9YQTydYIvXdK+e7T86kwZ34=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hZZKp7268zLlXF;
	Wed,  2 Sep 2026 15:36:30 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id EBD04402AB;
	Wed,  2 Sep 2026 15:47:20 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 2 Sep
 2026 15:47:19 +0800
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
Subject: [PATCH v3 5/8] pidfs: Use test_bit_acquire() for attr flag tests
Date: Wed, 2 Sep 2026 15:48:02 +0800
Message-ID: <20260902074805.398540-6-ruanjinjie@huawei.com>
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

Replace test_bit() + smp_rmb() with test_bit_acquire() for
PIDFS_ATTR_BIT_EXIT and PIDFS_ATTR_BIT_COREDUMP tests in pidfd_info().

The acquire semantics ensure that if the flag is observed set, the
associated attr fields written before smp_wmb() + set_bit() are
also visible.

Writers keep smp_wmb() + set_bit() since no release bitop exists.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Assisted-by: DeepSeek:DeepSeek-V3
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 fs/pidfs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index a6a643f15d08..2cd0fab73180 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -393,8 +393,7 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
 
 	attr = READ_ONCE(pid->attr);
 	if (mask & PIDFD_INFO_EXIT) {
-		if (test_bit(PIDFS_ATTR_BIT_EXIT, &attr->attr_mask)) {
-			smp_rmb();
+		if (test_bit_acquire(PIDFS_ATTR_BIT_EXIT, &attr->attr_mask)) {
 			kinfo.mask |= PIDFD_INFO_EXIT;
 #ifdef CONFIG_CGROUPS
 			kinfo.cgroupid = attr->cgroupid;
@@ -405,8 +404,7 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
 	}
 
 	if (mask & PIDFD_INFO_COREDUMP) {
-		if (test_bit(PIDFS_ATTR_BIT_COREDUMP, &attr->attr_mask)) {
-			smp_rmb();
+		if (test_bit_acquire(PIDFS_ATTR_BIT_COREDUMP, &attr->attr_mask)) {
 			kinfo.mask |= PIDFD_INFO_COREDUMP | PIDFD_INFO_COREDUMP_SIGNAL | PIDFD_INFO_COREDUMP_CODE;
 			kinfo.coredump_mask = attr->coredump_mask;
 			kinfo.coredump_signal = attr->coredump_signal;
-- 
2.34.1


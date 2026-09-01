Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CB231B833;
	Tue,  1 Sep 2026 02:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788230537; cv=none; b=iF1Ts3wisRnmonKKHE6DX/jOcsBZVHqb7whYbyRQnlbrPTkANKpvHCjVkI6JwxCNXBpKhjQ9I7UYoJWLLWu9f8CMV61I4eE0gSoKOLCux7jICNQqHgzUyvA+xWdmNrbhxOGAvTVLmAWk7XRoLwMjMgdjLZc2Z4OZt9H6ImmFfK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788230537; c=relaxed/simple;
	bh=6PIg64GDnvklPC0UJj5Fh9eYgMI0rQUBw8ZYe1++kd8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nDMVsJ+YApbeEJN7j4OiKw77ImKQIapl27Ul6w36KvZsoyVDMpDpQt/sjqvXjUYMPUn3f5ycuu4xkBp1IC3HI9clxkXEZ0ORxJmaa5Uf2rYaEMj3p5QqMUSEFiWwnJHVOFSRsJTJdyIDhmVA339xz/Bj+/wUIgYJwjs3R5/p6lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=c9mLb8sr; arc=none smtp.client-ip=113.46.200.227
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
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hYqbY22jCznTVx;
	Tue,  1 Sep 2026 10:30:49 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 3CFF64055B;
	Tue,  1 Sep 2026 10:42:03 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 1 Sep
 2026 10:42:01 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<bcrl@kvack.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<libaokun@linux.alibaba.com>, <ojaswin@linux.ibm.com>,
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, <sforshee@kernel.org>,
	<pmladek@suse.com>, <rostedt@goodmis.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<senozhatsky@chromium.org>, <akpm@linux-foundation.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <horms@kernel.org>, <kuniyu@google.com>,
	<willemb@google.com>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
	<kees@kernel.org>, <cyphar@cyphar.com>, <tglx@kernel.org>,
	<ruanjinjie@huawei.com>, <sdf@fomichev.me>, <nb@tipi-net.de>,
	<liuhangbin@gmail.com>, <da-x@monatomic.org>, <jeff@garzik.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<netdev@vger.kernel.org>
Subject: [PATCH v2 05/12] pidfs: Use test_bit_acquire() for attr flag tests
Date: Tue, 1 Sep 2026 10:42:27 +0800
Message-ID: <20260901024234.135119-6-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260901024234.135119-1-ruanjinjie@huawei.com>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
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


Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471AE3E1D1D;
	Tue, 25 Aug 2026 09:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787651642; cv=none; b=Mp0t4yO3Zil+DXu3ahnyoOBsgDxMZNUSuqGFvWymVHYOquXfyoo6mhRfrDjZ0ztv728pqM18aQwpJznlPC1oCPEl0LOarJEzraFHXrqlCbgaGAyau6kc5+wwygYKdpGdrmvy4Gqp5WHOMu1hOaMHD3FfBQTyb3rFFwKXAxIA+f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787651642; c=relaxed/simple;
	bh=iMa5wE77I9viKX+iq6hS3czdT7wNpnuYi++AAeXFJqA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AHEMG4Shak66ek2ZWKRB3bBMSIfE7pdf73CZXKkelPnb4W4/BhJn83KQQC0/KDw/ceEoW4Q9Pngv9V5eKB4dXteMAmrHnsrL6z1MnT7rI4p/qgzJYgCoOxLV2U5nZsaIGX0ezNrQgnk0Ipj5kGPSUsQcSXNJOvKiblYMyl9SHpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=R+XDzKOd; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="R+XDzKOd"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=uB34aPYIu0gFatrgKpoNzKkyjI+jIEUqunuY9fhb2Do=;
	b=R+XDzKOdPy44XUzj2S9qrgEIuJ2suw9oMDPeNT27lU6xRy6SP6v5YGX5s7yLA7V2aaYrPe9ai
	TIrxJQCkrbmWT4uYoIusdxvm99sBHGBAmgDilAOOPDA/Mo6bzKlo9ePceFFLHAb5fJOA/RHCh4+
	ihKvFpENjOBXuPdUaXEp9/E=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hTjWW4cJpz1prQB;
	Tue, 25 Aug 2026 17:43:03 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 96CD240537;
	Tue, 25 Aug 2026 17:53:50 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 25 Aug
 2026 17:53:48 +0800
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
Subject: [PATCH 05/11] pidfs: Use test_bit_acquire() for attr flag tests
Date: Tue, 25 Aug 2026 17:54:16 +0800
Message-ID: <20260825095422.3166067-6-ruanjinjie@huawei.com>
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

Replace test_bit() + smp_rmb() with test_bit_acquire() for
PIDFS_ATTR_BIT_EXIT and PIDFS_ATTR_BIT_COREDUMP tests in pidfd_info().

The acquire semantics ensure that if the flag is observed set, the
associated attr fields written before smp_wmb() + set_bit() are
also visible.

Writers keep smp_wmb() + set_bit() since no release bitop exists.

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


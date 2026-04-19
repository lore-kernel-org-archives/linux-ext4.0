Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C551F2F25E4;
	Sun, 19 Apr 2026 06:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776580531; cv=none; b=r0bPbtGjsNluyIy6XBzUOCBTd6xvU6iFNupFttmc/wZeOTPKdx/b8aFnSB5iZ7hkh0CxPigMYH5Xnv++A9wvtu9u3LRQBvGHrgl64wjGjBaQOiIyCyM2ekjYDywL7++LCfxfwJoOkz0n9v/MoBeC3qqu8dstWV88FYwksbukbls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776580531; c=relaxed/simple;
	bh=AO14xcn3qCrUEJFv29xJ5fqMyI29XtvZJs1ua5nPtl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHPCvc0j7Hni1VNN3o2WOxTA5MKe+nqYlslNMCbAJArYcc/hPERt9wwPPRUwX1cXLwGYINobR3wQELS/evJcrj3Y0hsV0Yhb/3F3+xXvs4qEJ1S/4O7rp7w4x3Lt6B4+SWmTPKJtFvSTL0/2RQLTX5sK6OnsXpSN+IyNR/QrDb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=iXHmkIiT; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="iXHmkIiT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=8C
	Bk2n4W0IjNNrRLwj8VV5vgcWZEsY4jVAMR+auIjwg=; b=iXHmkIiThA3LxRNCA4
	b+D23CZUmBj3jDudWuy0fpy3DedqpKsocZX6p65JOCFIMDkLpzMa7MozcvoLxmr+
	Tj3Vt/vZkQyqwUWGhjLDWYeTbZpUjH8RtHPAEZpJ5fZ3b7ixXfTTY1kWUcdnPqXl
	Xwy/Qw6znqL4T94iQF6rDAsQk=
Received: from liubaolin-VMware-Virtual-Platform.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgBHBQKBd+Rp1PA9Ag--.97S3;
	Sun, 19 Apr 2026 14:34:57 +0800 (CST)
From: Baolin Liu <liubaolin12138@163.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca
Cc: wangguanyu@vivo.com,
	liubaolin12138@163.com,
	yi.zhang@huaweicloud.com,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baolin Liu <liubaolin@kylinos.cn>
Subject: [PATCH v2 v2 1/2] ext4: add blocks_allocated to mb_stats output
Date: Sun, 19 Apr 2026 14:34:35 +0800
Message-ID: <20260419063436.17999-2-liubaolin12138@163.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260419063436.17999-1-liubaolin12138@163.com>
References: <20260419063436.17999-1-liubaolin12138@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgBHBQKBd+Rp1PA9Ag--.97S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrtr1Utr4xur4Dtw13GryDZFb_yoWfXwc_Ka
	48Zr10kry5tr4I93W8tF4F93yYgwn7ZFn5G3sxJrZ3u3Z8Way0v398Ar45Xr1xGrW2k3y5
	u3WrWFyUJFZavjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sR_75rDUUUUU==
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbCwRGVYGnkd5G25wAA3f

From: Baolin Liu <liubaolin@kylinos.cn>

Add blocks_allocated to /proc/fs/ext4/<dev>/mb_stats so that the
reported statistics match the mballoc summary printed at unmount time.

Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
---
 fs/ext4/mballoc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 20e9fdaf4301..1e13ef62cb9d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3211,6 +3211,8 @@ int ext4_seq_mb_stats_show(struct seq_file *seq, void *offset)
 			"\tTo enable, please write \"1\" to sysfs file mb_stats.\n");
 		return 0;
 	}
+	seq_printf(seq, "\tblocks_allocated: %u\n",
+		   atomic_read(&sbi->s_bal_allocated));
 	seq_printf(seq, "\treqs: %u\n", atomic_read(&sbi->s_bal_reqs));
 	seq_printf(seq, "\tsuccess: %u\n", atomic_read(&sbi->s_bal_success));
 
-- 
2.51.0


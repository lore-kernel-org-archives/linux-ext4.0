Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2AD3203B6;
	Fri,  8 May 2026 09:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778232922; cv=none; b=OHxNOm3vMe39ZNUnCWw7JpFHuSiYdo3c9Fn/MoY7njeivhjuKLIEF8YW+O1FOW8HE0yI47rvF64s+4sFiGTtVUM7QV2V9Pg/LNNMI8hVx6lE8tiL8SkOZ6Sl0rOENdrgUeMIjp4NqRmamF36jckmot+xUe4LTBCWocsQc0uu2xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778232922; c=relaxed/simple;
	bh=SiyEP1WZSP5zJJz4PdRF92qWLnENtw7v20M5ZPSdrjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCQ9ACIe7jHh0efW4Tlrx+qE6qN6BzTtjbcPj4HALNr6taGtQRwR6H1Uq4jMaoVfqplQLH7pXHzrMRdTxJWLbTxoo7tAapl3LAGHkDdK6a0fmNMEGe11Jb7lm3Qi6o1eXbh6ph0dpcOD+tBMz3gwJ3owqQAweQc9Z0DRoZbKTyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=F8rz2NEs; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="F8rz2NEs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=45
	c6wya7N0PUbeskGcHwwrqhFeuHXefamz6GyNQYArQ=; b=F8rz2NEsJ4GrLXqxx3
	06QVrnvyywfCS4xk0U7XYAh/80JxTseBEv6xbtaxh50Sd41KH2PAbv+snFkviFLg
	9dhjQ7PSJOW7KBhk82YOPJl+1EtHNqEwOHiJ48OLdWHj7pPUNT4sFCGIFP+FVujH
	RD5lBzTmVCZgbB4ziJXBBix6o=
Received: from liubaolin-VMware-Virtual-Platform.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgDXeCEprv1pUW9wDg--.60442S3;
	Fri, 08 May 2026 17:34:52 +0800 (CST)
From: Baolin Liu <liubaolin12138@163.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com
Cc: ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wangguanyu@vivo.com,
	adilger@dilger.ca,
	liubaolin12138@163.com,
	Baolin Liu <liubaolin@kylinos.cn>
Subject: [PATCH v4 v4 1/3] ext4: add blocks_allocated to mb_stats output
Date: Fri,  8 May 2026 17:34:26 +0800
Message-ID: <20260508093428.5814-2-liubaolin12138@163.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260508093428.5814-1-liubaolin12138@163.com>
References: <20260508093428.5814-1-liubaolin12138@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgDXeCEprv1pUW9wDg--.60442S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrtr1Utr4xurW8GFykAryxKrg_yoWkGrX_Ka
	40yr18ur45Jr4xuF18AFsa9rZ0k3W0vFn8W3sxJrZ3Wa4DW3y8ta98Ar4rXr1xGr42krW5
	A3Z3Wry8JryvvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sR_QzV7UUUUU==
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbCwR2UX2n9rj07fwAA3U

From: Baolin Liu <liubaolin@kylinos.cn>

Add blocks_allocated to /proc/fs/ext4/<dev>/mb_stats so that the
reported statistics match the mballoc summary printed at unmount time.

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
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


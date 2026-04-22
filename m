Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC1D1F7569;
	Wed, 22 Apr 2026 01:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776822768; cv=none; b=CoJpy1yLmWfVvikA4DN6/n3yCoQXycnus53MQXqY3hkTxOTFSZ3Irb2bCQp8rCJq2B/Wf4QPSaRAlVlrFr6b/vChtlYjqudcLVPnnMkcSTpB+4QUqcsZWWHvFJOoMXrMy90L1BbKSaHxoQTyKfrAq0KMx2NsEpmvfV9R+dIRn7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776822768; c=relaxed/simple;
	bh=SiyEP1WZSP5zJJz4PdRF92qWLnENtw7v20M5ZPSdrjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JReJ2xAToLwnL0eBpe6lXq7RaW6KXoy/vyi9oKvLqbtMiQn6myN6hu5ePKl5ITC25xX573XJGDbZBJso0q5Ntrr29aA09lS70Io1T2uzuZ9irmXXGf2pJxJTUGtTtiU9Wc8zX2Ma78F4UOZ7e01wbz1o/PO++ZlZJj5NWaMyN9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ZUe9dl3b; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ZUe9dl3b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=45
	c6wya7N0PUbeskGcHwwrqhFeuHXefamz6GyNQYArQ=; b=ZUe9dl3bUzKiyD2wMH
	neCeucN00PkNr7ZMXh++bCvM0+PVUUVpwbWcitvckaJBCLTY78thufjfLsMuE/l5
	gsvm03+AlfG16wIzL4mYFl8tEgAMvQ9IeNFY3wYy/1Eg2AhAnRKuhg55DtXTSJK/
	MhHKG77ut5rMNSgWMZJt7WO7s=
Received: from liubaolin-VMware-Virtual-Platform.localdomain (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wA3Hx+uKehpOCzjAw--.387S3;
	Wed, 22 Apr 2026 09:51:57 +0800 (CST)
From: Baolin Liu <liubaolin12138@163.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wangguanyu@vivo.com,
	liubaolin12138@163.com,
	Baolin Liu <liubaolin@kylinos.cn>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v3 v3 1/2] ext4: add blocks_allocated to mb_stats output
Date: Wed, 22 Apr 2026 09:50:24 +0800
Message-ID: <20260422015026.7170-2-liubaolin12138@163.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260422015026.7170-1-liubaolin12138@163.com>
References: <20260422015026.7170-1-liubaolin12138@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wA3Hx+uKehpOCzjAw--.387S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrtr1Utr4xurW8GFykAryxKrg_yoWkGrX_Ka
	40yr18ur45Jr4xuF18AFsa9rZ0k3W0vFn8W3sxJrZ3Wa4DW3y8ta98Ar4rXr1xGr42krW5
	A3Z3Wry8JryvvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sR_nNVJUUUUU==
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6R0O2GnoKb123gAA3f

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


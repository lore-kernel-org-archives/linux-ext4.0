Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAD221A434;
	Sun, 24 May 2026 01:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779587723; cv=none; b=HLehcZRPw1i/ocsdM9NxW/Oq0FeqxRPb8Alz3BSO4Ug4f1aPPqTCg5jU4wJw9C7cHHnqyl3jUl1RLU3mtQsctHUtkjx72sMLA98rC/IxRFjLTl+bfNVdxlMdNsErsiVF5OkRtK3WMOo1D1G2CxjnhiM2s4iH9ymSIEr0QAYDiCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779587723; c=relaxed/simple;
	bh=J//TQ/8P8eQmnsdm5WQGNvahdWrPBxYth+MOpI61WxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EAZUiTFFovleMhaNQVJv3tTcNUPI+ZWxy8oK4ny897NLUQbarGoI7fn/mYGlEsfZqJDS2hUaVHzChxONh+KiBWtErhzc8U96zFZqEtbvibhvyqNGFJC6SY2bhHGgrFVL2TheL/nc3JcWk+SfeXbQe9TUx/bk/oE1SJQwEQFB674=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=NXLwcN64; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="NXLwcN64"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=va
	FDWIDrARSeOO2/BdaMZMml4ig3Sw7shfp2cqf4rV4=; b=NXLwcN64xuXHn7amwp
	Ds/WxpUDZnh6zWx0veNQt9r018VaLNE5BxJHGnuDr2/T8Y1JB7WiHx1e4NJUy7LA
	+fMd6Vyubud69ImMiDUecydrbVjTBJFHHJa8elzBDmAxMnR40y7/MiD4WCa8cO4y
	Csd1re4ai022smuu92bjcXZm8=
Received: from liubaolin-ThinkPad-E15-Gen-2 (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgAn6uNUWhJqz5eTEw--.270S3;
	Sun, 24 May 2026 09:54:35 +0800 (CST)
From: Baolin Liu <liubaolin12138@163.com>
To: corbet@lwn.net,
	skhan@linuxfoundation.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baolin Liu <liubaolin@kylinos.cn>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v6 v6 1/3] ext4: add blocks_allocated to mb_stats output
Date: Sun, 24 May 2026 09:54:19 +0800
Message-ID: <20260524015421.2529617-2-liubaolin12138@163.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260524015421.2529617-1-liubaolin12138@163.com>
References: <20260524015421.2529617-1-liubaolin12138@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgAn6uNUWhJqz5eTEw--.270S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrtr1Utr4xurW8GFykAryxKrg_yoWkGrX_Ka
	40yr18ur45Jr4xuF18AF4S9390k3W0vFn8W3sxJrs3W3WDW3y8Ka98Ar4rXw1xGr42krW5
	A3Z3WrW8JryvvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbJPEDUUUUU==
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbCwhzMl2oSWly2aQAA3k

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
index bb58eafb87bc..d36b0f7b5d7d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3217,6 +3217,8 @@ int ext4_seq_mb_stats_show(struct seq_file *seq, void *offset)
 			"\tTo enable, please write \"1\" to sysfs file mb_stats.\n");
 		return 0;
 	}
+	seq_printf(seq, "\tblocks_allocated: %u\n",
+		   atomic_read(&sbi->s_bal_allocated));
 	seq_printf(seq, "\treqs: %u\n", atomic_read(&sbi->s_bal_reqs));
 	seq_printf(seq, "\tsuccess: %u\n", atomic_read(&sbi->s_bal_success));
 
-- 
2.51.0


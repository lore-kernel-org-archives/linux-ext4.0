Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0283370D47
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2026 10:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789034935; cv=none; b=jowwg6lSKniaYJb5bW614VVVCHjoS9zfd3csQeLDr9N/B7GckWBt9vNQz8ll723rHaxRuGFkUcA6Cs/o3mk5Ap+XSAEYhfVNQwUbXoEulF7m1AoSI7vpciUqGt1DeCvOmXRavsYx9Q1KYP93yMKBJstVpVBunXA65ecGX8O/rB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789034935; c=relaxed/simple;
	bh=xAjbkTTj+/jn74zEg/OvrfEBI1zgNp0tauct5V72fa8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P3h5b1jIRaVBGEu0szXj0eVkR9qvqlBKHlfFxaEY8YeYfs4ZM8hnCFDpCeSfp3U+obq7/unvCbRyX5KJLtYwlvcaiB8B4vBclKJvHDd1imnuKqJh6jBPzp8liyOQ6Xu0Ga4VyjGzRIrL6OqnWcuVOWrv9vbuo//MbjsH9myA64o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4hgYKf6gtPz8sxm;
	Thu, 10 Sep 2026 12:08:38 +0200 (CEST)
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of kernel@pankajraghav.com designates 2001:67c:2050:b231:465::2 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
From: Pankaj Raghav <p.raghav@samsung.com>
To: linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH] ext4: set awu_max_opt to awu_max
Date: Thu, 10 Sep 2026 12:08:29 +0200
Message-ID: <20260910100829.2532894-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4hgYKf6gtPz8sxm

commit 5d894321c49e ("fs: add atomic write unit max opt to statx")
added atomic write max optimal to statx. As XFS can support large atomic
writes through SW, max_opt exposes the value that will be HW accelerated
atomics.

As ext4 does not support SW atomics, set awu_max_opt to awu_max.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/ext4/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 26f0f9714f03..93056c971e74 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6304,7 +6304,8 @@ int ext4_getattr(struct mnt_idmap *idmap, const struct path *path,
 			awu_max = sbi->s_awu_max;
 		}
 
-		generic_fill_statx_atomic_writes(stat, awu_min, awu_max, 0);
+		generic_fill_statx_atomic_writes(stat, awu_min, awu_max,
+						 awu_max);
 	}
 
 	flags = ei->i_flags & EXT4_FL_USER_VISIBLE;

base-commit: d5ba62a0b130441bcabca59c2fd2d59e65360234
-- 
2.51.2


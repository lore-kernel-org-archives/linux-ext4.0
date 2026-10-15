Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0E44C33E5;
	Thu, 15 Oct 2026 10:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792060197; cv=none; b=H9A+BTC+hpRLo0n6for+ilAyNecQn0BksFLr9tbmLe2cdpFBwRLIYqssIrdHtr/GbvyrY3Pwq3CAos618/oQl1Lh/2YVMJONwN7Truybfjt3Mw835OQMWBy/IL6EswRPJGtQOSpJBtJ1RVSqQTzNKd8euFzvbx5Ru/IP8jQIBK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792060197; c=relaxed/simple;
	bh=wp2qSWROyWZ+r3redg4Nlmqxreb8WRoDsgJs16qBVO8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nnFvUkqAZysnX5zDlvJqIdt1DgTH+l0Pvxk3EdeHb7JJ0S1rkjL7x9jhPYNy8Hgce7676DasA6H0po1adDHdVDWPu/eQJ4oPth8vRnJbjpp3UoLb8A6ybl1cQcqPR3590HuOTsxS5pFNeFlRvjPLIE8YcH6wf3/w6zuWEWQqZhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=qq1T3XE6; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="qq1T3XE6"
Received: from localhost (gy-adaptive-ssl-proxy-4-entmail-virt151.gy.ntes [IPV6:2409:8d28:39:f54:403e:4083:f623:91af])
	by smtp.qiye.163.com (Hmail) with ESMTP id 512956c60;
	Thu, 15 Oct 2026 18:29:46 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>
Subject: [PATCH] ext4: report unwritten extent conversion failures as writeback errors
Date: Thu, 15 Oct 2026 10:29:43 +0000
Message-Id: <20261015102943.74632-1-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa13f1c5f8703a2kunm59b97cd470211
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaSk1CVhhPHUJCSE1JSU5CTVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMfSUNBSEJBHU5PQU9LSB5BT0tDSEEdTUlIQUJKGh
	1ZV1kWGg8SFR0UWUFZT0tIVUpLSUJDQ0xVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=qq1T3XE6A+/iaB28ThsxhrEQT1zBkQcE9W0r4nmCFC+AeU7me3hWYe4plhbP0IDVRS0YTjv5uWhTe1Jfo4qveczZOOugl4Huh5lQlolqe/MScUPG9x0wppWWKDSvISqwXFXaByyPltfjeBu4a/gEf1+Kv3znhf2i3wmmHz1PLYM=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=6WClDbYaFlwWZT9MauoEsYrLdd/m9hn5aeKmSVgPILc=;
	h=date:mime-version:subject:message-id:from;

When a data writeback bio completes successfully but the subsequent
unwritten extent conversion fails, ext4_end_io_end() does not record
the error in the inode's mapping writeback error state.

Bio failures are already recorded by ext4_end_bio(), but conversion
failures are not. When the conversion is processed asynchronously,
its return value is not propagated to userspace, so fsync() may
return success despite the failed conversion.

Record conversion errors with mapping_set_error() before
ext4_release_io_end() ends folio writeback and wakes waiters. This
allows fsync() to observe the failure.

Fixes: b82e384c7bb9 ("ext4: optimize locking for end_io extent conversion")
Cc: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
---
 fs/ext4/page-io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 0236b6b9785a..2afa4c096156 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -189,6 +189,8 @@ static int ext4_end_io_end(ext4_io_end_t *io_end)
 			jbd2_journal_abort(EXT4_SB(sb)->s_journal, ret);
 	} else {
 		ret = ext4_convert_unwritten_io_end_vec(handle, io_end);
+		if (ret < 0)
+			mapping_set_error(inode->i_mapping, ret);
 	}
 	if (ret < 0 && !ext4_emergency_state(sb) &&
 	    io_end->flag & EXT4_IO_END_UNWRITTEN) {
-- 
2.34.1


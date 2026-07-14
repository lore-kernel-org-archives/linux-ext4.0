Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014A43F5BD8;
	Tue, 14 Jul 2026 08:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784016555; cv=none; b=Ol/Pl9UQsNjNgC/zBXlbNRck4toXsZSZ8JjDejFvd6tuhxoBvRgbytI+dm+koFXiFXGhvz6H17l6ddZ1TrJBRTqPJVi0WXWQHlLH+rbwjkK28lOmorHIqnoxb0/tCzsKHrGRop2OthQ6N8mY4dh+vq3du/vcsN0Vpawmi8N2Kcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784016555; c=relaxed/simple;
	bh=+2tXDBKPO/QuwbK836VP4RK5OIf2/gxeCPuU7Uo8OQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNmUG6H63tUxE5vcAmVsGb3CjX9odbJsuREhefr5UoOch2m/vVrMr3s1kvkoltTeFHrPLCWQTsCAMcTOq36UQXUc74KvuyKgw4t7yu9h4Qs9yPqXJlL6AOHnKDyCe6/Sm786xH68ZrLNqwvYShhClhusA7zGR8L6bJLiD13dmnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gzsQ91ksKzYQtll;
	Tue, 14 Jul 2026 16:08:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 37FA440605;
	Tue, 14 Jul 2026 16:09:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgD3B3ST7lVqDS26BA--.56424S6;
	Tue, 14 Jul 2026 16:09:04 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	chengzhihao1@huawei.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v4 2/9] ext4: skip tail block zeroing for inline data files
Date: Tue, 14 Jul 2026 16:00:37 +0800
Message-ID: <20260714080044.4038124-3-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260714080044.4038124-1-yi.zhang@huaweicloud.com>
References: <20260714080044.4038124-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgD3B3ST7lVqDS26BA--.56424S6
X-Coremail-Antispam: 1UD129KBjvJXoW7CFyUWw1rCryruFyktw17GFg_yoW8XF1rpa
	45G34DGrWku3sFga9aqr1xWw1ag3WfWr45JFWagr18Zay3Gr1xKFnI93W5XF1jyrW3A3y0
	qFW5XFy7Cw17ArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1l
	e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
	8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
	jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0x
	kIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
	AY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAI
	cVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjfUOdgAUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

ext4_block_zero_eof() is called from ext4_write_checks() on every
append write beyond EOF. For inline data files, ext4_get_block()
returns -ERANGE when ext4_load_tail_bh() looks up the tail block.
However, this error is currently ignored because the return value
of ext4_get_block() in ext4_load_tail_bh() is discarded.

Before we fix ext4_load_tail_bh() to properly propagate the error,
skip the zeroing for inline data inodes to avoid unnecessary
failures or confusion.

Fixes: 3f60efd65412d ("ext4: zero post-EOF partial block before appending write")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7b2face041ef..3ce925ca0769 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4218,6 +4218,14 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 	offset = from & (blocksize - 1);
 	if (!offset || from >= end)
 		return 0;
+	/*
+	 * Inline data has no tail block to zero out.  Note that a race with
+	 * ext4_page_mkwrite() converting inline data to an extent without
+	 * holding i_rwsem is safe, as that path zeroes the full block before
+	 * copying in the inline data.
+	 */
+	if (ext4_has_inline_data(inode))
+		return 0;
 	/* If we are processing an encrypted inode during orphan list handling */
 	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
 		return 0;
-- 
2.52.0


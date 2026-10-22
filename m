Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.194.254.142
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792652636;
	b=Mh69ddAfQOxFZGl3mIP37T25pun9YuDdeDdgzQFfrAh5qZ1MbBzvfxjdbAcd1UEyyXH9
	 RwkXJ9nZd5Tl7MPQXKzhVr7PsKqNtf3LdFozx3t7M46LCo76CRyLRIqxI1vXaC4AxSBkJ
	 7at842x4lSTxf+/mrQAyyWgIKO4BzqtRj6Zw8LA20bDP66z2m+vrn1mdY+CJINjpLjbKf
	 e9s1AXrYNtq6NtBDCp5bTs10vNEbmTyOmub5AVyThg4kFH/XOIann0QqdxHZLXPOfZeM4
	 jcOtkUzXWD7g4owOCQg7Jul6Y5qz9N0OE1UAJOHCWAawZjj45NPQgn7bqZ3Zkia0ZvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792652636;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:EX-QQ-RecipientCnt:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-QQ-SENDSIZE:Feedback-ID:X-QQ-XMAILINFO:
	 X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=Vh9t55iizJgxx1z3hrOQq6uSMRH3e0AAbZNB2mNDNFI=;
	b=rhDayeMymBse9PSl00BypcgBNibKtBlX7AvmiCgqXducHqPCny/poeOTzwWz6Ljsjgoc
	 zJomgrCBywj/hWoLtgi6YotErEz8jPj3sNWMUrtD3f9cZQDJZnMI/0UZdRTXZZoblZt8T
	 +MZv2meu6KnilxKWjvQmxsao+uSGAP2rN0VxQm/J9OvV/X2XnhK3DuBWTD6uDdcqLrNnc
	 yKcZbVFkTOg/HEWTGhZaUFj3ymggK+MzWO7ZsF8EVA4xQp++Pn2QgfSJ3anORu1dStyOU
	 F1C2YT9NeOBgQvo82B9zoLTkfuyu/w7hcZNqOaAa8536ThmOG52JQ8LTR+8Sh4bmn0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=uniontech.com;
	spf=pass smtp.mailfrom=uniontech.com;
	dkim=pass header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=GK27cvbS;
	arc=none smtp.remote-ip=18.194.254.142
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EDE606A319;
	Thu, 22 Oct 2026 07:03:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02EDE606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=GK27cvbS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1792652577;
	bh=Vh9t55iizJgxx1z3hrOQq6uSMRH3e0AAbZNB2mNDNFI=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=GK27cvbSDu9iLilIqB0VhBYytipY73YDu8rVF44n/qFLVHKRoDmQGBm7IbuAe7lv7
	 8FkzLxruQoUhOZrO3Pxq4CwqHw0RwMzYuujOsfglOeavy9loZQVo+tXkq4r5H+TdsO
	 YXB/odrBfWshChj1/rzB5cMXzDLgb7mmlnFUsJmM=
X-QQ-mid: zesmtpsz9t1792652559t4c609bf7
X-QQ-Originating-IP: KHid3TdewaR6ZJAwD/c+SfzGRxlxSbLwS+PIDpNG418=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 22 Oct 2026 15:02:37 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 11804153230825737676
EX-QQ-RecipientCnt: 10
From: Yichong Chen <chenyichong@uniontech.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH v2] ext4: drop tmp inode ownership before migration cleanup
Date: Thu, 22 Oct 2026 15:02:35 +0800
Message-Id: <20261022070235.17849-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NFu7PsLv8TZxQ2r9+jVsx9FB34amAibEjHKg4ZJDREhV1wxNVEBTZ2ce
	H9p7uvQyft96UcE2lbVCtBq7ZV7bju0/5qlO7NHve+Tiil0JuU96aLJASIgBT68izg/ogyw
	FQJjwu3MFYqX5lmtKCssKymzVnpIjx2VkJUjOpR1XX0OQa5KEAR7SQwgR5x7/HJFmnC0xAG
	MLjXGPtPfQg5aOAR2lGg257MjhXeTaaqjdXyIm3vlqpGkpfOtBj+p6UmgYTL/c9Dbe9S7ql
	czjZYDyUZ+Wk5Ln34xj4uow/YN50C+LaJ7EwUhOOMhw/CEdaVwCa1omDGBMfD7qUEyJNQSt
	luY4k48Nsod2K5Ner8G2IMIwjNCph+TFUbpbzlBriFDlroYaur8MKA31eG+Gja4/AxSYryq
	6W36QI9U6x6VLH42+3Yr/3YnChldCf0kNeWhl651Iln3r2TWeiayXJ172PzteAIpNJ15qq5
	vlukyfCLKKghqQiG1d4qL857ORwVo72FX3wTuRcxl+rVq6vflPxkMeYVSIcgBGggrtelrwM
	Ak3zkxjGAujhG1tyvN+bDmCp8CZMuk3bF5oM00LwMcBds8+07oCZDIqsYwZxoSvODqGkZfR
	uBkc/Jgo5LLBagzR/Z8cAOgGnPFmrMuF0Qlu4o+nUKZyTL2KQkwVrurooTIXSK2DiMBdeTd
	VaDIpifO5l0q/vQDcf0NcsF6W9tw4o3kQ3AbBnRwE+gjkiqpUTTArW992Y/03j+X+J8n5Oe
	S4eCQgVcDLDtUtIjYuPW8xMC0vXu3y4FcUhuuctPVkrd3q+SRhU7pYEPNDS9EeiTM4Ltxue
	zebMOs+SnusSMQAyc3/QlQ0hXRnfEFzVR9Sa793v5OYU2Fzk/AoCpgAg5/jyTxLS0ay9Jb2
	UwcMsj6SJk6TY8RFsjN5NJ+FOwjuKqFqoW3eLHxDD0DcBmwJ2HyKh9Mjx8N0Il4TioUorcg
	0vw6NYdE1zxB7Z/sZXKx9lnVNSHHepnig5mfDSlQa12zOpi5O9KYuYdl8FNChktP8Rb16c3
	Prd2sMU40URW//kevKOI4IaD+pyYry9XzJzipElPjH18ha28wE
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0

After the extent tree is transferred to the original inode,
ext4_journal_ensure_credits() can fail before tmp_inode is cleared. The
subsequent iput(tmp_inode) may then free the transferred tree.

Move the existing resets of tmp_inode's size, block count and checksum
seed before ext4_journal_ensure_credits(). This leaves the temporary inode
ready for eviction even if obtaining journal credits fails. Keep
ext4_ext_tree_init(), which marks the inode dirty, after the credits check.

Fixes: a413036791d0 ("ext4: Provide function to handle transaction restarts")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---

Notes:
    Changes in v2:
    - Move the existing i_size, i_blocks and i_csum_seed resets before
      ext4_journal_ensure_credits() instead of adding a conditional duplicate,
      as suggested by Jan Kara.
    
    v1: https://lore.kernel.org/all/20260930080241.414973-1-chenyichong@uniontech.com/

 fs/ext4/migrate.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 09931d3ba2c6..cf5239c42693 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -566,10 +566,6 @@ int ext4_ext_migrate(struct inode *inode)
 			free_ext_block(handle, tmp_inode);
 	}
 
-	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
-	retval = ext4_journal_ensure_credits(handle, 1, 0);
-	if (retval < 0)
-		goto out_stop;
 	/*
 	 * Mark the tmp_inode as of size zero
 	 */
@@ -586,6 +582,11 @@ int ext4_ext_migrate(struct inode *inode)
 	tmp_inode->i_blocks = 0;
 	EXT4_I(tmp_inode)->i_csum_seed = tmp_csum_seed;
 
+	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
+	retval = ext4_journal_ensure_credits(handle, 1, 0);
+	if (retval < 0)
+		goto out_stop;
+
 	/* Reset the extent details */
 	ext4_ext_tree_init(handle, tmp_inode);
 out_stop:

base-commit: 9a482184d910775cf648863148944945b74e2815
-- 
2.51.0


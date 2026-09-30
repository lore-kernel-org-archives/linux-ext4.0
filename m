Received: from bg1.exmail.qq.com (bg1.exmail.qq.com [114.132.73.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F43A3438A9;
	Wed, 30 Sep 2026 08:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.132.73.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790755461; cv=none; b=DOWOSNuSI4g5O0qNSCP45SA8Vb7puojf1+NdSZdTRz78ctVPYog0202vjNaCVwTfhqEHEItCVI94eMRRwknH7XMqp95OQ99rDt8W5hycCHmHrmfC4wHD0RPs6+PBgYjcHn0u3vgkV8s12UCva4ow+VXhCGYA1jXLcZEaSuO0XgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790755461; c=relaxed/simple;
	bh=oPT3tg2L6HmLsILUaRQtcWroKgIIt/TdhpZ7yEk7Uho=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=R3kS7QI1Rp0BvLt4ApJVQFRsYVTHdYX/atD2FLGoRHW88YtkWv4oOK9hUqtwNetxhG6xb0t9o9NDYY1oM0eoBniiocqZg4Y2EgqajfzssTkgmWwY3oAGful3bnGBKpkouU+r6QwhZK2GuQUtacwq8Gbenq02qfxZq2AkLYerh/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=DqeG1QQG; arc=none smtp.client-ip=114.132.73.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="DqeG1QQG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1790755385;
	bh=B1xaRJPj1w1p0V5KG4GDUYATKKaieqfDd6pMYauV7vg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=DqeG1QQGaHcvf1HKThqjcdp81HOJW/+lgMr42I6vvU20KDKXFGJcBKgploSmstNq0
	 Csfe/umtbwbp0N6Ywbtat/L2qV1lwKchwjcy1EOMD35oBCWUcjSyS9eKQDjWVh6ICq
	 to+1wnEAuDCmrXGBMNdDFKWFi1r9yuRMtX9nCZzs=
X-QQ-mid: zesmtpgz7t1790755366t5415e8df
X-QQ-Originating-IP: JsKWQKryqfAHbSkD8GCJzK/uJ5Jcb+q5d8aNCaXg+Oc=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 30 Sep 2026 16:02:44 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12572682429920885809
EX-QQ-RecipientCnt: 10
From: Yichong Chen <chenyichong@uniontech.com>
To: tytso@mit.edu,
	linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-kernel@vger.kernel.org,
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH] ext4: drop tmp inode ownership before migration cleanup
Date: Wed, 30 Sep 2026 16:02:41 +0800
Message-Id: <20260930080241.414973-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MgIyGr9KWTnBG3Rh32fDhinrJs1J9kMiPYpssQ+xlMeKGpSJ6k0plS09
	Z8ap2egc7QRTzBO/Rh0Eyn+xUr7Tu7L3KS9yBkYjvE7NGAJP7e9900JwPo1Nuj368FYZT18
	iPIkmLXiYNxgXX+SGeo7BSA0Ro2oMcb7H0hEG0ApAYPqcABTVDHCJRQ/lZmYQX6FrK4t0s/
	Whc6X8ME05OdCpguRRtn32XmqL9cQcC7/56AeOjuFHI1cy+hYGqxXG6abVv56gVkn2HRdvy
	zPZeCkodJiqQabUmU9zsnT3yE4RgWetM5hZAqc9B+8FI+oxokzALSwl4zJEPDjZgGY5OExa
	5XhRVycn2YCR31etq25R5IRpvmI8o77gjateEoZPqqZN2Zt0/v6iDEJlojM9fdjyGVppA8w
	NG1c3nFoF93I0UBsVbtmI57CT0dERUa+ZzSDD08OxQ57nXkUOmxxSLugfFXsTCyxapBBYR1
	5IlWbehDvaO1od8zTVXOBeKoccI+qh7gA24IRl+uBhdidJwA85rvZ+qTSnYh86BvTN3MH4K
	mYFq6Nq4Kxkg+JMQoDhiWjyc6S0YfeEgqukKa5EyOGJ7t0yU25vXAys2AghVOQiAAS6M6f9
	OvZHttM03Gp0Mc0L9Kns5DMvDP0bTiDEJ+frUKCIgktbO03QNoXLoKAfg4Ir6PYfZLEgwQG
	oZtbX9pbGcnEqj4TVKOb3wafXNpKTlgS6ZZ4t4CHPQVlZilA5HB973Ze+vYx3VhlhgKWhTr
	zOc2t8hM62Y6vCjyXwcS98mPrwArYgUZt3e65a4vGul3jZbQDbnaSj8dEiz7nMzZHVrTalM
	7ph8KnVoJ1aYFTVyVD2MwU3D4dFPINVgiVndVB2tX/xY6pBUXSDjYAEEiNVdNonw7e+gLus
	mNGdkyBXxVO9uBrSgXwc4WXGPw2s5ZT/6w6Me2xa2awyZrHoKy/b2884OGOm8wpDjhSZbWP
	UFFflO4BEwKXp6jjgwBJm/Q+UvTx4gjwp3wYXUx4KmRhe9wzPpQ1MsZSoDBh1KOmKxUuIHC
	Ir17S7O1ynJq0SsuzlJGPn5jsrcjE=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

After the extent tree is transferred to the original inode,
ext4_journal_ensure_credits() can fail before tmp_inode is cleared.  The
subsequent iput(tmp_inode) may then free the transferred tree.

Clear tmp_inode's size and block count as soon as ownership is transferred.

Fixes: a413036791d0 ("ext4: Provide function to handle transaction restarts")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
 fs/ext4/migrate.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index e588b4157604..11b3da396966 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -570,6 +570,12 @@ int ext4_ext_migrate(struct inode *inode)
 			free_ext_block(handle, tmp_inode);
 	}
 
+	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
+		i_size_write(tmp_inode, 0);
+		tmp_inode->i_blocks = 0;
+		EXT4_I(tmp_inode)->i_csum_seed = tmp_csum_seed;
+	}
+
 	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
 	err = ext4_journal_ensure_credits(handle, 1, 0);
 	if (err < 0) {
-- 
2.51.0


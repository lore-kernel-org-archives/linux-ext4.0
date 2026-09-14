Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DE83290C7;
	Mon, 14 Sep 2026 06:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.194.254.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789369078; cv=none; b=YySZtxHKbkU1uo6pDnv+o0lQhQd1mi1bYcNwBPJZoL7+Tj7SpWTgWCjF3W0YPJHLWpmyMJsxK+SuVNea9FZntYi3hE1xtzDVl4LOS/xF5/4Ds5YRmga3pfm/DvODzaZ5KVW6sF7J4WcSGa3zXC+tX7mRcT+VpKIFLa8OQb+ygVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789369078; c=relaxed/simple;
	bh=cE7HLX+YCBfj2HIFGPdVVmbWnE7TYB2eicReZHTWim8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=D3HWGx1hIlvDaXjtWc2q0feAgV74/3FTcktjVXulaYrG6wTMFCm/+fHaN5w8zCfdOtgpp5MFVwhIZviLtD0n0l/X5TeViqAbfq+YDD2FkvJS5LwSGfXy7VdUDc3Pj4swwEsk3dWWl7hbxBCoGzCQjiCyj6mKf+PG3VR6WtEUxAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=e4nn9din; arc=none smtp.client-ip=18.194.254.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="e4nn9din"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1789369005;
	bh=LIVL8L76t6KEPTcGTpEPKDpsGGvY+rr+QPSKuZ3S47E=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=e4nn9dinSZAPTIIaOk+HD0sAxthyzy9pakrgHJfDCKP1WhJwdDk7TaoFzP2WROk3M
	 C6u0v2WuyiVBLOnjLWeVD6S2w9hWV075y465gjSR86p+fp15BmWrick6Rxy7hk0dJk
	 Vww3YhRdG32SjScsofT7JHu2OyX4IzyJ7Wv4GLuY=
X-QQ-mid: esmtpgz10t1789368987tc3938474
X-QQ-Originating-IP: oa/POHotl25pRRqxZDjcxefat9hRezoAQFHWYo8D1aA=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 14 Sep 2026 14:55:47 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9193533759185836638
EX-QQ-RecipientCnt: 11
From: Yichong Chen <chenyichong@uniontech.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH] ext4: fix the logical block counter overflow in indirect migration
Date: Mon, 14 Sep 2026 14:55:44 +0800
Message-Id: <20260914065544.3438431-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MfQnJH+7WKv6drDog6dbw8OMcEYzBjol7oM3AVxXW59Tzq/zKgrcnk7G
	xqoBRHDC88Qo3DzarVgCnBEH7GHaGtmiU6gIIV03S3AgXAyK6SgUkBHi/C7OyikOf5aCUFf
	5gWRkwicgu+wh2Q9Unh8KjZK8icy5Vzo31A2PomiIAxJTsoYSEKcdSeb3UQOknBynAqN8n7
	xOG8DOGTb0hwAuaEfify3DAsuE6SoQn5qqC+j8lOt6+B1p9EatKnfOiJ5qv3O3AZnvET4lO
	p5zD5lUTlXNPH6fqI/H8XXoIh7JUzBBM82rsiXu0ic9Ph1YubMk6Uzxs1zg6ip4Sd2DL4ZU
	QwZk1GN2RrgaCmdjgxCc45HvHA+G59eGj6lXDX785dEmSWH0juxiOVzgc8oUT57igk/+/MM
	bHwmNX5Vwtz9i4b/rokZSkd7wuzX0wBG/fYKybNzCNXzI9WCYcQXswTiUk2NsJGt0yel1w0
	OBrD0ysVHHkNxZcs88H5XSIh32QIxPM9cxInCD/8691mRRgIAaqJec0Ms+e9bryxlBcclF2
	ZyOa7kF+Q4AtXoXgg+wy/aexar+XBNwej4Q9HuZDPle804R5yf4XiEV4XnCQUiCI/SQrwS5
	zRiu7LRxD+vZ7xK5q+Cq19TSzKBJkrXAynVSgUyB+miQLaFumeaySlf5+KdcZRrouYdiDBr
	T5oMI+lrzfIt6utfLKh8fGSzWFMKQ3MNLGSbFsT0u/M9zN+JJzTkyVRogcYnWfh0PnlXTgA
	2PgzMF1C890NcJedt65Tcglx7NkzLYe1NnNeq0vXpos/orzJXU/LYB83fXRs8/NFkCOmSyM
	6pIb/nC7klHCZbL5vTk18TC5E3WVemhwfGmqqd5jukt/Z/Xz1SJq1ZX0+31ZYoytwNwSCMo
	Qk3Kh2ekvO4W5z2HBPk4PBRUn3D1NhZ0TwecSYKkDc9cfkDkgvki3+I0LASewPTiqGvhB6D
	7rOIwW6A2jNEsfmAfJ1JWWs0j8xxzJdHIXcUu1KN95v21lIqUl06VfWk5iwQj/hRS4wkbk/
	Cr4lPxYg==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0

update_tind_extent_range() advances lb->curr_block, an ext4_lblk_t, by
max_entries * max_entries for every empty triple-indirect slot.  One
triple-indirect block spans max_entries^3 logical blocks, which exceeds
2^32 as soon as the block size is 8K or larger (16384^3 = 2^42 with 64K
blocks), so the counter wraps while that block is walked.

A wrapped counter makes the migration store a block number that is 2^32
blocks away from the one the pointer block describes.  Two ranges can then
end up with the same ee_block, which trips
BUG_ON(newext->ee_block == nearex->ee_block) in ext4_ext_insert_extent(),
and without that collision the data is still moved to the wrong logical
block while the migration reports success.

Keep the counter in 64 bit so that it cannot wrap, and refuse the
migration with -EOPNOTSUPP when a data block is found after the last
logical block an extent can describe, which only a corrupt block map can
contain.

Fixes: c14c6fd5c56a ("ext4: Add EXT4_IOC_MIGRATE ioctl")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
 fs/ext4/migrate.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index e06d847033a1..8043959c19ef 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -14,7 +14,7 @@
  * represented by a single extent
  */
 struct migrate_struct {
-	ext4_lblk_t first_block, last_block, curr_block;
+	u64 first_block, last_block, curr_block;
 	ext4_fsblk_t first_pblock, last_pblock;
 };
 
@@ -65,6 +65,10 @@ static int update_extent_range(handle_t *handle, struct inode *inode,
 			       ext4_fsblk_t pblock, struct migrate_struct *lb)
 {
 	int retval;
+
+	if (lb->curr_block > (ext4_lblk_t)-1)
+		return -EOPNOTSUPP;
+
 	/*
 	 * See if we can add on to the existing range (if it exists)
 	 */
-- 
2.51.0


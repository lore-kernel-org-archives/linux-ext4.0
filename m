Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1056F379C5A;
	Thu, 10 Sep 2026 03:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789011687; cv=none; b=hiM9SZa75LcQJ7ToZf7IGINcnK2kt6JUadbkdQ8mWTe5pqTEEdOAhi9HgcxL0f6yGR/novKscGLXXYn2vj5LS/MSRPEZ6cdqorGM0lT+2TV3B51riQPh5LLcpLPKBLiipz6C0VPCsbQ0cjvDbH+PHsYb7ZlSGo52wHEoa+zCmkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789011687; c=relaxed/simple;
	bh=2mQEncX5mEvfF8xcMEnMNL/HXIXXtcb6KdhKlxg3syo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rX/nig3k1U1e8QRaxasNj5vu+2Q4fId+HJDM+ifUGhl/eAM3xh0Ni66jXz52vhd01ZToXNZUcTqojnrZlLAixR3W0o7n9aWhYxAzeZC+J1ihOKE9bq5DPmL3Cljk1sv14M9JMJJSK9A1IAXhKiIkAgG/ijk7tnKrZ+im2wbQxi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=CiJflB7j; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="CiJflB7j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1789011622;
	bh=z8JyDZCkB9yRCbmVxWvH4HBGdOjOAyTA/+kpwSquw6s=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=CiJflB7jR/6Bu4iVKFBL+u1zWGZ4o0GHadn7Xv5VCdcscc36cui6adY4wHeqs1EJl
	 O50qY1GoC1br0/cONYWmzjtHxCX8WNvo54Gx9/11yh+GbIv/I7Tkw0oPNfYzHs3G5y
	 i/dojp8/Ymh24/uyOF1qMUs1jlFv+aRpd79M/KHU=
X-QQ-mid: zesmtpgz7t1789011605te093690f
X-QQ-Originating-IP: kT3WBqvApPGH7fUNfiXzIRokNUnVZgwbkGTasXqZ1Cs=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 10 Sep 2026 11:40:03 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13685970796220708092
EX-QQ-RecipientCnt: 11
From: Yichong Chen <chenyichong@uniontech.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	aneesh.kumar@linux.vnet.ibm.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH] ext4: cap migration extent length at EXT_INIT_MAX_LEN
Date: Thu, 10 Sep 2026 11:40:00 +0800
Message-Id: <20260910034000.3155420-1-chenyichong@uniontech.com>
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
X-QQ-XMAILINFO: MDN2VRNR2P4wXuzwOC4l+PoIt0eS6qPg3JCl/HFa1SHFWkYmVd7MkkAQ
	NsfGTlQxnwzHcOKEz4Pjr+YKTwx80LYy+Z14EOoHJ3xtHOjVdW2GC2RC60hG18TV+wXQXHH
	t6z87yM8GhhB4r2Re1Z55ls58kLNhIPbrrZSCds8WPv6iBzQVeDB4faJDjZNVn781nBrtdI
	hvzFcUVMUH/fk/we86KX6aXjqBbGunb95i3bH5N78W/UwOyOB8w1S4hdgBUgNkxPWob6N9A
	fMJUa0UH4QH92vOTtisG0Fk0qLKKYjDY2rD7Ga+vDa83hYMDmluNTVt0V7lWkRvOP872L4b
	PXarsC/ag+sy7937fx7eQwrQXzKqEvRiZEB65QSoChisEUHN1gp6cXGrLhLovm68belmmII
	ZG7AjaXiY8DO2LgDohRlQhzW3LWoM/Rgspa/SaB6ulCth799MQSw/FKG7jWIHg2wkPH7l5p
	llUlXM+Cv1yMAxxmE5hMgXfxel8hI9geTh17n8EAcH6Hsadv6GHooIcV2fkc7jnpzrFfFCt
	L69eG6Hqmbk2PST5LQ6SCgiZ9xDrPnQY0iX4qjg7jucS64/U9PUohc8q73+gY40c2tw2cw2
	UWChXU01Inf/V8JtEX10twnf5tP/oSTxKqdqFY6IaeZRENfMRgeMf6OrNZIrMZiH/XlR47K
	VYE06KXjeb0cEp0uEagvV4+G/PIMiDKzA58Z0eZzNmN/a1BfwO8tGeBYt5/Umy2qgWvLf+j
	gV5COJUjbE5WYwJovK1f9eY6S8I2zixB3lmYvD2S4evIohqCEEyYqwXZuieNuxzBlEWK5ye
	ma27J+tMQpeK7Qa1HsAWLVjuhY2Xk14CppaGGdwAe4e7HgRi5nR8KXUdwfvkzeM65XNze0d
	xXpjc0Ti8RZpWfYS2JyajmGYLdmTc/zxOrctbSkqUTWaqOkbFqbaaTsyAUQD84oDfONpA8e
	pBdyfbxt0zMMVSw7M0EjUaNgLcwwt74x7pCKH3DJkWKqp2F0sTmP6UBfMTnGOgxonaAtnTg
	aF140rJjgR0AnoKA6N
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

update_extent_range() keeps merging physically and logically contiguous
blocks without limiting the accumulated range.  The maximum length of an
initialized extent is EXT_INIT_MAX_LEN, because the MSB of the 16-bit
ee_len field is used to mark unwritten extents.

finish_range() can therefore store a range longer than EXT_INIT_MAX_LEN
in ee_len.  A range of 32769 blocks is stored as 0x8001, which
ext4_ext_is_unwritten() treats as an unwritten extent and
ext4_ext_get_actual_len() reports as 1 block, so the migrated file
silently loses its data.

Stop merging once the accumulated range reaches EXT_INIT_MAX_LEN, so
migration creates several valid extents instead.

Fixes: c14c6fd5c56a ("ext4: Add EXT4_IOC_MIGRATE ioctl")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
 fs/ext4/migrate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index d467b5a13c62..2aa6572088cf 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -70,7 +70,8 @@ static int update_extent_range(handle_t *handle, struct inode *inode,
 	 */
 	if (lb->first_pblock &&
 		(lb->last_pblock+1 == pblock) &&
-		(lb->last_block+1 == lb->curr_block)) {
+		(lb->last_block+1 == lb->curr_block) &&
+		(lb->last_block - lb->first_block + 1 < EXT_INIT_MAX_LEN)) {
 		lb->last_pblock = pblock;
 		lb->last_block = lb->curr_block;
 		lb->curr_block++;
-- 
2.51.0


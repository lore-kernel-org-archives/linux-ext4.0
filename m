Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF683E51D3;
	Mon, 14 Sep 2026 08:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789374396; cv=none; b=uI6onVxHU596eoE05ZgfMg0zkCxXk7EPIUPk4RMQCLFYUOXc+fqA4QqWVDFu37D12oV9lOVc+wXb9NfiOea9rPAvb1XAZ61+C3ZPb/zugH3DOXkaXxe86gYVAQDPKR7uzh7+cSd3/swWXtSCHja2gNOUA7aQFrxfGLNSlsdcCkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789374396; c=relaxed/simple;
	bh=bfGGieevK8ATka05Zoy4EA3P1XwdTQV2N9bC1G4l3fc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hdb+D60DVwbjEbuanRixsjYTK0nuWxHUoCZXePPPjlD8aIrdsBZrtBkshThb/nm5TkidEBrD/pZ2dldVWcvkK9PFrxWvo827J2OyOyA0NuKNW/jKzSBlDpVQxXpGpuYVqSiFCaA3iWdyS0Jau2jRx6nZclRqwViVjCaxFT5dbUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=fIk5KZ26; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="fIk5KZ26"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1789374338;
	bh=lI+nbrj8btjozV4VFDmdnG9LP3UULfDKR3KDqhgqIQo=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=fIk5KZ26Tc8sHQKhz+d4N3LC1TViKCgIk+It2xYHE2nKYIzyMQYbvd9imBE3dOTVL
	 13z2EX2gE2okvgCV0fSOIzmND8crR7wFXa7/l2YXI/AmhnMfOMlkrl5U14Eq2vzb3X
	 yb+cS4w3KVI/demcx2FrE1O7mPrgceQNBUUd5E/s=
X-QQ-mid: zesmtpgz4t1789374320t50419108
X-QQ-Originating-IP: QXHOB8GnYnT3dKcfnjvuy96HE1U+5Q1QtFjRuAg7tWU=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 14 Sep 2026 16:25:18 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 1740976292682735913
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
Subject: [PATCH v2] ext4: fix the logical block counter overflow in indirect migration
Date: Mon, 14 Sep 2026 16:25:16 +0800
Message-Id: <20260914082516.3442815-1-chenyichong@uniontech.com>
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
X-QQ-XMAILINFO: N6yLXQa++l1YBShACHmAv3Nm3zE9u85NZ0h0x9q/56zCO7KFLvQ89IpJ
	aO9hv2y6XUhjBroWKVb/S6YrelkqK2zijKrFry6GVkwqtz8Pf6cuDUHemj/2AOaJf2g2jar
	p8THaoft2P4bj7QXJ0GExKufhPth6hO4WGqJtWOSbRSOYRo8jL/CRoQ2y2eG89Q/lhsTbMn
	OM0LvQe2NQgCguSSP5TaUro+nVGSSr7SQxeZoqDhfWrMpWtsTiE/YJO5gyhBLVGuXVm2gEZ
	xbx6dIuu2OU7D/6izr8pBl52UV28lojgB63trQUYJsUxRhD/yGW2uFfPjHvrC2sSVW8hEd4
	SYRlZoJP4Z5wEzwCoAuxlSpmBstbGLnyZ8lLMUdp2nvL0ljUc6GQqiELuJXRLjMsSDzNVwe
	42Fgz+u1bzZpS3np0hn8epYNJVbpOZSOJpt3fUUylbEb1BBBrQ5sFLcs5QFFIDa84AclEBW
	5JE8JQ2ospVZuaUtc6wsSS34r8P3MEfJ09q/2DlI88p4+bWKtNmOgtBmtmOZBkfCNj5gOoh
	ivBulp67t9sNACFE9XpO/tIGpTTH+g6c5Vjp7+LFhLVQNwwo1fBzBdP2O+U/SclTCLMkY9Z
	Izin94miZ/V23CVLMVSFWHvEOhdxxEefRiI+WmPnnqZnfY13MLMXeJmAVUjqYMZDnoXLYAz
	aWEeSA86TUJJ9Nd5CQo8CJVHRsXM3mRKGI/UUCfl/8vLldno38T9F5fYJ8uknsdE0RjTsU3
	7fZWKlcz9Kzqefdy0LnurAt6oylYISSXt3fBYTAqRNnTxTRi/z+c+0ww2a8aR9f+/4i8th9
	cY2JfJRly7xWx8KbAixf9nDvytyouw7QO2vCr9wXUoMBGiZ7lljLS0WfDtiEV3cGKalpUYB
	CJP/tr7SzPqM1fj/dBU4WB7hLlVKUbMFOCkrbBAmq7O/HkwItEyUA2XEiobVObhCoidPLis
	yY6yXhDKBllPt9xONlFcz2OX8qYRtZil5++bzOfJBY7CCMdeO/Pafm2bTe7cKk6dkXamNxP
	U43CeW8J+WDaVPDNLgemxhhClGukhVwYwgGbpPzMQjIYsGjiGt0QfyBdEqE9kG1PGZ2p90H
	WcC9zVeLG4OjDvBv7sjOZgob4hZuq2vgpcv+CTd1VGUZP7DQlpcWuo=
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
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
migration with -EOPNOTSUPP once a data block would land on EXT_MAX_BLOCKS
or beyond: an extent may not cover that block, because
ext4_valid_extent() rejects a wrapping ee_block + ee_len, and only a
corrupt block map has data there.

Fixes: c14c6fd5c56a ("ext4: Add EXT4_IOC_MIGRATE ioctl")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---

Notes:
    v2: refuse EXT_MAX_BLOCKS (0xffffffff) as well, so the bound is >= instead
        of >.  An extent may not cover that block: ext4_valid_extent() rejects a
        wrapping ee_block + ee_len, so storing it would leave the migrated inode
        corrupt.

 fs/ext4/migrate.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index e06d847033a1..2ce587043945 100644
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
+	if (lb->curr_block >= EXT_MAX_BLOCKS)
+		return -EOPNOTSUPP;
+
 	/*
 	 * See if we can add on to the existing range (if it exists)
 	 */
-- 
2.51.0


Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EB033C536;
	Thu, 10 Sep 2026 05:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789018264; cv=none; b=W/GTPjfSjakwfaasbINkib7dAFYwr+4e1muGccLx/TK9wx4IFibYuZifHTnz2sWBFo+Mao8LyT4qo9+PSZBkgDFedQudH9IiN7VRVNjoLPWY831ZvhOdvlJV2uCsNOhLdc465nqyYkQfuzp8J9+npliEL9hZXLRRnIomeaWynRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789018264; c=relaxed/simple;
	bh=75mvSAFdsdN2VwGCfUVY35/23tifmMlYF25CdhbxYfA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ftGMWLiX4uHLy86VNXQHc3CPIVXYx3Gp7mjYTaKGkSfn71DOSyrpQeyWEwfEIeIsvpafhRBFDsiO0O4e24AmIPgT/2N1Auxw1guA5RjLX6yGi9scUAzAd1Eo57KtEqre4zlhqSderRDVotynlbj7qo9qa3fzc7nDHtaNTZICxv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=kxeK9VkK; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="kxeK9VkK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1789018194;
	bh=svEBC4EG5k4KB2FCFKcCYTwFYotu1s3CZ0kjOWtCXpU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=kxeK9VkKEI1uLz1Zh/oTZX3GvtoDnM2iA1BB992DEmCd4O6GlEXKhq6wbTt21kh5Q
	 T08M+f2zwxhxq2Ljvx+rZS0INjXiym3A60dp5ATOXtQxFN3ga/7q9vd981ZqH1L26G
	 n3Z/RfomKL6BlpYPPV3GRaXCzSohpNwsuRILjqAc=
X-QQ-mid: esmtpgz14t1789018177ta955758f
X-QQ-Originating-IP: MMkSWADVeY04QfnHvuz00WxiF7H71qwD3cHlVqdW1TQ=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 10 Sep 2026 13:29:35 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6232899006786362079
EX-QQ-RecipientCnt: 10
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
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH] ext4: don't clobber the migration error in ext4_ext_migrate()
Date: Thu, 10 Sep 2026 13:29:27 +0800
Message-Id: <20260910052927.3161092-1-chenyichong@uniontech.com>
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
X-QQ-XMAILINFO: MAN6sKHDZ5xShbcORIDeiCLYjcWJvjrLDoPUAAyTdTuEBi/8nYgwq1qB
	zqIHkljtXn8a7PakYmvRyhw6nAaJfLcvCBk+2VHxfEK+FTtuSOiuKY401GhqVbZUgX5oFHE
	gJC0frp5AjfZVWRTI7zepw6Kabgy/geGALheaul+Vtg/n3Wk9kCTgl/BllKsbK6n/kQQSYW
	4ewm1ZBdi2Sd4DPQBgZm9hW0fxuDm/k/TM3xJbBZDHk4YY5GpyNEoNkS1DcolooqyUgwHKx
	anKz0BYJ3cOsQOx+r39F4OMq5pfChZc+flGFV9mZ/Krirg2b/sXRhtUzqJ4xkwibURZjk0x
	2a4vI+94I4R59jTqjD8XvbFF88kSEFicW8u5s7kyhS75ev9lYTQ3em9DHemNpEsrn2WOmG0
	4Y4VNSqrEeIYM1JaY7oGAOrSdOierQLs/0INoY+39T6/+wETvMaLiHm6YvfExZU8W05jQpR
	OPF+1AdC2hij5ahcVbS51nPUMyT3xjt/byde5XuzSuoJTeDBf25ORu0aRqb9/1ijuBC7l22
	5MU/Xo8hMEzZ2eTQStd79Z/j7paQj05RdMD6WGhE1ZYEARY8rseb1Bpw9I7JsKXK8UvIles
	M14AYQ81QGYyRGR9fqOORqMlTZePgzEwGNDI8CForODCIXWUeATJymvCBOZTOxA3tC97SKh
	Hm2Ix7Szl/HBqEecYHymrf0WEUEan2o2JrMqkhVlUl3zPuLB80PHPIvNlOtuu6neyzjLMzS
	Sg8Jo6z9ITah5JnA34rzH0035o61mAdqX3mp1e7mhK8EpY38Xj6nYuUZa89/5ixPJuVbWFO
	xw5XkJtZOqm0E5SdyudXkd7KG8yLQ0kNHS8/aIfjLZO4RkK5I1tEVJQgbqpvp3wWiA6vuOr
	PiuO7bvxNcrn7qwRP6eC6fOMqnYFLJVhieyC9KWOh1e9obqjDDeyQXgy8c/wWCYHOaICFVk
	QOTxG4e05hl1oHz4nnKaQPe7zsSaolpHwln+XUO5JkIPG2BzSD+BNkIkPYhKKbed4r0E/iX
	7PL4YMV6O5VBdQZEygTmsVFleqp2T11Dw7JOoBLfA183f+nEWI
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0

ext4_ext_migrate() records the failure of the migration in retval, but
ext4_journal_ensure_credits() overwrites it: it returns 0 when the handle
has enough credits or the transaction could be extended, and 1 when the
transaction had to be restarted.  A failed migration is therefore
reported as success, and a restart leaks the internal value 1 to
userspace through EXT4_IOC_MIGRATE and FS_IOC_SETFLAGS.

Fixes: a413036791d0 ("ext4: Provide function to handle transaction restarts")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
 fs/ext4/migrate.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 2aa6572088cf..e06d847033a1 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -410,7 +410,7 @@ static int free_ext_block(handle_t *handle, struct inode *inode)
 int ext4_ext_migrate(struct inode *inode)
 {
 	handle_t *handle;
-	int retval = 0, i;
+	int retval = 0, err, i;
 	__le32 *i_data;
 	struct ext4_inode_info *ei;
 	struct inode *tmp_inode = NULL;
@@ -567,9 +567,12 @@ int ext4_ext_migrate(struct inode *inode)
 	}
 
 	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
-	retval = ext4_journal_ensure_credits(handle, 1, 0);
-	if (retval < 0)
+	err = ext4_journal_ensure_credits(handle, 1, 0);
+	if (err < 0) {
+		if (!retval)
+			retval = err;
 		goto out_stop;
+	}
 	/*
 	 * Mark the tmp_inode as of size zero
 	 */
-- 
2.51.0


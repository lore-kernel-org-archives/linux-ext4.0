Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CDF3563E1;
	Wed,  9 Sep 2026 03:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788925027; cv=none; b=Vq/lejfvcqYuVVH/sxBSBpNBEXga3dc26bU0RYq2uNH8FDmyYz7dkZlwTcKAcE76C/ikSdQOD9MaA2O4WuUI3Qv+5VljrVRjUDLnsoDT+5wBlHbitYHIeGNfiQIdwAOrKXynXSqjqe4493Ro4O3Bp4FRxnkjD0XOiuwLulOivtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788925027; c=relaxed/simple;
	bh=Qd1XgArg2q+m7K/L/jpwsQwWH0hMl/cvrWWrUCs0GzY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=j6TDzcIGZPWXPb7SqQfoFQM4OTkefn9FaB3JaMJK7P0/DZNrRpJKpPRfh5Ppd0uxtYjRMK1pj8uZWKs+n2Ve7yvZmcXAycJvNHG57wY0s7jB78+f2M+jLgu62303kXk5DZf1JnvNz7/ftAj56LEgl3txWC/t3jp1Ixz6/Wy9Ekk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=ETNc5U+Q; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="ETNc5U+Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1788924965;
	bh=xXRf0SUBV3suWoM0NzxTLIfVE6eSGflDShrfnAnxvT4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=ETNc5U+QCXv9fcNzyRhUVKnWlKohowejNyViGdLn40TD+c4kITK/XgxmDEK4cc3D5
	 fuNLvXcN05ihc4Lkg32uy7jK5lOrOtBssn2OEz6cptVzvRcmFZHxBmFZ2qwWu/ojYY
	 heVNS2B4Cbe7Yef5INZegAMhvJjZjtTduvp3GphQ=
X-QQ-mid: esmtpsz17t1788924947t863e0c09
X-QQ-Originating-IP: gMXocejGpJ2GJABfXFf8kOt/4JEgASBRhiAgAOtWxxU=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 09 Sep 2026 11:35:44 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16255912553971824354
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
Subject: [PATCH] ext4: clear journal restart indication after inserting extent
Date: Wed,  9 Sep 2026 11:35:42 +0800
Message-Id: <20260909033542.3087876-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: Nb1VDHjJrCDX4GR0sMoYT5NnIG5Z3SY+kHzCKAmZt39Pcxlu5Ducstrr
	kzsLHa4rhqscPxkMz9XIr8tSaK4XpBrGeYOa8m0+aTRFnkIEJVptOlWs45Hj1fxVNz6VbUt
	Zhb20QBdYzrGJatMnBw9Wqrzw2ino4TrRNGmMCS/L6yF0J5bObxGh7oxQ6vutuNnO+9IrfS
	B9CKsmkMlL/t4jLofdC5vUOFf/BfAed//I/oUFpxYPKMnGqLBZA7IIeTxOICO0MokNF+arV
	eZ8kmx3kjLqX9Q646vUW12TnryVaHGl5hAeABGm+viSY84pGeqoDFYCOKm0pxy2E/BRGboF
	GggTHZzgfCfp4Rcerxh0v2N3Rx5P0gKaEz68ny29rXOrTu3FwUd9MV2y4hVjU1J0eTuXgTf
	JTkzhmgyFngzdQVkwBWNUuUnzOdjecehXwU3yPbXtMC5k0LimSnP9SvIdcG3ufz8UczXj2n
	Dd+Kc+zJnctZYUzv/nOTHgPLsh+WEkbtLjY5JeYXmwpZQ+mwjre/PvOOkWYwKelo4lf7nhJ
	TQsr0yAgnLEXwtM0NTLFYxdSE0DSpZo1vqPL9yzy7h7sY9oqK6xpVwAIqzo42SWhQsPKQoa
	YMA+ulDtDkBp1TA2JBSOobhAmwLx8POLKju/0puIR3M8IeBLXgzQq3H1ibqj3MDc6Jc0mjP
	QsyKt7tTFncsQShllZU3WOdZWyf2kZo4qSN1d4dCZnEuv6OYv2rSZfR1bk/0g5ODOyUtwY2
	nMBUUd/+6t0pj3n0t6gVY2JCAhbTHngFAIe+zwvdVAhlN8ruitMgz96x8OpV80DuK/IKirw
	SfvmdiKG8opFh7Q0lTpDOUaji2kwyA4PpzolHxtEyqfFaMP1M+8OzFvgMWB3mugMQ7WGqdH
	uD+qNRp7rrr/3TUFizbP19fq6ar8PLguFGncW6QvZf6y2NMW99rjVW5/PcxneQE5rl3qO/1
	K12snMrd1z/J1xJI4VaoGvfBQnQZNEPjSQ6Oki9uUBKwAzPeIJlLjt9Qy2H29AfAESbM7bO
	QOWknAjHRu4zPUOmEg
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

ext4_datasem_ensure_credits() returns 1 when it successfully restarts
the transaction. finish_range() leaves that value in retval when the
subsequent ext4_ext_insert_extent() succeeds. Its callers interpret any
nonzero return as a migration failure, so they stop building the extent
tree and take the cleanup path instead of completing the migration.

Before ext4_ext_insert_extent() was changed to return a path, its integer
return value overwrote the restart indication. Restore that behavior with
PTR_ERR_OR_ZERO(), preserving insertion errors and returning zero on
success.

Fixes: f7d1331f16a8 ("ext4: get rid of ppath in ext4_ext_insert_extent()")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
 fs/ext4/migrate.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 5d60ef10fe11..d467b5a13c62 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -53,8 +53,7 @@ static int finish_range(handle_t *handle, struct inode *inode,
 	if (retval < 0)
 		goto err_out;
 	path = ext4_ext_insert_extent(handle, inode, path, &newext, 0);
-	if (IS_ERR(path))
-		retval = PTR_ERR(path);
+	retval = PTR_ERR_OR_ZERO(path);
 err_out:
 	up_write((&EXT4_I(inode)->i_data_sem));
 	ext4_free_ext_path(path);
-- 
2.51.0


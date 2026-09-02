Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B548D353A69;
	Wed,  2 Sep 2026 01:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788312870; cv=none; b=CTJpQ7hf7CbUpbm21rtB350npODru7KKBcpKJXrtuDTPx2QJ18jjQoodFc4gnJv//0voBDLGKX9kSMVyrImK3pc1/QsImzw4K2+jbIP3pAcj+CWQ/0uNh0MEsdwxqBYV3RSQNYQNOEzj6Ut84SDuTEDjH+tihK0SNmgq5ezXTcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788312870; c=relaxed/simple;
	bh=RoAnNi1LaWFXzkf5ttVSCCM5YF3rejo06VWhnYO9l30=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YC2ncmeKnCQjNdtk8g/34iIWh3iCjdXOuS11+I1VhqcArqxpQStvyC/jVNzofzaKCepXzUkJaosLV3BTX020UpJNAhLn55rbREkTjH7FZ4Wn1Ab3QBVx9+2TamSnHy/BaMCNBTCGT4eMiBhDLb4RDpCEuqWyl0wDge4Qi+Wsz24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Lyrs7mXh; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Lyrs7mXh"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788312856; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=BgLxNhyI91gbmnPap7rNB2Wq15wMhEpgxMeRIeIytd0=;
	b=Lyrs7mXhJIO5v665TkMuBU57qMlvnUwi9+cDjn3oZZsfva8rtU8p2zKdetGu6Y4gFLtkZW4MFWwd5Md2BJoUTCLszHAwmQrlabM0YghRTMHMi52CMA+Kqvi24kR44GukxYO7PfKjYUPisUPJeqbHJ02FnbzFkDoFM6C7wXkKvM8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XAAdAJF_1788312855;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XAAdAJF_1788312855 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 02 Sep 2026 09:34:16 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Srikanth Aithal <Srikanth.Aithal@amd.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH] buffer: fix NULL dereference of bh->b_folio in __bh_submit()
Date: Wed,  2 Sep 2026 09:33:57 +0800
Message-Id: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
writeback") added an unconditional folio_test_dropbehind(bh->b_folio) in
__bh_submit().  But jbd2 shadow buffers have a NULL b_folio since commit
5febcba29792 ("jbd2: point the shadow buffer at the frozen data
directly") made them point b_data at the kmalloced frozen data rather
than a folio.  Submitting such a buffer during journal commit oopses:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:__bh_submit.constprop.0+0x87/0x120
  Call Trace:
   jbd2_journal_commit_transaction+0x932/0x1b10
   kjournald2+0xb2/0x250

Hit by the ocfs2-testsuite fill_verify_holes test running with
data=writeback.

Dropbehind only applies to buffers backed by a folio, so skip the check
when b_folio is NULL.

Fixes: 5febcba29792 ("jbd2: point the shadow buffer at the frozen data directly")
Tested-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sm7225-fairphone-fp4
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/buffer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 427d8a817cd5..f46fa6413032 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1106,7 +1106,8 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
 
 	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
 
-	if (folio_test_dropbehind(bh->b_folio) && op_is_write(opf))
+	if (bh->b_folio && folio_test_dropbehind(bh->b_folio) &&
+	    op_is_write(opf))
 		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
 
 	if (IS_ENABLED(CONFIG_FS_ENCRYPTION))
-- 
2.39.3


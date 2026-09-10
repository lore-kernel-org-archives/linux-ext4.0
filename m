Received: from out203-205-221-233.mail.qq.com (out203-205-221-233.mail.qq.com [203.205.221.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69C1377553
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2026 03:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789010811; cv=none; b=Wc5eDYUZ/vW6UfEq/ogYAYSHdryrrtRUT0eoAlPpTklsENIWM6DTd1QO1pJsdVDEFFooTfy5YXce8XdzvHOjpxIamDqzRkYKg5eykcgU/i2s5qfcpxKygyljajZGFH67ap2SnN+qjvde0n0XORrAbXGLvkGN3hR0JLfMXaiFKT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789010811; c=relaxed/simple;
	bh=5AboohLiXieYcXp2rF9pp0zytjmpcHLrJvUZJI0XhtE=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=ijPwiAkccdsCnOcHL21uUSrzJ46d4bpJ+O5D+siish6jIlMtF7kCbBUqS/ZL6FubA2GjpRFesujVcX7mAIJaALCdPfswFcb/aAwG/OWf4DiT6E0uHqr9uJ0MCXOfGHti4PDwdMevrdpzN5oIyusLJw5+zVyhF51ZO9s4152BFKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=rTzaomuq; arc=none smtp.client-ip=203.205.221.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="rTzaomuq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1789010800; bh=b1/fdYpvVIN08u2xuNqvurWos97yyjIiONFSrW/8bH4=;
	h=From:To:Cc:Subject:Date;
	b=rTzaomuqdG0bkB4krS3Y71z1xs0rX13Iw8LQtJ8B9i4d5ErQ2jezEcH0D4Wtb+09u
	 9K/1WrI5cm9IlEBWa0b4i6+XVSNzjsMwWv/3ljfYX8jyKoJybbA+87kzUODllermkH
	 cw1NeMTDjwYZXxJiH43WgTZTJ7ANF9Ee78C/+XTc=
Received: from DESKTOP-AT5F202.lan ([183.242.101.176])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 6A49EAAD; Thu, 10 Sep 2026 11:26:36 +0800
X-QQ-mid: xmsmtpt1789010796tqmexerrj
Message-ID: <tencent_0EDE840F0C8186D030DEAF5A95B8BE54350A@qq.com>
X-QQ-XMAILINFO: MTEKjEyAppcsNoRNQaSPkIDm8GrrLl9mT+HR0Ay2p5UidjSGG6B6WMAzmwmnkb
	 r1G0bMB4H3UB9wpu6gHsSC5IFvSeuxA7JaKRxqosD+k/dKlbSYl3bSOI2oLKDJg3C/auzCAaHHpu
	 ifkfCcktY+eTvlunJ8GpORfxdQ2+v0GRi4nNvp7n2Pf0/Pc5x+SW1xFGmGZTBeFgzpWEO0QhDyWg
	 w3HQCqAXoI3F/LfLlYhxiPMOb1XJSRi9fjrNTuNAgeBMI+V5oQWZqzf5syRzYvpABhepbtNzlyjM
	 pl0sajvMsgeoKEI72w2UGb3hWAIEIBEkixZkOUNm1oninwoJYPzghBRFLaKVimGcUlaFteNns47M
	 VZYXlu6zmAu7bDBjxSXgDmJ4zSA4Hjg8aJSg1hrXpaY+6DBjeB7MVuvvH/QS6wWq64kbySYmDNuR
	 Hxe3cLplFsbCmz6R3IUoEpR9y8H1atFT01lI404N4XkhLd7iD0LMczCYFjFi0iEk2gv4T+YPLRAv
	 Q5CtOWzT44z/gllSkOzZKS6VBi7gUcUeX2il9GKC79Bu4f9ROxhHscxdYhvd7b4DGFZ8nsS1bXOZ
	 L3gUejasD7ky83i0fm5GNtcC3aUDUm/oG3lgzxak9YTdyAnu3Ttft7CdAShDgVDppUpkXZqh2fA/
	 7WbwNynvLpCnq4TfFem1erKgxS85VHTh/yAGdtH8SFZLjs89KbwJzjaPGVf6oC6WjVUPA1rttamB
	 PvwOF1e5uKv95+5FBG97bja2EJzx1oQt5DAKm+xR+NMtX1B1Bc1v5B/8Nq3Yn3EFmxD6RjRX9GVW
	 SXPghe+vdOmM+i9QuHbDOidg7qbma/RM5zRODsJOrSQzux5ZDTRPn7DRcx2FuGNlH/pB5pjChwKY
	 ERCd3w4Pbboz/23Qo9650eDF7UFZFVqnk8SLRx00J5vrn4Av7RfHv2MdeGPKKcbOwKbhk0f1yRBe
	 JV1X5DZmgIPxWiXbdqit7s4unTO2e3bEgobcJ0SRk2o9YHHrvDyLXdjs8WS33S/hTsvnpjV2ySeE
	 6HRjBdLVd5fXqVZfiMJXUZNX4tJF2cw/8MR+uRYWT3YRl67cZ6
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: shuo chen <1289151713@qq.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	shuo chen <1289151713@qq.com>
Subject: [PATCH] ext4:Update the pre-check in ext4_find_inline_data_nolock
Date: Thu, 10 Sep 2026 11:26:14 +0800
X-OQ-MSGID: <20260910032613.96175-2-1289151713@qq.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pre-check in ext4_find_inline_data_nolock should be kept
consistent with that in ext4_xattr_ibody_find,so as to avoid
unnecessary operations.

Signed-off-by: shuo chen <1289151713@qq.com>
---
 fs/ext4/inline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index ceee69a66482..9f6a4d13b9ab 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -151,7 +151,7 @@ int ext4_find_inline_data_nolock(struct inode *inode)
 	};
 	int error;
 
-	if (EXT4_I(inode)->i_extra_isize == 0)
+	if (!EXT4_INODE_HAS_XATTR_SPACE(inode))
 		return 0;
 
 	error = ext4_get_inode_loc(inode, &is.iloc);
-- 
2.55.0


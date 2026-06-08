Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C352389106
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 06:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780901562; cv=none; b=fEn0puRBeUPVSSunrHxyuB8tOIZP4ZWoXauJKT7Yku7D4KWTbv7EdFt9w3KQvuJVK+Puclz9r/zWmTBGU3cJ2bRVovlbPBK65fUyxKDEdFK5IcXxFjZJUUIBpUDBxxzjIVRz0Pm2u7GZe1ZARtByYWiBPqnDwIdYhpuPacX8iTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780901562; c=relaxed/simple;
	bh=tjzxBNSdqRFOyj6+g30EPXm40tLqjFJYlt5rAxFWtgI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=et4Hm95gJY2lHhlmPGJRsaGLeM8VOS0v2qt9UZTgycPXLJviEG3yo1O5C5e3Rg5ZswPBtao0/O0yXRL1jgEW0clMetM4CLbKC+Rqm2yHEeaaHzo8cMqN63lG0HZijP3Vgg9EbajrkCJS2eimAZo0UIOTo0fsGkoB0McLdb1zbCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KKjG+xG2; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KKjG+xG2"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-36d98b68d68so2573770a91.2
        for <linux-ext4@vger.kernel.org>; Sun, 07 Jun 2026 23:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780901560; x=1781506360; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MERoGnUio44nzGcqr2/zlC7emb75wJcMNQnRu8+qUzQ=;
        b=KKjG+xG236AhMY8t70PAO6I0C+5ZayjQKjbtkeNSP6B/59a03lC2qYq8CUs7AAHI34
         tP0PsO8BJ8dYcOTZj1s45CZvbNGjap1j2ZBnpcH/KvD0wEmHWMZrjS15E7wYVP6mMU9l
         uxfhlhJQrFYRy+NXGc87PSuytsF2hLrLcnnHdcauelqT3x1sv4vt2j0RDLRs4uDS5qaC
         pvxTHuia6pU5RT8IUfA6FMpw8cjMt6XcAZMO7GFKbCW7LA7vZ3m9qyy4MuIpK4HPGrrI
         0ZJK4tpomOjo0hUUNJtn3C8GDBWZFb3+V4oRjhkHELJB3WgGjECzAQJE8a97/jQDa27p
         Is3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780901560; x=1781506360;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MERoGnUio44nzGcqr2/zlC7emb75wJcMNQnRu8+qUzQ=;
        b=FyK31wEqmMTOAt/ITGzYe6Csy7YQqVVS5jl/DiIafN2oGQgL+vRXcd4keEOMF02Ko8
         LYsK8spbg7Ri8Zyx0sjsGkI7bTxxq55yKlWscPDAEYipjYwbAXr9KqcVLjCRVXC+fs17
         R5yTkFZRytD2XG5QIkGXQEVg8k0m8CBIP+e6mDNOufWud3u2UAF4TQswm7ClR26aNosI
         EDXANtifFonk5QF4yx4Zjhox7QtwTwnonxdQGR9A/0gi1c9upYFXFBNrMWvP9+lvuIQU
         v822YvzUHEX3YTy5hWs/8kfXzKnj0LOAS4AnpZT/Dad4eKxgz+cYkWGE4SglHWTlXEYK
         r2eA==
X-Forwarded-Encrypted: i=1; AFNElJ+sj3y8LeWjXo0QWude/ZFWT4pSGAMqado1S4f0kCLw6Ki0Mgoqf3Fre3veTvWNWHoDxKr/UfD68FYg@vger.kernel.org
X-Gm-Message-State: AOJu0YziS4/JXU/x/e7+ywo0uCFrrB0nIzO6+BYq2xILbYrrGw9YOUkK
	Yc4Y95WpqtPnmkSJtgJQQeP2jCNURoUy7ybc2XWOohzXqTGOaWzmNQzT
X-Gm-Gg: Acq92OGIt7Al8AWK84uo2iOhYlyz1quTxoAJB7Cf26tlQjAd8fM7KiHy2Dibdh+RgFJ
	66Mp4Gury0NVU5Y9PVgbdWPdGxDleSVKK358hOoXG3HR+ILkY5upx/vZuhyxsKOSwGwCgx4fPzq
	Z0kIlI1y7yght8O+OIm7pEhVa6YP8fu+ZJ31n3ZDCzT7lFrUt5Oazewe0Opth2H69WK5IYDCHs6
	oerDViJsE9Rvvjng0ubu8svCXrB+sBCnulS1u5dLSAsDIw3RnMHBOy4h7rHCF+Bptpw+WcfgHd1
	bh0e//z5CTR40iwtWU/SUrIpJQqrQkqlPtdOmDJsbQdJHi3Fpf3+zCLWhRpJAzm90gR3nd/4dSO
	xwSDl4s7AdeVmpXcfijHqNuvyCE86Vgu9Ox9Sh1xzqH5EZbBIwVufbA3HLE4bYyF30G1gGcGKhS
	l9XvU9X+hOpcPN+ZtLcHPCsXP4MwEq00qSoYdgwo68TmUHMPo0RD1hbHFVRKhn3Q4zN5iOmplLw
	R4J8tuRGzPSz1kWvL+5UyVkbDhjS45kay2CJWlnQ04MlXtGj4fl9//Y8+3hkc0sWfH493mlv3Ip
	m++3Ie6cKJCesn4A213uW6+6+/it1Rk9kA4YVgCwu5X5OPE=
X-Received: by 2002:a17:90b:6c3:b0:36d:6308:12fa with SMTP id 98e67ed59e1d1-370f0386f18mr15990477a91.18.1780901559625;
        Sun, 07 Jun 2026 23:52:39 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (163.184.87.34.bc.googleusercontent.com. [34.87.184.163])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6dba8521sm14477560a91.15.2026.06.07.23.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 23:52:39 -0700 (PDT)
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>,
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
Subject: [PATCH] ext4: fix kernel BUG in ext4_write_inline_data_end
Date: Mon,  8 Jun 2026 06:52:27 +0000
Message-ID: <20260608065227.3018-1-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the data=journal mount option is used, the ext4_journalled_write_end()
function incorrectly calls ext4_write_inline_data_end() without checking
if the EXT4_STATE_MAY_INLINE_DATA flag is still set on the inode.

If a previous attempt to convert the inline data to an extent failed (e.g.
due to ENOSPC), the EXT4_STATE_MAY_INLINE_DATA flag is cleared, but
the EXT4_INODE_INLINE_DATA flag remains set. In this scenario, the next
call to ext4_write_begin() will not prepare the inline data xattr for
writing, but ext4_journalled_write_end() will incorrectly attempt to write
to it, triggering a BUG_ON(pos + len > EXT4_I(inode)->i_inline_size) in
ext4_write_inline_data() since i_inline_size was not expanded.

Fix this by ensuring that ext4_journalled_write_end() only calls
ext4_write_inline_data_end() if the EXT4_STATE_MAY_INLINE_DATA flag is
set, mirroring the behavior of ext4_write_end() and ext4_da_write_end().

Reported-by: syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0c89d865531d053abb2d
Fixes: 3fdcfb668fd7 ("ext4: add journalled write support for inline data")
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
---
 fs/ext4/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3d..4fce9ec176f8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1560,7 +1560,8 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
 
 	BUG_ON(!ext4_handle_valid(handle));
 
-	if (ext4_has_inline_data(inode))
+	if (ext4_has_inline_data(inode) &&
+	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
 		return ext4_write_inline_data_end(inode, pos, len, copied,
 						  folio);
 
-- 
2.47.3


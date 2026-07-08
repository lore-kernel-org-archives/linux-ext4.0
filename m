Received: from out162-62-57-64.mail.qq.com (out162-62-57-64.mail.qq.com [162.62.57.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1811D44A730;
	Wed,  8 Jul 2026 12:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783515473; cv=none; b=OS7qSHxeztliCJFP7lXX8Mse2EInjYAhjB8ky0sPSx+lUjzbWnp8KBgXN3wIc5fPencwBaAbI0qJwdd1sbVDTSQbtXFAVx0kPePxuhHLfJJw1XGNNt1wWzF2HqFVLJI71R26wA5uzB0VBALN5p5L9pU8KQ2A6RRkJyvqHw/M2Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783515473; c=relaxed/simple;
	bh=TiKzRJ8RNRuRP+na3GAk3iRiue5Rtif3hPJhjgyhPKY=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=QmWIi5q1U6zZdL5Xp9SAD2Se3E0w8/qCM6LBpSsQ0uXax3yPLFaHrBm1pDnCbi8AtwSVA+v7FV2/pBHiciYTP4kMCNLhcpY6PQOgvHWF6IVGUakZdoz9V290DpMV97xCp4fspHzJG4osIBq5c8gHvSeyOlalS0EwF8KPsc2gG1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=rnZLsPSf; arc=none smtp.client-ip=162.62.57.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="rnZLsPSf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1783515459; bh=cz/Y3hOKbAXkKO1xXEKWfY4bB5PM8G0cZD2p9trRJgU=;
	h=From:To:Cc:Subject:Date;
	b=rnZLsPSfD/SyNFsC0mXGJ2upvic7IInyczFTrExkAorhx3L73mns7u9uaN7OK0Un8
	 hK3YhQj3XFwDeLFAA5THJ/Drjv8M+4VUukxNCs1kq0LaMYPDADH2Pyzx61xCpJ9mle
	 6ltOqEKZeXHPmeUzHbOzaTlFNu3f4InsF0ukE7BM=
Received: from ubuntu.. ([218.196.207.7])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id E59B867B; Wed, 08 Jul 2026 20:57:25 +0800
X-QQ-mid: xmsmtpt1783515445t88dlaecy
Message-ID: <tencent_192F8A699EFD21126E02101131C9546F3C08@qq.com>
X-QQ-XMAILINFO: M1rD3f8svNzn6R6CDNdZdzVbn6TP/hxkd1QIZrpTUUw304PbR8N7CQOZbtWIFQ
	 S5wYVoURJ52hTUJ2qjFWdVlR2P9UKqBkA0WAIaoD06fXlsvhqmC30Pbm216egpoEx4ll9h7kHUH9
	 gtLG0HJV9bXZUODahrB2htWM2FPEsOksFKsZj2SxbFoC4Cja5UDRkXaaC2dJEu3OX5T8WH1MjldQ
	 QDqNQcEGP1xGId6NZzfQaia0X+c5iinw492ROWmHHBEY49Oj7PfXggXVHqmHwn8ygJEuZRQ/sINg
	 PVlApL1G8cHjWhbytKpUNBdK3nberlVi2XSwoBIT9RUMZvDvAkeyURudlQ+Ekt4BItGA8IzJfv8r
	 RG4f72ZEXS3TgbT2fIKf1lvvEYYEDokhlrd4WByUCPtv4dno4AAlPkuXHKnsDgd4wscMmPQx9Av4
	 7YMOpUI1lgWcBfGQPmwXJk9BJbP5aoICetqIxpWJ7sYc10eudljueE5dIbAQoabLYCdQmHj+BpiO
	 doh3aMzuzc3LBWTM7LSmd3sxbwxLaOG8DaXtCPNVREkGumpS/tE9NhT5x2NoQ9TvhjIB0trEVsXL
	 TWnZFLvs4yuWBVwanmmgkH+bD1fjHH4M6SwNKHRgV4FRgMn6RZDzdFpzeHREg2dJZPlwmKogoCZ3
	 9Z7YzRuvyRcHAFHfE1e7UFLba15hs0Xno+wxZKNQ1fbVFRisWcPRPViPdPPgVImUGtyPVQfTkyef
	 klKzIsES+C9XJGiFoMxDqKJXALMw7JZhth5uZnTBlzBM4Jr2/njYocN56OxiP/Pwe+iSzL/CxZvz
	 iDVZLBmex0pAUujzf7Jfra6rTmb4L/HK67AOcf9cpEpYpMrcgx0VGY52KGJy3maydyV/sS6RFUMt
	 3OHutJ0yH8+H++aY98UJmi//kecU9VBiRe3kYIoZnWE6b+BDjCB73+LwZdiqQEZSlWvVyOsM1zKe
	 4hTj9f9VhCHFUVZFimOObhidhuU8aT37YjqmkKU3XAtBOKu7yrmz7syE2OdKu6cJj4+bTL3cO2/g
	 QV2GdlyZhd3OU8OtHs6ltzR6iL04JEvYbjeQ+Wv7t/e1KSW4hZc6bAlKb/HgNcim/zK1Z4Dg==
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Guanghui Yang <3497809730@qq.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>
Subject: [PATCH] ext4: clear error before retrying inode xattr space fallback
Date: Wed,  8 Jul 2026 12:57:19 +0000
X-OQ-MSGID: <20260708125719.1031857-1-3497809730@qq.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When ext4_xattr_make_inode_space() returns -ENOSPC,
ext4_expand_extra_isize_ea() can retry the expansion with
s_min_extra_isize.  If that retry succeeds by finding enough ibody free
space, control jumps directly to the shift label.

The previous -ENOSPC is still stored in error in that path, so the
function can update i_extra_isize but still return -ENOSPC to the
caller.  Clear error before retrying so a successful fallback expansion
returns success.

Reproduced with an ext4 image using 1 KiB blocks, project quota support,
256-byte inodes, and min_extra_isize/want_extra_isize set to 32.
FS_IOC_FSSETXATTR failures dropped from 802 to 86 after the fix.

Fixes: 69f3a3039b0d ("ext4: introduce ITAIL helper")
Cc: stable@vger.kernel.org
Signed-off-by: Guanghui Yang <3497809730@qq.com>
---
 fs/ext4/xattr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 982a1f831e22..9da5dfcea7b8 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2839,6 +2839,7 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 		    s_min_extra_isize) {
 			tried_min_extra_isize++;
 			new_extra_isize = s_min_extra_isize;
+			error = 0;
 			goto retry;
 		}
 		goto cleanup;
-- 
2.34.1


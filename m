Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DADDF76
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 02:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785982856; cv=none; b=M/KsrpkvwOm1lY/dU0ZJCEI8KK/v1AjOMaOh83GZbSQOXuEHPJKsfcPlTGzPBhlVKybkSg9DZXnPXtZiRjobUpymsRUSmvxqBEqs2TGhUVmng5i7XR+tAYzmSo9BlfQIFd+iGzczfqfBjbTw8riuoOkcMTRbPqhB6xHmRwJUkVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785982856; c=relaxed/simple;
	bh=w19NtSrhDkavmkUlqXA4R+/hToYaKJSwinog3Ti6Hjo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CDlDHTQ32RJhOCKc4IPF93wIJn80WjXMvnqRnC1GzoyU07Z7v/WQA8flElr5oJZisiD9rjVFp5avZjql7g3xrxA1nPs1yPley+mNqLLF6lNFONmcVuIMugqxVR3+V3Jk/54YEkvUms3hVeDImw7LF4armmIe3cUdd+sBZ+4OSZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pwQBK64i; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pwQBK64i"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-848743155bcso855801b3a.0
        for <linux-ext4@vger.kernel.org>; Wed, 05 Aug 2026 19:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785982854; x=1786587654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rDAOxwq3ttzmOFNmqT41qJrWI/l0YQGgUcGKO+iJ9p8=;
        b=pwQBK64ihHou8hnoP8PrZQ9GcXXgSI3ff4u0QX412SlLZCH6Y/U3qMvU3tcoEGUTCg
         UnvLTxjWHYT37hfm7T7o1F4rbNC9LJhKYO5sTizWhMqP5ZlwSSqhDGDTADnogVpRSu2S
         3JJSYd/aFt/Y5LJn6LdQGlux8VDU7Gky36yDQf8shu5k6bxkySNqDJj0zO+wVsXmoE3a
         bVhd0/aA5OubB0IJEeSDuCZXTpZfTleJAUqbh3khxCBhaA5dTQZ7bYdUceI/fueiM0NN
         EYqsVbG9OWkOFmG/Z7R8ZpYLTd7V9T20fF0vuRVd/qxb/JOxKZqrIzxdB3/0BvvMgd6D
         tQxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785982854; x=1786587654;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rDAOxwq3ttzmOFNmqT41qJrWI/l0YQGgUcGKO+iJ9p8=;
        b=InTBkEpg1tEcGB3vI8wpsW9mVjTPQg6Zqq0yIZVtI1O10BJ62HA/bOkCreEAlBS1t+
         pmK0hY5BwlV0seeqkPit8U5ws0j9Fcr2mFx9+pXtQUb5mii84eEEVFxSwgZm4sUL3k82
         1CS7jexpPwVK2gIr5pcxrRGfyg8q2Onshs8XBy5Kmqs9y2v/66+QYIWKFkhHW50hJ09J
         duhaXA2Qll+qyVjiFhG4VOCJWuX228E+M0kjvd+pOrkeB2RvIMrgWt209e0syyKqTiqB
         qhituc0+489I+kLOl5nphcwYJqgsYyr2+MJhn3M1Nm+XG+OvHFiJiyCGmB1ry7+AfWcF
         kAuA==
X-Forwarded-Encrypted: i=1; AHgh+RpQLvFbTk82EtYC/a78GrbSw0Oqv6z+W7Cdv3NO7hMAK5tyQnrZPm3lpVhf7Z67ET6BfGz502QrwHWk@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0fp1TxnfF9nOhQFD7ZMNcJYkR1LzRExLYOurpVH0Nqgty6ggr
	l6xWdXTK+ks2s1MzIknj0kNuaziHuMA0OJ2+nImHSWRF+T31Ftnp0G+F
X-Gm-Gg: AR+sD11B4s+f0i67xT/EG1TZksJRyUIWqpg4rw3mLXGF06arZoDDw9alYh6MHYs6MIq
	+eIhBwhy5692MzYtvjxJVMYhoepR9EHnzEcKaf3GWlzPqh+Lt/qFd5xfzCqU1wErW6ptFVLXl+m
	xdqYKOFsbD//HwgBwCaBdYLww/ZCP36/c6HWkUMcfwOPDrtykHHse8cPocyq9QDnlBDXj/wket+
	K2gs3EmVeoegBn7YL4LeZElHeMly0PNeRjUf8tJetrSrWgAc0IGzn3WOhhfXQvjgz5gusDq1FOQ
	CR2AqUdmtNsFJjhRkv3PxUnShJgiIyXjv6WfCGgoEBQLNwt+zSN5tb6Gtl5rlFy62WLGTZHZAUW
	NFEomCk8Cb4TK2LEVN9Kar6Zp5nv5JBdMLg8WuChBXpb9JlDPDAwtDo+n2Lsat+39H0r6Dh8z1N
	1xRPsTSlos0Hy+wKcHspAxIcydUxZxcYoGGqJtRBEIz6+/nzk3CVY5elmtE9kNgxzdggLeFYGK
X-Received: by 2002:a05:6a00:4489:b0:84e:24df:3873 with SMTP id d2e1a72fcca58-84f2e0c9cbdmr12720996b3a.32.1785982854383;
        Wed, 05 Aug 2026 19:20:54 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f4538ba99sm323012b3a.9.2026.08.05.19.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 19:20:53 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: [PATCH 0/2] fs: fix readdir position truncation on 32-bit kernels
Date: Thu,  6 Aug 2026 10:20:42 +0800
Message-ID: <20260806022044.167962-1-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both ext4 and ocfs2 rebuild the directory cookie in ->iterate with

	ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1)) | offset;

ctx->pos is loff_t (64-bit) but sb->s_blocksize is unsigned long. On
32-bit kernels unsigned long is 32-bit, so ~(sb->s_blocksize - 1) is a
32-bit value (e.g. 0xfffff000 for 4 KiB) and, under the usual arithmetic
conversions, is zero-extended to 0x00000000fffff000 in the AND with the
64-bit ctx->pos. The high 32 bits of ctx->pos are silently cleared even
though a directory may exceed 4 GiB.

When readdir() crosses the 4 GiB boundary on a 32-bit kernel the position
is reset back into the first 4 GiB, and the re-validation path then
re-enumerates already-returned dirents indefinitely.

These are the block-offset (non-hashed) readdir paths: ocfs2's
extent-list path (ocfs2_dir_foreach_blk_el(), used for all non-inline
directories) and ext4's linear path (non-indexed directories, or the
ext4_dx_readdir() ERR_BAD_DX_DIR fallback).

This is the same class of bug that commit 3dce5bb82c97 ("exfat: Fix
bitwise operation having different size") fixed in exfat. Cast the mask
operand to loff_t so the AND is performed in 64-bit. 64-bit kernels are
unaffected.

The two filesystems are independent; they are sent together only because
the bug and the fix are identical, so each maintainer can pick the
relevant patch. The truncation was verified with a freestanding 32-bit
test mirroring the expression; not reproduced on a live 32-bit >4 GiB
directory.

Zhan Xusheng (2):
  ext4: fix readdir position truncation on 32-bit kernels
  ocfs2: fix readdir position truncation on 32-bit kernels

 fs/ext4/dir.c  | 2 +-
 fs/ocfs2/dir.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.43.0


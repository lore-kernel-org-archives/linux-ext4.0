Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795723992;
	b=gc+ogC3ETbBn4UW+nqTGHlCoLhYEs6zx99XqZIRRw7ksMc/c+IxtkqqfDIdJGvbrVj4P
	 lmabTqmNK07kin09I3uBLVCfIychqScs994m4EduqWyYR6fVw6zNEcyXow5N41C+9BSZm
	 qJdLDbhJ9RxrDIBhLe/idpfR9sRM0DfOQIglRYTziyJGqUcY4Ok6pI6xf0eXYKwRsm94B
	 ma5OECgwxqGs20YEBzWpk4yAoor6GPXpLXpas1qcLSg+aLX9k3Jxpd9yHPNzYWKl8i4Vh
	 izXsmyFp+9fDgTLPQAxlDlt/FFVZ4SC7rDBhESg0dEyvyNtUlH/A8lr4X15Cc3jrb9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795723992;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fK+r7DYwMxbzHHbFUIMMSN8fB5bhLsamSVzb5cLtIIk=;
	b=yWU0yOl3F/RtR7mgoyyE38HL9tP6FnJXNafmRbh2IjDk8mXiikNw966zFm+zlIhYEOTk
	 esHs1Bi174XMH40yTvuMylm7DwaCRH2C2+H40cPlOa88b/0ZlsaXpqS7RpYKhGTtOOOAn
	 8XYSYxsuzX94LYcbHT1cnxqEK3g8kTCD37b1nYgRP+potGX3sQLF8/tGJLlB5+r6clxh9
	 2Rne0XRLdsudFLjnUB5HllKeY7Gt5XbAfahV+Du1ebsr2PCevnD04PEastdW4ilMnWNG1
	 HxZk0un5BLpT+ACw3ILQMBbKYD/pO4YOpCatqabWQCSYrDnRdOc6GMcpOC4MC9hO/rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=e2b.dev;
	spf=pass smtp.mailfrom=e2b.dev;
	dkim=pass header.d=e2b.dev header.i=@e2b.dev header.a=rsa-sha256 header.s=google header.b=IHlLsPeI;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB3E606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2026 20:13:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BB3E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=e2b.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e2b.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=e2b.dev header.i=@e2b.dev header.a=rsa-sha256 header.s=google header.b=IHlLsPeI
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4bb6adaf0f1so64809895e9.0
        for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2026 12:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=e2b.dev; s=google; t=1795723990; x=1796328790; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fK+r7DYwMxbzHHbFUIMMSN8fB5bhLsamSVzb5cLtIIk=;
        b=IHlLsPeIMRWDMqt19AJ8tpjCDfVGEHr8dXU27+bzKRtxCaQ1nYOtM3Bt3bEhPVNKjO
         51R6s3fWWa0Zcl1yW2tgABQweJc2CurWabvlq55E5oED3oBB3WRfGpe9wAd4BdtRnWNF
         AipZXg9jdET50L9zrQ1hCF34te394sAFynzZljc6YIhvkioY/xoAxcdrTXevyfY7wzqj
         +oPVbPKXmLSmEH9QNMCUPd2nhloJJp2R5OPZZIRqZwsXIsLwgCWSEfRzatuZxENG/Fmw
         8a/6TGwED7bzV4zR1XrXRPWNdd6IgKl0lhEsZ7jvBzpsFvlectwzOVyLRGRYKT1ObrzV
         3V3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795723990; x=1796328790;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fK+r7DYwMxbzHHbFUIMMSN8fB5bhLsamSVzb5cLtIIk=;
        b=IqTG0+R6AH+rXJWq+khVF9yR8vTODHWH7NNlj9xEZrZiXBXInnh7efuVkb1cEnbXFW
         vI/yO+s7NCTr9ngPkgUIb4uAorpxagKC3p86OMqe8KjXDTZuNEuaLZ1PvDKB8osrX5Gn
         QyQbX4NFbJdzwuXbX+evOFMtlofEpO75pTH3Cj8b/Ecwxj1ikRiZO3m55SOkLk8Hjf4V
         xuijPffIy9B/VM0ml5LhpN3v/XiV8P0pTwf9tmj5c6u6o7j4luZGELxVBaNGeeZDYWly
         2O276FNtf/fTt/mgt//YxOwH0NQC5aK4uYgBHY9gNy8xIFNrI4tnVHeSM3pEZBvTqQek
         f2Mw==
X-Forwarded-Encrypted: i=1; AL+hErGLbR5sR4gp7lhwgu2VqtI79hNKuKVJIQzqorN/VHuOKsJttuxVo/a23Q3ZZH3FfycoaRrDn/LBoW3s@vger.kernel.org
X-Gm-Message-State: APuU4Z/TPErUb6cAiWGQJJB2gV4pquyNQtLlkchuuUnfhcOJLP//uz/N
	3kI+TESzKcZ8kaDRMHt3u31GytH0UGtXrSGm5t0f+2ruQyxeycSJmg/+Fx2UuIECb/QnLac4++C
	el2EzQAM=
X-Gm-Gg: AZFdTZexhl3nzC23fA7dPAhZFB6dvDEMcucNvLEaQKEBZdP8Lh/8GT/K81zrMASRNxA
	pkz37ro5J9gPzR6Yrw2peKIelhj3KfnjOC+W5BTJfpLNkJSAN6T2X+6x1TtMr1au87DfXtlWsTd
	4bTEFdpkp8orC37S50PyfDR6d+gF+KY9sZzDBmSixrqFk9T31c1IOOIOr8eWm0ugLBjvlDTSCHK
	/0qEqblMkHAgg1Fko43ezxvvLJmIBuTYU2s/mbeslweNSX1YVmXaHnuustaqda+LHDRjrRYMFob
	m+1oUTJlJiS22ZlxxQCojzfBbIsYUHGVmOSxInZLhB0Bpk5HoniynF9vqNxzDHVPeKmaSqZZRT0
	XHDCFAnRNlA5viCPIKNMrdDNyJIBbEZ26ilpeeyqRSMSFi57yUCyy/zGSLnrbWKcgSySvgg1Taf
	zUmEdtfYw3QHgjPF8mFU9SWSXunPk89Ey9bZ0OUfKr+wd8lHKhElyhTs6cK1td4byUkgoFM6rR5
	XVlwHNq/WOs8+PuS7KALxHzKFo6n5rOBzySal+Qrw6Gz0sxUSy5EY6f5BdUUOz5HCUGvPsSa9KG
	vbVlbZs9kJbW26rGvyTB8yp+kG2iofJSbtd3XD2P/73HZH+lgS/oyV+O8d8nE+uV5HPZdg==
X-Received: by 2002:a05:600c:1546:b0:4a1:fc98:1cb1 with SMTP id 5b1f17b1804b1-4bb887c2cb0mr494283365e9.2.1795723990324;
        Thu, 26 Nov 2026 12:13:10 -0800 (PST)
Received: from fedora.sphynx-tuna.ts.net ([2a02:8308:397:e200:f9e9:8bad:f8cc:87a3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b09bsm1154281665e9.4.2026.11.26.12.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 12:13:10 -0800 (PST)
From: =?UTF-8?q?Petr=20Van=C4=9Bk?= <petr.vanek@e2b.dev>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	=?UTF-8?q?Petr=20Van=C4=9Bk?= <petr.vanek@e2b.dev>,
	linux-ext4@vger.kernel.org
Subject: [PATCH 1/3] ext4: drop KUnit checks tied to the inline conversion's metadata buffer
Date: Thu, 26 Nov 2026 21:12:53 +0100
Message-ID: <20261126201258.1553196-2-petr.vanek@e2b.dev>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126201258.1553196-1-petr.vanek@e2b.dev>
References: <20261126201258.1553196-1-petr.vanek@e2b.dev>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

test_convert_inline_data_and_rollback() checks that converting a
regular file's inline data writes it into the block device's buffer for
the new block, and that failures to get or dirty that buffer restore the
inline data.  Those are details of how ext4_convert_inline_data_nolock()
converts the data, not of what ext4_convert_inline_data() promises, and
the next patch moves regular files to the page cache, where there is no
such buffer.

Drop the content checks on that buffer and the cases for an unmapped
block, ext4_inline_getblk() failing and ext4_handle_dirty_metadata()
failing.  Keep the checks that hold for either implementation: the
conversion clears the inline data and sets the extents flag, and an
ext4_map_blocks() failure restores the inline data.

Signed-off-by: Petr Vaněk <petr.vanek@e2b.dev>
---
 fs/ext4/inline-test.c | 38 ++------------------------------------
 1 file changed, 2 insertions(+), 36 deletions(-)

diff --git a/fs/ext4/inline-test.c b/fs/ext4/inline-test.c
index b3d7c51ad216..3b697d4c425c 100644
--- a/fs/ext4/inline-test.c
+++ b/fs/ext4/inline-test.c
@@ -1149,7 +1149,6 @@ static void test_convert_inline_data_and_rollback(struct kunit *test)
 	ret = ext4_convert_inline_data(inode);
 	KUNIT_EXPECT_EQ(test, ret, 0);
 	KUNIT_EXPECT_FALSE(test, ext4_has_inline_data(inode));
-	KUNIT_EXPECT_MEMEQ(test, ctx->data_block_buf, buf, sizeof(buf));
 
 	/*
 	 * 3. Error rollback when ext4_map_blocks fails (-ENOSPC):
@@ -1171,46 +1170,13 @@ static void test_convert_inline_data_and_rollback(struct kunit *test)
 	ctx->map_blocks_ret = 1;
 
 	/*
-	 * 4. Error rollback when ext4_map_blocks returns unmapped block -> -EIO
+	 * 4. Successful conversion via ext4_convert_inline_data():
+	 * destroys inline data, initializes extent tree.
 	 */
-	ctx->map_flags = 0;
-	ret = ext4_convert_inline_data(inode);
-	KUNIT_EXPECT_EQ(test, ret, -EIO);
-	KUNIT_EXPECT_TRUE(test, ext4_has_inline_data(inode));
-	ctx->map_flags = EXT4_MAP_MAPPED;
-
-	/*
-	 * 5. Error rollback when ext4_inline_getblk returns NULL -> -ENOMEM
-	 */
-	ctx->getblk_fail = true;
-	ret = ext4_convert_inline_data(inode);
-	KUNIT_EXPECT_EQ(test, ret, -ENOMEM);
-	KUNIT_EXPECT_TRUE(test, ext4_has_inline_data(inode));
-	ctx->getblk_fail = false;
-
-	/*
-	 * 6. Error rollback when ext4_handle_dirty_metadata fails on data_bh
-	 */
-	ctx->dirty_metadata_err = -EIO;
-	ctx->dirty_metadata_fail_on_call = 1;
-	ctx->dirty_metadata_calls = 0;
-	ret = ext4_convert_inline_data(inode);
-	KUNIT_EXPECT_EQ(test, ret, -EIO);
-	KUNIT_EXPECT_TRUE(test, ext4_has_inline_data(inode));
-	ctx->dirty_metadata_err = 0;
-	ctx->dirty_metadata_fail_on_call = 0;
-
-	/*
-	 * 7. Successful conversion via ext4_convert_inline_data():
-	 * copies 80 bytes into data_bh, destroys inline data, initializes
-	 * extent tree.
-	 */
-	memset(ctx->data_block_buf, 0, sizeof(ctx->data_block_buf));
 	ret = ext4_convert_inline_data(inode);
 	KUNIT_EXPECT_EQ(test, ret, 0);
 	KUNIT_EXPECT_FALSE(test, ext4_has_inline_data(inode));
 	KUNIT_EXPECT_TRUE(test, ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
-	KUNIT_EXPECT_MEMEQ(test, ctx->data_block_buf, buf, sizeof(buf));
 }
 
 static void test_write_triggers_inline_to_extent_conversion(struct kunit *test)
-- 
2.56.1


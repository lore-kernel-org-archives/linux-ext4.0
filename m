Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1632F3CB54C
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353428; cv=none; b=TLVXWgtQWhDBi35OHIEvBwS30LvXO7xc35XBBmhIyS3kKIaXkos7ZDZOkA5Y4SZ5gaS7roezpTSGhZ4YKXzXs1XLQmQXXU+Vv78lr1wXF4XA30YGJ4pb+5TWxqdPcq4dv5WUtIBkfGYilRammqaFtKa0p9QHQzk3NwZ+XehVaRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353428; c=relaxed/simple;
	bh=NkWTxDB7BVf5kr2NeMKSqq0wtS9n6p/N2UG9HabFDJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzha/6C3kEBeppJMb/giw3azeAkmPxt1dJTBvlMj0XDW6f8f8c/KlDAklFttvfGa3VUpB5lcXJF5okE8D5HCusudjV6fImK3oFCt3tfYxebjbbjwz6N+8JVZQOd/t1i3ulGdv5O3pIJV4n7CeQasFV8w1Q5VB+nzsNqvLLFiy/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RzjNwIXQ; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RzjNwIXQ"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38dd55ad76cso15403a91.1
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353420; x=1785958220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e6+Ei9NFKggzOoAWAaPtMOQsJgv2L14jqLZIvC8zwcM=;
        b=RzjNwIXQwrsLc3iXdQispTSj9R5/FlEjfFmgXGQb9PEF7caPycSYLn3C3o8pRgIk+g
         kED15/HnjZSIvZ7AxM8N84cMjdb8B+6J9J3pgM4GFLvxqsa4dfTzmqmolRiDNP9kPH0N
         hh5Kx6pJwWKF+N7ADb/GYUaDTgJpaUeIWuGPFFCuM4fBexqG3OApWHJpFDejajRRnD/x
         ZItS2yKSfr2/VYq0WFmXLUPiHUgAt/pBwgQhpZq2FPvZOKfBURv0YmqCKTlppvhT01Ug
         e7dA+zbEXM5zNDAfxBzxCtM8OxAs8zqPs+gwfRM9HOUpqrUv09N+za9omB1R9bvAjMX1
         kfQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353420; x=1785958220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=e6+Ei9NFKggzOoAWAaPtMOQsJgv2L14jqLZIvC8zwcM=;
        b=nYOTIsnEDy5UfRVRmqNBFvz3OeGvwer0YCS4oniKIbJg2ws38Y6Z1fJN4n9UPIMJq7
         8EAYdPPoeI3UmORNXs9Ja+uOtfX/3U5QwNUzP4CoJGjwe1DqK70/QKDzMxitupoVvmAo
         DrngOcDLEM7y2YYQ2FleoKMkbx9dJEXITu4eaREqngDeRRqZBqnS1CLw7rmZPo3lHo4e
         ut17nI7MC29fz+7rC4qQW2ZRt4X+3FMiskokvBabktAqh8VEz8uDX5oKZ4Y9jzYjhnpl
         O773tiVqcW86b2Exd1VHmTDtxze+g7s+D/iM731E+44GAdz7xYPuD2IcfAF1gNLWtMXX
         1cmw==
X-Forwarded-Encrypted: i=1; AHgh+Rplfz5LAC+5k9xaMTi3fAlQ/zVPpoZRTweBNqLKrnUVlJhdocnDhdr4OOXrTyOGQ8lltb06mwjvxZdt@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+JqEBzjbT5JeQFJfq6Z1YA3YIWw0hJSUSmoNn/NBkQzU/wKRG
	28tuQsHSrweve9uDaGuFYzFc1cxb2lux1sEj2iuaQRvjf4LwqDjvleLf
X-Gm-Gg: AR+sD102/oVuuBg/xz0RNQ4of+KxEAFt14a7vwwsmk1heGQceQkeenA6MS6X0Oxgr6v
	ncOo+1y2aUgTV+n2TY61K3S5ZLeN+0/y0KQLnNBOlEmjxdtGmBW3tMpT03ZpbBVWHfO42AvKD1y
	KrUPGeQo7dbDV4ZCc0GRAHGad9zk+UO48qjIxHpsWGhm/k4u+BWi39CcU2+QkVDw7W7LGpQe3Uk
	FiiuyEQKdAxzSz5eO/O7NHnHJFjv2rXfrRV0ShwvBN5N1fWxUZXTWioQW+TmbCRX4UmeaI+lB+d
	DbWSkMY50DV2X0jesYNrWwVx5ZAeftBPysOfU4dX8fKV8UKKRev57Y7EQOJA+SuhBUHs/VDLPbM
	oDcfdAG+hSo2cBzcZqT04q2GeQtYa2qNseWx57FFnWEvvizHI9wwOFZ3hj4jOiLlNOjk2sGFCmW
	LmaAL0lqBkRQssLcNcLH84lhE165ChfHPOlcsyUSIYt+IYUPbiy9E6BG1dgj51PU2z1ycD6nNal
	PPVEpzX+r/qSqwZPmaMeEYC1xvC10BlCUQ0ghrH
X-Received: by 2002:a17:90b:1b07:b0:384:927f:3db9 with SMTP id 98e67ed59e1d1-38f83519701mr2825738a91.1.1785353419540;
        Wed, 29 Jul 2026 12:30:19 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:2::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f6410ff7dsm3181791a91.4.2026.07.29.12.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:30:18 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	bfoster@redhat.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v5 13/22] ext2: convert iomap ops to ->iomap_next()
Date: Wed, 29 Jul 2026 12:27:28 -0700
Message-ID: <20260729192737.3190206-14-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260729192737.3190206-1-joannelkoong@gmail.com>
References: <20260729192737.3190206-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert ext2 iomap_ops to the new ->iomap_next() callback. The callback is
generated with the DEFINE_IOMAP_ITER_NEXT_END() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/ext2/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 29808629cce5..7e0fa9c454e1 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -860,9 +860,11 @@ ext2_iomap_end(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(ext2_iomap_next, ext2_iomap_begin,
+				  ext2_iomap_end);
+
 const struct iomap_ops ext2_iomap_ops = {
-	.iomap_begin		= ext2_iomap_begin,
-	.iomap_end		= ext2_iomap_end,
+	.iomap_next		= ext2_iomap_next,
 };
 
 int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
-- 
2.52.0


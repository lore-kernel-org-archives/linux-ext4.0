Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74513D8907
	for <linux-ext4@vger.kernel.org>; Fri,  1 May 2026 17:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777656338; cv=none; b=EmRd3IduKdKr57u8gUv64FZfjwQRhyvTEdD1WjMJ060WH6rL4wciYHPajO1ybI5TW90hYewtfsKDLs+QiTvRQzvBcl3c1RdwaILuTINaPX7LUnBV+qIBXLc73mrW2vufCfSj7DrCUza9wRKeDi7sNVDTTi01jDDd7yKVGF6BIsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777656338; c=relaxed/simple;
	bh=2srHf7GIl/tibrCrIcmdObSAgG7zX5V8NLa+IAsRtrg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CrDbtzN3GPRgOV2zmX1E27RUBfuwoK+sOeb2AdJ49ajJKaxIRcOcIv+wXkNv0bvW3fqkcrrXZyyaJLZzf8Ypy53VkfiFcwpi0HoJcX76KWqu3gsnrF91cedpR4wnN5i162jf4GgPpJGQnGNWwBK2zs5ijJIrvyjPxlZDaDc7AGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cS+Vbdws; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cS+Vbdws"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ad4d639db3so9595495ad.0
        for <linux-ext4@vger.kernel.org>; Fri, 01 May 2026 10:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777656336; x=1778261136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=K+HMcI/9s3RPCJwI7of2kYI/MCsDHTZiRUZd9gr7WX0=;
        b=cS+VbdwswbDJahR2gOU4/PNfvdB22zYJ59fZNhiud+uJXXiDhyMSpqQOy9bHxm2OA3
         PZhducucgU7TCY4hnyEd1lrJkNp9wTmc7UGHEVXcJWuKeBXzttrg7rkMq+T0DMy2XnLE
         2RxSL36WuIEXfhT/XS4QLwv58O0AOR5SJZbzu67TDlN8INIeA3f9KLjScs7pSqgpLcG/
         N9XhxEqnU9b1PqGr7YB6zdW7zbLpfNiNDmZJ23yKj26MdKiMSlg6Pb3LgLugCChoiUhk
         m53TT/iLINmH/NJd6RWwa2bMIdgpReJz6GLtnZwliUDsbGw1iV2NucEowbYAldffunJX
         6f6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777656336; x=1778261136;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K+HMcI/9s3RPCJwI7of2kYI/MCsDHTZiRUZd9gr7WX0=;
        b=IKsxMmWZ5IGDXYxFH7wmDL039dv/8y4POt40EsKjXQ8859fJkpkydSOc8ptjsKwZMm
         Juw7/bzevx97M0mPpG+pRGPl2ySEXCdpYsizqBoaozSltUcPSwHnbgh6pUH3kHnX6zoq
         Z9YwTdJ/dxCT9ruj9iVinMlOzDqhoDwT87/Kqc8P9CBHwwDdXgXu2AIrjMzVxwXIM4Cq
         A1JCwdnVIKyFJD0/IMmk5qmqBvTvOpHJuBmL31XqtCkz3sy9FYiUpv4+yZoX0Q+ikNKw
         Bl937BZliEbjVfPYTkDR9IkcnEvx1oa6zrQAszPWnBeeMate5HRXSH2f4mBf3mhC0hI8
         dEag==
X-Gm-Message-State: AOJu0Yz1qoOcPL38lytXqKKsPwDi91G/TvMYZNHUn2AS3To4Rs7b2dIw
	GdLbUbWyrwdDLu4lpy2Zw7aOLAEjOPSZbTIPAJb0jkNbicFJ+4mrxQOg
X-Gm-Gg: AeBDiesCykkvdUZO7Wkk5W4U9vpGJeusKIRjwovmbRduLJPmEDzUqGqbluG42vec0UJ
	8krInGgYMkljaBn1UqVYaZXsXkNPJuDEjjGr1up/s55mxeY9CL036l+jSRzWHv28pngbID03NMO
	KIWRE7//PFEwGOyiZTXo4cXTwdi0AOvGI0WYOiuDk3gvk3kNt8suAFpq/IBczulm+Z8xVTuAjhU
	Y1om/tU08c53mN1B3dA2kfbRgzcj7U4or0Fkdp8C6wwQj/KN1k/yCZv32nqKylNe1YuL9h1kqCR
	L5G6jWWo02M8rEcILq4G/f3bFhXTy3T0qrLR4cmIxeuoWsSaRJlFQuNA+msHK4tZlElIW2yx4KH
	GztwvSXAIGibLFbehIzTxdSNWp9jlcd7uDvtibVGz6fVlSRQZIeheuCfQGw8QJO5dVJk/c9UhQg
	r5ZG5GVL+BDo8ksiZwLo4LjGTiPMihGdrSNaM4NgE=
X-Received: by 2002:a17:902:db10:b0:2b9:ee49:29d9 with SMTP id d9443c01a7336-2b9f25fd090mr1599795ad.29.1777656336150;
        Fri, 01 May 2026 10:25:36 -0700 (PDT)
Received: from vini ([2401:4900:8fcb:edbd:7155:edb6:dac:107e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caab231dsm28800675ad.26.2026.05.01.10.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 10:25:35 -0700 (PDT)
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-kernel@vger.kernel.org,
	Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: [RFC] ext4: possible inconsistency in ext4_append() error path
Date: Fri,  1 May 2026 22:55:06 +0530
Message-ID: <20260501172506.563064-1-agarwal.vineet2006@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

While looking into ext4 directory operations, I noticed a possible
inconsistency in the error handling of ext4_append().

In ext4_append(), the inode size is updated before all failure points
have been ruled out:

    bh = ext4_bread(handle, inode, *block, EXT4_GET_BLOCKS_CREATE);
    if (IS_ERR(bh))
        return bh;

    inode->i_size += inode->i_sb->s_blocksize;
    EXT4_I(inode)->i_disksize = inode->i_size;

    err = ext4_mark_inode_dirty(handle, inode);
    if (err)
        goto out;

    err = ext4_journal_get_write_access(handle, inode->i_sb, bh,
                                        EXT4_JTR_NONE);
    if (err)
        goto out;

If either ext4_mark_inode_dirty() or
ext4_journal_get_write_access() fails, the function returns an
error but does not restore the original inode size.

Callers of ext4_append() appear to treat it as an all-or-nothing
operation:

    bh = ext4_append(handle, dir, &block);
    if (IS_ERR(bh))
        goto out;

However, in the failure case, inode->i_size may already have been
increased.

One possible consequence is that subsequent checks relying on i_size,
such as:

    if (block >= inode->i_size >> inode->i_blkbits)

may allow a block index to pass bounds checks even though the append
operation did not complete successfully.

I understand that journaling may ensure on-disk consistency, but the
in-memory inode state may still temporarily reflect a change that did
not logically succeed.

Is this behavior intentional, or should ext4_append() avoid updating
i_size until after all failure points, or roll it back on error?

Thanks,
Vineet Agarwal

Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD48846C853
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353410; cv=none; b=cFAyUGbqFPrl0S1+75cNz+35GJr9i+fJgr1LPc9td2ubi3kSI1+YubM/h4IOnpeVXCjmXF3/FgGzicDOg610IoJBZP6j+eqiQ74i64XmT73hBw9bGToSFG5DLo7f6sb3v5iwCLNdHzlStuzShDgcwlHihH+n8urFKog+2EDHrG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353410; c=relaxed/simple;
	bh=U/rckYROPBe6b5K0Y/8tt470oUNqTpGawesJbxo/iRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKANU3ISlpx9TLmTOlvPeg2fUAQftSS7LFRUO2aEdyTH16s/y1x+9WiV5XkzSF5wwyRRNSCUBB34biWkCjKjZD6W2TVJhMhUWFQfrJPbCLK/zIEBjs1V13qYbI4OTTGbUT+ze7/blq0RoL4sZpiR3iRgcVYRYjE2ScAqpV59Vhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TqCtwt97; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TqCtwt97"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-84861fc51f5so1021635b3a.1
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353399; x=1785958199; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BvkbA25OGT8gs7alZHVVlBMx4s9jhvYzzcPoZrf679g=;
        b=TqCtwt97HFDak/L7IUpHUs52nEX/Qa7tx7/T8UQks1G692H5lgUhL9u/NAyamrxc08
         xw+oX7kN0d2z8OL2LF/BJO8zaQwy3d6ihjfHIltvMuFekVc7et556dureb5RiPvkNrUg
         avbFHTUHj9KBy5exJD3BERvxBZWOKOgu8/LrXKH1q9mybhYh01EFi/FXpornTeT6csfH
         imsBXKte31+qSpEOR/Nxb/8BzDk75UX3YAOoJsqu5ayT/+Mayv6mPVtvcv/CNF44IDAc
         4gAXcK8ebIF7tizbN32qu4XIYRTY8kc6rF7dqt2H4VV3Hjg8mxlndgdVuhS5zZQmzMIY
         NTUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353399; x=1785958199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BvkbA25OGT8gs7alZHVVlBMx4s9jhvYzzcPoZrf679g=;
        b=WDeWBqCN7tgcWLX1ZbDWRBF0punfb+hJumNx0o8QkuilI+b5RVbyaCYLlDUSdSny4I
         ZTc5fe6qX0RYC5h+u15g0vVYLyVWQ6GV8TjZfGaZTuPE02mZzf/Z5z+MIJn+CoW53POF
         B6niF/cby2eRWRJT0wRBCfuG25IukyB2whtPrwS81nX8eBJFdftH4yHUyP3310YR3mNB
         8NOP7TgZi/z/WIHov+2F5FT8cvjL4kgPUcsMxOiOE43YutVfs5Zdrpy4/bOlalz1O6FE
         w1FbgsocoNTIlsJ7JbfzjB6Lv/x6xUuvuQxq1QPOquzm0kMhX/W5Bk9yXii9uHpTdpkQ
         1+bA==
X-Forwarded-Encrypted: i=1; AHgh+RqnAptHBplCrkyFEYjQfcWxRMQIbWBpUxj/ZIw6EMCQN0Is7xF7O4k3V/p7mFpl8/k5MPdUw3Hq8au5@vger.kernel.org
X-Gm-Message-State: AOJu0YwiltHhLBvv/mjj3jZRz64eIod1tAa9eDc8JEmjJRuqUgV1xkb5
	ojcq8AGnqgA4WndbZjvM3BrKBJctjn/JvhR53bJC2gsFYLmpWNoCbweg
X-Gm-Gg: AR+sD11P4TGx44DifIGM60yhpmgpJx81T1K8Et9aig8uYCZVcwJa0CrBL/tSfkP/hQ7
	xw1mXRgkqSZjE0NMdQnIA83kPQ2GdC5+H7Kbb3ZLtiuTU0at2DCS3WQHJCJ2WZAJ3SQaBoBkBvw
	0Yhhu03ITkv5EyRBgMDavch7NMA9UL86uhCUkaulCsXbqVSX2i8OFu2NHjpvdeJL4OqAoqsf4y7
	QYf0LJExBLNI9gGDeuoaf6mmHBGErlPcW2ipZn/RjUBRnSUlhrOwePssC7V191+G0ShxyIY3oVA
	Fl+Igz0zkGGvCSvrQ8DZKxOzv2rem3Eav9/vxAWAn0+y3uLWDHXZ12jmil6m46V8d5RERh6uYSe
	b2LJVRYveVy7LvfzJDGCRnfvwzQolAJSSkm9Ydh4Pqo1EugPKKSoV9zlIcV6nxN6bbnj/ymkOYp
	MYMXsWcIF9zTM2j09VH9x3mwXGZYEXOlqX/qfgROHb3VZ4FeseQp2F+uxn9PL7honvW8EWRTw+A
	ymkx7pCetIbpRG/LUQpEe3HpVg8wyfhsE8CGIzUwp1jh8NAlVM=
X-Received: by 2002:a05:6a00:139d:b0:848:31fb:43d9 with SMTP id d2e1a72fcca58-84eba1d3555mr65509b3a.45.1785353398841;
        Wed, 29 Jul 2026 12:29:58 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:53::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ea02f8461sm1842019b3a.28.2026.07.29.12.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:29:58 -0700 (PDT)
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
Subject: [PATCH v5 05/22] iomap: add ->iomap_next()
Date: Wed, 29 Jul 2026 12:27:20 -0700
Message-ID: <20260729192737.3190206-6-joannelkoong@gmail.com>
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

Have one ->iomap_next() callback instead of ->iomap_begin() and
->iomap_end(). ->iomap_next() finishes the previous mapping if needed,
and produces the next mapping.

Collapsing to a single callback lets a performance-critical caller
inline its iteration loop and pass its ->iomap_next() function as a
compile-time constant, so the compiler can devirtualize that callback
into a direct call instead of an indirect call through a function
pointer.

iomap_iter() uses ->iomap_next() when the filesystem provides that
callback and otherwise falls back to the ->iomap_begin()/->iomap_end()
path, so filesystems can be converted one at a time.

Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/iomap/iter.c       | 8 ++++++--
 include/linux/iomap.h | 9 +++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index bf7d4cccc1a7..c445a38b6285 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -118,8 +118,12 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 
 	trace_iomap_iter(iter, ops, _RET_IP_);
 
-	ret = iomap_iter_next(iter, &iter->iomap, &iter->srcmap,
-			ops->iomap_begin, ops->iomap_end);
+	if (ops->iomap_next)
+		ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
+	else
+		ret = iomap_iter_next(iter, &iter->iomap, &iter->srcmap,
+				ops->iomap_begin, ops->iomap_end);
+
 	iter->status = 0;
 	if (ret > 0)
 		iomap_iter_done(iter);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 80832edc7ec2..d203d9fe0f89 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -231,9 +231,18 @@ typedef int (*iomap_iter_begin_fn)(struct inode *inode, loff_t pos,
 typedef int (*iomap_iter_end_fn)(struct inode *inode, loff_t pos, loff_t length,
 		ssize_t written, unsigned flags, struct iomap *iomap);
 
+/*
+ * Produce the next mapping (finishing the previous one if needed).
+ * Return 1 to continue iterating, 0 if the range is fully consumed, or a
+ * negative error on failure.
+ */
+typedef int (*iomap_iter_next_fn)(const struct iomap_iter *iter,
+		struct iomap *iomap, struct iomap *srcmap);
+
 struct iomap_ops {
 	iomap_iter_begin_fn iomap_begin;
 	iomap_iter_end_fn iomap_end;
+	iomap_iter_next_fn iomap_next;
 };
 
 /**
-- 
2.52.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793138321;
	b=Tcvs83Zyl33JIPsgdl1ORInvD+Br+9y5UHQEshVW7/Zmvaz2PBwYpj+mJXlXbSj2CQHt
	 URMbPoXi5EX8n95rHzdQqYL5rLnSxlSZYe8sf6y6hJo+DFghYAPi7Jn2N0+43BkKyhmIx
	 5exl0zioXGq6xpWoJPzipQTUgolaOlfngRuCys8dHrrsszO/y1hvzc+7sP6eTsZLDfBjI
	 el1W3130IlQOH88USuFtIo+cwUyRb+I6jMHqgeRdUmea04avptWdC6FY6vFKIYkfIDaX6
	 pCeK8IeiPwrGiftgx+DtvATz7v1F35T9mE6zP89tbCRwcYIsx22D6M63ejLm50MuoSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793138321;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=43G9CXaG7qSF4UFTj5k8Ql+kaR9Fc0A0Kgr5LG/j+HQ=;
	b=R1PhwcjkxVDqKPbPtqTik42YZIBVa1SlFiDT/xWXeUXYqcyTd6ZRi0lOOpADDr8hXiHe
	 1tId6ayrZxJ6SUSrRTQdaSRzau5+T30adJZl6Kk+gBzIBeSlabHgDOgo1uCZFPBSxOdJ2
	 1xzw85Flxa6tLvK6fO8vhIr+NneehZUB+dKoGpnQFSAwsecBApl6PmJCYaCxVNIFA4rkW
	 ySt3wYjmCo9FfZcOhuPebTLYIg98edA4i4wDvVuAKIJqUDVU9smJ3+2lyu1t7FOJzhF3p
	 gscsUIg16OuPoJPEdpyAwb4ZluIbG8hflAUc4xPy4fR4rpFORn/1ioQJAVRG5wrs1PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0JoWngSl;
	arc=none smtp.remote-ip=209.85.128.172
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7DC606A329
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 21:58:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A7DC606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0JoWngSl
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8b118bea471so2484827b3.0
        for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 14:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793138319; x=1793743119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=43G9CXaG7qSF4UFTj5k8Ql+kaR9Fc0A0Kgr5LG/j+HQ=;
        b=0JoWngSl/7Wd4baloUpWZfgYNcJsVWiereAE7th7R2Ip+sXgtUEhPJO1hjFXHapzbR
         yPAtjz+ezQBhpAMDxbiS6NCatGfpLLaiWx3O1DQmpz0O86H1LD/XTr04UMKmlmbO/Vo9
         4xfaa0gGx4eWPRM/ewD4WBEPFHsEj5k8P9e9oSmnQTcm+8DivDfjUd7A5oR3TGka4RC1
         vJv+hHOEGLK5VpjdEhPVM/J2fOv+egtjbFUGk7eBJREyknkrXfZnUtf7klqTWt0ENeiz
         xUBRXMjgnVeAVE6Dbu/WEYJzXgstdrpDAg+ijV1WUiyayiW32T30xxd0cGoPgh6z5wgq
         Ns4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793138319; x=1793743119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=43G9CXaG7qSF4UFTj5k8Ql+kaR9Fc0A0Kgr5LG/j+HQ=;
        b=x6rGmDyuxq+mhHj8aMd7DGAyvmApRM42MuwshT5eVslE3CyrkcX7oSujZh47LW0cLn
         xJ3ITzzvnPHHEEXVBR9rt7mMp5/kQ/9qBMvZk9lHZd1bLwSrMeduv77Ew6f79dCBxUSv
         VNPOjc8hRTRzv9BO7y1+07ZhvNw3HG9TRNMZdfJYG0vEjRi8ATPoFusdoU92zhGWqUvN
         co6fnQLmy50rnP5qMK6qDLRc1smkMHeQPqtwkFTgnPxsPHoC6I1z6EWUhJmbLls/S3n4
         kI+7hHFg88a+CrSfI2W2Jzi5HmT/yYo3I+9ijq3gSGwKOETk9JMeEuzsNMSVRHQ8ozoP
         s7QQ==
X-Forwarded-Encrypted: i=1; AKwUvBw4KqT9yWnJrsFbDQb5FZmzrV2QbGcFkVv7bbxJc0ZZu8xjYL6/mPwb0HUhzv4XdykiRuZQaKUGv4ol@vger.kernel.org
X-Gm-Message-State: AFq9FYKue1A9mjBRBQiwMkyANz5eZAUbM81A69Ic5LUsSGMcdXhuMMFc
	jZJ/wOv5ZekZ69o+lDH5Mv9/85wCSJKb/H+WHHPbgML2f3U6NN6V/kER
X-Gm-Gg: AYBFou03iyC3rsjgIeAuKYEysVBSSlEvHb7iHvYoLtckfgU9VFraBMN9jR4H8GWkfwh
	xoG3y+hbCBJ/obPjYIVHVgGqtBv6g/BVmM818oz05uxVLDk5/LnkYm69OjXSXdMQvP/gunbAXSB
	y+W2xxsyVaQLQ6h9lMt1fXJwDqvXX1bbbN00xwSuJGgPkL/LZlPLa6Hsftn/+yuRd8USOgsasbu
	q3WHqp0tcUwq4xqnVeBYuOW3TH4NJPFXf4XRpcwk+nMKy7Rm0cHfbJZBtE3UgQnFoLD4r8Niv0D
	ftCjeuGfzmjR6Nbsj3W8Iq76Rw9MMedYiRVIw+5ZgM4kk7Rt8hCAEJxQCJ980LaGYUQYg6E63Do
	NzTgRAofZ2MCQWdyO7G0Po60LXUb3o26fk71bagvrE5uGCmMzbEQiSm4NIqZ9/mYMna+m5zapcI
	kUko93AYGT7WYsew/9W2e/5jv6LONDFvluOIueTTQBv8F2IGd0Rxkm6/2Pc9Om5euXx5nXCMeEO
	/yGvpxgzGV34aR+CyfyNneCT3i0116j9OWqPVKBnhzy6T3skJK2pDKDf6BGenK9+EOnRn3NbvcD
	9/OH9UYvTSkzaZynJFjebhYlWxmxeQjW
X-Received: by 2002:a05:690c:f89:b0:8ab:485b:9bc8 with SMTP id 00721157ae682-8b1b5a8ceffmr2994117b3.24.1793138319600;
        Tue, 27 Oct 2026 14:58:39 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:73::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b19e5b83b9sm18877967b3.27.2026.10.27.14.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:58:39 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	changfengnan@bytedance.com,
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
	linux-xfs@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	linux-nilfs@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>
Subject: [PATCH 3/5] iomap: remove ->iomap_begin()/->iomap_end() legacy path
Date: Tue, 27 Oct 2026 14:53:24 -0700
Message-ID: <20261027215326.2693300-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261027215326.2693300-1-joannelkoong@gmail.com>
References: <20261027215326.2693300-1-joannelkoong@gmail.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With all in-tree filesystems implementing ->iomap_next(), drop the
->iomap_begin()/->iomap_end() path.

Reviewed-by: Fengnan Chang <changfengnan@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/iomap/iter.c       | 6 +-----
 include/linux/iomap.h | 6 ++----
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index fd8791c4963b..8b6da9750a93 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -119,11 +119,7 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 
 	trace_iomap_iter(iter, ops, _RET_IP_);
 
-	if (ops->iomap_next)
-		ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
-	else
-		ret = iomap_iter_next(iter, &iter->iomap, &iter->srcmap,
-				ops->iomap_begin, ops->iomap_end);
+	ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
 
 	iter->status = 0;
 	if (ret > 0)
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 59718f73c15a..95d4995a49ca 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -195,7 +195,7 @@ struct iomap_write_ops {
 };
 
 /*
- * Flags for iomap_begin / iomap_end.  No flag implies a read.
+ * Flags for iomap_next.  No flag implies a read.
  */
 #define IOMAP_WRITE		(1 << 0) /* writing, must allocate blocks */
 #define IOMAP_ZERO		(1 << 1) /* zeroing operation, may skip holes */
@@ -240,8 +240,6 @@ typedef int (*iomap_iter_next_fn)(const struct iomap_iter *iter,
 		struct iomap *iomap, struct iomap *srcmap);
 
 struct iomap_ops {
-	iomap_iter_begin_fn iomap_begin;
-	iomap_iter_end_fn iomap_end;
 	iomap_iter_next_fn iomap_next;
 };
 
@@ -256,7 +254,7 @@ struct iomap_ops {
  *	incremental iter advance.
  * @status: Status of the most recent iteration. Zero on success or a negative
  *	errno on error.
- * @flags: Zero or more of the iomap_begin flags above.
+ * @flags: Zero or more of the iomap_next flags above.
  * @iomap: Map describing the I/O iteration
  * @srcmap: Source map for COW operations
  */
-- 
2.52.0


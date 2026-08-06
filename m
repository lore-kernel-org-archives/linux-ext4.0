Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE60427FA0
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 16:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035568; cv=none; b=RjJ+r0id7n8ihevqY82Zlu0rdEAfipNIWyzuv3Yxx+LnDFXEb0XA0YGwy3qJEi9slTEdH7/iQu641aQUTMlkqtS/8BUHY1jabNNYzivX7H6iZpT5alSIyaSHVykhLddNIRMCNP8518RdDDz781cch4G5Dklq5N1HcqxfoaVgosU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035568; c=relaxed/simple;
	bh=rnhWvDAamvoYeIKRmdifnx08e4HD3+YvwIOGYnqYA4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GTNMR7zjvzG5ZjAEi7EbfgcvM1+FHzM8OXWirpnvA8jDuX4yaYa8N1Rknbwc8pIDugf+m5oMR+cXucYHg7yNDxnj7dlFdcTM8OwCqGNivzCOkbOZH8aRefFINWtDA6UaE5cm9p006ZVONNVe6bvkMBJWu6LzFLY4Z5HsmZ/Jbxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pou6BHbJ; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pou6BHbJ"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-96944741eaeso787281241.1
        for <linux-ext4@vger.kernel.org>; Thu, 06 Aug 2026 09:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035566; x=1786640366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ByrJwOVSq2vYDCfCPUNcQuCIafVp6X3bai0sLx612mw=;
        b=Pou6BHbJ8C0nRs23QcGZLdXsAeVbkCeZZUAlD8+PI0C3YMw4ZPeU+ag8R+lUVhQh4Q
         GktYmqZuFCQq2HPObxCy4z3hHoWjy/Za5rIhwJHGiINyx9zp5p7YCq7o0KmnLXcNVmV4
         upodZHe1S0ATqzCNqJLR9JdsSe9M38UH8S5XZgo+nE4u7UjNezwTZyUDdupXb2ywbDCd
         9uJszE3xFsH9zUxvw8ek+TkEEAYsuT/Ovt7zg8kzkXgBKmcer2wM+XjgpWKfw6Awgodn
         VrG95N7ITzH3u7i/kBFsEqQiCwvtYx/xgxVlSKpDXd06zj2ZkKbPLa9RZ7YDf8Jd2k7q
         AKlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035566; x=1786640366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ByrJwOVSq2vYDCfCPUNcQuCIafVp6X3bai0sLx612mw=;
        b=gw9dX/w8tRFiOqqbEv0voEewQnWN0OQKaK0rgfVul6vEdO60QKGUNEnEkTEn9NRZsh
         FjdupgLcjAQ7IuLNbBQ1V89gS4b4muzF4wQAaS2fQqmC1YAA6uKQlB5yIj0BpPdNPNbK
         LFnicVIroN+T8mIXqc1oQc7dPxf+yRFgJgfMA8vHiKwcPhivyVu9Z/Ncpdd6MBM3mR0C
         J2wP3F+C7AOZ4VPwUszfRA6leR6cmiRHNMPMKN3ajdFZoWmxQbYW8kqioT1memeN9xAk
         hvDWl/IS600xqsP1Z6YVg5QUHOz9zYhyJXNVdgz4G/RpVq0uR7kG7K8FUhe6NJP6QzQ+
         Cc5g==
X-Forwarded-Encrypted: i=1; AHgh+RpPxFmBgdRN2xnxbaag+WRPYgeUMLFxtYcJXpnWFCGvRlGSyDofWxh1xX13AYt3R1ta4AQ3KNrxpl4y@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3Fdqd6JaKQuNbakZ/VTsYm8VUDvxjfMLd3RbtXsYaicGAYHyZ
	S+9v2txGuLPPllXKPZLb2gjDfJKfUVW94FQ9CIkJ12ZgvVTYTY0hZgze
X-Gm-Gg: AR+sD13NBilL+KKcAKwwTdk1dANwwwqe4zMbjc82SxP/9jOFaDwAeLsCM9jpfvtpfrP
	Sc65jJ5W6Y8lj6tdjQRxBpKAn/0jXAlXcjK0Jm7CpAcdiWBq5ISStuepN0PrNHmHVx3NfK1plkg
	aY2iP99lnw5MdSJG9lF14LJva2QZTgu2dEMsmemSipxzMmwc7T1qar59OuZY22+ERq0LHF4qu1a
	1+QXw2Egek83WVysNjm6KBfX0al3hWkoUg+bMgYQ2Npl/Eupoa2bknAdaB+bvJwkqhB7c0G/DXK
	KnemdW7WnAhJdCXE2Wd0dbTMXo+uqntqmTRy1J6Sgdtop6OiECWyv3rcZOOlPU52NWIvDpPF1dB
	z3MuKtI2cBJHa5YwGWB+aaCMlcxl4ZjYi+YlrCFypy/fynt+RmdufHh/w3jnhcQbAz2fdDZM6tT
	/hjDv2boPoWcKQRj38GwjWCOU0RKy6/TtynoTWgHYyHZEHuz+U+wBnXEyLZwtDzmHx5GUqx/LLe
	e3PXBQ=
X-Received: by 2002:a05:6102:6c7:b0:631:28c1:154c with SMTP id ada2fe7eead31-760e9e4714cmr4097167137.9.1786035565908;
        Thu, 06 Aug 2026 09:59:25 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:25 -0700 (PDT)
From: Chao Shi <coshi036@gmail.com>
To: Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>,
	Weidong Zhu <weizhu@fiu.edu>
Subject: [PATCH v2 07/21] buffer: detect metadata write errors with buffer_write_io_error()
Date: Thu,  6 Aug 2026 12:58:30 -0400
Message-ID: <2b309196b883cc8979800911a47668e225401b2c.1785951556.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785951556.git.coshi036@gmail.com>
References: <cover.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both places in this file that report a metadata write error to a caller do
it by testing !buffer_uptodate() after waiting for the write.  That works
only because the write completion handlers clear BH_Uptodate when the write
fails, which is what this series is removing: a buffer whose write failed
still holds the correct data, and saying otherwise makes callers rewrite,
re-read or WARN over a buffer that was never wrong.

BH_Write_EIO is the flag that actually means "the last write of this buffer
failed", and both handlers already set it via mark_buffer_write_io_error().
Test that instead.

No behaviour change: today a failed write through bh_end_write() or
bh_end_async_write() sets BH_Write_EIO and clears BH_Uptodate together, so
the two tests agree.  They stop agreeing at the end of the series, and this
one stays right.

Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 570ce7f495d3..aebf74abbc49 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -618,7 +618,7 @@ int mmb_sync(struct mapping_metadata_bhs *mmb)
 		}
 		spin_unlock(&mmb->lock);
 		wait_on_buffer(bh);
-		if (!buffer_uptodate(bh))
+		if (buffer_write_io_error(bh))
 			err = -EIO;
 		brelse(bh);
 		spin_lock(&mmb->lock);
@@ -2743,7 +2743,7 @@ int __sync_dirty_buffer(struct buffer_head *bh, blk_opf_t op_flags)
 
 		bh_submit(bh, REQ_OP_WRITE | op_flags, bh_end_write);
 		wait_on_buffer(bh);
-		if (!buffer_uptodate(bh))
+		if (buffer_write_io_error(bh))
 			return -EIO;
 	} else {
 		unlock_buffer(bh);
-- 
2.43.0


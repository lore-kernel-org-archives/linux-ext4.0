Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473CD3B52E9
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 16:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035546; cv=none; b=Ee2WG3luFwhdgJXtwNAkU32/HOn18Q9fwRFCShc20tkwZkuvaCswMPxfkpdSXThmZP4sSW7G0Cn/RDiu4O23aYH0ERRyGN1prKp2WMrbNK0+z78Q9lX4EBHFOJ+m75HUIttV0f0NvtLmQZSItmwOFvO9mvBwDSIhPcYACERrzmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035546; c=relaxed/simple;
	bh=hjREzgpzo5QzVUOXcfPLZusIOE1tYvynFiHWCGrfyGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FuzrohzSIT4q9rMD4uX2ph0ao6GTiz22NE6ZH2gSPz7bLdTzIE9KBBA38NWYJ3pWBu55dTwfkhjOZD0WHVf9F2yLf5NcYkfq0I4UnCiu/lnfTkVlyB4a3lEXlVnY6NvMv8vYkEck2DMmFPr5U+I3upLD/cJ2kyftzGkbNF4r16Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=imPXJnGD; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="imPXJnGD"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5bfb5e20a90so1678770e0c.2
        for <linux-ext4@vger.kernel.org>; Thu, 06 Aug 2026 09:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035543; x=1786640343; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k3JV3rYlfmcwigTL3Ipqk1+R5zcTkEoUEmgylrQxXIQ=;
        b=imPXJnGDOfb4roQ+X6WBd7zySacKBqMeFhpwQsWWzyRlY0bzQvWA5tzGbHSSfRTP+O
         JEPd82BDDRpW7jzNhiWTWvwNPmPOSQavFmTGp9CE1aeHqcHY4m9LcxpVCJLJlUNdtUI2
         nqV2DwVMYn9IFLnoNM+UOysnnQNyIigX195mENSEbmcK327WAX2TTMEqZUD30CbrKhwj
         eJuxvk3MiOmT+reXUY7NlTlF0Goatu5YycGuQieG8stdK2CKx2vf5OEgvqxSMNlRv4+7
         DfH/Pan8MtIoDaOpJZTeubjV4mijXnDPKo+NPk9HOoozb3EOGHarp959NPyHPNO+95d5
         h90Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035543; x=1786640343;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=k3JV3rYlfmcwigTL3Ipqk1+R5zcTkEoUEmgylrQxXIQ=;
        b=d2XZZAdat7leZuL7WwyvBF05gA5LFAepw1YZ4dWKX6LRU/1vuTp7VL9eHVGhDanl8c
         CbBw9fdHTLme5MpyvIPQzeW8JrXg+iKOcdQTgRGeGAPn6xIuQtzyz+URPpwKmyrXBsA9
         9/XXAWfvAt9TPpXP9+ksQYoN/JDieyqS9M71EPB/zDth/D089l0Coe4MoFP82pB0Fga0
         MB0+gWoHCfyXGvhFm8Ood4HuNSUOOWeRzIvedbP/JMyD9b3iH0zBsLbeM4Cl/liCJhyx
         1tJuEfENX3UAM4inhR1XXuAjNjnhUPYM/91VQPclUY29RLnUMlZDADJdLKzCltZrC6Ap
         eVPA==
X-Forwarded-Encrypted: i=1; AHgh+RrZ04EzpC/y/AOUPy5FSdx5CDvSGcS2QbbM6fFD1s4y1HSustRrhhe/jjSkj2v56dGyJ3bpZmFP6unc@vger.kernel.org
X-Gm-Message-State: AOJu0YwGD+FxpKSITaREqbQYiH5LvT6TsSCAV3tx1lSpAP/+W6/SE4B4
	Cr6vByEKi5tEwEqwnQSx11J8jBMfKJvVcMKWfEw603Vpd+2MYDvV67PH
X-Gm-Gg: AR+sD13VslzyLXYQ7WM3zxCYuwBDG4l4QgLiff9I+oQOdl45GaipbZI2xFACl1pRrDN
	QFxMHOjCuVYXOt12pCv3FDnG/ltXu4Zjp/lfWGNP4VlyEWMrtcS04x13fmgUVizeNNi7wBCcGhs
	ivdUykuY60uxuPT14PkWTngc7YdCD0aKFZGpADVOAPRcQZ+sQUlFr5ZC3pU5iO7F60MKzf3qSV7
	jCjr0iTuQY69Y10MiFWf9yU0IsuzlorhinHq48XaM/qYoRuwVWwQ+7PHYTC3DoB8/2BKTfmQmDm
	VB82LrA/0bArVPhj4jWEHpNEySTctmLS3aCK3M2/83SXgT7z8s9ngVoMemJHsBS2aPh7kxloWjm
	Pmzi3QvIFGlfYXIMNOR3bOv9wmg9Sk2jdnE3FiFz3t1CgZebWzH/6lCVU32QVu2ou3qpWKT6zlh
	bCi//e0qVKzgRm1helV1mqZ1i5k+nhD9Ij1+8Ty0OUdztZTXeW7FNgwpo3ul/ZcPS7aJEkJbArs
	PXEBNk=
X-Received: by 2002:a05:6122:8b8d:b0:5bd:ecad:8f80 with SMTP id 71dfb90a1353d-5c3f9e68046mr593111e0c.2.1786035543192;
        Thu, 06 Aug 2026 09:59:03 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:02 -0700 (PDT)
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
Subject: [PATCH v2 02/21] buffer: allow a buffer_head to point at memory outside the page cache
Date: Thu,  6 Aug 2026 12:58:25 -0400
Message-ID: <bb6fab2111a48d7ba61887fc1372362576fce6e6.1785951556.git.coshi036@gmail.com>
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

jbd2 builds a temporary buffer_head to write out the frozen copy of a
metadata block, and that copy lives in slab memory.  Today jbd2 points the
temporary buffer at the slab folio backing it.  A slab folio's ->mapping is
not an address_space, so anything that follows bh->b_folio->mapping there
gets garbage rather than NULL; mark_buffer_write_io_error() does exactly
that, and we are about to start calling it on this buffer.

Rather than teach every such helper about slab folios, allow bh->b_folio to
be NULL and let b_data point straight at the memory.  Code that needs the
folio has to check.  There are two places in this file:

 - __bh_submit() adds the data by virtual address using
   bio_add_virt_nofail(), and skips the cgroup accounting: a buffer that is
   not in the page cache has no owning folio to attribute writeback to.

 - buffer_set_crypto_ctx() returns early.  fscrypt has no interest in a
   buffer that is not part of a file mapping, which is why it already
   returns when the folio has no mapping.

Nothing sets b_folio to NULL yet, so this patch is a no-op on its own.

A buffer_head without a folio is a narrow thing, not a new general
capability.  Most of the buffer_head API assumes a folio and will fault or
corrupt state without one - touch_buffer(), bh_offset(), the async read
completion path, and plenty more - so it is up to whoever builds such a
buffer to keep it away from all of that.  What NULL buys us is that getting
it wrong fails loudly instead of quietly following a slab folio's
overloaded ->mapping.  It is also only valid over memory that is always
mapped: buffers over highmem have no permanent kernel virtual address,
which is why folio_set_bh() records a folio and an offset instead.

Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index be8b57a635cd..04fcc34e4fa6 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1099,12 +1099,16 @@ EXPORT_SYMBOL(__bforget);
 static void buffer_set_crypto_ctx(struct bio *bio, const struct buffer_head *bh,
 				  gfp_t gfp_mask)
 {
-	const struct address_space *mapping = folio_mapping(bh->b_folio);
+	const struct address_space *mapping;
 
 	/*
 	 * The ext4 journal (jbd2) can submit a buffer_head it directly created
-	 * for a non-pagecache page.  fscrypt doesn't care about these.
+	 * for memory that is not in the page cache at all.  fscrypt doesn't
+	 * care about these.
 	 */
+	if (!bh->b_folio)
+		return;
+	mapping = folio_mapping(bh->b_folio);
 	if (!mapping)
 		return;
 	fscrypt_set_bio_crypt_ctx(bio, mapping->host,
@@ -1142,7 +1146,11 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_write_hint = write_hint;
 
-	bio_add_folio_nofail(bio, bh->b_folio, bh->b_size, bh_offset(bh));
+	if (bh->b_folio)
+		bio_add_folio_nofail(bio, bh->b_folio, bh->b_size,
+				     bh_offset(bh));
+	else
+		bio_add_virt_nofail(bio, bh->b_data, bh->b_size);
 
 	bio->bi_end_io = end_bio;
 	bio->bi_private = bh;
@@ -1152,7 +1160,8 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
 
 	if (wbc) {
 		wbc_init_bio(wbc, bio);
-		wbc_account_cgroup_owner(wbc, bh->b_folio, bh->b_size);
+		if (bh->b_folio)
+			wbc_account_cgroup_owner(wbc, bh->b_folio, bh->b_size);
 	}
 
 	blk_crypto_submit_bio(bio);
-- 
2.43.0


Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1740F3859C2
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 22:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621672; cv=none; b=GSajm2KKMl3NgYyBwkfDjqqr2ashJG6USMomag2gHHbvLiNrU2qqsO9oPWrROF1F3ctjDHL2wDN9R0mX1ifUg+AgTAOdBXVxX73bNtcJ6F7Xt8W5zxLzu2mpN7GJBLEVUdAGEHBWj0I1cwgJexxUcmOHnFOFCNyjiUhvgDouEoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621672; c=relaxed/simple;
	bh=dHCSXwhqSp5ZYzPgeTI83J3l93w1hXqXrOBDQtAfTkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdhNpLeUlyDAnhR0vtXX/FrIPpNdWlxdRL2FzlT/O2WKVlQXkK5qNfNbLBAU7JDcjwgBAKaUi6P008G/SyKdEPlEfEEeqC8fDqQtef1s9wK/rNbovnqlixLRpKoP3YxnABPTFgMieyYoZ20ZnXkfMp19leTZ47ZLjwG3yu9bGOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rr/zyvdC; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rr/zyvdC"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-81ed073fed0so31935597b3.0
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 15:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621670; x=1786226470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R/+4h8mFnc0QJGTHkSaUWdLQ44MjYcXD2X7Z3kRsV/c=;
        b=rr/zyvdCTTUD1h2ADJZFQyniubg/ygk1iHIqyBK4nLEnXoBsBusjzCjmNNhXFvB970
         SjkpNJH6ZyKgVLdYEF1589AEsQsXJswezNwrHN4q+2S8xQsq9rHhEc8oA3DmCWFJVpwT
         4I7bj9n9FgdU12Ud/vUks/qJwfM+2z2CAu3R3Tjh4loeZEWPkaAfz8DYGFS5Tn2VHFUw
         IVTqQxvgHU4CnJBcIgMjWXbfNe7sEzxBenigQ4xeBk7WfNdB46emCGxrlTfzAkYb4HA+
         1Kl/VtmbuVZ0DxFuJQzHKIgcD+4dkHXcykF69jid98GhvtXVNpoxHxepa7nmc10XyMiT
         fc2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621670; x=1786226470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R/+4h8mFnc0QJGTHkSaUWdLQ44MjYcXD2X7Z3kRsV/c=;
        b=dX/muf652z1TPUWGipZJpGmp3a0FKw0PWgmDNgEoY+O2aQtdZn4n0P3X/B4Lo159hJ
         95tHXsftHJJe5r/ZOm7qWaVsO9Pv5bTfbDRzzrnlIFjn0KOXmt0NAPSAAP8uyVs0lASM
         nfTiDUBA5hyWGFLfkoO0XgZz1048iNHyusvnebY1fA63cWZENJqiHHInvFFwucQrZ3ra
         Iq3XjIQdY+mS+Ah/Ny1cc0MbsHx6WsgXUeTB+qEtMEg4cI5DOg4V0UsbGaiQbed/pkOg
         H1SWN6BrmPPAujXd3HSevb98hgunRCIYZl749hV16I5MfBROHxmAJo909dA6kXxmlRNf
         uE0w==
X-Forwarded-Encrypted: i=1; AHgh+RpF2+plknNQQ6Tnp6Xrkds+xjQ+fQW/c8QdWhEUhvFg91/oynfqQ6PvOWo1wItSekuP2LqIgcv4DDl/@vger.kernel.org
X-Gm-Message-State: AOJu0YySOWEvLWNrNwJ19LlpeuA+qrsnxFp3GG68iGwTEtqFIjc97qzZ
	j3xtAflF3IxCsPVLRzwQeJGxPOhR996+FDfTQF8Tfn4zwuAlchBfe66C
X-Gm-Gg: AR+sD128B7rOk0VgwzIYVqdmHzd02WQMkDHLd5tzQ7OlUmentruHJI4JvS4ImF3wyP6
	Ip6XZDu2F0I9qQwrHlRjJFIyLdebFEkc0ovMtYyqZbtUmt1Oy3KYG5uC39Ejit5lgBMShmLrvUe
	W1TyhG1HO1Us+86Jy/AfsiTsEZ2voOpoEI/PpMnAyrn0sXlLmT8omUGOVa6LiLH1pyv9oSZbBlR
	+cFzKjP2dxSJAP5aRjBwgNwF25yz75McVJCgxPd3lgrMcMewpPDLJ1J6fS4ifzM8648gso/kq5T
	z/3GDzrGGe1UVvDEPwec3lD+l6T7swjg5+eFl2mrphKSJohy/+7FVQhy1mF4kdULlFwKL/UvtvT
	W7LXKUJYB6Qr63GUuTuQgPO4bz/VPuFJMXYyLgDNQcH2ONxUVwKebgYBbXUxhHIVNfqT6fB5tiI
	YUQsCNHJJgz0r3v/msKOSGPbSc6CaALw7OiFLjtxuwIW/vfs6Pn3MLq04e+RUkIqGynrFlSJdHU
	EV/ypxB0P4ofI5RdzOekNQyX0lpag==
X-Received: by 2002:a05:690c:6203:b0:80d:c2cc:f673 with SMTP id 00721157ae682-81fd4b72857mr77020067b3.20.1785621669974;
        Sat, 01 Aug 2026 15:01:09 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:09 -0700 (PDT)
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
	linux-karma-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>
Subject: [PATCH 02/19] buffer: allow a buffer_head to point at memory outside the page cache
Date: Sat,  1 Aug 2026 18:00:46 -0400
Message-ID: <41c6fee66724e374d4682124a1eb80041e22efb9.1785621505.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785621505.git.coshi036@gmail.com>
References: <cover.1785621505.git.coshi036@gmail.com>
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
   returns when folio_mapping() comes back NULL.

Nothing sets b_folio to NULL yet, so this patch is a no-op on its own.

This is deliberately not a general capability.  Buffers over highmem have
no permanent kernel virtual address, which is why folio_set_bh() records a
folio and an offset instead of an address.  A folio-less buffer_head is
only valid over memory that is always mapped, and must not be passed to
bh_offset().

Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Chao Shi <coshi036@gmail.com>
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


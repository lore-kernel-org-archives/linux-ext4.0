Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C333BFE3B
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 22:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790288994; cv=none; b=jqBv5c+Zc6fiGMWBWF+fAeC9XhUQObO7HjQICuJwczwrFnXZ9IYPQ4Sobe8YI5uaoss5rkD92+aTswap48/TbTnnayBpFK3c1Jcf3vgbFaYhKeHcj5dWJrG4H6ACzbtBMSTV8ZsZO1GZU2+T2VXlJ3RklI8GWhB61D3veLFIRhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790288994; c=relaxed/simple;
	bh=jk2W4qW5Jvcpd0GdJiPdJSDciJZlk0IZGptCLebEpKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhest3avc0yXJjQpiINyyMVBb2YgwL2GjJ7jgRqFgGgCQ9d3jtD1E7+fSab05yUd4p6b8VEubO7B+szrANQXvP19/BMuWj0u/DGYCOCwzxTMgF4X7KPj9ytOUXkGBNYFhckzz8qvwliBDhX6dQWFw0ymR7dS98GE9Oq0kQNhPyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dqgtbIEK; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OiZxXP3H; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dqgtbIEK";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OiZxXP3H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790288992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jnx16kM9dVUjgz9S3hg7CrUBs+H3vT/ogFfVT/rQd9w=;
	b=dqgtbIEK3o7c3JDm+PFELYdfiY1VN0eEltTBm6myFdBEA0jbuBP/fiSEOCHfIFzjyIg+qY
	sUx/cftx5DEhQ6bxGS4kUudy5hZyDQ9bbihT6sW9YrENTphj52Z/eWju8SrZXdr7p6T0P9
	kxpYZn/6dvEKDybf5dx5eYXAA8FoKhw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-LvQ3HQoeOZGG8urBHcsZdQ-1; Thu, 24 Sep 2026 18:29:50 -0400
X-MC-Unique: LvQ3HQoeOZGG8urBHcsZdQ-1
X-Mimecast-MFC-AGG-ID: LvQ3HQoeOZGG8urBHcsZdQ_1790288990
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-9390a2c895bso81142585a.0
        for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 15:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790288990; x=1790893790; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jnx16kM9dVUjgz9S3hg7CrUBs+H3vT/ogFfVT/rQd9w=;
        b=OiZxXP3HNQHvt7F+9RaRoIKn5fb9DbSBO5ZQzxEFCsIbLZM3YI96FE68CCp0Vvgj8z
         8ebf+v03OQtIr83upgS0iN0FKsHYY4Xx9U18HV2B/WxFmZkZ1kAYMtMohn8q6dtBK7Vb
         IJUjSYuYjred27ff54yFO6fORs7vFrSNnNqBdEdYpV03iHOCFHECMz9kV+f2rHP1LdH4
         A+a1rmM13v6UBg1rTGlWcKnBTQKVNK0k/+5qxquJSKr+sUIAOGj8rgUXol3sIXL8Rcux
         36EwSQzztxXzmuE95TN0GORmrOnqVMTPjvLdYf2DbCRPiBTcOvmb2xMAE4T25PMl4Mef
         TzaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790288990; x=1790893790;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jnx16kM9dVUjgz9S3hg7CrUBs+H3vT/ogFfVT/rQd9w=;
        b=WYDVaaEgmVExcNGU1opXTQ3i3rs4IRRQY80CgAytIK7stiDSZXdwpCJMr2ZetLVKHL
         Q4n+F78l5QuLJb7nY9gGAIwXI38fL/lbRgd11ZOUvTaZ7axDvRRglprUCXrNAZE4NCTD
         SgpPsHzbuqnXOJn3MP/kipJkbJo4wSVZg+FzQS1R2dhd7NYjOoY9B7aPG8o+i7vIPTtR
         iK8khGfW+DmpVdjx4rReQsaoahNjXvkEiYCjQzXKSUoSy0496/iKeK3j3pA9c7T4BoWO
         JFoMQxF6hIbqzx7mHy07z0UVvTgK41h489roI42MkbiViCai+GHtQYmn54xfguUFKMfe
         Fo5Q==
X-Gm-Message-State: AFuF++mqlYMqCVALfZ7xRtRfBFiPk/WqwOEXBK1m7i78kxDQEvljDmbR
	ASn6tcdi9QBYHQvIHpzGfy9VeveP8CD9n++6p3RN7YLTc8xpy4Q1/N/IDnz3bfaNfMTNbmT1kKN
	bcQt3OmJ/ZMfggvbPLLQKubAmeBD2fyjlw4PnJaUpG4ukRZUjvgdBveZkTvZE2P9LG1YERvzF74
	IIYoxoxdkUN8yZVglY7k/DUKzrUCu1ntdCajAZTUTkjJ55YfT3
X-Gm-Gg: AYBFou2qW3K+RU/o8DreGfCyrQEtwQg6tRdt9Xav9oE6eXrIigt7dBZ6ePJrJ7KI+Hy
	yUMafsn5r5j1UkHtJdirjPsB//2QjsiddmMrlTR8zn9sfidceP5rcu7Yqtwd7q52U+S2iJIUAh1
	c5OpogYsyZFZFESwcv7Ct9Q+DIgzBpUi4i4ZOgH7e/I0bpBxdx+FPnWEXw9YUMxEoUZNyC1Iok8
	vn4naSrwLNpD8pD2ayPW3dZfJ3tIGSuiso5dZv8Q30ha82suBbUG1PQZbKjkIzr22luRbain+XF
	YpAXiZCJYWCI65+giqo2F5KRTEDQIgA2+eHA+hCM51a98g1fPAkgCKO+2AU4o1gY7dTDoQQqMrf
	jK+L+egt0V+aLlIXkijhPzm25T6HwTejcUNP+LA==
X-Received: by 2002:a05:620a:2727:b0:93b:eac0:ddd5 with SMTP id af79cd13be357-93c43e480bbmr141770685a.51.1790288990110;
        Thu, 24 Sep 2026 15:29:50 -0700 (PDT)
X-Received: by 2002:a05:620a:2727:b0:93b:eac0:ddd5 with SMTP id af79cd13be357-93c43e480bbmr141766785a.51.1790288989639;
        Thu, 24 Sep 2026 15:29:49 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c44972febsm37216985a.39.2026.09.24.15.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 15:29:48 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	sandeen@redhat.com,
	agruenba@redhat.com
Subject: [PATCH 2/8] e2fsck: fix extended attribute block checking
Date: Thu, 24 Sep 2026 17:23:36 -0500
Message-ID: <20260924222944.3683556-3-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924222944.3683556-1-sandeen@redhat.com>
References: <20260924222944.3683556-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andreas Gruenbacher <agruenba@redhat.com>

Fix the same problems as in check_ea_in_inode().

The 'entry->e_value_offs + entry->e_value_size > fs->blocksize' check is
covered by the region_allocate() check that follows it, so it can be
removed.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 e2fsck/pass1.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 555429b6..f66a2908 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2493,6 +2493,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 	char *		end;
 	struct ext2_ext_attr_header *header;
 	struct ext2_ext_attr_entry *first, *entry;
+	unsigned int	remain;
 	blk64_t		quota_blocks = EXT2FS_C2B(fs, 1);
 	__u64		quota_inodes = 0;
 	region_t	region = 0;
@@ -2630,10 +2631,19 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 
 	first = (struct ext2_ext_attr_entry *)(header+1);
 	end = block_buf + fs->blocksize;
+	/* take finish entry 0UL into account */
+	remain = end - (char *)first - sizeof(__u32);
 	entry = first;
-	while ((char *)entry < end && *(__u32 *)entry) {
+	while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
 		__u32 hash;
 
+		/* entry->e_name_len is within the first four bytes */
+		if (EXT2_EXT_ATTR_LEN(entry->e_name_len) > remain) {
+			if (fix_problem(ctx, PR_1_EA_BAD_NAME, pctx))
+				goto clear_extattr;
+			break;
+		}
+		remain -= EXT2_EXT_ATTR_LEN(entry->e_name_len);
 		if (region_allocate(region, (char *)entry - (char *)header,
 			           EXT2_EXT_ATTR_LEN(entry->e_name_len))) {
 			if (fix_problem(ctx, PR_1_EA_ALLOC_COLLISION, pctx))
@@ -2649,13 +2659,12 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 			break;
 		}
 		if (entry->e_value_inum == 0) {
-			if (entry->e_value_size > EXT2_XATTR_SIZE_MAX ||
-			    (entry->e_value_offs + entry->e_value_size >
-			     fs->blocksize)) {
+			if (EXT2_EXT_ATTR_SIZE(entry->e_value_size) > remain) {
 				if (fix_problem(ctx, PR_1_EA_BAD_VALUE, pctx))
 					goto clear_extattr;
 				break;
 			}
+			remain -= EXT2_EXT_ATTR_SIZE(entry->e_value_size);
 			if (entry->e_value_size &&
 			    region_allocate(region, entry->e_value_offs,
 					    EXT2_EXT_ATTR_SIZE(entry->e_value_size))) {
@@ -2697,7 +2706,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 
 		entry = EXT2_EXT_ATTR_NEXT(entry);
 	}
-	if (region_allocate(region, (char *)entry - (char *)header, 4)) {
+	if (region_allocate(region, (char *)entry - (char *)header, sizeof(__u32))) {
 		if (fix_problem(ctx, PR_1_EA_ALLOC_COLLISION, pctx))
 			goto clear_extattr;
 	}
-- 
2.55.0


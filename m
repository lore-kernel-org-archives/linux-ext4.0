Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0610540F73B
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 22:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790288995; cv=none; b=XgPTh+eDC2fnPnSDMDPumwTsoPNMm/FGjOnNOq2ti9FD8uyAe0/jsDh9qRwJkDZ1Pmk53jilovbYdJcw+wr0txypE2ZzU0cRaDF5iNnWt8feoBQrJKUIOtW/4+t5uWb5EHWX7qF17ycddDHeB5nQ9yhVxvyISEgdblonk3hIeWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790288995; c=relaxed/simple;
	bh=p4nXpfoqtEO/7pgk84Gd5u1p/zkdwQCRHndegxEOGzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLaTS8Npi64WwDS2p97fZpirMuzYY5FrscCmrN4UOieL6b3qVkESTqbUHidOqUtsExgmC5cnI1xt/1HQxi0mNERKGA2H/p+kMz0Te1n5jUuiEruWDJGYD01MTWHHVlv+JfvZLLqO7e3JnDcwQWHTuMY4zq6MA37vxZPL8tCyKh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BAPKda22; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OYCAy0CK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BAPKda22";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OYCAy0CK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790288992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5p57mMRlnlaa7EgtP52VlBRGCyHIZngOUyWVhdE+mZ4=;
	b=BAPKda22y3rCqPgDMuMq3u4Z6MNeIxFqr60fVW4iiWQQYSHn42wtdaNNoUvEEJFNZwo2R0
	dDi8eXtBt7Sl527vDq4tfywfb+uqiUe4F3zTjfikbbn5cBOwOZ+gcXGm+W8/ddn4LI56bp
	FMQ332gd3e8w1+8elF7RYLCS405oRw4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-DjdS-0UtN_2-nKRJZROuWw-1; Thu, 24 Sep 2026 18:29:51 -0400
X-MC-Unique: DjdS-0UtN_2-nKRJZROuWw-1
X-Mimecast-MFC-AGG-ID: DjdS-0UtN_2-nKRJZROuWw_1790288991
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93a05d645acso58173085a.2
        for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 15:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790288991; x=1790893791; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5p57mMRlnlaa7EgtP52VlBRGCyHIZngOUyWVhdE+mZ4=;
        b=OYCAy0CKFE8CBqtOBam1v8IlPD3PeeqhkwB7GggNSc+CH6uiXkVPNl9+wmE+aN0gzi
         fMDDokvyWj4XlVHcCCoevtlUtG2VwWmlV9imTa0Fw1k6Yvxl5IQTIXimQvsigMMujlPP
         hNPilu77Ccuen+/wXhtyUuaFlgXFYRg9svCTkPt5yD7IJjQ2Pd9Jkaoi6rfSQ5Xim3QG
         yT0JMtfxrWbh7lpKW7ONGCN5NqCozoda4nKxCGjlMy49w83RFzZBJkuzjx5FVyolw/FD
         X9BF7M6CDcBnWJsz9A/hgFFtJB8vbOQTDEdeeF8i1Dwfy1AVIgkJf5mRH6Azsl4CIHJA
         MNAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790288991; x=1790893791;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5p57mMRlnlaa7EgtP52VlBRGCyHIZngOUyWVhdE+mZ4=;
        b=Ddpui3rnDSUAOTVCShKckpQhQCJeTfw+8/kRdUJ4yUA4Cpf6L+uHmHPNVX0y48WGT4
         l65b22F/COSnvFChUCghrHhG5QU8UiFteZD+uoMcsrBkGsMTWudSNdq7pIL46ySrjM80
         T8tyUlvroJ3IpQPFq6kQEumaL+fJ38EFWsJ54foJ72aynZLPACsXFRV893TFCIXJJTC0
         xb+v7nyJOcB6B7s0ptzriHOE0HVeesNActDdCXPvdh1V/iaBdhPpyQCbCFVKF5vmKi7H
         rpqyu2RwbnOMDX0GOorpTNBfE2Q4JUPTTTP35OY+MiF8Moy7f2ubjAJAiwqncqKXG74B
         mN7A==
X-Gm-Message-State: AFuF++mRMLktqps1rar/1lGWrUG+sVeYYyoVz9p2iW4mCy5gNtjSkoz/
	TXZ42uIGDvw8il9HgAp5wIsM10Q1gPF2r6nckyXqU6OLpPC0Yx/XVfWnzs3QKWqGl0rv6fMqxlu
	CqewpQWbbC5y3wT4NkpSL3pOYNVJ1BSmtB8r415LF186t9WWKoZ1PN4s6QbANjl7yCCBm1sQme9
	5yq3xHlbFsoIqQZE/5Vqw4pwDctG0nUYOpJ4s4ixKd03ACJJci
X-Gm-Gg: AYBFou3+aDqFNOpGHXoylVpwKrwGk5hCnfnF7yCzBguqiMvLMY6ReDsUl/ySlbZ5OiI
	X6CPuFWt88Zofw9K8FYmFrWOFski8dpnvtpGrHUqt0ZAUu2IgMpzFXZaw3FmUkP5TNyysycFaeV
	55BOpIzd8CCptDMfULN/e5fkD2nuKCT/jEL183q1ewyfr05EQoz8Xc0x2aKt64lL1NAA0SGyjBj
	Y4A6x+CxF155Smhbo8Mp8S04mAVrfSBECWSDBPR8pStK+TN5Q9zaIrDsDRNiKmjkgI2XP/YlcDo
	mjMHq/DCI47KalEmp9DzGDnel9uS0QXwkNoqTpj9an5ZJUcO2Z/2zTRskrPRBas7brpk//F4ZSB
	mfBTJHnI1MlpnmAtI0AeWQYU2WTuiPI+MKVuqVg==
X-Received: by 2002:a05:620a:2954:b0:936:d360:2eb7 with SMTP id af79cd13be357-93c43bb9eeamr132128185a.20.1790288991204;
        Thu, 24 Sep 2026 15:29:51 -0700 (PDT)
X-Received: by 2002:a05:620a:2954:b0:936:d360:2eb7 with SMTP id af79cd13be357-93c43bb9eeamr132124485a.20.1790288990709;
        Thu, 24 Sep 2026 15:29:50 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c44972febsm37216985a.39.2026.09.24.15.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 15:29:50 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	sandeen@redhat.com,
	agruenba@redhat.com
Subject: [PATCH 3/8] e2fsck: fix ea loop in inc_ea_inode_refs
Date: Thu, 24 Sep 2026 17:23:37 -0500
Message-ID: <20260924222944.3683556-4-sandeen@redhat.com>
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

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 e2fsck/pass1.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index f66a2908..e47e3b04 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -412,11 +412,16 @@ static void inc_ea_inode_refs(e2fsck_t ctx, struct problem_context *pctx,
 			      struct ext2_ext_attr_entry *first, void *end)
 {
 	struct ext2_ext_attr_entry *entry = first;
-	struct ext2_ext_attr_entry *np = EXT2_EXT_ATTR_NEXT(entry);
+	unsigned int remain;
 	ea_value_t refs;
 
-	while ((void *) entry < end && (void *) np < end &&
-	       !EXT2_EXT_IS_LAST_ENTRY(entry)) {
+	/* take finish entry 0UL into account */
+	remain = end - (void *)first - sizeof(__u32);
+
+	while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
+		if (EXT2_EXT_ATTR_LEN(entry->e_name_len) > remain)
+			break;
+		remain -= EXT2_EXT_ATTR_LEN(entry->e_name_len);
 		if (!entry->e_value_inum)
 			goto next;
 		if (!ctx->ea_inode_refs && !alloc_ea_inode_refs(ctx, pctx))
@@ -429,8 +434,7 @@ static void inc_ea_inode_refs(e2fsck_t ctx, struct problem_context *pctx,
 			refs += 1;
 		ea_refcount_store(ctx->ea_inode_refs, entry->e_value_inum, refs);
 	next:
-		entry = np;
-		np = EXT2_EXT_ATTR_NEXT(entry);
+		entry = EXT2_EXT_ATTR_NEXT(entry);
 	}
 }
 
-- 
2.55.0


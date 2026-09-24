Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D345409298
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 22:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790288998; cv=none; b=sRb06EihIEVeW9j4rbxfO0ydKR8XykiONumSh7/LjZPNRJNNHwlWijec+vmrBFZmG6y8KtaBEF/z2YfXz3xJVT8XBM1UzB3Bre5yUa1jvL4c6hInPiF090JLo+w7tu5dri21okcONDEPWzr6Dh6BF+wI86H6kOSycjUrJCPik2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790288998; c=relaxed/simple;
	bh=JAv4eCIf9DAWqH1mt1mZ4UR+MvLY6DLtquzfEX3xSeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCD1+xHbG+yhHoR0P/m93zDvIdpGqkB570NPXdN0TaSxfRJ0xqnJcDzK/xu25Dk8UAQuXGXON7c8RgtBk8+vNf0KJOMVMXNyaR5MCuoxq18HY1ZqzbSxs0f/oByweZwyTBf3XLOYr7wAHKeRoTWCjQ29Vts3X6JqQZBmgF9HNSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LgB5nyfp; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zwv6qwof; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LgB5nyfp";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zwv6qwof"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790288996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RRnKSw29LPfBR39OwnUDPjIAAzlsglHeeVWlyGhlZ48=;
	b=LgB5nyfpNekkIyqb1AmUkoKtJgK/kh2AaFPLMQNGCZcqdx7T7hbShD5I97m9ZZVxv8Wl18
	eDvmTxhjMUvY1ecOiWtwjLEkQpq2kFn0zucH+73STp73bpo6w9hcX2FFKJWHEnVgRACOGS
	+5rbMEL1jQ0KzboYhTMVVkfYoTKy8Ho=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-vTK2QgKXN-WdEjsjYUSDvw-1; Thu, 24 Sep 2026 18:29:54 -0400
X-MC-Unique: vTK2QgKXN-WdEjsjYUSDvw-1
X-Mimecast-MFC-AGG-ID: vTK2QgKXN-WdEjsjYUSDvw_1790288994
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93a1de6d5c3so67865285a.3
        for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 15:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790288994; x=1790893794; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RRnKSw29LPfBR39OwnUDPjIAAzlsglHeeVWlyGhlZ48=;
        b=Zwv6qwofedw0uw/RP8eVF6jSlAYRmQ0mmlb/PD4IICKdDS58CMPSRST0YEJ4hLm+mN
         Y75Zx1Pi8KFjfKQDFqZprmP6lLkX9WXOp2OoJBvEIIg6avZAIG8XELS0J1J9P2IiKhwj
         pxcK9LVvrO0jYKAOM82Vo625okNCYaQNWanhULIbDzLaR2zdmABFTfBE+AqB1TtXt1v8
         bS3jCrUQ1QwsFhyq52N3RAGz/UTCa9qL/lrflz9lJ/CmRq6jKWQ5rW047XfJ8QqQJdZP
         zi4WA0z9wYHAjFDhHWP7yVhcAYE0CaRoEd/Yr/Kw7UOL/KZyWnpWouDfRLCo1c40atst
         oCQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790288994; x=1790893794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RRnKSw29LPfBR39OwnUDPjIAAzlsglHeeVWlyGhlZ48=;
        b=lqlN9csNUNtfS9uXr1nFjyUqo+n4cY31QlbqpS9kdUtWnBN1EeZ9vJcXy6jmuXQO/k
         /ZoI902QrOBjtq00ah2rcfepS2HpHuHFkyR2H3uhP+rTxdweTIki8YHwdjua+xhqbYFI
         uebW3t2DMrtx+pxIdU6nDxbcOW9zhWJK1gAa76rr2mvSzYe7x3MwLlSFstXxo95t8l4k
         iNboYGnzlm1xkr/orlSK0N/DLl7nWLrCAGR67WPr3Mkb5Tq6hy37o3RXMy+dy0ihXK34
         VcR2Tt1GBg9Fn+2irDwscElhVoizdvf0mGDCFXoAvT2LRKiizWbBZOIDSaley7mFh7eW
         dk2A==
X-Gm-Message-State: AFuF++lzwZLPJQ0wrpMHKglo+m9OWdsRtXV2AxK1s7Cw90dOd8Pwlrsb
	0Oxuo5EkVzhNt+QFYuPh7461BsQ4sa4r0ztGfkKRdz0WxGt10Sc6q70ftt+2N73vW29pPeTF6+q
	FSipVq5T8NmjhGbHdRWAGrxGrdFDjYgM+1af8Z3PNYRFrdmO3v7eoNtki6xj2biuXTodpk6q1Gy
	AehSoVcn2OgOFRRiGtW5UrmzvbZms5AXmtDIlXEs6ILCWnSu7A
X-Gm-Gg: AYBFou3VmnNQIUJbQ6KTjTY/ph6OZISv2fnqDA+Me/78k84XttJWD/2Jj2lSg3514c2
	Ws8zMinhqKcRV44C9M2c0zXQZe4vY/T3R0cf2/uXWsW/vap/3DkQjKU/qGjcYhfKn8N2obDVV2N
	ahDeG9ytGaoBD8HuiBaNrR84DBa2/NPpqEZRmVZB07xGyCsOtVkMIDDVVkj3iWz2Gwp9eiZDxon
	IhrSvj7iL2PzqTPl6JXo/yjktkaLs6hQysTLqQM2mNWQ7Kev5T7TmYT+BGQt+OuHuAoP7/AIaA7
	VNp5LswG3f3hn6pJ3WQrXdByjBmHJg3JyFCduvIZxG9KKGkupD4E+d0DXCNO94njxZb8+OuVrDC
	XBPhiLZn1tyFOe973JAHw/YjzlL0M3sQaQ/Okrw==
X-Received: by 2002:a05:620a:700c:b0:92e:bd39:9993 with SMTP id af79cd13be357-93c43e0e3ccmr120933485a.31.1790288994352;
        Thu, 24 Sep 2026 15:29:54 -0700 (PDT)
X-Received: by 2002:a05:620a:700c:b0:92e:bd39:9993 with SMTP id af79cd13be357-93c43e0e3ccmr120929785a.31.1790288993822;
        Thu, 24 Sep 2026 15:29:53 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c44972febsm37216985a.39.2026.09.24.15.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 15:29:53 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	sandeen@redhat.com,
	agruenba@redhat.com
Subject: [PATCH 6/8] tune2fs: fix ea loop in update_xattr_entry_hashes
Date: Thu, 24 Sep 2026 17:23:40 -0500
Message-ID: <20260924222944.3683556-7-sandeen@redhat.com>
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
 misc/tune2fs.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 2d85fb70..53a7a1b2 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -774,13 +774,19 @@ static int update_xattr_entry_hashes(ext2_filsys fs,
 				     struct ext2_ext_attr_entry *entry,
 				     struct ext2_ext_attr_entry *end)
 {
+	unsigned int remain;
 	int modified = 0;
 	errcode_t retval;
 
-	while (entry < end && !EXT2_EXT_IS_LAST_ENTRY(entry)) {
-		if ((char *) entry + sizeof(struct ext2_ext_attr_entry) >=
-		    (char *) end)
+	/* take finish entry 0UL into account */
+	remain = (void *)end - (void *)entry - sizeof(__u32);
+
+	while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
+		/* end->e_name_len is within the first four bytes */
+		if (EXT2_EXT_ATTR_LEN(entry->e_name_len) > remain)
 			fatal_err(0, "corrupted extended attribute field");
+		remain -= EXT2_EXT_ATTR_LEN(entry->e_name_len);
+
 		if (entry->e_value_inum) {
 			retval = ext2fs_ext_attr_hash_entry2(fs, entry, NULL,
 							     &entry->e_hash);
-- 
2.55.0


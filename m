Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB54408031
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 22:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790288999; cv=none; b=TnPahlcOjT8GhQr/jh42FnqxqcW+xWbfV3U0IDa8UbyOULkwCEva70cG4EKwgp9ObSkvX7mOzUSQjlFWu9h3064I4IwTTamvo7F9LsWzrmYHpaqzkd+3EYqDKAf1m4EBUk/RB7MzRbVaUqb4Ht7DUMHo1cYmVm8RPfznNXlzQv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790288999; c=relaxed/simple;
	bh=UdERNbAB8vlra4wXL0TO2IlxSkvg4HTfl53kERB8wy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IP+uPqA1a+eOx5uZ4t+4cgd3+YXd4eZY2V6/hDGvNPnT7/KSeSikLRxo6or85dDkqLxJGJYe9n0usQDrMR8PukXkFaDuK8BxUb3s2V74IWHE8tGjsHJK8rISHIpnAx/SeD0joov9JAwMpSXiA/hUjpi2Dalzl0Ff6RWuAYVSivU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DViykgxw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VZltkrsn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DViykgxw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VZltkrsn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790288997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xMcSTPpN5kocTVflAfMX/xt5pG0WUj+FRla3DJ1xx94=;
	b=DViykgxwD1ymFPlOHaQv0eBB+pa5m/46p0QfZNiOkluXtaMtNASffa50Map7URvGIY/KhG
	wNn2RLJQ6m8BsdV+I7YVf2xQqFS1iHWe6rc34/9Qso3S+AM/t9ygtm8G+HeHF3RzU39mh1
	IqjKySeoj7X7Fr77U8cGCT8Sn1ymNUU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-696-0EkR1kx0MBelTyfSbBnWew-1; Thu, 24 Sep 2026 18:29:55 -0400
X-MC-Unique: 0EkR1kx0MBelTyfSbBnWew-1
X-Mimecast-MFC-AGG-ID: 0EkR1kx0MBelTyfSbBnWew_1790288995
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93a183a0e93so64303085a.1
        for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 15:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790288995; x=1790893795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xMcSTPpN5kocTVflAfMX/xt5pG0WUj+FRla3DJ1xx94=;
        b=VZltkrsn13iaErBytvAt656Ky/i2+xuKIH++3pFY7XTOsh4BC2+TwYDDGPBSeS6G3q
         gRZOFdTG+x4i/IJUrgriq4CM/x/5mAj9ZbmW53wNpkYx/dQYwq54RGrvGcCyYxhbdodX
         iD0CF+TJ5IUo+gIDcYLw5DvopdjruS4t74kxRDTWV9XS5BYPMdgVO+lABULh8ZlWcp1u
         ikfqk47aiP/DbmNWZmGbYYo9L0eGdQq1+66BohslNqsZrg7ucbGJuzn0gvQ4gC4kvNAm
         22NJ/j+Nvy3jjouaJRQsFw628fdGsccY/dIu9vkdk+ws0HylF0u/h/I1Jm+ZkgpzvRBT
         TdnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790288995; x=1790893795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xMcSTPpN5kocTVflAfMX/xt5pG0WUj+FRla3DJ1xx94=;
        b=dxbx6NbeeWwgB2jKibdlp/8YLyjNoC+Z1IX8jbfFuODz0AMig6w445vsCu+80P9e/K
         alhlQKV3YKF5WJ91DXs6TQNpa+ZMWNdq6ZWScoN+DEuo2Djnl2ajmQm71V8QG/owudV/
         1mnVDqtTG57p47PcvPPzusbFn5x+lLrRJuVEc6b+wTdLrdt+oZxC5o8AL7dOX3EkO/CZ
         vIXTZky3sDdYcLxueVawz4DHP6yiCiZcwpXxg2pNduUM7ZT7hOxCkTNRaqKOrt4qc7Qa
         aV1SIAESyOVRdV3jwRTE0esdRkGSSrgmAmDn+q9tEDI4PFfe/w9YwifNBX7xyJaXgH86
         YhEA==
X-Gm-Message-State: AFuF++kS7o9ii1UfK19HrFL2YHcLHfr5Yk2i55j5bnfBosB2ZDwY4+qN
	BjDkv5lHqeE+fJrwemCqDD6KfcO3YVcCwJE3pFxQQuDQmNCLchdNCBLV1MpP44z369XuIIQmuLz
	xZfxkW47BTJz6+FIlW2nCWdLIziok/12lGw3ssURk3iv4UJ6rPVt7YGtdOFXh3hhOtYsgzhkUaG
	P3ok5byWDNB/oJV7p95bTTmu7+tdeKefNOvXiKO7XRJ4BmVGZp
X-Gm-Gg: AYBFou0XI/xMvJDiAO299dVUF7qfVc518S5SY7nUHMKlW/bv1BGXgWet8zMhIh//aFN
	N5lVkXB8ZndrS1LLitlnd0TPnoOWAnGtsM5kkzrbsJc/ztgPwA1aCYxnNNZlDmj4ljGcsY6zZKa
	elGXHlLjLhVXMmrEpO/ef3RRGjN+JU8p9pGpBMAv7XtQb4JmWmL/c78aNIpWMt6GpbQvHF/VLH2
	AO0FRKHwDxf5SjJwEJhwb5GOePwwEJL1UiTNmOLdEtVMtnPMhDzrP7NPiBWsJciY13uM3lUyJUI
	OqAIC2VRFmBptIC2z7J4xMuA3OshMsCRRvX47YTfZENEfxus4YinTP2318bp8fRjMhpO6JEw3P1
	WwTYLOQpptxBQGJXxlWv2WDgu6da3UbMIzFykVg==
X-Received: by 2002:a05:620a:4612:b0:939:5ab4:e6ab with SMTP id af79cd13be357-93c43b8352amr148130185a.5.1790288995140;
        Thu, 24 Sep 2026 15:29:55 -0700 (PDT)
X-Received: by 2002:a05:620a:4612:b0:939:5ab4:e6ab with SMTP id af79cd13be357-93c43b8352amr148127185a.5.1790288994695;
        Thu, 24 Sep 2026 15:29:54 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c44972febsm37216985a.39.2026.09.24.15.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 15:29:54 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	sandeen@redhat.com,
	agruenba@redhat.com
Subject: [PATCH 7/8] resize2fs: fix ea loop in update_xattr_entry_hashes
Date: Thu, 24 Sep 2026 17:23:41 -0500
Message-ID: <20260924222944.3683556-8-sandeen@redhat.com>
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
 resize/resize2fs.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index c8964af5..49aa039c 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -2039,13 +2039,28 @@ static void quiet_com_err_proc(const char *whoami EXT2FS_ATTR((unused)),
 {
 }
 
+#define fatal_err(code, args...)		\
+	do {					\
+		com_err(__func__, code, args);	\
+		exit(1);			\
+	} while (0);
+
 static int fix_ea_entries(ext2_extent imap, struct ext2_ext_attr_entry *entry,
 			  struct ext2_ext_attr_entry *end, ext2_ino_t last_ino)
 {
+	unsigned int remain;
 	int modified = 0;
 	ext2_ino_t new_ino;
 
-	while (entry < end && !EXT2_EXT_IS_LAST_ENTRY(entry)) {
+	/* take finish entry 0UL into account */
+	remain = (void *)end - (void *)entry - sizeof(__u32);
+
+	while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
+		/* end->e_name_len is within the first four bytes */
+		if (EXT2_EXT_ATTR_LEN(entry->e_name_len) > remain)
+			fatal_err(0, "corrupted extended attribute field");
+		remain -= EXT2_EXT_ATTR_LEN(entry->e_name_len);
+
 		if (entry->e_value_inum > last_ino) {
 			new_ino = ext2fs_extent_translate(imap,
 							  entry->e_value_inum);
-- 
2.55.0


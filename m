Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78087408031
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 22:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790288996; cv=none; b=nuIFmRhF+YPx5UoDylUAlbWeZuy/jSnVJxZvd0o4eT3FiXyFsvssB3xzH9pnUYZV7Yaveskg77dyKO2nSCBIdlvsk35JVqumW+9DsW8mpil+npVna+3CdqRQv+RzCzNZiViHLb7PVvuPNlnK9C0HlHdri3yWw3FX5zWYBP7AUPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790288996; c=relaxed/simple;
	bh=VaR0LHHzy+BPFpibJZDxbc+2EhNc/NiPSGMTWqdYFBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqGbGLn/ol4nSJkDrLLDEZfdHPk7Ffxo5QIgUFwIINvIib0BbOkluNQeXvEPV4dut6S0HblRuqEtPdwN034Hy7UCmj8HElRDmmXWfgbLK99KZ/NOm93pgR7yEq0uQ6j5e1CSZMQboEd5XyYlsAng9pvJjc5eMfiz7s1grV/5p88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fhxri+hQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=kAPAj8M2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fhxri+hQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="kAPAj8M2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790288994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uj4ZEezBbLqzG6SLUO8frwWEZvEoztuY9E9eoB5GByg=;
	b=Fhxri+hQIl8zZn/Hg3Etahi8et+r4e8pJPRNADB66Arxv0QaJLPgh4/ZiZv9xB6SxZf2J2
	fOGYL7qjziG6AzpQmCB39fADQ+VRTZjXkoZEXNfNIPJEOSDDfVD3jO52ehwkViUzqijFKB
	QKTUpE3b4UMp2KAGgll4hHODI8BrX24=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-yIQgc4yhPPi4hz8g4PhLBA-1; Thu, 24 Sep 2026 18:29:53 -0400
X-MC-Unique: yIQgc4yhPPi4hz8g4PhLBA-1
X-Mimecast-MFC-AGG-ID: yIQgc4yhPPi4hz8g4PhLBA_1790288993
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93a3f673221so79249785a.0
        for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 15:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790288992; x=1790893792; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uj4ZEezBbLqzG6SLUO8frwWEZvEoztuY9E9eoB5GByg=;
        b=kAPAj8M2H/+zvrSEM9mH81sqJGS6iVJmo5VIa4bLkrhnZOsXaF3fXctkmvhiGVN0d+
         1Ij3cnPp6lbX17bPKuzuZ2ks47ApsmXA58GrRlvl72KtdohnthNvMKBEMnkAxyXMwyYw
         U4Wj27TRwBFP4WPoL21l1lN4gsyUq0F4q27/RxboHG6dUJlccDUA93HtN1bTedmkEBAv
         XjtG8adtp+ykV7v+yBLRpbs92YApPg4GFmGsle6UkO5iK7Xe2mvu2vXBRbgAhOC+wst4
         jn6hKUFjsLQDeoNyqn6dTjh5L3A/wFHhFQTQQC5uRVfmAs7yP9ZTUf/h/bQf7nJs8AvN
         /AFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790288992; x=1790893792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uj4ZEezBbLqzG6SLUO8frwWEZvEoztuY9E9eoB5GByg=;
        b=WyB9+y9EgchUixou29Gakyt6s1IIBPKb9j1fVkCtwIKhtnTpBwYu4GK3ohRk6SD8ns
         rLHc/TBE9GkgBkkYw9P1IS4tt+EzvJ7pz93071KzmWx8DABjfAD00eNp1tUYc2Mt6giW
         ubTcOvF743AXYvkcAVsujboa26svvJvewORNqJjXJazHCZnzMPAjc96AqIy74b/RZxTN
         IQ85oj70/JCLo5JntBGemqtQD8FA5QU8CcgybvzXdHWRrRN5XqyIEeaoYqO/bt7sa7e0
         kb5EeKFNFfESqxlveJTfVnyaX6CxrdOlgIajQeL0V2+1/vqgzBhCGks5xNaS0M5ntXHY
         Cnfg==
X-Gm-Message-State: AFuF++mNQutvqrPxKitRYlDh2Ej69umBzy2b+UwfddYQELYXgq9vYYAg
	BWEdiIOJ3oIpfv3NBAla/AT3D0a5nzdRuA1mroEPfeeqq93DQvkm3zfObZ411M2In/ObFbPEGtT
	TCyqAmLPNlBUoZ8Z5PKQXfELMtvXf5reS7DzSdmHC1Ya8kDFyF7jvHxBDHVgZxNB5yOiTa6OajR
	stZD/aXkiHt01umiFXKbtoQgRXx1IIijKRetpCNCJykMe9Xr93
X-Gm-Gg: AYBFou3l1B2/3noE7gifFow9sh141HZA6hYXataJao9P5QOrE306xzUnlVtHt+FQp+g
	nQAyDU3F6MlX5eQB7GNIkZ+Y5M22fPvjRDlEmNHoMGXW6jmQxwbApuB48aYZdEo0ezZnzjfymv+
	vqyqUOR4diSlfWPVGhqXXXG1ZwqzkT5pN1mxAIkhVbxF+ztbG1EXP6/hXJzp1tZ/8o5YFjFYPb9
	oh5JtyQgwPjDo+ioVo+ZFNXmuxPLuRwB+OdBdORow0lwfS5Xo8AsErCTFn1Fsj+cN9Er8HlQ5FZ
	9nC3tje3uc3i1vqwRiFj+HFahwS4nplfxKnQSiTfoTBuYiZiTWr+ZLED7pPEB6wgNRtmCk5KbUz
	KKJ0fpVJ/FmsyN1EHD2fFiCTzzcnW9LtfSf4+cA==
X-Received: by 2002:a05:620a:6602:b0:939:3a81:326 with SMTP id af79cd13be357-93c47498e61mr29985785a.37.1790288992445;
        Thu, 24 Sep 2026 15:29:52 -0700 (PDT)
X-Received: by 2002:a05:620a:6602:b0:939:3a81:326 with SMTP id af79cd13be357-93c47498e61mr29981285a.37.1790288991760;
        Thu, 24 Sep 2026 15:29:51 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c44972febsm37216985a.39.2026.09.24.15.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 15:29:51 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	sandeen@redhat.com,
	agruenba@redhat.com
Subject: [PATCH 4/8] libext2fs: fix ea loop in ext2fs_ext_attr_block_rehash
Date: Thu, 24 Sep 2026 17:23:38 -0500
Message-ID: <20260924222944.3683556-5-sandeen@redhat.com>
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
 lib/ext2fs/ext_attr.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 7723d0f9..914bff1d 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -163,10 +163,17 @@ void ext2fs_ext_attr_block_rehash(struct ext2_ext_attr_header *header,
 				  struct ext2_ext_attr_entry *end)
 {
 	struct ext2_ext_attr_entry *here;
+	unsigned int remain;
 	__u32 hash = 0;
 
 	here = (struct ext2_ext_attr_entry *)(header+1);
-	while (here < end && !EXT2_EXT_IS_LAST_ENTRY(here)) {
+	/* take finish entry 0UL into account */
+	remain = (void *)end - (void *)here - sizeof(__u32);
+	while (!EXT2_EXT_IS_LAST_ENTRY(here)) {
+		/* entry->e_name_len is within the first four bytes */
+		if (EXT2_EXT_ATTR_LEN(here->e_name_len) > remain)
+			break;
+		remain -= EXT2_EXT_ATTR_LEN(here->e_name_len);
 		if (!here->e_hash) {
 			/* Block is not shared if an entry's hash value == 0 */
 			hash = 0;
-- 
2.55.0


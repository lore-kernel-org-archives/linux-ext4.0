Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0087A40B6FC
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 22:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790289000; cv=none; b=XYBJgnrRvLcFY/8pQhxjSX8IG4KDII8YCFmjIdHVWyTXeEjm8hvWCNdbt/niEBAFkl1yRXunI+tZiy5pVpkxyH8xmg++Ge+tQoKEQe6fIUO1iTxKr5dNAjuRW5bb5PNEKOLKSPfWtnYwcx9VkjoCS8vI5V7MerB0UMYFSVqzOqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790289000; c=relaxed/simple;
	bh=IhRNBpMOLPaoAruJSr1anXnxKzHCYaHizvngL6qDbzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8xul/kMlY1nQpNy7te/l0Ygaa4kDNJqeryaoHErpnVMFd5s/nvvicLSVUj8os0R4BBEWNdCpoJOR3uCkGBIjL0TtPVXzNuJsYh0om7wTDBPStAwiS6zyqz2Ib/T5zqsl+y0jKwh0gDXNBp1XnS/QHQ+K+dMLb2TKPEXM7jDK9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xm2sOxLS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y7d2yDN7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xm2sOxLS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y7d2yDN7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790288998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=maziDtTtq6Bths82FexowbFXRko7tUV+THFhllPjGS0=;
	b=Xm2sOxLSITFE4vBA+/eUxxtxKkI2dN+/H9GuLgb5WLk14LESppYRLLUGX6ckRtRMJz4+ZJ
	U1ATukOFx+NoSwB2Y+eeR0r4ASnFktsba6o1DdlaPn4vBY5IlHZv6Z7DrQ8LpPcxJ1WV6p
	hr9Y3vOhk+uJX2r0duaYPhC9Qy8IP3g=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-TtwmM2hxPV-lXTeBPD4DOQ-1; Thu, 24 Sep 2026 18:29:54 -0400
X-MC-Unique: TtwmM2hxPV-lXTeBPD4DOQ-1
X-Mimecast-MFC-AGG-ID: TtwmM2hxPV-lXTeBPD4DOQ_1790288993
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93a0c7126e7so50948485a.2
        for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 15:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790288993; x=1790893793; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=maziDtTtq6Bths82FexowbFXRko7tUV+THFhllPjGS0=;
        b=Y7d2yDN72NwBuiZE4jPJq2orxX5CUKmIb3pYrmetP8W9GiXAiqV5movHHPlR7LRUqs
         neh+Sypu7AeN/2ENm82GRM6vyIPax/a8VoQPnuF0HC9DfYyqxQOD4R/efLm+0528xx3f
         uulo+xUXP43Ph7V9B5g8T1nMLyVuCYuui9oz2xfE2Fm8Qs4vDOcYznzJv15+zJusD7OW
         vu7SdRDaKjw3xAMBBc+qnx90URl+0CLyLTN/Z4ihTBJjPHZSTH1EmMCTam3mik9/6voA
         dpKfofq7bN5i3DdNDwNDpTKo45Tn6CvNxr7T73v5yD2YqDZ72gZ1qne5J0w9dbJXmSDs
         5yGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790288993; x=1790893793;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=maziDtTtq6Bths82FexowbFXRko7tUV+THFhllPjGS0=;
        b=H6LLLn+PDx6en+yjZS9JfjzrymazJIHpOIb6bp9QOzrkV608FCFBGZjTKl7+CILj0e
         j70zRW/FZAfJiZEyZKbVS9XVYTeG1uxcXOfhHTNHag3w25ZMh+d80Qlus4uTd8rNMVkG
         U3GbPYwQYAKDD458g7gXBZnQx5lmNaQetabxF+U2v/AffDDumF5jVlSZjVDVpc4CzYMU
         d/WxsqQqvwonkiCES3oWPl7eFEcQQaSUTgza6va+ZTexExsVR03W0saacHfLVa7/oWlC
         X9RQLhT8wpgnn97+EO8V53uExq7EWn5gbmvTBK6qPgkWhHSaTruOrVDyr3FnXKjHc8It
         fgcg==
X-Gm-Message-State: AFuF++m4LygAPGsalMOFZnZDkCQQmii56sZibaDuCqTEalnQGsYy4IRY
	vlwmYaNAMu2AOGaT0hLX4XKc0nUHFL2sV7xgA6u4iTn7jUVPXd+eHF8PVo7adXfgorCEZ0NJh7+
	NrtxB4BVUTFu1WIqkbUVH7zV1SHTnclr0qW3tqQ/VCfQHK8EHCg0qO4tT8RN+VNL2y/zJboE3Iq
	KTMbr/1pGNI+27xN23asETDcmbBuPLgW7uLoRWUntC5BvRRZ3w
X-Gm-Gg: AYBFou3J1747ULWvzW+v2zH3y9UK5zwtOXJlZJaKg2c63cYGFHMIECvV8oJiGk/B1dW
	79jTAiKFENG8aT7AkpQnuKz30BUxWbfaROziTwrH0K/i45dzE8UIW5yV6RqoNWHTmZOHT/YSJmY
	plMwyQP1LT1/9YLSiJ+Yb1cLiea8x1lvXJLYumJCUcy+wFPD9c8V2isGpvBsFNHCZWVxlpg3eu9
	gfJL+fIhaTFz4qTccnlMZxw+gJLqB5v1K/lElgCytdiNDgehjFnu31BJguhux1dSot/SfCIB377
	dFWQyNRvQs2g2fPDlfjTJ0HlFzcBjbqlAJ7ZLNMLOgKiekI3tWQDvRYETEwenklrTvtLibqweK+
	Bq/AaGnKl0Milnebar/rLXPZK7kL0RTV0I8LMJA==
X-Received: by 2002:a05:620a:4515:b0:939:6df9:6547 with SMTP id af79cd13be357-93c43d16ae4mr140140785a.51.1790288993355;
        Thu, 24 Sep 2026 15:29:53 -0700 (PDT)
X-Received: by 2002:a05:620a:4515:b0:939:6df9:6547 with SMTP id af79cd13be357-93c43d16ae4mr140137485a.51.1790288992867;
        Thu, 24 Sep 2026 15:29:52 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c44972febsm37216985a.39.2026.09.24.15.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 15:29:52 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	sandeen@redhat.com,
	agruenba@redhat.com
Subject: [PATCH 5/8] libext2fs: fix ea loop in read_xattrs_from_buffer
Date: Thu, 24 Sep 2026 17:23:39 -0500
Message-ID: <20260924222944.3683556-6-sandeen@redhat.com>
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

There is no need for recalculating the remaining space in the second
iteration.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/ext2fs/ext_attr.c | 38 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 26 deletions(-)

diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 914bff1d..6f6d2f4f 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -884,26 +884,23 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 
 	/* find the end */
 	end = entries;
-	remain = storage_size;
-	while (remain >= sizeof(struct ext2_ext_attr_entry) &&
-	       !EXT2_EXT_IS_LAST_ENTRY(end)) {
-
-		/* header eats this space */
-		remain -= sizeof(struct ext2_ext_attr_entry);
-
-		/* is attribute name valid? */
-		if (EXT2_EXT_ATTR_SIZE(end->e_name_len) > remain)
+	/* take finish entry 0UL into account */
+	remain = storage_size - sizeof(__u32);
+	while (!EXT2_EXT_IS_LAST_ENTRY(end)) {
+		/* end->e_name_len is within the first four bytes */
+		if (EXT2_EXT_ATTR_LEN(end->e_name_len) > remain)
 			return EXT2_ET_EA_BAD_NAME_LEN;
-
-		/* attribute len eats this space */
-		remain -= EXT2_EXT_ATTR_SIZE(end->e_name_len);
+		remain -= EXT2_EXT_ATTR_LEN(end->e_name_len);
+		if (!end->e_value_inum) {
+			if (EXT2_EXT_ATTR_SIZE(end->e_value_size) > remain)
+				return EXT2_ET_EA_BAD_VALUE_SIZE;
+			remain -= EXT2_EXT_ATTR_SIZE(end->e_value_size);
+		}
 		end = EXT2_EXT_ATTR_NEXT(end);
 	}
 
 	entry = entries;
-	remain = storage_size;
-	while (remain >= sizeof(struct ext2_ext_attr_entry) &&
-	       !EXT2_EXT_IS_LAST_ENTRY(entry)) {
+	while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
 
 		/* Allocate space for more attrs? */
 		if (handle->count == handle->capacity) {
@@ -914,12 +911,6 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 
 		x = handle->attrs + handle->count;
 
-		/* header eats this space */
-		remain -= sizeof(struct ext2_ext_attr_entry);
-
-		/* attribute len eats this space */
-		remain -= EXT2_EXT_ATTR_SIZE(entry->e_name_len);
-
 		/* Extract name */
 		prefix = find_ea_prefix(entry->e_name_index);
 		prefix_len = (prefix ? strlen(prefix) : 0);
@@ -942,9 +933,6 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 			return EXT2_ET_BAD_EA_BLOCK_NUM;
 
 		if (entry->e_value_inum == 0) {
-			if (entry->e_value_size > remain)
-				return EXT2_ET_EA_BAD_VALUE_SIZE;
-
 			if (entry->e_value_offs + entry->e_value_size > values_size)
 				return EXT2_ET_EA_BAD_VALUE_OFFSET;
 
@@ -953,8 +941,6 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 			    (char *)end + sizeof(__u32))
 				return EXT2_ET_EA_BAD_VALUE_OFFSET;
 
-			remain -= entry->e_value_size;
-
 			err = ext2fs_get_mem(entry->e_value_size, &x->value);
 			if (err)
 				return err;
-- 
2.55.0


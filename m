Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866D61E1E16
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 23:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785541865; cv=none; b=hUgg3VPvOdle07h4+Ervv6dm9vLBM1jbrBLZ+4/rysoZiP6XYGhlPukMF3q+fLoTlAfehRoGhbypZhvJASPanAsrRi3pMC2ioNAH+gK4YwymQ19J3Efb+zqNzkPDEMVfk9kKyDCrt4NciUbiTmMEFwtJvd6ohYepeSmgdCDhYHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785541865; c=relaxed/simple;
	bh=mMwmh8CunMxX79/11+cozJ4+J2RN0zZKe8Q4zjY9iCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUYmLGK3Heidj17D/ECli6jpm3IAGoCj/idwrxVz1xQh1H5+Rz5vUY3Tqg0IWoNzCnCPOsZ7srGR3IwknBlXzQbycDQNXkHnat4Ugf+P3g1oqd+19oi7I4h3F6BEo3ysZPZ1hPpndiufX/5roD0xlGSm1/J/bIQ/SFZVQxFGn2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RDuHO6aQ; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RDuHO6aQ"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-496b7622a83so1857535e9.2
        for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 16:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785541861; x=1786146661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wFueboZLPWAkgNDj6HQNTjnIe1s16kAVfyJgzcPKDFk=;
        b=RDuHO6aQE7keQuWiBLVH6MY6P95jCA4wDg/ZtiQP2DLMO0+COL6+a416GLpJoATyWt
         r2R70CUsnm/hIHnbRvXQ1MfUCMUsXddxSdEqKJXmYBAbS4rIvVI4pfue/4i7oFlh3d06
         trUrH7Lf0+UXfDTqs96Rb7tsiuFj0w8Cxgo68wAiL9koJcuCRdYlOB57yWq3M2bbxClQ
         MweG/1IRHcXoceco8yI9GaYtS1GMxyRVLOL6Wbm0gvo1gI8M7ucqVCj8ehT0laMf/vZ8
         847dDPwpCnnaPv6YHswR6SXkjqFtUsNJ0+Zn6ZTpJ8vlhKYrdfdgkmKTQPuI9k1UwjDx
         85Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785541861; x=1786146661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wFueboZLPWAkgNDj6HQNTjnIe1s16kAVfyJgzcPKDFk=;
        b=Oc7iNx4N8GC4erCuCkPoqLRkLV0rRMVRVqHCK3DE91KSd9GTdMrUU5FTmLJ5v8/LUM
         +H7f/4ju624KO2bnc3G0f0cmFP/VmMBHqt5JJXN2svW4hqpm1FdM1iPTZ6AO6Rc6RVz6
         STTezCclCa2e6KNXAR606Tr7HkupTDFC52iysU39/Zdy60b++WH3qUPLi6hHUnvTLJNs
         BwR41FO5ijdB6HRLOLdp+8nRENcDMM5k+zC2MKRJ7/auNEV4D80bXtLYBemGFMywIdHs
         pnwQT7pDQ0uJAsO2HYSv5uwGKwkQolh9rt0y17Lyxzf7sz2+Usxvd+7hZ083tt8EW/cI
         1Vqg==
X-Gm-Message-State: AOJu0YwHt+oi2Pbawq6fKNfDRIaQjnNqu2LGo0DhzTJkn7XBdRjOL7aK
	kRnBgLQw94xieFNcqfw9EZ3YTuCqxyLOHNoFpjtRsLjyjwmh9P8DbK6M1SYFaN8X
X-Gm-Gg: AR+sD11GzDuyRp2yCId86QVnTKLJA0vD0TIcBnrkObHT6ilSEZZisU5cNn7xazhiak+
	nvsKDfEjHwEqGHKLhKbM0Us8tDofzbO/jJYY9QUOy5giKELdiNMq0SnW+EAPXFtBUdeWVBUTHNr
	325MRqJ6Rgw30sFyCaWyNDqAb5PRiKadP10QpfVMNrzhZM02bu/Y+HNzP52Uvi+LfAdflbJpe0X
	aHzs86Hy+ROHRYj+OUGo1Fdl3SD5Jg5pEfSPQHyKcVB+ld7Gju3Dmzkv2J4yeZRHEwrgeJdo2ZL
	w8LsCKIhpIPmGAFXTcrPB46EoO6mN0MyMUeJ25KbaYSv3gfXGuQ4vfrkfPXNi1i042P/g7xcJW4
	YjRBUk1J8xhPBqDGu4PmI7wO34Cx2kO7C/+uG/8ky8aBBEFiQxsP0mVpr28hGvBKE51O28arr1a
	q9z1rMeKklRfXFPN7YdGwx9WybbQduBeXwgsoEeccA5J8gy/3xP5wiRsWqjjEl402RDzHU57wQm
	iF7Qd96MYtqC1CTlIOf
X-Received: by 2002:a05:600c:c3c1:10b0:495:63e4:7f78 with SMTP id 5b1f17b1804b1-4980c672b1cmr1444395e9.10.1785541861527;
        Fri, 31 Jul 2026 16:51:01 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49807b85be7sm5338715e9.2.2026.07.31.16.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 16:51:01 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	xiaowu.417@qq.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v11 01/11] ext4: validate count against limit in ext4_dx_csum_verify/_set
Date: Fri, 31 Jul 2026 19:50:31 -0400
Message-ID: <20260731235043.44068-2-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260731235043.44068-1-ablagodarenko@thelustrecollective.com>
References: <20260731235043.44068-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dx_countlimit's count field was read from disk and used directly to
compute the checksummed range (count_offset + count * sizeof(dx_entry))
without ever being checked against limit -- only limit itself was
bounds-checked against the block size. A corrupted or maliciously
crafted filesystem image that sets count to a large value (e.g. 65535)
makes ext4_chksum() read far past the end of the directory block
buffer, hitting adjacent slab objects.

Reported-by: xiaowu.417@qq.com
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 fs/ext4/namei.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index cc49ae04a6f6..a283e285937a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -477,6 +477,10 @@ static int ext4_dx_csum_verify(struct inode *inode,
 		warn_no_space_for_csum(inode);
 		return 0;
 	}
+	if (count > limit) {
+		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+		return 0;
+	}
 	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
 
 	if (t->dt_checksum != ext4_dx_csum(inode, dirent, count_offset,
@@ -506,6 +510,10 @@ static void ext4_dx_csum_set(struct inode *inode, struct ext4_dir_entry *dirent)
 		warn_no_space_for_csum(inode);
 		return;
 	}
+	if (count > limit) {
+		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+		return;
+	}
 	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
 
 	t->dt_checksum = ext4_dx_csum(inode, dirent, count_offset, count, t);
-- 
2.43.7


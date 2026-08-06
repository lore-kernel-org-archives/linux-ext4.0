Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F102394470
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 16:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035565; cv=none; b=SOagOKXrMP2cf3+hHhBkpaSk7bvdrao+Tz4Fj7FPrE/OhsyJYfRhxCTEKSkcQcCXz6KGzPAtkKLCJIyqAfhu8ahUq6d5SrM0wV7QOF6bcgH/LroRCkM4W9KOgOlDUT0Emk/HcVfMLwqcVoG4pKn8WGmXgQnap1UWHIzLAZfbVfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035565; c=relaxed/simple;
	bh=kuaP2Ip3RQshQpbYi/ZOrxn5Jrkw64bBBtC+6NgGKu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/zVPCHiPQfy0Rjogt3yb2+OtmGHB3TywXaiTlddyiIDxuQLn1mKmQFuO6Gb+0C4T2iWvWyqcBEVmQqe04Pcl9r29qj5AHssgZR5SqSt8ZOaRRXOcdbGk5GtlpVaSvadjC0egT2Qxa1qCRoq7/33umLfFX6HJR82cSXrXglx1j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S/25BVFC; arc=none smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S/25BVFC"
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5c2dbaf828eso857880e0c.0
        for <linux-ext4@vger.kernel.org>; Thu, 06 Aug 2026 09:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035563; x=1786640363; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y4mp7C2u8iNxOV7vEnH4xyJiQARLq+7PYATgmrobvgA=;
        b=S/25BVFC4tQmExvrcnyrL4T+C1uYJLjrko+D058nwwfiFqQv5R4W5QwuMHJ3X5fpUc
         p4US9nxxhggMLbHAQQ3aGWJfVlACWXvwV1WGbhC3cFwRkG3KZM1sTvSqYadGrEFPNNWA
         Bj41weHqHIrica/WvG7zopeKK1gHUcXYJpPRtPm/Fg+IFrMytw81V5pgI6gc3iwIUJ2Y
         KyI2HDTHgjuQf+hnQ+zpKkfS+f0wYDaM01MNC7CAB2JgbgAfKUmMfvQ/nXZ5O00yIapR
         N3JE1Dh03CaAA2AlVwXwviKgBWMllrr8q9YavlsLMZA3ix9E2e2jJGAA/PHGfLuzPxbH
         HUHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035563; x=1786640363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=y4mp7C2u8iNxOV7vEnH4xyJiQARLq+7PYATgmrobvgA=;
        b=TZEjv4ics58Z6rfKwg/oQciy6NcfFrmJ+W2eUUPo4mZN75YenUPXxiTmOVuPp0o4lM
         +yiV8KC5YkmLRfbqu00NoKACWxNjbSip1YnRrsjnsXp/20MRda/dpMoBOin/5N+4JflP
         iQRiII/0x6KpmURyIrCzLUaRANK6GfHAzNZkJSaaXL2RnMZ79+0j4Gb9cRFAz4GPbPXV
         kfhGg9x2gLBEN6WOvrHNERADYd3Z7MdWvoeSe9YQ9P1SBOfWdEP66b8snOAfHAMkIJ3D
         aXjUPJAJj5PI1dJ1sVGQalYgebzZ3fQxnSRWVyt9fTNtjcsFOooZ+EtPOIwzCecM2OFf
         k1gQ==
X-Forwarded-Encrypted: i=1; AHgh+RpyaCKKWTWpip8PPFbBXF8SMenblSuexW0D9AZ9JMCiTbDLL9sYIlD3zunMqsodXQlIl1Usq+ueZxdL@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6bXVPu7YQtHt09+iEC0XPhS7JaIdJWIgdT349Tl/VUGwEJ0gH
	EiKsmKduCd/nOVwSuUNQ0Lq2z+L349YNvQ4NV0m3b+JqpyUbWzRGFyQ6
X-Gm-Gg: AR+sD10VfLKKLucXnSHNolgyHOQ9PUckRA0JkDbUB006byAWGamoffgEdu7b2PofFvV
	QkPmUwRkHUh/UNS+uAR3r8ASA3hfl+LBh+L0GffWIirhch4ggJn59HUxpWHPzrkT4Yt0wRlCUQw
	ZmtVeqhOtlQBNegxKqKRIEVbVcp/CNDooAxG1prtGQ9RT0Obgb1qO/tJplbZ2D0OGFm7I043qHc
	BNU00dJMnfferQ74Nmx+sHTaJ3KZpTTmfNQY3SY/NAlDspzYFbyJ4JMwqZyhX6o5pQ1OcgyqNhy
	0MPbFzFJAt1L3MFJU3dTKgGrmVjNTSfBhSd22GoObzeBJK/BgCiHND5NMb+wVcjTvCSXTyZyLXN
	6SonSx0gn2asNtSttGDdz9ShJdMzBzm/fylUC4CQhPhCOZjHslEkkYHi0fikDzJnv/Sbag2tXG0
	N9Icmb0U2xsVuHyGH9a2d5eW2xp7fk654m8tkTo0jZG4O1ZUT7x1s0RamioyRyjUSt3fmT+BJEm
	ekwOII=
X-Received: by 2002:a05:6122:8f88:b0:5bf:b3a0:388c with SMTP id 71dfb90a1353d-5c3d91849cemr2184457e0c.6.1786035562798;
        Thu, 06 Aug 2026 09:59:22 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:22 -0700 (PDT)
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
Subject: [PATCH v2 06/21] buffer: discard BH_Write_EIO along with the rest of the buffer state
Date: Thu,  6 Aug 2026 12:58:29 -0400
Message-ID: <c6e9db48d8d0feb83d4ca29306f4bc1e58f1ee0f.1785951556.git.coshi036@gmail.com>
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

discard_buffer() strips the state that describes where a buffer lives and
what has happened to it, because after an invalidate none of it applies any
more.  BH_Write_EIO belongs in that set for the same reason: it describes a
write of the data that is being thrown away.

Leaving it set means a buffer_head reused for a different block starts life
carrying somebody else's write error.  Like the bforget() change, this is
mostly theoretical today and becomes load bearing once the rest of the
series makes BH_Write_EIO the report of a failed metadata write.

Suggested-by: Jan Kara <jack@suse.cz>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 381690479520..570ce7f495d3 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1518,7 +1518,7 @@ EXPORT_SYMBOL(folio_set_bh);
 /* Bits that are cleared during an invalidate */
 #define BUFFER_FLAGS_DISCARD \
 	(1 << BH_Mapped | 1 << BH_New | 1 << BH_Req | \
-	 1 << BH_Delay | 1 << BH_Unwritten)
+	 1 << BH_Delay | 1 << BH_Unwritten | 1 << BH_Write_EIO)
 
 static void discard_buffer(struct buffer_head * bh)
 {
-- 
2.43.0


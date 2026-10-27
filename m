Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793138318;
	b=v+e+9hLkyk7YkKfunwI+TVaAPpdMkPiZK1+hwDsXCgg7T5QTThy9ZRS29gMEgOE2LddD
	 ukToi8NYQB3gq8+69fSsGUO6m7XmAZRWAXFoHN0MZQs/kAQIVn4UY9HcItkp7AZ2j/3IS
	 qSMxSO0yNWpbfC0HL7HTczRwk5Z3qyyist7a1e23+Zp0PTjlkto8nAyDqY9zv+gTJF6xA
	 B7BUa3EDd2X6chfBMHWG6EcpgSqSvgA1c5Qp2f/f2BpM8LMTzadcAddYo0i2lycpg93jX
	 YJY9JzihIrulHOVykSyKmyf855VO0LrANHocMI7+VWpQOpOBgEp84y/xIcNRYHyjmjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793138318;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iqfPoWTkUvjEoiyLTnmr5mj5KovsR6sHRhbPRdxo4UA=;
	b=rNqP8BYqMhaRSSMBgGPdIOpFKvPKn1JNRKvmLWyd4Bgrtx6sPuDCkPGgs/c8Ato9QrNm
	 NX5qE9iqD2tccYQKB63r4f+vD4LvSc3uDTi+iRwD6jh6c87fbDWSiXNOUKjJyibQaMKj7
	 YWkH2P4VB5XMHIyXJhDUHr8E430d1ePGPtrLfMP7UhdEzrqXigLSeGEkbDk1HJMp5o2xJ
	 FMRFgHGAleDp/3pUppfiGqd7aZqJHs30Ie86IW68KUW/k/JIJ5o6EgBrZNQ65JTCBfKt9
	 TBQejExYqte3oa6sw0ptVlNxR2drSrWk1h5/HaCHyj97FlkndCJ3tTm1sXaP+XB2D+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hHefbI+9;
	arc=none smtp.remote-ip=74.125.224.47
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7B2606A31A
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 21:58:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E7B2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hHefbI+9
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-679aeeddc6bso412355d50.2
        for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 14:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793138317; x=1793743117; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iqfPoWTkUvjEoiyLTnmr5mj5KovsR6sHRhbPRdxo4UA=;
        b=hHefbI+948nzC9V3ObgOm7xqIlu0T2MEDj0gG6avl8Xb2kbhf6Z/cbqoyxSTnA73BW
         CDF5OTDEdklbOqujS6eVhxL5dGvh/C6tEqLgDMTWvMNYjG/xe9C8VnbQomQrlEVPuJFG
         m+SVQ/r0R6uk3NynScu0b7mMuf29mIgeofx6m0l3z2mL0kRhgjYRJbMWyYYrRrbZUIG4
         AG1hLaUcgUGyfeP1pEu8FX4TgOHzM5iAwdAKt4hZbNHbOhfpISpbqGywIGZjvg1dRFdo
         GgL5HVvBjS2vRht/e+neQcTE4BQOXDlg/uGmJh01kZlWUbRinQzJknNHTTrFiU4vjNMu
         iDIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793138317; x=1793743117;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iqfPoWTkUvjEoiyLTnmr5mj5KovsR6sHRhbPRdxo4UA=;
        b=ubzmzGoa5uYt7oSmVQV8dXfirxwyi/1TFWWvCB6c9ASQbJw7M+MgzPq5wjIOiIQWle
         ZiBcQV7eYkNrF8AYtkybfXyQN1aBlFOhCZQdoKkOrEodeCfxVBzomLIPSVo04+FfBAlT
         cIrBuim73HLNxrfuTrCUGblCShtwpRQjaYyLknDk2pfNGOtdgrMcSA2OgktImRI7rB5Q
         h5Mu60xO9DbnrLuNWFbv4kTPl/BAIN5WKAaa0VLgYpEoaKZs5UWRYDpaHYrGMQAvRRy+
         ssvswDdGkjqTdH+wNSo369YYfk9egeVv4cBD1OPyL4J+G0ViQEzhpO6xeKlnbX1SSPkb
         4Z/A==
X-Forwarded-Encrypted: i=1; AKwUvBxcJxOTK19KZmHIjq9LoqAzMbgNf9GACNAUM0WE7vClGlVOX+vtw6Ya+KCKPJCSvXP39aAm0kiJP5U1@vger.kernel.org
X-Gm-Message-State: AFq9FYJzqSOnyPF837HS0zvMowt2H7BHQXa1YsJR0EtgVxVGdQ9TdZZx
	zmUoLZdAUV7omT0oapb9RMItOPldH3WdeEQxTBPfV05CretsiNmhgvHr
X-Gm-Gg: AYBFou2oINRee5fIjglTK7QQFxeFKQTwY8DxB5ckXTNlfQ7mkL4rN9j4Mb4ZAxoLrPx
	PWeGgMi4qK/b4ORJGP0pUzZDOZyHpevYNMTJUXFl7By2i1E9NvbciG+AMVaptSjC0AXOvJSI6jH
	YvOkSSR5DGoZfrujGZGOawukenu2ohDMxjun9bq4DTBGSfase6HUFzWRX5ciRUIaJRKU1yI7iMJ
	ouB2e57i0aaXONfF+AexU7YPPsAZ/FeadDoYks1B/K3BmH+LAbv2GVqYU6XzKgti1cuVslDgxdH
	zO9l6hmhtIMx3nah5YlRHbpW1lj/5QKEuMiX+aft4av7RkmzxqrwN3M++y1Vuh/bmdYGhAuBd7O
	CcvOWvat3tr2cOm/qoMwjLFxOffAa+5zrcaEEGLd+Ast8Xg4TADvzMBE3twLSwfzkT5ik1w4R7G
	dNFjY6+fJdlqcAk/FINZPoGZBEHB+Gmj8ih45Br08X5Cr3T/Qwo7LgdQ8d+EzqsyW65TAjASmFq
	NxaIdzZHK9rr4H9Wjyf+m+Qkb322B4RzSDvqgwzIcwMpGw3NhlKFk2k5KhfgatpaJPQwFidu36q
	c0PpFZyD1ouO6Wxkqbgss5DMpTbDFwr7
X-Received: by 2002:a05:690c:a418:20b0:8b1:691f:ab4d with SMTP id 00721157ae682-8b1b5ba3a5emr1705147b3.35.1793138317281;
        Tue, 27 Oct 2026 14:58:37 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4e::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b19e43e1d2sm18903937b3.5.2026.10.27.14.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:58:36 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	bfoster@redhat.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	linux-nilfs@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>
Subject: [PATCH 2/5] fuse: convert ext_map iomap ops to ->iomap_next()
Date: Tue, 27 Oct 2026 14:53:23 -0700
Message-ID: <20261027215326.2693300-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261027215326.2693300-1-joannelkoong@gmail.com>
References: <20261027215326.2693300-1-joannelkoong@gmail.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the fuse ext_map iomap_ops to the new ->iomap_next() callback.
The callback is generated with the DEFINE_IOMAP_ITER_NEXT() macro, which
wraps the iomap_iter_next() helper to finish the previous mapping if
needed and produce the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/ext_map.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/ext_map.c b/fs/fuse/ext_map.c
index 7f04edc33fe3..edb19498d496 100644
--- a/fs/fuse/ext_map.c
+++ b/fs/fuse/ext_map.c
@@ -210,8 +210,11 @@ static int fuse_ext_map_iomap_begin(struct inode *inode, loff_t offset, loff_t l
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(fuse_ext_map_iomap_next,
+			      fuse_ext_map_iomap_begin);
+
 static const struct iomap_ops fuse_ext_map_iomap_ops = {
-	.iomap_begin		= fuse_ext_map_iomap_begin,
+	.iomap_next		= fuse_ext_map_iomap_next,
 };
 
 static vm_fault_t fuse_ext_map_huge_fault(struct vm_fault *vmf, unsigned int order)
-- 
2.52.0


Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFA235F16F
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 13:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782308291; cv=none; b=s3o49L3tPMavYPuyijQttDz8HpziQ9sHDgO0mA9nbhoU5frFKe3a5D5rLdyPSaFxOb+aR2I9KOki0o25+3oFATdufPaP2qAA5m3TI4GfgxTWKGRa3xn+gtthoJ9IxlNHUP2DDiqlsos+e/1skPzo2CLz5Mq0qaLVNAqyHVg8psw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782308291; c=relaxed/simple;
	bh=OThOFHIElOUX1c/ZB6TWjLgE8iB04DaKWfOWIg0SNzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jY/RkqppMIgrmx8Vl7KwFS66iaLXhJpw8/YGxS99wZ0r06OHC5r1H1GTozdlNvaQhq3lIKucotj1qV95qkM6KX3HgEz7IB8sA/pCMCQWS3jlGtJE5IlvrlYQLBs1wjE4CCF4aFjANMuawr9I93y66oEgqPPrDpUKT9+GpqZ3bCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FynhOy6G; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FynhOy6G"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-45eeba68948so724687f8f.1
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 06:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782308289; x=1782913089; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eO/0qFG1J/XyoZlo2kspw5sa44LNbKpl9dfwZgOZg3c=;
        b=FynhOy6GoEY9xqpKGOyXdirXbDmeWfpnKCwQddoNXR9vcqg/RoGf32lCuyomKvIqyM
         8meojja5DmziQxEEnA1mJJP5xZSC0C38MlHwWVjLukOdfn+glbhhiZ0aHVXc1Q++iBPK
         0WEGqFSsyrPgw9NEe33eDMBD6gH6CT61qSw6sjHGt+HF7nfH/tTieE3O5nmrz0sgivOU
         rf3A2dNnBq4dAZWyH/v0NqL+XneUwZB20KBC/F7zqZhFBcbQzcVGH3nEequkyf9MXL9s
         PiWKg2YGPFP3tcoZtSYEnld7NSZ2evv1eqktsK16i6pi8xVG+PQl36M/H5b89m4SukmA
         M+WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782308289; x=1782913089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eO/0qFG1J/XyoZlo2kspw5sa44LNbKpl9dfwZgOZg3c=;
        b=IjzdQvIZ92B0FBk2ZbX4OvkFecykhY5CjAT1TJliKkWLGrHUQTGvbyCZFXX2GQlOKA
         lOs1fzzI0SE5izqwLjoAP57/TfsJpNa9OuHhAGhT/o8Ix+q9OXtWZaF+Muwo0vw3WhLx
         S4fxVL7hASBtCwAh1TZdgaDJkQdEqTI9YvYS1oukzdnHdiPeVS8GkuinozzcGltmg8oM
         PigGyMTMvhQldjndJQouBouOYj8pjl/9ZsJGlKbW61RK9SFvBBDOHNQbneMLy5vVyvP3
         wu4WCJ9Fi1jqxDBSIuDCbDRdXjkC172iofeB8AADFllWU2I1vtMBB6evr8ULB453kThN
         F7BQ==
X-Gm-Message-State: AOJu0YxV08sv8ahhMCsKVcz73n5jHvl0dTasAY5U4h70EqjXaNQrcWKu
	ztZN63D2etRdRQAKxHDhD9caZmB+MPctdYjkn3m9IHDvLgV2OYBei0oyfZ2wGe+/1JM=
X-Gm-Gg: AfdE7cmRR5PO0xiWhZq7HVOmD/N558an2ohLBbuT3HzGr83v7fdMO1LWCVbBk311IXT
	/jHqMgT9DR1IIYlt6ukHc7x0m8dxbiPYqmKRZlprT9N0YfFyg+X8gzYIY1XV64WRmofiCfg5RGr
	ueUIFFo1eTAmH9MOuXvqS2hRuPVmYrxZEbHajl2/hbd0/7CU+KBv7EHCt2+18lDP3WlFQ+WNGWt
	UVTNKLNhObQEALOoBWe/sHm3IRctJB9vkLdorBcWVMOtsGY40M29J254od1CmNJfMAV9rYmG0mQ
	wyeZuwT1zx2xja4iW0r0Geh/F9xQNSk93Km/BuCzSMQ5Hh23DyHCDdZUFc8AOV1CjrbVmiTHV2+
	/KJcqd3oPFfPA9q+J34D9XULW1hoktbvXKasJu4C2UTRGoeUfvLHEfOMDBN9fToyiRLM/k0SYYI
	vr1Ljt4OHAY1pYwxC/9NYy7uDkYcjoFP5+IyzaEZesNEq0
X-Received: by 2002:a05:600c:3f18:b0:492:4d52:315f with SMTP id 5b1f17b1804b1-492607f5933mr52602135e9.0.1782308288391;
        Wed, 24 Jun 2026 06:38:08 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:8ee:1201:acf4:9ddd:6ede:2d9a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923fd33dafsm501416155e9.8.2026.06.24.06.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 06:38:07 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v4 06/11] ext4: preserve dirdata bits in get_dtype()
Date: Wed, 24 Jun 2026 09:36:35 -0400
Message-ID: <20260624133642.18438-7-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260624133642.18438-1-ablagodarenko@thelustrecollective.com>
References: <20260624133642.18438-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Mask the filetype with EXT4_FT_MASK when indexing
ext4_filetype_table[] to avoid using dirdata bits as an index.

Preserve the extra bits
stored in the upper part of filetype and propagate them to the
returned dtype value.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/ext4.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 98603aa44693..2f29f50a12ac 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3046,12 +3046,15 @@ static const unsigned char ext4_filetype_table[] = {
 	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
 };
 
-static inline  unsigned char get_dtype(struct super_block *sb, int filetype)
+static inline unsigned char get_dtype(struct super_block *sb, int filetype)
 {
-	if (!ext4_has_feature_filetype(sb) || filetype >= EXT4_FT_MAX)
+	unsigned char fl_index = filetype & EXT4_FT_MASK;
+
+	if (!ext4_has_feature_filetype(sb) || fl_index >= EXT4_FT_MAX)
 		return DT_UNKNOWN;
 
-	return ext4_filetype_table[filetype];
+	return (ext4_filetype_table[fl_index]) |
+		(filetype & ~EXT4_FT_MASK);
 }
 extern int ext4_check_all_de(struct inode *dir, struct buffer_head *bh,
 			     void *buf, int buf_size);
-- 
2.43.7


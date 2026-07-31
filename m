Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B287025333F
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 00:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785459335; cv=none; b=EZ0oa4+sOixA8iJfRoZAnv88qJ9hS1pd3n9lRlUemAZKUImehi0Yv3b4RcnpwQcEiq4FyUvh4FzT4ECXt+OQYdLbVgm5ZP3Vxd8mAbvl7sEYyGsrxOoFQPhngyyVOD2PiHEW9VMR+GX1ugMOEItNAIvC6PfbRX3gkdO1vW525y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785459335; c=relaxed/simple;
	bh=mMwmh8CunMxX79/11+cozJ4+J2RN0zZKe8Q4zjY9iCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCkBrPSwnAGECtmrqixydwM8JogHcbQkAT/br5meTVc7r/nZuwXzWbjCvCcC/Yfu5Uc7Ti6gZ1RCOZOsNtkYMAaBLJMx4dWFFWi3aPZB6KYO/VSDuQO4otwXo2yZdNF2NdXX4H0KIO24yjDzyIaJSAhoshFBq1O1bzsvwQ9WIzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n6jOr3+l; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n6jOr3+l"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-476a130c138so315018f8f.0
        for <linux-ext4@vger.kernel.org>; Thu, 30 Jul 2026 17:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785459332; x=1786064132; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wFueboZLPWAkgNDj6HQNTjnIe1s16kAVfyJgzcPKDFk=;
        b=n6jOr3+lQBNQFnS/fHOlFm4L1P5T7EEUWPICydAh/Ruktit145fhW87edk24fNY629
         BSr1Rx8luXfVCxaPLXHRqq0E560X7E9lP/6kkq972BQQ050nqeBOfhMCyf+n+OVkgqr9
         0bTM+ovPYWeA5VTYPwaocViSd4GspC0HaETlaoU0BD+ixHuJT/0+gIwysvDHy3dHwyAS
         Y58FffdcDoHN0ieCfrgWvFKgDTSJCfzhXVBY/EsQ9Byrw7wrjkAMzZf9JQN+BMCEjGEd
         7CZv9BVT+wYw3aKyxPwScLg6qJmrmEg2BaAAodA9ZenDh/9MviWD3lGoZ2JtOuNUh5Jr
         jWEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785459332; x=1786064132;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wFueboZLPWAkgNDj6HQNTjnIe1s16kAVfyJgzcPKDFk=;
        b=MvDFXx3yfiSwq9Fg4GnH6JFr1gWA2f2sGdQeeJhpuAZPAr3BRgH72FTlAFazqxGMD2
         8FJw2Z2bssPcrZYVwArrDwh07EWTpo63z1oaKxg5pwiTV9MtzMSKnyQFL7zH/zi33FNq
         ZEx4/CLNzS5HouJVFh+VMvkGVi4cK/2fFkHtCtv0kxXaiZiipQ2X+GLvCpkARiZ42XZf
         sc8xqC13IRq8hoH+C2neqtj3rYs4wAJURt++jRBodabpKLiqHqoEFTjWvEzbuFkNEDlB
         IQBztnvAG+b3P3KRDGCFa+6+UrBFWgyRRgCFZEktuS7fKfDkCXvpNcW2KBsuIguz+05C
         df/w==
X-Gm-Message-State: AOJu0YzCV3w+R5M+HdWgql9Ul4usx6O0CLk05BP10sogKacBOcIqUCsb
	LX/jjnvVzGemazzMMe70mdDe9p8UGKCmwKmcqOaUBPasYJan18QfOyNJBF0xVQ==
X-Gm-Gg: AR+sD11uX4swNCjbSD8IxzMVO2R01DS1TOyfd7LG0X3QtVKAc3eM+ZbKfkED/xVEbMh
	UahQPxmwXS1aUMuSrdrCSgxyBHa9liVpjOyBBwAowMThAnh7a3dRJwalNvk/VwLqV7Ez2rquW7o
	TQdVbipXBntX9fiuc+zaeKwqJ9Y0EPJnJEwgv0JJddrWrpdBUyXGOUjiifR0Fzc8vD93OgMU5g9
	Gzr8H2lMBYR15EoREaKU60Brzp8A8PgSjjaGHGYBnB5vEK2e7fgeqTdUFMqbyOTav5wDASdoVAF
	Sn/P2vCHKNOx8VQ4HQsrcSHauWUY6RP6jFwY/g6p3VAUYSGl7Cc123BwajI5V64ZARUnsHGrplZ
	iYAbVthLHHu7Q+7g7M+SFOSCoBIFMRgHfTVpuSOj0ZeXTirD7nGBKAvrcoC3fkti3sdZeKTWFiI
	T0uUJwO4F5mP6Nv6P/9qBJZfSC3NTmY80W9Bw+Wi7dOHCMnLk01xFnzeJOH2no/rikQPyiFNeDw
	briH75PC/TL6JprwYek
X-Received: by 2002:a05:6000:18a6:b0:47f:773f:2d68 with SMTP id ffacd0b85a97d-47fd2ac9f8dmr396981f8f.16.1785459332054;
        Thu, 30 Jul 2026 17:55:32 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fc88d6f4csm11975801f8f.2.2026.07.30.17.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 17:55:31 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	xiaowu.417@qq.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v9 01/11] ext4: validate count against limit in ext4_dx_csum_verify/_set
Date: Thu, 30 Jul 2026 20:54:18 -0400
Message-ID: <20260731005430.36801-2-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260731005430.36801-1-ablagodarenko@thelustrecollective.com>
References: <20260731005430.36801-1-ablagodarenko@thelustrecollective.com>
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


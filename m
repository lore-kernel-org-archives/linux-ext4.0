Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C453B27EC
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 22:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621685; cv=none; b=fKf5LAKKclDYLr/mat0oBdqVaLEzfj0eS95hlG1y9EhLiJFeVHnLREUpEzTsT1qlTbrw/YuNUAZs+O0aW9eTV0q42SdPPxUpmH28ZAP9ECuS4DGJLQtHSCpI0E5NQvJFqmIj6m/VL+/AMrsGsPk6tuNqq2D5PVbZ6cF4icMKZdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621685; c=relaxed/simple;
	bh=0GZwqUy172rmUBMrDMV2vQcxlGBw18Y+h2pa3/xDLGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgNG01n2r0UEAIRYoAzl4zp+yU0Fg8iVZsOpbd03zWrLOPl36uMYURx1e3Az4e/rwcum04JOx3BhxbzvXJdINYWD6V9aN97ocH6Th4q+5Fwd8jzxuJtFJBw9wuBGafgJmrOXKRxBdHkMl7KRGHH4fUb2HRCXwGzZ4cAVBx/SaCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BSZ8BYZc; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BSZ8BYZc"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-81ed2a06b9eso19525127b3.3
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 15:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621681; x=1786226481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZTD9K6oObS45hnhRjtGbn2SpngZimROJJDwLscvqzbo=;
        b=BSZ8BYZcRcxM3awTw2IR7SZiL43EtkPRP/HJP4UPaqugzYvhfLH137ZE2fnZ/yXFQo
         Bj6/x4uvRE2rZOtNaBO730T8RAOfYjuV6Dk5k3ywMABH++Kyeg6iAx701bEzkaxAijCd
         vklhSZJe346aVtPeUcqtK6v1X3c+q4a97+cCSwSYcQxHEL99Z6N+bHK0QmnAFcQjU0bA
         m1qWp4jkg0aC52mVVoCDl47RDlm8EfFS13z6UIoWvyopX9vJ9lF8GqmSQL8KWCktQnFK
         xRteSSXvUrUGEZWpk4iY5sXR0zGBZhnJjmgwG9TZcxuRYcxXHIgbaWWD7SgUkh/5tZ6W
         OIKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621681; x=1786226481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZTD9K6oObS45hnhRjtGbn2SpngZimROJJDwLscvqzbo=;
        b=THyKRLXin9SfegufwK8BVSNePfBC3BWYM+6gKDw5yemjxMvEaGKnXhuc1+ZAPrzMSy
         Zvtvut06imi6qiAl4E7PTDa4CVjTYUIDn46RCpKP8KZJJYt1o50pe678hNmk2cygiVVR
         ZrhHwzmcTY02oGWeyFTGsTrtdtO29avdDm2KnrUN9vNJKXDMmEDPwzK2MP39eaw+Sit8
         0YLmAUqzhB15LVxS7ddN9tj411jJ/NpS32uCKRYPabm5BWYzwYIU33wb4r3GXDbX1JPW
         +muZw9cxOV5fIKqisuoeim0jGhe+6MMpkPqxvJu/wJnkkv67Q+XlDwPiu1NWheB+7yeD
         pHTQ==
X-Forwarded-Encrypted: i=1; AHgh+RrEdqlgxCotSPIzHleHWYnYWnbMvcjj2qjuOIWiYySkcSgAHvKdFEIHDLekwLO3tGDlQTB47MSa1oM8@vger.kernel.org
X-Gm-Message-State: AOJu0YzC8x453Kqsm7dt0DzpW835vTiNINTUdkr/9Cc60sytx2YG1q0T
	I1vcjTLMh3Adt9hPVczFOcsG1tkloG4QbMLLiJmHqdpUQ8x9k/wC7+2C
X-Gm-Gg: AR+sD1346BZp1rTmr4nixr8ZW6PKTPmtm32RzwFzel5uJXLjbx/rUB/ESuOWhM3kzBm
	BzX36Tc9ahv/X7/VQlfjuTMBl3blx8Y1tZpT085pWCnzy4bubtsDzI5Kg2OCLjlBEYq0RWXBUOH
	bp7Cp22vEb5bsr2LUsr4BJPpHv7/rn2JP7K+SKEwHSvi36tnTyGRnR8lQFX6B5syUlOJ+moYHuG
	HVarDvw1XdpbwQAwuoxFonUsXEzLamKRrxZMrLd2FUDTgx5yayjvwCnUBTQtJonHdip6eb/J9MM
	G56CTvb5hNhsJeINAMUfzNNtqNqwR+ryhmjrhzh+LYcCQ0DLaipRuimMZd/ocFjPziu1tBfpF2p
	opvj9Y0O5jpX/G0Dblk34Hd5T4JecV1mlEozJfQVQUwzavTw3RCaVXJOrdZn20sSGQboPHddRoO
	o4ejT9WBD4RTCeVFJB2zXTrRi3ZI8N3A2RXd2C5gtP9tZcQiOHPt02cNtuPBvHId2YtYt0+30zq
	86Y/xE=
X-Received: by 2002:a05:690c:6ac9:b0:81e:ae6d:caed with SMTP id 00721157ae682-81fd4bf66c7mr72228817b3.34.1785621680760;
        Sat, 01 Aug 2026 15:01:20 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:20 -0700 (PDT)
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
	linux-karma-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>
Subject: [PATCH 08/19] ext2: check for an xattr block write error with buffer_write_io_error()
Date: Sat,  1 Aug 2026 18:00:52 -0400
Message-ID: <f4c58a745b508ba79c114a3467eceaeb08647385.1785621505.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785621505.git.coshi036@gmail.com>
References: <cover.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext2_xattr_set2() spots a failed synchronous write by testing BH_Req
together with !BH_Uptodate.  That relies on the write completion handler
clearing BH_Uptodate on error, which this series removes: a buffer whose
write failed still holds the data the filesystem asked to be written, so
declaring it not up to date is wrong and makes callers re-read it.

BH_Write_EIO says exactly what this code wants to know, and it implies
BH_Req, so the pair collapses into one test.

No behaviour change today - a failed write sets BH_Write_EIO and clears
BH_Uptodate together.  It stops being a no-op at the end of the series,
where the new test is the one that still works.

Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/ext2/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index be63f89402a3..39005ec23fe5 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -769,7 +769,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 		if (IS_SYNC(inode)) {
 			sync_dirty_buffer(new_bh);
 			error = -EIO;
-			if (buffer_req(new_bh) && !buffer_uptodate(new_bh))
+			if (buffer_write_io_error(new_bh))
 				goto cleanup;
 		}
 	}
-- 
2.43.0


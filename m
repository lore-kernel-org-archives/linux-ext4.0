Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8493384CF6
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 22:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621691; cv=none; b=ery6dH5ERYd+b2jpCpGlWqNnADrmjElUVQjmQ3uS06S49Ll50tn4R/Dt7SPxU4snfeCiM2PmOrBGt437jtT8hnH+BvyTycy3W1l8KfjCPqkXtagLGA5O9Y+wykEU7K8UV3cBkFukFnO2kUDztFlxNa3TEjOvG3pbfkYgQfhFmXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621691; c=relaxed/simple;
	bh=8eaNHjlxdd2m/7vaM8HHzpWZ1ndxEHRbTTCO2KCwplQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esaNEs4RhpFn5l7gRjDIUazTygpGGebYBcfemCjV1znInrEHHU+B6XSmGHZex1jR8vIy126qQbfOzhvn+zcJrfUucGvfqD80oNB+62wWwi/T8nDjBJ1m5d2iq1EFLShlLFRS4zpgD3U565JJknD7aX8FlYM7cRHCU92DSG+ZkGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yun8d6rU; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yun8d6rU"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-80cebd41372so32695797b3.3
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 15:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621686; x=1786226486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3pK8MlUvCqFzPv9m7RxaKBOJ8dELfs23G8cRNXDTowI=;
        b=Yun8d6rU0GoHZQcKyHCKysFS1cmF1+vOzb36IhO1iprimsJcB5E5iDw8v63y5vqL9b
         etNPkdTEm2nZfFCgJ9AIc+/vVJxP8roJGK9j2AXQilPM/2Cw2gDL2XdmBQtOUaV0sftj
         +rM0JHXCUz0P8wP2syNvzwrhjLipikksShz8Fo1f1Il703+AjjJAlQE8Dceo91k6cxbO
         QwKMnPaHb6dyxYmHOQVBOp2pwUEhHARdJroXbUAQ8UWKSSnj6IJihONCyXuBWozTaAxg
         bNWrQZjA+C+eEaOxdxtb8D8Aj+zV+DseLbs8obh7rIc6EsdLqJjFjnVQP8t583vhk8OZ
         Yx2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621686; x=1786226486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3pK8MlUvCqFzPv9m7RxaKBOJ8dELfs23G8cRNXDTowI=;
        b=sgX8mqOtVo9XxxZxnjMFY4UnBllTBOKJQ+8cjavc1V84YezC0AycmkT3ZnpDFhh2Ql
         LQqRWgjY3CreDAKnL8f4NqZf85w6LJkxxjVUBNl82htq41KWe5MqPzqVUWvWVNEOw3ZZ
         y7kgMmDyiCLwjf2nUlDcnW9OHrfvTbSa1eWoRDUtwp8BWmefHNJnK49vsD3phPo8WT8q
         DtyI2ZgCc8uTKRCVqFfk+R7/199kf2X+hR6fxIs5Sw+ApyAQW/idcIN8x8Yg8+V4VYcj
         mi/mdIYh7xxV+o7/8HTu6WFp+XC4qNtRslsOz7ednn2C1QWeCbLZkwLHXbJ9CVsT6RXb
         HCUQ==
X-Forwarded-Encrypted: i=1; AHgh+RpCc829s81Vn//hnD0Hwblz8ElEQBiS0SMU6DzLNTUF3rSLk6IDrFnG5UafV3xu6oxMXL5oEjVC+wFx@vger.kernel.org
X-Gm-Message-State: AOJu0YyoWv3jBTedD8Nyy95/NXqIg+BYoeukj4aUAvC63dctDmFDdpu9
	L7t7PVPxam+fFX88Cv4okqO5uSAN7HN++4jzZJImqi64zNyNVWDB5PFD
X-Gm-Gg: AR+sD13o15cHxIvYeY8H+OaGz2IeqkgLHdO/5enLt8gYDeyrOEcPQUU6Tn7CBVG/PFN
	dPueWKclbcSfEqqfrDlHT4kdlqXYNeMOuio/E3sG8tYzOUTHVcqQ0BvPpBjzQ+Wrq7fS/kjYeWp
	LUJ17PC1xU/9/c1ml9RRjKiR3eqVYP8S7KrEH2uWn4YiuvYRXON3PrE+HgpBuDprWzSSviunIwe
	sG+yG8dcbPpv9zwmLV+aDKmoNI1EsqRGWyA6O/Bv5muHvfXTeO8gYmRG4srJMNNWdMSNHG18ZfN
	PFeYxEn5FNc49uzKEcV/dPDgVKo5m8TgTJbhwnd2XdSro0A3MSsuSwuIfYHEbRH159VMuYl3hO7
	OZf+TL0x3T0st5nkr/RIdxiWOSA3+z+AZzjDOnC3GPT8kHEafwRA77oVGKmA+YrVJukNTKbq5Py
	ffjw+1FSarYgRtcGQ6bEspNiu4aEiZQAfVVTGvayLoFwkq+47gg3REhCDvnuQHRqUMkfQK6nZ1f
	/8QLlo=
X-Received: by 2002:a05:690c:6f10:b0:80e:5236:b930 with SMTP id 00721157ae682-81fd4c9064cmr74857937b3.36.1785621685651;
        Sat, 01 Aug 2026 15:01:25 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:24 -0700 (PDT)
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
Subject: [PATCH 11/19] fat: check for a metadata write error with buffer_write_io_error()
Date: Sat,  1 Aug 2026 18:00:55 -0400
Message-ID: <202c109fe73ff6899235aab9dc19ba15eeda0d5d.1785621505.git.coshi036@gmail.com>
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

fat_sync_bhs() waits for the writes it issued and then tests
!buffer_uptodate() to find the ones that failed.  That relies on the write
completion handler clearing BH_Uptodate on error, which this series
removes: a buffer whose write failed still holds the data the filesystem
asked to be written, so declaring it not up to date is wrong and makes
callers re-read it.

Test BH_Write_EIO, which is what the completion handler sets and what this
code actually wants to know.

No behaviour change today - a failed write sets BH_Write_EIO and clears
BH_Uptodate together.  It stops being a no-op at the end of the series,
where the new test is the one that still works.

Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/fat/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index be18f6b5819b..4a4cd0111e47 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -356,7 +356,7 @@ int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs)
 
 	for (i = 0; i < nr_bhs; i++) {
 		wait_on_buffer(bhs[i]);
-		if (!err && !buffer_uptodate(bhs[i]))
+		if (!err && buffer_write_io_error(bhs[i]))
 			err = -EIO;
 	}
 	return err;
-- 
2.43.0


Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F863955FE
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 16:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035596; cv=none; b=G+1W4YVC99B+5OSYzeKBHx4ipxgy3QKNFKG2bN4io3kgStBJKYonzRRr6XufTYOtHLSz96jUd+ofiHeVKlFi/O3M8VqdumWkozFG0x/tYHAl8jExwrsMGLVQk7ILuRD0GQ0KaLESq1U8czfhp70iwFMCM/hJANek0yTZXp5iKiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035596; c=relaxed/simple;
	bh=PhUfiLl4o8/gnM5dBdAr9/CI3mtr8neFPCeerCnHCbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXB5pTG4bHskYbvW66AMyJN4lfaI6i+jdnJHLs+9aEleNmb/yDKExrqYKtluAPsSl8CBeiIV7ob7IuHC9Omg2XC3oSJTP7O4IcMpB290zZNhg/owADQdnfCoMAn8D40lboXCY9WhoQFu/R3jfut1JMd0FLcT1Hxmaq/bff9vsOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iK9FazpK; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iK9FazpK"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5bfb5e20a90so1679462e0c.2
        for <linux-ext4@vger.kernel.org>; Thu, 06 Aug 2026 09:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035594; x=1786640394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a0eDfGNL18OJWRoQDXpl4mokl45SZAvTsQakbJs+ewI=;
        b=iK9FazpK4YT7CI/a0908Op2Wo+SMHFr5IcWGldEOkw0g0Vox3sVreDirnyg/dxtMU0
         gW85+Bpx3hkC+xU/FrHIVnDFdW34dHo+HXI48f0DCxlSUo35WrRPSWEfAA+SYmnLbDXp
         Nu1eu9oWwpjwORQtH/uSf6dBIwGrxv/S8PiFdekbqIWvELMz9BzbWbNpucDj14fxow5F
         rSSmDu39oQkBjwLAMXw0Mt58OhYwU3U2/ncLkH6vX4c/P3i+IhbvliyCwiE0EkrFQZ1q
         pJrNTtApqq+hGpHlvo//W1F3z3wSZhUhfLkPdM8gA23YuGjr+u/1ip3JIFoaHJq8kQp9
         T6JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035594; x=1786640394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=a0eDfGNL18OJWRoQDXpl4mokl45SZAvTsQakbJs+ewI=;
        b=o1LafBvO8SKDsJtCdFD26DJnN8GYq9hfSTGCPiuujcXnP7E0pV/8Vmxi3XUJa/Bmpc
         3OwAz6Umdx0s2/ct9lEAdtULpDsrdR6WAFZvd0oTD7Wv4Cq6aCJ2lODXLvYJzdoxPrvH
         KzuauME1PpMSA07ASl1w/Fhw5qwR7oLDSvxl9jRvE+z/Nkan2r6o32EEw8bdKDM9gJTh
         qkJtIh3ijcCH4jW2wxfqkzec9e/rrm2jBQJNzhcti0qBY2qdvt4SNp2XjRADF89Rc5Or
         qz9/IrpTYYQjh7lztzGnFaMRXz162zazkhvu+DkwGieh1RIi1sPMeadpPWsULi7DFw27
         /FhQ==
X-Forwarded-Encrypted: i=1; AHgh+RqEAbqnkvSEuSwyZSgY9sM4Vaj4EeUYx8M0DLDOHl52kku7DLteWL+v6L2MxcrwI6OZOc0VCWajSPnY@vger.kernel.org
X-Gm-Message-State: AOJu0Yxpja4kIcgf35M4yW5dAkwoF85UTyujSwm7/ZYCgAoC2RkMaFK1
	8icLZXNq5nD3ev1FSyOHlTMgMMWJZAURpy24MRUpeFO5I/7Y+Wtr6Cdu
X-Gm-Gg: AR+sD10emQ/kXviTkebjSbwQ2dvMrTUEfvnQP8Ia+QyXyDtFKlHt5oZDr6HMAP2Sw5k
	DLTL/j2nH7Ajr5e///9UQlsL7rnXDp7Gm8KKO2UP+FErQ4KTDsrlrpDpwgIXonG/iriSMYsANMu
	zteVjkCeLQl1y4H80zTTzOVGmXfAOdyXHpvIbj8PVkKHQVgNPzA29U9ruSSb7FD2Nf52wQ/yXo7
	8qB5et0vS7lbAGzu7GNuSDUIKpxiiiy66qy7LQGjxuj1lRFvyDnQyJDt5d0HkF8wdVPgpHE8tV2
	Heu4LuSStQYIt/+6Qps1mddQc/B3zx9UrrXLnkyUpPtS76hDrAJAqizVuauOpJzn99plIKFbnrV
	9r3s4DKy8zbGFh6b8AZtO8Je1yB0SELVZhQFfqgk9hrtUHJgFPPJRbtPvBxWC2yaJbU8wZ5r66m
	sEFBhASVylA+CTpDoKzhzC+OZyqgti4s/bK1hRA2Bonb0bgivUZqpwrd3myQ4631RVigSblIiDb
	56K4jU=
X-Received: by 2002:a05:6122:8b8d:b0:5bd:ecad:8f80 with SMTP id 71dfb90a1353d-5c3f9e68046mr593995e0c.2.1786035594156;
        Thu, 06 Aug 2026 09:59:54 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:53 -0700 (PDT)
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
Subject: [PATCH v2 13/21] ext4: check for a metadata write error with buffer_write_io_error()
Date: Thu,  6 Aug 2026 12:58:36 -0400
Message-ID: <568e57d184da17041872fd4b498f31dd6259a4c1.1785951556.git.coshi036@gmail.com>
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

Two places detect a failed metadata write by testing !buffer_uptodate()
after waiting for it.  That relies on the write completion handler clearing
BH_Uptodate on error, which this series removes: a buffer whose write
failed still holds the data the filesystem asked to be written, so
declaring it not up to date is wrong and makes callers re-read it.

ext4 already does this correctly for the superblock - see
ext4_commit_super(), which tests buffer_write_io_error() - so this brings
the other two into line.

In __ext4_handle_dirty_metadata() the old test also required BH_Req.
BH_Write_EIO implies it, so the pair collapses into one test.  The new test
is also strictly stronger than consuming sync_dirty_buffer()'s return
value, because it still fires when the buffer was written by background
writeback and that write hit an error, which sync_dirty_buffer() does not
report.

Note that the failing write does not clear BH_Write_EIO, so an unrepaired
itable block now reports on every subsequent sync of that inode rather than
only on the write that failed.  That is the intended behaviour, and matches
what ocfs2 has always done with this flag.

No behaviour change today - a failed write sets BH_Write_EIO and clears
BH_Uptodate together.  It stops being a no-op at the end of the series,
where the new test is the one that still works.

Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4_jbd2.c | 2 +-
 fs/ext4/mmp.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 02b066299164..f338d6e3c29f 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -413,7 +413,7 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 		}
 		if (inode && inode_needs_sync(inode)) {
 			sync_dirty_buffer(bh);
-			if (buffer_req(bh) && !buffer_uptodate(bh)) {
+			if (buffer_write_io_error(bh)) {
 				ext4_error_inode_err(inode, where, line,
 						     bh->b_blocknr, EIO,
 					"IO error syncing itable block");
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 7ce361484b38..4b18ddef468d 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -49,7 +49,7 @@ static int write_mmp_block_thawed(struct super_block *sb,
 	bh_submit(bh, REQ_OP_WRITE | REQ_SYNC | REQ_META | REQ_PRIO,
 			bh_end_write);
 	wait_on_buffer(bh);
-	if (unlikely(!buffer_uptodate(bh)))
+	if (unlikely(buffer_write_io_error(bh)))
 		return -EIO;
 	return 0;
 }
-- 
2.43.0


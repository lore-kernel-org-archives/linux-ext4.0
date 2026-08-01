Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7FF353A98
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 22:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621681; cv=none; b=Ann2HfgzSflHMnhyEWFvdy0GrgR3ucZLXRensW8Ln7Ljws255DbGRsTAWPVBBXyA6IR8DbYJuMdJt5CjOAvhku5JjEGYJYAYKVR0QbcBWF5pSCeScVJTnlx2XzkOvDCrJ6SRge4dhH8XVKkR5bTDgl2JN3KutYvSM8PFlV6AXYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621681; c=relaxed/simple;
	bh=nTKqFaIO4eWueECCBUw01WYSenLBpxO8tTFhLp4DI8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBQfu1cckFxHkISFIMBwS9+jshhve8ygftzhcL38rA/Cc2BI/xczd40ojRo6hiszJvHKx9bL32xtrC7Ymo68Cz4r6Xt3Wf8gm/A9TkKj+OFNpIp4SBFPMmxa9cvlKnJkr1fspMPWdvO9ePNB6veBq/RpRu/rih3FnqH0OCNkzC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mhZDp/RP; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mhZDp/RP"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-80814edb536so31512017b3.2
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 15:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621678; x=1786226478; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Vy4j4aElKFiT0ILAbTnwQA9DPnzOxaRGdQq6jv8GAw=;
        b=mhZDp/RPeORtxayAJxHijgqC9qNm90l4P6i0Flu6B7+HSOSH9Agxm2V6wYLOoQTrxS
         TddmwBfvofGm3zZ83wrO+BuGkV51HHmPYQv+Gvbfp8vetuZqreaUE2SPC4Cjwt4MDuUX
         sYimmrLQBHLWYLIN1uL/WwC6+WlHx0JkxFef/66FFooATqEJUxAHq//26qs0cEoktsJi
         P3lirHZ5MpcYubzWfmwIMARnWO/BTaamaDt+UTffZUKqut3/LvaYvA/Nz+7YWDxiIooE
         4NVEf7NPoH8VMlHeBcL8xlFuIvS7HCwrBohWIEB3edibmaVdm6fmYlgwEzhajtEaUTXV
         NkDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621678; x=1786226478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+Vy4j4aElKFiT0ILAbTnwQA9DPnzOxaRGdQq6jv8GAw=;
        b=g7e6uANAu0/PJg82BdZlc+sd8XKlaRn1icwmNazSrjgodWBsPWfJfkozM3IEkutrkb
         6vFmu7cLRwbJdtloGDRR4b/+fRI69Jf+goQUTvWGBT8eVUHKtH1qVWGGvIIBFCvwWjZd
         +F/S+wTO/3sRpqGhnP797crzt7XvgBGCe4JAJ1yoL5y9ubwF4gn8mi/9NpfPP0RIyWiG
         6G57LrbO7+RwNUuuAxhvsfKteu1BcbCWqmezjGu97vWD1/NCs4yRAHKJ0x9dxWV7GRZB
         zu0ZcJRipWMtyBVadcgOvacBuUOFX9mPfzhKYV5cgRHP9/u9P78xyn+LhzHrhOmEo+RO
         lhIg==
X-Forwarded-Encrypted: i=1; AHgh+RoIG8hjMNrc7DUJbut32m8VdHrnHxZyVv6HEUvUJ0knEl32SPKtCF3CKsNQixr9SidlHdBEvWzmBScA@vger.kernel.org
X-Gm-Message-State: AOJu0Yyax2HJN+pVUtt0DzVFgKwwGES6uNIkGKIhjtI1IZZ4svYStDOc
	kDlKaI5BdNOb2geoND51ecKn0YASwrJ7x5fNq6hJ9nj+SK58sj7Xb78Q
X-Gm-Gg: AR+sD10kiY4478/60HDH9m7N7O1l0nVwQCfS6n9dk9jkpoZ5Js5J7wtvr2illZD0Qjb
	L4fIBs6KpsqQW3vUQgWjqol0Ln4JulG4I1jbRbMXtwJKnAjPErDGH6F4ZmdrK+umKIF6yMfNfl7
	2Do+Q/WXibdqWdcqJ1mWW6DCHhtEZOn91nxLn26iBujk/4TM+0i8ZHCOScJI5cSsDok/bmmc9IB
	NMbtEnt0tNOmLu7tybyJk1AYV2VRvaKclwdP7cHOglkAbcYchnKRSMygDRF7Ooo+Oivix8n9JfK
	mdHT4kJ6i5E6VKzGmHzq8tDIX+OHuqyJd9wz+wvF3bLp8EbxOPSv6kvqnmPm6FAvko5pNPBEYxa
	epkb5LZ8Is/nRdCpHkoEP/KyM0Y8lyNIO9X9qZEBhJJ2kwlbgj7DYOZTD2KOR7LEbR2aldE25rz
	mfWmqqWEzDH09W2pTgAScWbpVa0yczB4qQQRNtmJQupy40n9hzUjTBIlhHY+TsR8bFN0c1q3am6
	IZvwYA=
X-Received: by 2002:a05:690c:4442:b0:81e:c972:e8c3 with SMTP id 00721157ae682-81fd4ba85d1mr75578147b3.29.1785621677847;
        Sat, 01 Aug 2026 15:01:17 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:16 -0700 (PDT)
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
Subject: [PATCH 06/19] buffer: detect metadata write errors with buffer_write_io_error()
Date: Sat,  1 Aug 2026 18:00:50 -0400
Message-ID: <adebc1e3de48c3e997057d10cb78756dec03b800.1785621505.git.coshi036@gmail.com>
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

Both places in this file that report a metadata write error to a caller do
it by testing !buffer_uptodate() after waiting for the write.  That works
only because the write completion handlers clear BH_Uptodate when the write
fails, which is what this series is removing: a buffer whose write failed
still holds the correct data, and saying otherwise makes callers rewrite,
re-read or WARN over a buffer that was never wrong.

BH_Write_EIO is the flag that actually means "the last write of this buffer
failed", and both handlers already set it via mark_buffer_write_io_error().
Test that instead.

No behaviour change: today a failed write through bh_end_write() or
bh_end_async_write() sets BH_Write_EIO and clears BH_Uptodate together, so
the two tests agree.  They stop agreeing at the end of the series, and this
one stays right.

In __sync_dirty_buffer() the flag also refers unambiguously to the write we
just issued, because __bh_submit() clears it when it resubmits a buffer for
write.

Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 50a63d964815..ac978d9090c2 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -618,7 +618,7 @@ int mmb_sync(struct mapping_metadata_bhs *mmb)
 		}
 		spin_unlock(&mmb->lock);
 		wait_on_buffer(bh);
-		if (!buffer_uptodate(bh))
+		if (buffer_write_io_error(bh))
 			err = -EIO;
 		brelse(bh);
 		spin_lock(&mmb->lock);
@@ -2743,7 +2743,7 @@ int __sync_dirty_buffer(struct buffer_head *bh, blk_opf_t op_flags)
 
 		bh_submit(bh, REQ_OP_WRITE | op_flags, bh_end_write);
 		wait_on_buffer(bh);
-		if (!buffer_uptodate(bh))
+		if (buffer_write_io_error(bh))
 			return -EIO;
 	} else {
 		unlock_buffer(bh);
-- 
2.43.0


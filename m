Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2939B30D414
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 16:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782231128; cv=none; b=gJDajrrLm4AGYLVda+istR+EJqSO9cXqpdtIhrbClNX9UEuAlzdiXJ6l4uhdwFsJhS+Fx4EF/6/eyR4R9adhdMOaD2nOJOEbasOgwhge8YDQjTnQpzCbi4EFShs5SpZQCZBmHYvbsmZm3wPQa5HyGfGd3fZASLF/P++19rUso7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782231128; c=relaxed/simple;
	bh=uN1EZRClgoUwwTbPHXOy9C9cJoeMminRViXVtG5lQMI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ObhWWDmmkVuQ+3xCrp1rS2Ta4MgslLfKwl4YjPSa8AaXUyOoYgKKaNwPf6JDlb958MAVnp/TQRm2Ti0N710EynYcAoWNBvGOUrnk+B73vqS9QfzSIUTERaUYRJAYJfrukwK0+VnLVpHNs7Jp8aChAxIqJm6uyaOoRKwx6xvMqDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jihbb/sQ; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jihbb/sQ"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-37d82f3a244so89750a91.2
        for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 09:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782231126; x=1782835926; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5VLqiXbHUSk8P6cXgMo32lHHndXjEJIEyZZ29AUICc8=;
        b=Jihbb/sQzVerVw7UA52m0+yyIBIgMBm/zdlvgYS5fegFApXfEr9p6xO8e4mj558pTc
         lMgegIKuXCOBWwS1SB/DAW4tw6RPSD0EoVRUhaxUz4rmCLiqijV4qzxGs33R+TBTMt4p
         UGfX42luAa/P92dtZ0TUpIp+hTLbAEht+XOpLqkDTUh+I7CleanUdZNPSx+/0b6GUxKQ
         R6OisCD57osVXUa7ALEVVoXxmKtEiyIKUd0GWZfeIvJEEetiufbJLOp8EKCd5VI9vYH5
         IXxvbn8EZfMoPAKz0SEwgY+VE+abUWrOQtWw0RXmZxgyiapb6/ZPMoZmg/xY+nFl1Kgj
         pH0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782231126; x=1782835926;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5VLqiXbHUSk8P6cXgMo32lHHndXjEJIEyZZ29AUICc8=;
        b=lRTkwkK1VihibFyUpFkJEgnwXaiLInaOkEMPQNe39aTh5WitVbjkob1En5XOMBi0Os
         IZiEJiWJPupst8WwS1rQDb2u2AI57VCvKB4QnQeCYmyo+LnJd+dbBmB1sfnFNYguBDD6
         sTvGTCHmUqx6MyZnVHjnV0NLTG8cUVfm4mmd4HoUG0riIa4XrfqKqSbw5/98VO3vhZYB
         GOir+XpvRQkuI5RZ9l4VCRYA5g4lgNEFn1lsdaluG59rNfKmANpKlw6HUbJu3URNZ51s
         dtn1vvSrbjK3UpQcykVCHl1mp6FtJtO4E1lHae9TXXgt98neGFEFKDnUtiouAQhxuj9t
         LjTw==
X-Forwarded-Encrypted: i=1; AHgh+RqVLyIQ0Qp8NyN7MGx3b8l4e1+7tCNkVTyw+vDpEjdA896kkDIOPveZrQ4hX1nsw3nRCMzB0H+5w1th@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4ktI7d60DSO85xeJPeMK+Yk0onBltcalQXGQp/tDt9hiFf8zl
	aUaIbXTkPSudslUxI5l9R4A/ZB/+c/K+tdnYBMxS9+fToyrxz8A9l5qm
X-Gm-Gg: AfdE7cnDX+qGu3d/FNHMiKMyvthuXUMZ4uOrp/5nS3NQScsmIH7xNRWkJe9CJ/2tJy+
	eZ8CwrgRBBeVKNxDvbBVRXKzh0HB8fXrnle7q2Pqkw1OcyP0hZgKfbSzC+HyPPPKCG7DRPNuHdr
	0gO11JhM4tqbDPRxpxbGJgJSuP1MxK9QnszdtxH4ktz7kQZPirgsvFOd9Y27vG+S5UL1OPa3Uji
	klEpLxbu3B8TKPTN+rC1DiHFO9s+yzLVn9xcJeo+Lqtn3NTacb2Z/wdm3q61oNp311tl/qLhsLW
	3Sk1BeIuGsucxglgTT/7Y4mF1ONhu8w3PFedcfunb4sffif50wsBBcySHWwLqqFrt0Hgrr7vSsI
	h9wQKkWbpEaGUYzROyHvLDUL5+lHISit2GG8rBJaHqelCjCWvhhd5BJbpsrh+CfNbTAupqqRkoy
	USxFes5Fxsl+g6KmguiHqdt0rSUBQAS0D9wbW1ylueT2axYgMAkdMj+8ic26fnHlRDTlz0xv3ZI
	e6cuxDPmg3C+OPiRJoYa60aBYeHd5va643TirltjhPuFnXwmZyt7bpM+ZJRxPQSzv0YnbOoNdO9
	yQYwhxL/yx8ZlWhuAAAhZPMy/toA
X-Received: by 2002:a17:902:d504:b0:2c2:8659:da2c with SMTP id d9443c01a7336-2c7425d58aamr162095025ad.14.1782231126211;
        Tue, 23 Jun 2026 09:12:06 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (235.235.240.35.bc.googleusercontent.com. [35.240.235.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7439f8e42sm109281705ad.48.2026.06.23.09.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 09:12:05 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: tytso@mit.edu
Cc: jack@suse.cz,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>,
	Anthony Rebello <arebello@redhat.com>
Subject: [PATCH] ext4, jbd2: abort journal on file data write error under data_err=abort
Date: Tue, 23 Jun 2026 16:11:31 +0000
Message-ID: <20260623161131.2189-1-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

The "data_err=abort" mount option in ext4 is designed to abort the
journal and force the filesystem into read-only mode if a file data
writeback failure is detected (to prevent silent data loss and stale
data exposure).

However, in standard data=ordered mode, file data writeback is executed
and waited for during transaction commit in
journal_finish_inode_data_buffers(). When
filemap_fdatawait_range_keep_errors() detects and returns a data writeback
error (e.g. -EIO), JBD2 merely prints a warning message and then
discards the error. This results in the transaction committing
successfully, exposing stale/corrupted data and defeating the purpose
of the data_err=abort option.

Fix this by:
1. Defining a new JBD2 configuration flag, JBD2_ABORT_ON_DATA_ERR.
2. In JBD2, if JBD2_ABORT_ON_DATA_ERR is set, abort the transaction commit
   and the journal thread via jbd2_journal_abort() if writeback fails.
3. In ext4, configure JBD2_ABORT_ON_DATA_ERR on the journal based on the
   ext4 "data_err=abort" mount option in ext4_init_journal_params().

Reported-by: Anthony Rebello <arebello@redhat.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=207729
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
---
 fs/ext4/super.c      | 4 ++++
 fs/jbd2/commit.c     | 2 ++
 include/linux/jbd2.h | 1 +
 3 files changed, 7 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7283108d7609..de34490a5b68 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5875,6 +5875,10 @@ static void ext4_init_journal_params(struct super_block *sb, journal_t *journal)
 		journal->j_flags |= JBD2_BARRIER;
 	else
 		journal->j_flags &= ~JBD2_BARRIER;
+	if (test_opt(sb, DATA_ERR_ABORT))
+		journal->j_flags |= JBD2_ABORT_ON_DATA_ERR;
+	else
+		journal->j_flags &= ~JBD2_ABORT_ON_DATA_ERR;
 	/*
 	 * Always enable journal cycle record option, letting the journal
 	 * records log transactions continuously between each mount.
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index d8577725a2fb..49acc9d0809e 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -768,6 +768,8 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		printk(KERN_WARNING
 			"JBD2: Detected IO errors %d while flushing file data on %s\n",
 			err, journal->j_devname);
+		if (journal->j_flags & JBD2_ABORT_ON_DATA_ERR)
+			jbd2_journal_abort(journal, err);
 		err = 0;
 	}
 
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 7e785aa6d35d..e39679656de6 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1410,6 +1410,7 @@ JBD2_FEATURE_INCOMPAT_FUNCS(fast_commit,	FAST_COMMIT)
 #define JBD2_FLUSHED	0x008	/* The journal superblock has been flushed */
 #define JBD2_LOADED	0x010	/* The journal superblock has been loaded */
 #define JBD2_BARRIER	0x020	/* Use IDE barriers */
+#define JBD2_ABORT_ON_DATA_ERR	0x040	/* Abort the journal on file data write errors */
 #define JBD2_CYCLE_RECORD		0x080	/* Journal cycled record log on
 						 * clean and empty filesystem
 						 * logging area */
-- 
2.47.3


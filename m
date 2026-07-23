Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC0E1C84DC
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 20:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784839850; cv=none; b=O1PAweOkrdg1lCrGT9MrMi5W1oihqEVCn2PQOneqFmkFShyvX/vyo5/x/ohcKR8n7l/1K7l3yf8bvFVyoUVn+XdxhiwTqz+LAS8cUFJ2JTlbiZb9JL7aLnGkyoAPot0Od7LIlikaDs3xtz6HruJBPOQv7gb8Ybii4UNrbPcNy4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784839850; c=relaxed/simple;
	bh=yuJnoATnhqrUec4Gqgsj8933IC5t0n2Sm1rPsf4Nrqw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WVsV33eYq5hLgYQVE/kFlhCMu/6dvacb9DklrSWi+/hP8CRTt72ixXnSD0jh55PgKg/rhA/iIlW/F7Y3aGhCf+gURxVvZlOiublgVFLK6Jq9thyRXju9s8woqbU8EjOCtVsCoVd+ZDhNqUZbDpsgVbwRydyndI0vGuaeW9WQOyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gWYNGMgb; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gWYNGMgb"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-930c0f9c1b1so110806685a.1
        for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784839848; x=1785444648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TxQ8q1hZFDeQHXbdO0431brEhmNkmkrVteItKfiKWuI=;
        b=gWYNGMgbWH4L6OoemBJ8+LAhioIW2NWnoBDodGPIcstdwvsP7P3EW7OTtFPp3u+sE+
         Ss/aXWPdx0SVYsH141UmBOFYX78leuDwgQsNMDDSywZyQg7ybYTqtBHbJxtuWLCZKoId
         fJFqRkV53UFkhqkWeX6CVWM1C5muebtEPNi0lMaCpq14zG/hPvcnza71dn1bWnW9ysTi
         4c4mdaV7kO9qQJygD6/Bdf8KNXhcdZ9gY8tgG/MnvKimEsC5JB0HV04EuLcj0UqmpDI0
         xP2ItZPc7IA23JzxUXkxiWbb0TlrfVocL7xYacXmsc3heLlm9AUzk7ORlDUvJzMtUpGJ
         JH0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784839848; x=1785444648;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TxQ8q1hZFDeQHXbdO0431brEhmNkmkrVteItKfiKWuI=;
        b=FbkXCnvTdVEDZ+8icJo8HI34x3ZtB89O/zIYLXts75hkYL6zVs4VGG9DDeXy5Qlr15
         jJtpy1ckEl8L/7wBQu6GJPnGZP27FXrsOomjC2V5HNNX1LebFjS3KFPhxwnwHac9aZ2l
         AOWBjQgn3W5hl4yXCzTgXAk5nWuSfwGredYhGwRTmriEdLgQboBENmgHL6StRTnDLnuf
         l/vMQBDbuazZQ/oHhWc1qLaChh7qN5KkX77AtxSLgFHOP5bVMdonejhP8YyZreRQzLwN
         BZoBoJYuXkMi50323hbJObpVtGeCfKi4nwFo5Pl+zOsMfW0gaEVsjW2okegg3GB9gjoK
         GJUA==
X-Forwarded-Encrypted: i=1; AHgh+RrhZ0St+6BHm0kwWX4RIP2hEvX24kIeQTs6x3mhs/VJHTSPwsOLxAr7Zq1sB0q5/W2ukfqDQdfkn7Qw@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6fM0crowTU2AGG72TlaWUrfuLyVaSm8CKjctkr8HBPY9k3bpW
	Lgl/4RB4nfvZTY0pDDIX9DUXxomRJ9qy7wtk/54H1X6EjBQeZTfAnvNf
X-Gm-Gg: AR+sD13YAX/lMBzNMFAKYf/g4Ld1TVPXqpXZDf9xlawBTGxcfCg0m2SAVCYdVnLsFVj
	LR7xZpGKLwR+G81ixmDiJHaaPY745gzT9P/u+ZYsTJlMGo9IVozEJQU7hysauou3J51FgVrxBAO
	Oq90QTkuFl93ecupPASQoUYab/sofTTuejsTPC1d5BgzmmLTjm/8j5d2fyYZ5y6HkQ5xOtBy3RH
	FXux/HdL2Fd9bLP5O3MzRcSjoeJSfkk1DWnejI5ho8fWJRcgl3zR+TWj/C7fdAgLH4FDIBmnoO7
	V+/R7vDvpMY/qWKXDYL7LM0xT5rdvV2gmT/B457KUgAm4oFb8kVWUEDX5mQzbjL4VuQgnITSU+O
	q2lElTzAnD6dLSGK9A1C287jqvroNGSS0Z8SUcrqLKe7QPwnN7JGHOdbT+9xcNHeoKC8U0ubBBP
	XMet7l6hhFxAw7RrKOtV7KYZQBhV44QMZknoXnrUeHRCWewSGGcSOzoo8weeLL601oU4T/Dc/1S
	zjKrHKq+GNq
X-Received: by 2002:a05:620a:2942:b0:930:987d:2732 with SMTP id af79cd13be357-931036f0f18mr533968185a.59.1784839847690;
        Thu, 23 Jul 2026 13:50:47 -0700 (PDT)
Received: from Ai-Server.tail94eb8c.ts.net (131-193-45-111.cs.uic.edu. [131.193.45.111])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930f68df1f7sm515866085a.21.2026.07.23.13.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 13:50:47 -0700 (PDT)
From: Luyao Bai <bailuyao1997@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: do not WARN when starting a journal on a frozen filesystem
Date: Thu, 23 Jul 2026 20:50:36 +0000
Message-ID: <20260723205036.661832-1-bailuyao1997@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A WARNING is triggered in ext4_journal_check_start() when a background
writeback thread attempts to start a journal transaction while the
filesystem is in the SB_FREEZE_COMPLETE state:

  WARNING: CPU: 1 PID: 2903 at fs/ext4/ext4_jbd2.c:76
           ext4_journal_check_start+0x1f8/0x250
  Call Trace:
   __ext4_journal_start_sb+0x181/0x600 fs/ext4/ext4_jbd2.c:105
   __ext4_journal_start fs/ext4/ext4_jbd2.h:326 [inline]
   ext4_do_writepages+0x112c/0x3d20 fs/ext4/inode.c:2707
   ext4_writepages+0x213/0x3c0 fs/ext4/inode.c:2813
   do_writepages+0x35f/0x870 mm/page-writeback.c:2683
   __writeback_single_inode+0x14f/0x10d0 fs/fs-writeback.c:1658
   writeback_sb_inodes+0x80c/0x1370 fs/fs-writeback.c:1954
   wb_writeback+0x41b/0xbd0 fs/fs-writeback.c:2134
   wb_workfn+0x410/0x1090 fs/fs-writeback.c:2321

The background writeback flusher does not take freeze protection, so it
can legitimately reach ext4_do_writepages() and try to start a journal
handle while the filesystem is frozen. This happens, for example, when
ext4_writepages() failed earlier (e.g. -ENOSPC or -EDQUOT) during the
sync_filesystem() phase of the freeze: sync_filesystem() can still
return 0, the freeze completes, but dirty pages are left behind. A later
writeback pass then tries to write them out on the now-frozen
filesystem.

The same state is reachable through the EXT4_IOC_SHUTDOWN path: if
fs_bdev_freeze() succeeds in freezing the superblock but the subsequent
sync_blockdev() fails, the filesystem is left in SB_FREEZE_COMPLETE and
dirty pages remain, so writeback eventually retries and trips the WARN.

Because this state can be reached without any kernel bug, WARN_ON() is
the wrong tool here: WARN_ON() must only fire on conditions that should
never happen. Replace it with an ext4_msg() error message and return
-EROFS, rejecting the transaction cleanly. All callers of
__ext4_journal_start_sb() already handle an error return (it is the same
path used for the existing is_journal_aborted() -EROFS case), so the
dirty pages are simply kept and written back once the filesystem is
thawed.

This patch is intentionally limited to the ext4 journal-start check,
which is the direct cause of the reported warning. Any improvements to
the generic VFS freeze/thaw error handling in fs/super.c are a separate
concern and are deliberately left out of this fix.

Reported-by: syzbot+b75d75f957975f3d40e3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b75d75f957975f3d40e3
Fixes: 49ef8832fb1a ("bdev: implement freeze and thaw holder operations")
Signed-off-by: Luyao Bai <bailuyao1997@gmail.com>
---
Tested with the syzbot reproducer under QEMU: the WARNING at
fs/ext4/ext4_jbd2.c fires on a clean mainline build and no longer fires
with this patch applied.

 fs/ext4/ext4_jbd2.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 9a8c225f2..1756039b1 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -75,7 +75,12 @@ static int ext4_journal_check_start(struct super_block *sb)
 	if (WARN_ON_ONCE(sb_rdonly(sb)))
 		return -EROFS;

-	WARN_ON(sb->s_writers.frozen == SB_FREEZE_COMPLETE);
+	if (unlikely(sb->s_writers.frozen == SB_FREEZE_COMPLETE)) {
+		ext4_msg(sb, KERN_ERR,
+			 "Attempt to start a journal transaction on a frozen filesystem");
+		return -EROFS;
+	}
+
 	journal = EXT4_SB(sb)->s_journal;
 	/*
 	 * Special case here: if the journal has aborted behind our
--
2.43.0

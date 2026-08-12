Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30C5392C2E
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2026 04:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786509843; cv=none; b=FAgYY1jMTeOYVsKyyel7dGTiLzTU0D29e+0S8mtLJ87yJewRgTelFEF9g1bJx1T0XXewdjVxVPzfy8x/JY89C6WOttdVUq7+a2U0rWYhOlSf6CZpnTDrISFLM/O5IJNkUHTc8GlmyXzQhmTTBFaSNaVF9GRGRYL2zuwEnNgIhAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786509843; c=relaxed/simple;
	bh=Geen8rRi9DYSEeIAFJv4tuQyYu6xQCEWIEOmRHPkpYE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DmDAl9+6sAXkf5nm3RT8CxTd+lI2Sg3hXWwN0vjCMH3/olERX90uX4b+n9tNGaDvwyITYtluohH5OmcMCd1oE44MF9yvVa4zUdkoRj+pSHJxN0iHJveQSe4xo095X1h4RAu4/0sufrxDphpYBtYnwF7nYacjZ9lW5WaODSyZIME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LLuQZnzA; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LLuQZnzA"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2caed617615so8215875ad.3
        for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2026 21:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786509841; x=1787114641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z09gGCJzZ8Oqr2QOAqOOmcBjVqdoajQ3RwQNJtoTNM0=;
        b=LLuQZnzA411Sgd9r+cj7XCqdwMkDlYLSyzE+jQNhBxP1UTzkwU9MixzM6oUWzBGK3X
         Q4ShdAAoK1sQwtulXo+FZb6fRO0klCvhGRN8AprBTEJ+n3yR3bhCdzlO+ZZkpaW5QdKJ
         xqTWJhkfqVDXvujUOtz4ckSMvjSRRWc53BKhA8QwYlsdgUiP43hNDkSkP5qBKVUkx7YX
         vJj/edmDHYoTkAGZndC2UwBsBduD7Zp4f8CsZMHAoL18NUTMHsemFA21nzUTPpOpQWUZ
         i13tawS4JPLkHd9dg0HbTI7SyhFoDKzo5zVZJfzJn/eWCGJn2Fq40kG9HWKo4so6XbVd
         HCig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786509841; x=1787114641;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z09gGCJzZ8Oqr2QOAqOOmcBjVqdoajQ3RwQNJtoTNM0=;
        b=Z4VCg48QVdW1VLNNsKcTcPyi/uGsg4oQmk6piMbYv3CeCGNs2cgt9eU6i8isEiSvBo
         bP2NGhEDCnaY4eIyAeMYY3Nphigg0OLJI8bpw9C1dG/zaGJlVSZ8DkjM0kCsQUNgwcqI
         24DIdB/ynhU5nU4GAlZMfFDfAsKWxP11Ti3f2LZ7tgJkeTx2c5Lu8k9y8z/80MpyPyWD
         PcW5m1LM6cfLscBTClcIm05zj9dIfHp4HAeqw9pqb3dSurcUIoz7Yx/AFpiDcaHhkHyQ
         mz3CcXA0v2BCUSthD2DrA8TTQsXvfClR/8FxU5GvPfSI8QlpGg6hTojmm4nQwQiAlPA3
         D5tA==
X-Forwarded-Encrypted: i=1; AHgh+RqAAE3HCKZO0Iy3BpptQn0T5JeiZu0ICUFq3ezHsRoYqYaEw4Cm6xhMzk1i96yH0N1ybxsGAjCXDzLc@vger.kernel.org
X-Gm-Message-State: AOJu0YyUpFlVfzucgUv7LgSw2g3I6QNWP+VQ1fzju1uihcREsVsv2ymS
	Kn4a2tVgC3rGd94NgJKcNfMWxMKA8vGGlnN884XbaZjX/0kXDRuSk2HU
X-Gm-Gg: AR+sD13AA5ktZKT90UMZ4FWhunu5XaMHw6aknhDUFSPiYr/v7L2GxgMwro/5lyVGaNg
	9GDe5L4angFjgrHCHxSikB+QHfu3gw4IFdmdYAZJd4ZRm2npYQ0ebFvweflU2FZUCH16i4jUqHq
	5AaeDAXI092uH+RL/XPg1k2/A+A7gu0PL626j+ykKC9emhM5ybAefW/6RnOnuLlQ3WpS1s+sg54
	w7CQ5IlKkDuoY0GK+OwAcIC4YEnE/dVlPsBIHPD8VfWj28T/gmwTgsePe2e1zn+PvkXVlmpN/Ed
	+RNVkJ1KQ4HzjgwLvAZlEOB4FNeWsGSLGAo+d64NyJlMIohyCvq7h+iLDhkeAftzXXLlv023Qre
	Cu2uSWuy0z9JFh3dlLCsxNrp1M3NCVzI0wrJ8D8j89zgH6cDHIGPr39xCVuz41vd9ox0L29MQaG
	3E5N1fmPiw/YmKJzJrnqQN0hkrE9DvlLPcWBiOOz2rU9uvHhejCZWwM6tg+NcOPUmdklSpjDmIY
	MxhuSCn6T27gWp0iBc=
X-Received: by 2002:a17:903:230b:b0:2ca:d975:5bbd with SMTP id d9443c01a7336-2d3455ffabcmr25703105ad.20.1786509840697;
        Tue, 11 Aug 2026 21:44:00 -0700 (PDT)
Received: from jubuntu-dev.. (211-23-39-77.hinet-ip.hinet.net. [211.23.39.77])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d350fb0cd0sm1177695ad.4.2026.08.11.21.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 21:44:00 -0700 (PDT)
From: Hsiu-Hsien Lee <swinds24@gmail.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	jack@suse.cz,
	libaokun@linux.alibaba.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	harshadshirwadkar@gmail.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hsiu-Hsien Lee <swinds24@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] ext4: fix fast commit replay failing on a read-only mount
Date: Wed, 12 Aug 2026 12:43:53 +0800
Message-ID: <20260812044353.1018268-1-swinds24@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A filesystem with fast_commit that needs recovery cannot be mounted
read-only:

  EXT4-fs (dm-0): INFO: recovery required on readonly filesystem
  EXT4-fs (dm-0): write access will be enabled during recovery
  WARNING: CPU: 22 PID: 5544 at fs/ext4/ext4_jbd2.c:73
   ext4_journal_check_start
   __ext4_journal_start_sb
   __ext4_unlink
   ext4_fc_replay
   do_one_pass
   jbd2_journal_recover
   jbd2_journal_load
   __ext4_fill_super
  JBD2: journal recovery failed
  EXT4-fs (dm-0): error loading journal

Fast commit replay runs ext4 metadata operations instead of writing
blocks through the buffer cache: ext4_fc_replay_{unlink,link,create}()
reach __ext4_unlink() and __ext4_link(), which start a handle.
ext4_journal_check_start() returns -EROFS on a read-only sb, and as
that is not -ENOENT it propagates out of jbd2_journal_recover() and
kills the whole recovery.  The EXT4_FC_REPLAY check that would hand
out a no-journal handle sits after the sb_rdonly() test, so replay can
never complete read-only.

ext4_load_journal() has already promised that write access will be
enabled during recovery, so make that true for the superblock as well:
clear SB_RDONLY across jbd2_journal_load() when recovery is needed on a
read-only mount and the devices are writable, as ext4_orphan_cleanup()
does.  Unlike ext4_handle_error(), which avoids SB_RDONLY because it
would need s_umount, the sb here is still inside ext4_fill_super() and
not published, so nothing can observe it.

The failure is not clean either: the replay handlers passing a NULL
handle (ext4_fc_replay_inode(), _add_range(), _del_range()) never hit
ext4_journal_check_start() and do write, leaving a partially applied
fast commit behind.

Reproducer, where the unlink only ever reaches the fast commit area:

  mke2fs -q -F -t ext4 -O fast_commit -b 4096 /dev/sdb3 262144
  mount /dev/sdb3 /mnt
  dd if=/dev/zero of=/mnt/victim bs=4k count=1 conv=fsync
  sync                          # victim now in a full commit
  rm /mnt/victim
  dd if=/dev/zero of=/mnt/trigger bs=4k count=1 conv=fsync
  <crash, or snapshot the device while mounted and write it back>
  mount -o ro /dev/sdb3 /mnt

Without this patch that mount fails; with it recovery completes and
victim is gone, i.e. the UNLINK record was really replayed.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Cc: stable@vger.kernel.org
Signed-off-by: Hsiu-Hsien Lee <swinds24@gmail.com>
---
 fs/ext4/super.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 245f67d10ded..6c2b275a9cf3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6096,6 +6096,7 @@ static int ext4_load_journal(struct super_block *sb,
 	int err = 0;
 	int really_read_only;
 	int journal_dev_ro;
+	bool enable_write = false;
 
 	if (WARN_ON_ONCE(!ext4_has_feature_journal(sb)))
 		return -EFSCORRUPTED;
@@ -6152,6 +6153,7 @@ static int ext4_load_journal(struct super_block *sb,
 			}
 			ext4_msg(sb, KERN_INFO, "write access will "
 			       "be enabled during recovery");
+			enable_write = true;
 		}
 	}
 
@@ -6168,7 +6170,19 @@ static int ext4_load_journal(struct super_block *sb,
 		if (save)
 			memcpy(save, ((char *) es) +
 			       EXT4_S_ERR_START, EXT4_S_ERR_LEN);
+		/*
+		 * Fast commit replay performs regular ext4 metadata updates
+		 * (see ext4_fc_replay()) which refuse to run on a read-only
+		 * superblock.  We promised write access above, so make that
+		 * true for the duration of the recovery, the same way
+		 * ext4_orphan_cleanup() does.  The superblock is not published
+		 * yet, so nothing can observe the transient state.
+		 */
+		if (enable_write)
+			sb->s_flags &= ~SB_RDONLY;
 		err = jbd2_journal_load(journal);
+		if (enable_write)
+			sb->s_flags |= SB_RDONLY;
 		if (save && memcmp(((char *) es) + EXT4_S_ERR_START,
 				   save, EXT4_S_ERR_LEN)) {
 			memcpy(((char *) es) + EXT4_S_ERR_START,
-- 
2.43.0


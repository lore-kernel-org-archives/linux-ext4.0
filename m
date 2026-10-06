Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B351C3AE712
	for <linux-ext4@vger.kernel.org>; Tue,  6 Oct 2026 07:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791270033; cv=none; b=BiP4KiGPPTdnDkfQUn2oJu4b0YZf/VntLIQcmhNepSPKOtlafWZ4fW3aB/CbwwUZzPAOZ4r6kWP38uq/TP+2XPnCYeC9DaS2Zj7byZeXMBd6+j/jwWWYVipAZ8nEJHzN2BSbqwHmkhuvWjHtAdCIQ4R20HH28/rLBk+xSF8ZKZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791270033; c=relaxed/simple;
	bh=pK0QSwfeQ91TLluv1jW8CAI5EntbFutWZKmpXop9JJk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cEmH+w9Xf8kPW4frVZO0ts015WiqTq0jMdUoYlS9QCPNW1etQ9srqdzmRXXLpaHn4jgOriQnuke4OiEbLvEKzrCdO9/a725maOHYYeeYdAzGLcghsXPU7q2+bbeijxzJY4+0YeqQKmkR9jcL99XTMVsq1Sm2gkdt9BqHlXZeHKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z4ef4wNt; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z4ef4wNt"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e4a61a2fa4so3813825ad.0
        for <linux-ext4@vger.kernel.org>; Tue, 06 Oct 2026 00:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791270022; x=1791874822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=e4QBIhi+LQCZRYPDQGugLgDUtprAsIP/I0Fh4u76lJE=;
        b=Z4ef4wNtOR8fNPwEu+mGEHojFyaHxeXsgMZQr+Ul1ujWRwiztxqhwhTGpsabY8T9Rp
         sSyPZb1uPLVsP1lqf+1xU3Hai4ZMppGGIxsb0oPMGWNpHubGH2YmMmJIWJWejDMl+eWk
         sAF+FNotkGZeLdpxuSrBjIE3IhnbWbnM2eu/hFCk1uxUSInS0l7u3yVNRhVAYf/xDUJJ
         x0JITRLmIcK5ft5lAwmpEnLDX5fQjzbg07/7vF6NgJnolFvPb3lWi0eeeqfqKbtRPmsx
         03BS4iL+j8z/WsCNr8s/M2/Fhnf3wwjnnuLkDjlzub2MCfRsW8NANFYNVUJxt46BceTu
         4XaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791270022; x=1791874822;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e4QBIhi+LQCZRYPDQGugLgDUtprAsIP/I0Fh4u76lJE=;
        b=LrZEyxoW2dv65TjbC3xU1l0sybpQL0BVohvLd64BZdmiIHWrP3UUTCEhkrFX171TaN
         X9VGJkXoSRpreOzHZye5+kRjvGJ5eoGlKUAijYpYf4QBzbbsDdHe8lr+ShxmizgKodyD
         H3lFMRriVU3SNa1W3NiEPncOGaVwz/IXG0jtvPeSONjxqZ/3aIWhUY2MxE1zFF2UbjmQ
         FmQxcZk6MQvtALraVs/PgwnsqhGbk7g8bggNyXX4RNnTeYsb6/DLXkpC24+et5Sw0XYn
         SbNNli3dcVS6rUmXp0eW7D9A5DMBK5FTfxKVxe9AJjXJKmOCpZoGfJRab0Hjd2C0fL7p
         Q1MQ==
X-Forwarded-Encrypted: i=1; AKwUvBzCN40OvNNvMSjIG3qF+GHgT/0o9N0fMbl2ALWuZpsZbPJKjyy+rcAGDYWI+MKerpKh88FN66imYUel@vger.kernel.org
X-Gm-Message-State: AFq9FYID+5p/GZaWR81hXmVyHl65RdOowUGZJ1EV8hH5lq+OAnvuOBgU
	IUTjheHiDAOZI3OsFLLDlyMf4h8sb/4DfrT0CWmO3YghrUljY2ox8GKy
X-Gm-Gg: AYBFou2S7/xh76Qgs3wQVWg2sz4mhVmVhpxrWoqEsVPAj9SlhsySsFQknYignCKciAj
	AGV4fYHqh9NsnI13HDKP0ZAH7AzcukjCS05g+Qal7AdYUfd+gzQYVRQ8+K+8hHIZciOSRGS91EK
	BPCPenv7dRncr4gOa73OTplPfpt1VEtbjf3VOsl1HL4M9Y1q5Qrc8IhK2g8X34F7cRHpFOyjfvv
	8R4QR2wL2N2FrQUjuaFEDb+v7AUK/x5g3cobs4iNnUiw2pYLNSrUSGj8adyxcvspxm3tMbgKmsE
	jESSaG707Ufqy6Z41cjznWWQXSzwlsKEOYmrvbmpRR2MVoYyfaEvIC94rZWN/zvS0QHxqX8dyht
	9Gwx2eLStxPtlxQI8r1lzSZHQ9xSJ7AAFydwgxRGjMqOnGxy873uoIOG/yTTvkflyw0JVL3vdL1
	nFtABMU7yghV2rFr5QPnbI/2XdU81ZaXTrsMh16BmmuMshgKua0S/ZNRlr1ExmEFy0AVgGaXvON
	unQqFA8MotbezZqhv5Cjovpq7x2ynjlbfCDw5g6Wl32
X-Received: by 2002:a17:902:ef12:b0:2e4:affe:e06a with SMTP id d9443c01a7336-2e5dcde6482mr5648475ad.56.1791270021708;
        Tue, 06 Oct 2026 00:00:21 -0700 (PDT)
Received: from jubuntu-dev.. (125-227-154-99.hinet-ip.hinet.net. [125.227.154.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e5a5eb3840sm18338685ad.34.2026.10.06.00.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 00:00:21 -0700 (PDT)
From: Hsiu-Hsien Lee <swinds24@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-kernel@vger.kernel.org,
	Hsiu-Hsien Lee <swinds24@gmail.com>
Subject: [PATCH] ext4: don't fail journal recovery on an incomplete fast commit
Date: Tue,  6 Oct 2026 15:00:05 +0800
Message-ID: <20261006070005.1209234-1-swinds24@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the system crashes while the first fast commit after a full commit is
being written, the fast commit area can hold the head of that fast
commit without a valid tail.  ext4_fc_replay_scan() treats this as an
error as long as no valid tail has been seen: an invalid tag length or
an unknown tag returns -ECANCELED, a tail with a wrong tid or checksum
returns -EFSBADCRC.  jbd2_journal_recover() then fails, the file system
can be mounted neither read-write nor read-only, and the regular journal
transactions committed before the fast commit are not replayed either:

  JBD2: journal recovery failed
  EXT4-fs (sdb): error loading journal

The tail is written last and fsync() does not return before it has
completed, so an incomplete fast commit was never reported as durable.
Handle it like jbd2 handles a transaction without a valid commit block:
stop the scan and replay what is valid.  This is already what happens
when an earlier fast commit in the area has a valid tail.  Log a
warning so that the dropped fast commit is visible.

Reproducer, with the power cut emulated by copying the device while it
is mounted:

  mkfs.ext4 -O fast_commit /dev/sdb
  mount /dev/sdb /mnt; mkdir /mnt/d
  create 20 files in /mnt/d; sync
  write a fragmented file and modify the 20 files, fsync one file
      (one fast commit spanning several blocks)
  copy /dev/sdb while still mounted, then zero the block holding the
  fast commit tail in the copy
  mount the copy

Without this patch the mount fails as above.  With it, the mount
succeeds, the state after sync is recovered and e2fsck finds no errors.
The same holds when a full commit precedes the torn fast commit, in
which case the full commit is now replayed as well.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Assisted-by: Claude Opus 5.5
Signed-off-by: Hsiu-Hsien Lee <swinds24@gmail.com>
---
 fs/ext4/fast_commit.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 0cac890cf370..5649447b9524 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -2427,6 +2427,26 @@ static bool ext4_fc_value_len_isvalid(struct ext4_sb_info *sbi,
 	return false;
 }
 
+/*
+ * The fast commit area ends with an invalid tag or a tail that does not
+ * match.  This is how a fast commit that was only partially written before
+ * a crash looks like: its tail is written last and fsync() only returns
+ * after the tail write has completed, so nobody was told that this fast
+ * commit is durable and it can simply be dropped, the same way jbd2 drops
+ * a transaction without a valid commit block.  Everything up to the last
+ * valid tail is still replayed.
+ */
+static int ext4_fc_replay_scan_end(struct super_block *sb,
+				   struct ext4_fc_replay_state *state,
+				   int off, const char *reason)
+{
+	if (!state->fc_replay_num_tags)
+		ext4_msg(sb, KERN_WARNING,
+			 "ignoring incomplete fast commit at block %d: %s",
+			 off, reason);
+	return JBD2_FC_REPLAY_STOP;
+}
+
 /*
  * Recovery Scan phase handler
  *
@@ -2440,7 +2460,9 @@ static bool ext4_fc_value_len_isvalid(struct ext4_sb_info *sbi,
  * This function returns JBD2_FC_REPLAY_CONTINUE to indicate that SCAN is
  * incomplete and JBD2 should send more blocks. It returns JBD2_FC_REPLAY_STOP
  * to indicate that scan has finished and JBD2 can now start replay phase.
- * It returns a negative error to indicate that there was an error. At the end
+ * It returns a negative error to indicate that there was an error. An invalid
+ * or incomplete fast commit at the end of the area is not an error, see
+ * ext4_fc_replay_scan_end(). At the end
  * of a successful scan phase, sbi->s_fc_replay_state.fc_replay_num_tags is set
  * to indicate the number of tags that need to replayed during the replay phase.
  */
@@ -2489,8 +2511,8 @@ static int ext4_fc_replay_scan(journal_t *journal,
 		val = cur + EXT4_FC_TAG_BASE_LEN;
 		if (tl.fc_len > end - val ||
 		    !ext4_fc_value_len_isvalid(sbi, tl.fc_tag, tl.fc_len)) {
-			ret = state->fc_replay_num_tags ?
-				JBD2_FC_REPLAY_STOP : -ECANCELED;
+			ret = ext4_fc_replay_scan_end(sb, state, off,
+						      "invalid tag length");
 			goto out_err;
 		}
 		ext4_debug("Scan phase, tag:%s, blk %lld\n",
@@ -2530,8 +2552,8 @@ static int ext4_fc_replay_scan(journal_t *journal,
 				state->fc_regions_valid =
 					state->fc_regions_used;
 			} else {
-				ret = state->fc_replay_num_tags ?
-					JBD2_FC_REPLAY_STOP : -EFSBADCRC;
+				ret = ext4_fc_replay_scan_end(sb, state, off,
+							      "invalid tail");
 			}
 			state->fc_crc = 0;
 			break;
@@ -2551,8 +2573,8 @@ static int ext4_fc_replay_scan(journal_t *journal,
 				EXT4_FC_TAG_BASE_LEN + tl.fc_len);
 			break;
 		default:
-			ret = state->fc_replay_num_tags ?
-				JBD2_FC_REPLAY_STOP : -ECANCELED;
+			ret = ext4_fc_replay_scan_end(sb, state, off,
+						      "unknown tag");
 		}
 		if (ret < 0 || ret == JBD2_FC_REPLAY_STOP)
 			break;
-- 
2.43.0


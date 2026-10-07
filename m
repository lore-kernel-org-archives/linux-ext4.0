Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFC2331EDF
	for <linux-ext4@vger.kernel.org>; Wed,  7 Oct 2026 04:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791346118; cv=none; b=CxwAZln+JoVeCeUBM8kaRZ0ez65VmWJ8SL8oYMeVJ8nXGD6Lbwb01KdS81xBD/yGgvbsqjXS81ZoW5r2MDKZXDfTxj+lDSDCBRz/wPeeQuc2jxGymKkqRRsGUos/CPC2Pbk06XCMNaNuNPnVirNwiSbdu7vSjnHiAv0gNmC3VL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791346118; c=relaxed/simple;
	bh=ZeUSlO6QG/0suKKj6v4gTeXtxcfO7uYhj5F1UK0pwoA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aKCHYuBzwDZUUP3K2cFwuvAKpAxtaps2NuUueXcsVlMzEikSzD+gu4oMaFlVGu5eF7TYaNcptkkL4nm7/agWA4HQ9ZCmxdRMnc2pizFbEDwFFWPxCsKZqDIv8pJYwbF3Bei77avMjZ7m9HlV2pxjKFp3tlmEgk9/BurN7Nbytmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WX1c1m+T; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WX1c1m+T"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc4dbda1e5dso719844a12.2
        for <linux-ext4@vger.kernel.org>; Tue, 06 Oct 2026 21:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791346116; x=1791950916; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aavgm8XuyoOvFfWK19tQpulJeFqNL3Mu2MGTeCERXYU=;
        b=WX1c1m+TZQeHjwcZ/WqsRO8fqp3NtNvRwoE8bUVvShmxF9yZwfJ4/uJlzJkxNUlnZR
         thUwvGk/m72cSbpZCVFJx+AgnaD7qRYAN0t6brPRI1SR0mWzkhfz0hZeo0pIMJyzvBcb
         jgo50XuRj2GfXlBEnONEH0S3WES9w0fvqAEm9QSoVz1ahXNW0RDJ+PcwQit68Cu0edYN
         kWlxfkmtct8injqiUBeYLTyodishXwLs0c0y/hVFpHwCyBosKrTvl2vl0nfCes1GNdii
         rkJeY0nsw0sHg9tgFFIpAWiU8sHBcWr5z6EIxF/Gg39+nRqydDKY2n3bkc+1P7MeAyor
         229Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791346116; x=1791950916;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aavgm8XuyoOvFfWK19tQpulJeFqNL3Mu2MGTeCERXYU=;
        b=zl6gSX6cgHb9n4wwNTFffef2KlH3QxFZWqqWuycNL9j+ZoCukiZxw2pLgsJ80DHhK+
         oTpG0CYSGsJMiQ15ZKnVh0ZXqme9CoMG8jQyttUh804hy+BFtVzy9f7EKC8mzW6qb9Zw
         n0/xnd+SquYSYgVMei3ZFK91oppyfMSpBNR2XKxGKzYT+E5bnaSfq2efvKa/D6Pccmlu
         wUJ5DAmoYNJkIojhJw0Tb4Fwc7lFRXCc4SETlRKGPDhxQLBBVHyfudl16BXmcGA7f5VA
         y3cpHZyvZbw1JBFfHKqM591qSOztiHRgCAMlgSBiFzYk8OBcCJwv8BRG3PdGoUWg8dXY
         zOUA==
X-Forwarded-Encrypted: i=1; AKwUvByDv7Ll8P10Lc9F99Cxv9mAtRMlNGa1/s7RlTg/uvKv+Zz+gKMqasBCPB9uGhLIKKW4oisGIyp55tz2@vger.kernel.org
X-Gm-Message-State: AFq9FYLL+Or0BjSvI0UG8zlp4xCVdEAaWN2vgZF+EEDfZQWWmnEDddwn
	Lxwf4AnU+6D8wynScAZO9s86PG7+SqQtXAm3iIonZx6cu/62z4yJ2Jlb
X-Gm-Gg: AYBFou0AeKVFDWLQijy0ZINFasAXw5U/gaVOv3t9tvcSuUN9Pxr6xJ57+WL81SkwtBj
	QR4d2z7IAY1RIEOTFU0usQOIQnYDUpLCpL20PoTHTMbqvC7affob5atNbGV8aRSgDFb7FFh5HNJ
	tTZTUNxFNPI4078RBug7zyMjvWit1n2gFcj7zpcbBi4YNp6RQsx9HFHcS6LYKiySklFIwbKckD3
	7yDfJGyV/33yc45YQdRxqumk9AaX+NP/G51N54ybP5p+6N6mbTl6KkbcF2Hq9gE1R7J11d8eA6x
	kn+LHLwm0ucCyaNXCGiOGl0IDyjSnvslzAcckVuMyvfa4xHoX4yNmLzGbfpEkEIH3jWm384wr8z
	26J65TZWzCGl2UNha2J4q68+FH+E0zGoaWTMgHEx3ibNv7ZkNS+IfTd9ZnfyzdCU8SP2uXQs8Q5
	P3fp4hPcshZKeabwjM/9d2Sl/gI93rd0pZN5e+dNU+TZZxIHpEda1DYhyKylDHWTJAXE0xPW9xm
	MS+IUnxvGloxMwsBEJXDQDvsvDoSu987Q==
X-Received: by 2002:a17:90b:37d0:b0:3a8:5d57:a5eb with SMTP id 98e67ed59e1d1-3a8a19478d4mr827067a91.15.1791346116045;
        Tue, 06 Oct 2026 21:08:36 -0700 (PDT)
Received: from jubuntu-dev.. (125-227-154-99.hinet-ip.hinet.net. [125.227.154.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a89b7727a1sm2476237a91.17.2026.10.06.21.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 21:08:35 -0700 (PDT)
From: Hsiu-Hsien Lee <swinds24@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-kernel@vger.kernel.org,
	Hsiu-Hsien Lee <swinds24@gmail.com>
Subject: [PATCH v2] ext4: don't fail journal recovery on an incomplete fast commit
Date: Wed,  7 Oct 2026 12:08:29 +0800
Message-ID: <20261007040829.2074386-1-swinds24@gmail.com>
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
when an earlier fast commit in the area has a valid tail.

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
Changes in v2:
- Drop the warning and the helper, use ext4_debug() and set the return
  value inline (Jan Kara)
- v1: https://lore.kernel.org/linux-ext4/20261006070005.1209234-1-swinds24@gmail.com/

Testing: re-tested on 6.6.y with the same crash images used for v1 and
for the unpatched baseline (identical files).  Without the patch, all
torn first-fast-commit variants fail to mount rw and ro with "JBD2:
journal recovery failed".  With v2, all of them mount rw and ro, the
state of the last full commit is recovered and e2fsck -fn is clean.
Images with intact fast commits, or with a torn fast commit after a
valid one, behave the same with and without the patch.  The tail was
torn by zeroing whole blocks, so only the invalid tag length path was
exercised.

 fs/ext4/fast_commit.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 0cac890cf370..165950e2b7d9 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -2443,6 +2443,12 @@ static bool ext4_fc_value_len_isvalid(struct ext4_sb_info *sbi,
  * It returns a negative error to indicate that there was an error. At the end
  * of a successful scan phase, sbi->s_fc_replay_state.fc_replay_num_tags is set
  * to indicate the number of tags that need to replayed during the replay phase.
+ *
+ * An invalid tag or a tail that does not match ends the scan without an error.
+ * This is what a fast commit that was only partially written before a crash
+ * looks like.  Its tail is written last and fsync() does not return before
+ * the tail is on disk, so such a fast commit was never reported as durable and
+ * is simply dropped, like jbd2 drops a transaction without a commit block.
  */
 static int ext4_fc_replay_scan(journal_t *journal,
 				struct buffer_head *bh, int off,
@@ -2489,8 +2495,9 @@ static int ext4_fc_replay_scan(journal_t *journal,
 		val = cur + EXT4_FC_TAG_BASE_LEN;
 		if (tl.fc_len > end - val ||
 		    !ext4_fc_value_len_isvalid(sbi, tl.fc_tag, tl.fc_len)) {
-			ret = state->fc_replay_num_tags ?
-				JBD2_FC_REPLAY_STOP : -ECANCELED;
+			ext4_debug("Scan phase, invalid tag length, blk %lld\n",
+				   bh->b_blocknr);
+			ret = JBD2_FC_REPLAY_STOP;
 			goto out_err;
 		}
 		ext4_debug("Scan phase, tag:%s, blk %lld\n",
@@ -2530,8 +2537,9 @@ static int ext4_fc_replay_scan(journal_t *journal,
 				state->fc_regions_valid =
 					state->fc_regions_used;
 			} else {
-				ret = state->fc_replay_num_tags ?
-					JBD2_FC_REPLAY_STOP : -EFSBADCRC;
+				ext4_debug("Scan phase, invalid tail, blk %lld\n",
+					   bh->b_blocknr);
+				ret = JBD2_FC_REPLAY_STOP;
 			}
 			state->fc_crc = 0;
 			break;
@@ -2551,8 +2559,9 @@ static int ext4_fc_replay_scan(journal_t *journal,
 				EXT4_FC_TAG_BASE_LEN + tl.fc_len);
 			break;
 		default:
-			ret = state->fc_replay_num_tags ?
-				JBD2_FC_REPLAY_STOP : -ECANCELED;
+			ext4_debug("Scan phase, unknown tag %d, blk %lld\n",
+				   tl.fc_tag, bh->b_blocknr);
+			ret = JBD2_FC_REPLAY_STOP;
 		}
 		if (ret < 0 || ret == JBD2_FC_REPLAY_STOP)
 			break;
-- 
2.43.0


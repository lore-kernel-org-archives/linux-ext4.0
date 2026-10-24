Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792838704;
	b=q6JUwrmIbCpbgS6kWIJNvBJhIn00ENt4STk1JotV0YU1IyPiOarwa3lTNufqXqK4YBJ0
	 PtIrEazuJSCw1/UJ8pdoy7ZW3omKX4/wBrRwfFrdZijZATa6PS8KX9J6LDoQiI3yBP30g
	 8yE8dVbK60l5JtXFS9+2lMXzmfQPf2WSD1vgeS99gauqIExT+Cz5fwBnl9fvKmOmrhey3
	 5FhDbg51ELJ/SrWxKo5MQ3O5i6BS8h0V4Vvgd27mHXyfluxoGic2R3srKscweKeTzbXxP
	 WGHb2TRoLLUaUniSCOmCPv44EfulnuO+bRtuKgttxVII+tvVVNY7QTboZWS46QwS0Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792838704;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=BgrXdcaq4UhrqfD6q+1coD/c2HjcAw1EOOV8MSzq5gw=;
	b=sntiINHUA3/wD92LCaNP8qONwiyCfsfmxNjNaGtl7htP/fzgHFHyHzOAeFl1lgcruAqc
	 jwjvrWzbTkknxAsE+zBbGP1bQTHD5btVC2LVT/GW54FMLZSW7FfpqaBbv0a3WisWf8ARp
	 NQtvdbbtBL0FK1OavdkCu2/pLJ4apF+oJp5kRJJWkzlmVwiZnmKrkr0nCfKwanD1Q6bL0
	 iQFjlWHrkE2Pkclu4wezwLNgByzNjNc4AxO+holOPYtHZU7bBzx/Lwh8kUmcjrlmceeYV
	 X8v6hTEW+7aKbpVXKTeVz6f5TbHnrtXUIMSAgXjbHEnI6PMDevH8kawJsU/nmAgJLXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=czerner.cz;
	spf=pass smtp.mailfrom=czerner.cz;
	dkim=pass header.d=czerner.cz header.i=@czerner.cz header.a=rsa-sha256 header.s=protonmail3 header.b=LfI3ZOke;
	arc=none smtp.remote-ip=79.135.106.112
Received: from mail-106112.protonmail.ch (mail-106112.protonmail.ch [79.135.106.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DB0606A31A
	for <linux-ext4@vger.kernel.org>; Sat, 24 Oct 2026 10:45:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11DB0606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=czerner.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=czerner.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=czerner.cz header.i=@czerner.cz header.a=rsa-sha256 header.s=protonmail3 header.b=LfI3ZOke
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=czerner.cz;
	s=protonmail3; t=1792838700; x=1793097900;
	bh=BgrXdcaq4UhrqfD6q+1coD/c2HjcAw1EOOV8MSzq5gw=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=LfI3ZOkePp0GkGVSBQrrY2YhwVnnw/Nic6NSxoXf19SKJGKN3n16SuWlUi+7AqhO5
	 CQfP+6j/FS+nzIuysVR14Mq2nJ2VUJhUuVofeDmyrk5WKdBOpirOjn3IeSLL0VJPvU
	 fJS0SKPmexe4Xy97iy+ZmfdI8bSfGajsZAJBvjVZNjjFIgzQYYwTetsVVQq8AyJBRL
	 QAOfKCVYIIDkgKxspKttNrjv4LRpkhdRiagmmoqBV4Y1rPruTj8VpQdBFwifrO4hkW
	 UM9snBOfh2y+zNg1PDRTurumS5Mc50qtJWvD48KPyLeRX5+iAj8RWALX9VTaTvmsh8
	 XI6pwOVJzuCqA==
X-Pm-Submission-Id: 4jBc3D3Rjpz1DDnZ
From: Lukas Czerner <lukas@czerner.cz>
To: linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Lukas Czerner <lukas@czerner.cz>
Subject: [PATCH] ext4: free fast commit replay state on failed mounts
Date: Sat, 24 Oct 2026 12:44:07 +0200
Message-ID: <20261024104407.1037354-1-lukas@czerner.cz>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_fc_replay_cleanup() is only ever called on the success path of
__ext4_fill_super(). Fast commit replay runs from jbd2_journal_load(),
so a mount that fails after that point leaks the fc_regions and
fc_modified_inodes allocated during replay.

Call ext4_fc_replay_cleanup() from the failed_mount3a error path, which
every failure after jbd2_journal_load() goes through. Do it after
draining deferred EA inode iputs, so evictions still run with
EXT4_FC_REPLAY set. On paths where no replay happened both are NULL so
this would be a no-op.

Failures after the success path ext4_fc_replay_cleanup() call fall
through failed_mount3a as well, so set both pointers to NULL after
freeing them to avoid a double free.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Signed-off-by: Lukas Czerner <lukas@czerner.cz>
---
 fs/ext4/fast_commit.c | 2 ++
 fs/ext4/super.c       | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 0cac890cf370..e8917bce67af 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -2397,7 +2397,9 @@ void ext4_fc_replay_cleanup(struct super_block *sb)
 
 	sbi->s_mount_state &= ~EXT4_FC_REPLAY;
 	kfree(sbi->s_fc_replay_state.fc_regions);
+	sbi->s_fc_replay_state.fc_regions = NULL;
 	kfree(sbi->s_fc_replay_state.fc_modified_inodes);
+	sbi->s_fc_replay_state.fc_modified_inodes = NULL;
 }
 
 static bool ext4_fc_value_len_isvalid(struct ext4_sb_info *sbi,
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3ace06b4f9e3..d368b87a537a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5813,6 +5813,7 @@ failed_mount8: __maybe_unused
 failed_mount3a:
 	/* Drain deferred EA inode iputs from journal replay */
 	flush_delayed_work(&sbi->s_ea_inode_work);
+	ext4_fc_replay_cleanup(sb);
 	ext4_es_unregister_shrinker(sbi);
 	ext4_es_destroy_stats(sbi);
 failed_mount3:
-- 
2.56.0


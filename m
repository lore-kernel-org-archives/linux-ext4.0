Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794438168;
	b=olDRyfyjTW24L89t3kbkUsuDu4dyp51bCE3K8IRXH+xE9J/mC5gcTla3vf6gL1zRTj97
	 TV8r0wQnmT+Ttz4jYr8WYYVE2JI3SO3ughtGvtP1NS7VUA6WVI67uH6iEaJ4CUyO+PdM5
	 1rJ6kT3a2T5ZRR5jROnL8P6ggPjS8s0/Qw7cpx9oOCE04vbbSDPYX7u05U9xWSkoydW9d
	 CIG8h5acgYzRvUDB8jdYvflCT2MgfNruMdt9CabsDvx/2e7U48ZjRhSsx+LMZtskUUdaO
	 /lDLORQ/Zlv5CajxAaOdKGPM3qcz+w6GVSnlqlimYeU6t15KPAIDXmoYTCXSgbvKvgA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794438168;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=aQ20vb8Bet0kUFiWnP39yfO89c23b2KfFHWpqDI0nbA=;
	b=FNz9XAW4gZNpW6gXK9DRgUiFLS7AGVi+gA0Ts3QkYYIbk7/seS7ejf8NcpxiGgvLB3by
	 5ag5iA0zkjLBvK6slxm9mVFlz4lM9/Sk+9+DRiAYR8W6jtItlKAzzTRuOFkX1OGH/Ra1/
	 g4RgMIqmMzjmFM50/xzedm3P0VrLk8nwb8oq35kVpW5OhrvYyvKLObN3JBM6WNVyPmZVi
	 i79RUluWcOmnJ+Ne1vKyTea7GZe8g48Pk4hc7cxMtfY05q9Ubs+37xxx2h3yH6f/5JhVY
	 0/LT7100KFLoxTx6pw+r2WirTA4IzLSP8U3J9l3QCE11BFRRhJaA638n8A+AUn449Pg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OwfXvCcm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BD260A380C;
	Wed, 11 Nov 2026 23:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OwfXvCcm
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794438168;
	b=SFNpQnUiXRQsQ/VMnqSFLa0oYZTlLwPG8Z75glIG2Dvx4E5/mru8P6mptSx79RY571jG
	 RQbRKQWo4ykxRRPMRXe5/N8j8IZI5hHz4OmpNvRQz+gTqJ0P70/X2OJx/joSiwG87qhS1
	 S07r1h41QZgiuFFtcYlZUHpPRmdwi76zszujYQPn9kbXfRIf8q9uQ699gc1QNkX79lCD5
	 wYkuzizCyUqBfN9a99jbuLBjFZKhZcy2GcUDXMWVazM6evxESw54IaoOgFhUmzQr3k8uO
	 Ac6LduAY+uo7E71WBvHvTMe67bnBRDkNiQvkedD3kAw83Cvr2QYEYADqyqyzgYQWmxw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794438168;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=aQ20vb8Bet0kUFiWnP39yfO89c23b2KfFHWpqDI0nbA=;
	b=1GLyoVNvqS6I4jyQdWko6KvEcnM+VrWINSaU04HI/LrSAzc9OvKcUbFvj6uCePgfhqFd
	 Sgva6dar+ybFuu7GTbygfJuAEG+HPlGkChX7tvOyT87vZO3nLB9Lc8xMzNFIda+mIQ3NG
	 9C+o+ixNiPACi10n9y/PFctpirrVIAlaFgdyE8m3jOfDs02D6QoJOQKQw23b2JkTwlLCL
	 vipXJvE3jAuDgnzoCJwaGJnyFfNaeJgmJ9QMeiJa30AKHtt1uW9JTUJR+diGACeJD7+wA
	 wnSuAFjwgbYcK2ohB8ffCeqSlbA3SypRyclp0jcXyNUQjhGwaL00q5r+gz356POoUBA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 603001F00A0C;
	Wed, 11 Nov 2026 23:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794438168;
	bh=aQ20vb8Bet0kUFiWnP39yfO89c23b2KfFHWpqDI0nbA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=OwfXvCcm9yFo70eTOJGniN0E9GRZLDNMuvNQOFeR6UZ05OFG6Zq1E56VnOSfAfF3r
	 ZHpvkiMrg92ggDL1VcsedNO8a7m/vTdjiEHZr6iH3PYmiUzIJz/a3yD8EVQ2tTMJN5
	 srvILUm0ET9Ih1OgKg9I/40mcUrMspOWZsy+d/8FuUnBDIbfh8hT0mKuEz2kMSP5mX
	 mGOxXoPeCb4y4h+IHDKFyfMObMsSjMoInEaZ14r71WLBWiUQ2njWtohoCBgBrRK8ue
	 BQEgrCdmmyKOs199lts/M9TTqVu7sD8q4e8+FcCaaFtSkB2Rb82WdjLXbCmMg/1xlH
	 WZDyCQ74Bcjww==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D7BFD49159;
	Wed, 11 Nov 2026 23:02:45 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Wed, 11 Nov 2026 18:02:45 -0500
Subject: [PATCH 1/3] ext4: fix directory count after fast commit replay
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261111-ext4-fc-replay-mkdir-v1-1-4b20be29aed8@columbia.edu>
References: <20261111-ext4-fc-replay-mkdir-v1-0-4b20be29aed8@columbia.edu>
In-Reply-To: <20261111-ext4-fc-replay-mkdir-v1-0-4b20be29aed8@columbia.edu>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>, 
 Harshad Shirwadkar <harshadshirwadkar@gmail.com>, 
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 tz2294@columbia.edu, stable@vger.kernel.org, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794438165; l=3807;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=ImtH9yBJQanvkzGVDZNAzZ+LpPYNZJVGBXslCGNfD/s=;
 b=HvUFeKc3kMmZOzHYzygqp2gE7e20fECTP9LJ3Q3umKkWKVGzVgtoyRAYsCyueVREf94Qtyui+
 RM1mvs7qBqdBPlQ9BDo6JXeNuoY44Pj2JA122NBBUI++U9jnJxloSbx
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit

From: Mani Tofigh <mt4022@columbia.edu>

After a crash, the fast commit replay of a mkdir leaves the group's
directory count one short.  e2fsck reports:

  Directories count wrong for group #0 (2, counted=3).

The replay marks the inode of an INODE or CREAT tag used with
ext4_mark_inode_used().  That lowers the group's free inode count but
never raises bg_used_dirs_count since the function doesn't know the
inode's mode.

Pass the mode to ext4_mark_inode_used() and count directories there.
The INODE tag of a new directory comes first and does the counting.
ext4_fc_replay_create() now looks up the inode before marking it used
to get its mode.

With the fix, the directory count is right after the replay.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Cc: stable@vger.kernel.org
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
 fs/ext4/ext4.h        |  2 +-
 fs/ext4/fast_commit.c | 12 ++++++------
 fs/ext4/ialloc.c      |  4 +++-
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bf0325ecbec7..c5044aaddb69 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3059,7 +3059,7 @@ extern int ext4fs_dirhash(const struct inode *dir, const char *name, int len,
 			  struct dx_hash_info *hinfo);
 
 /* ialloc.c */
-extern int ext4_mark_inode_used(struct super_block *sb, int ino);
+int ext4_mark_inode_used(struct super_block *sb, int ino, umode_t mode);
 extern struct inode *__ext4_new_inode(const struct mnt_idmap *, handle_t *,
 				      struct inode *, umode_t,
 				      const struct qstr *qstr, __u32 goal,
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 0cac890cf370..0eac7be3f58c 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1984,7 +1984,7 @@ static int ext4_fc_replay_inode(struct super_block *sb,
 	ret = sync_dirty_buffer(iloc.bh);
 	if (ret)
 		goto out_brelse;
-	ret = ext4_mark_inode_used(sb, ino);
+	ret = ext4_mark_inode_used(sb, ino, le16_to_cpu(raw_fc_inode->i_mode));
 	if (ret)
 		goto out_brelse;
 
@@ -2041,11 +2041,6 @@ static int ext4_fc_replay_create(struct super_block *sb,
 	trace_ext4_fc_replay(sb, EXT4_FC_TAG_CREAT, darg.ino,
 			darg.parent_ino, darg.dname_len);
 
-	/* This takes care of update group descriptor and other metadata */
-	ret = ext4_mark_inode_used(sb, darg.ino);
-	if (ret)
-		goto out;
-
 	inode = ext4_iget(sb, darg.ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
 		ext4_debug("inode %d not found.", darg.ino);
@@ -2054,6 +2049,11 @@ static int ext4_fc_replay_create(struct super_block *sb,
 		goto out;
 	}
 
+	/* This takes care of update group descriptor and other metadata */
+	ret = ext4_mark_inode_used(sb, darg.ino, inode->i_mode);
+	if (ret)
+		goto out;
+
 	if (S_ISDIR(inode->i_mode)) {
 		/*
 		 * If we are creating a directory, we need to make sure that the
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 527f1f703c3e..e29faa8590c6 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -758,7 +758,7 @@ static int find_inode_bit(struct super_block *sb, ext4_group_t group,
 	return 1;
 }
 
-int ext4_mark_inode_used(struct super_block *sb, int ino)
+int ext4_mark_inode_used(struct super_block *sb, int ino, umode_t mode)
 {
 	unsigned long max_ino = le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count);
 	struct buffer_head *inode_bitmap_bh = NULL, *group_desc_bh = NULL;
@@ -860,6 +860,8 @@ int ext4_mark_inode_used(struct super_block *sb, int ino)
 	}
 
 	ext4_free_inodes_set(sb, gdp, ext4_free_inodes_count(sb, gdp) - 1);
+	if (S_ISDIR(mode))
+		ext4_used_dirs_set(sb, gdp, ext4_used_dirs_count(sb, gdp) + 1);
 	if (ext4_has_group_desc_csum(sb)) {
 		ext4_inode_bitmap_csum_set(sb, gdp, inode_bitmap_bh);
 		ext4_group_desc_csum_set(sb, group, gdp);

-- 
2.53.0



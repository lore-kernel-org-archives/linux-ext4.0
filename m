Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7BA2DDCEE;
	Tue, 29 Apr 2025 23:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970737; cv=none; b=a4t2p7p/YyNh7ujb2Uxv+nxoY5D3sazGwSDTXimOe57mGBnVUCLKCNOHDH2tRa7PWnR9ctZibVwcaJSwl3CCv9gEmaXa34SZEnTpc1oPQggx1i9OPoRusNzW2kWq4SHRy2iBHYSYMzHhNkxt4mEOR+TM/ToBNnjkoZTGACV2faM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970737; c=relaxed/simple;
	bh=hWNbhvRBcijb1nH7rU5gYmhKTyim5OmwVk1TauQ7sfY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uWcaU2FZZbEXEUxMnbdfymQ8WCJZYL5gVe5pCb9bI/B7Z72dfOG1ufQVILMFPFmr87sTA9a3W4CcaZevW4eibSboWzodx0O0fq48sjHawuqN7dqMdLgk7yb7GHdwkm+w2hJnlOjMeHVsYHgzDwUg2WYrD2gWfsyqlHJ4gDuFiK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZrpHDn2N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZrpHDn2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC2CC4CEEE;
	Tue, 29 Apr 2025 23:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970736;
	bh=hWNbhvRBcijb1nH7rU5gYmhKTyim5OmwVk1TauQ7sfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZrpHDn2Nu0RG5qS3ASVqFoUBcLNOfM6pMjdI3HS097Pjq9c9kIR1ho/LSDSaf42qc
	 ivv5XMqywetZ3SP6X0NW8li5MFpg4aZHUQuPO/o9PiBvCqORXzondvawgftneG1lLh
	 HTx+UnYefBJaVFHaXFf4t9Jgn0Icbe7XfJ9wB1rxJOx02F8v5j0taxgOEyRI1iTftn
	 PSAc8594Hfp00zVupIbjG5BZNZO9l+w8ZuBB7HqfmaJlxujwYIjuSmxzXk3k1D+D1i
	 x0cQ7xI0m63DewMVl1Ce71TXh7OvVoULhF18+xGzSrj2Iwv3EHctXIZCuf7xAqvXf6
	 fFabtz4QbB15Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Davidlohr Bueso <dave@stgolabs.net>,
	Jan Kara <jack@suse.cz>,
	kdevops@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	tytso@mit.edu,
	jack@suse.com,
	linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 29/37] fs/jbd2: use sleeping version of __find_get_block()
Date: Tue, 29 Apr 2025 19:51:14 -0400
Message-Id: <20250429235122.537321-29-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250429235122.537321-1-sashal@kernel.org>
References: <20250429235122.537321-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.25
Content-Transfer-Encoding: 8bit

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit f76d4c28a46a9260d85e00dafc8f46d369365d33 ]

Convert to the new nonatomic flavor to benefit from potential
performance benefits and adapt in the future vs migration such
that semantics are kept.

- jbd2_journal_revoke(): can sleep (has might_sleep() in the beginning)

- jbd2_journal_cancel_revoke(): only used from do_get_write_access() and
    do_get_create_access() which do sleep. So can sleep.

- jbd2_clear_buffer_revoked_flags() - only called from journal commit code
    which sleeps. So can sleep.

Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Link: https://kdevops.org/ext4/v6.15-rc2.html # [0]
Link: https://lore.kernel.org/all/aAAEvcrmREWa1SKF@bombadil.infradead.org/ # [1]
Link: https://lore.kernel.org/20250418015921.132400-6-dave@stgolabs.net
Tested-by: kdevops@lists.linux.dev
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/revoke.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index ce63d5fde9c3a..f68fc8c255f00 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -345,7 +345,8 @@ int jbd2_journal_revoke(handle_t *handle, unsigned long long blocknr,
 	bh = bh_in;
 
 	if (!bh) {
-		bh = __find_get_block(bdev, blocknr, journal->j_blocksize);
+		bh = __find_get_block_nonatomic(bdev, blocknr,
+						journal->j_blocksize);
 		if (bh)
 			BUFFER_TRACE(bh, "found on hash");
 	}
@@ -355,7 +356,8 @@ int jbd2_journal_revoke(handle_t *handle, unsigned long long blocknr,
 
 		/* If there is a different buffer_head lying around in
 		 * memory anywhere... */
-		bh2 = __find_get_block(bdev, blocknr, journal->j_blocksize);
+		bh2 = __find_get_block_nonatomic(bdev, blocknr,
+						 journal->j_blocksize);
 		if (bh2) {
 			/* ... and it has RevokeValid status... */
 			if (bh2 != bh && buffer_revokevalid(bh2))
@@ -466,7 +468,8 @@ int jbd2_journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
 	 * state machine will get very upset later on. */
 	if (need_cancel) {
 		struct buffer_head *bh2;
-		bh2 = __find_get_block(bh->b_bdev, bh->b_blocknr, bh->b_size);
+		bh2 = __find_get_block_nonatomic(bh->b_bdev, bh->b_blocknr,
+						 bh->b_size);
 		if (bh2) {
 			if (bh2 != bh)
 				clear_buffer_revoked(bh2);
@@ -495,9 +498,9 @@ void jbd2_clear_buffer_revoked_flags(journal_t *journal)
 			struct jbd2_revoke_record_s *record;
 			struct buffer_head *bh;
 			record = (struct jbd2_revoke_record_s *)list_entry;
-			bh = __find_get_block(journal->j_fs_dev,
-					      record->blocknr,
-					      journal->j_blocksize);
+			bh = __find_get_block_nonatomic(journal->j_fs_dev,
+							record->blocknr,
+							journal->j_blocksize);
 			if (bh) {
 				clear_buffer_revoked(bh);
 				__brelse(bh);
-- 
2.39.5


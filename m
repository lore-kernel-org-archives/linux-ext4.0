Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68FE29C862;
	Tue, 29 Apr 2025 23:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970738; cv=none; b=scPc8iLTyWChsLmeDcJfGR5nrd4ea0m4ZokYlDv24V9FxTzqOuDM99herCCfLU1JnYLYEJy5AHM9rUl3pTSSvzVl4oBSlvixwZwkvYAa1tBfez7ixouCIEoZy74CI6jjvIwUAk3fQ6kU/zIvzA1Pfpu1iBUDgfztuJpe7PmDKmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970738; c=relaxed/simple;
	bh=HvRvmphcCQrUIZGBZtMSzlflDdh2AqhPTV8DfFVDNbI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gxj33LIsXsvqrtuBNOb+Q+UtPYB6rOWcdKvdXTk82t+j/hHjfksmFYDvYhEWdHhSSiervEEXJ8F7rhqGNew1PfBE0o9pUoFDsOEDMcx025aJvyOcCCaMtX/b/bcmPt2wlY6g73H02lE2K9mFfezPKvx7RsJN+CsgeSNU4GGjGLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W5lP2j+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W5lP2j+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906E2C4CEED;
	Tue, 29 Apr 2025 23:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970737;
	bh=HvRvmphcCQrUIZGBZtMSzlflDdh2AqhPTV8DfFVDNbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W5lP2j+jQjM65/d2bRpCe92jDTzNz6BbpOTz4N5QG0Te6N1dJNyloLkUccKbrHbdW
	 DLFExD6cGrrn7wOmICq2KB+YaNPbhcJvt7t3uSbVz3Y+tJh2HjNCYkx14p8Fw6rcTC
	 goaf15UlwNUPOtNqj0RW3qote8YgqyUbbpMAOfHFNkjCD7Y6FEM3VUL/83GqRjHwFA
	 Wt0qiRZePyGsX3azeNMla2yFSJrZlXYC9R0BcToaFMeQ9OiG7uGpvVnQNEfdPd90fo
	 eun+C25rMsEKT7NpfAc4KR7kYL/lUkOO/75E5BulF2IhXqGTwj3hbDMrj34XUwnkCo
	 JEIYHwAtZROsg==
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
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 30/37] fs/ext4: use sleeping version of sb_find_get_block()
Date: Tue, 29 Apr 2025 19:51:15 -0400
Message-Id: <20250429235122.537321-30-sashal@kernel.org>
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

[ Upstream commit 6e8f57fd09c9fb569d10b2ccc3878155b702591a ]

Enable ext4_free_blocks() to use it, which has a cond_resched to begin
with. Convert to the new nonatomic flavor to benefit from potential
performance benefits and adapt in the future vs migration such that
semantics are kept.

Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Link: https://kdevops.org/ext4/v6.15-rc2.html # [0]
Link: https://lore.kernel.org/all/aAAEvcrmREWa1SKF@bombadil.infradead.org/ # [1]
Link: https://lore.kernel.org/20250418015921.132400-7-dave@stgolabs.net
Tested-by: kdevops@lists.linux.dev
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 92f49d7eb3c00..109cf88e7caac 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -6644,7 +6644,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 		for (i = 0; i < count; i++) {
 			cond_resched();
 			if (is_metadata)
-				bh = sb_find_get_block(inode->i_sb, block + i);
+				bh = sb_find_get_block_nonatomic(inode->i_sb,
+								 block + i);
 			ext4_forget(handle, is_metadata, inode, bh, block + i);
 		}
 	}
-- 
2.39.5


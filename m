Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243156;
	b=aiddJSTWAC3S2zGzcAPVd9iJm+wUBlUMWJ3tyjZWOGJAdA5o+la+fU9XlmH+kY0a3bcx
	 BzHhx1sD4NO+WJswlLqzsvV0BKCYfLYcM+YDX+x1Y8anqxhdvV6lfB6N0jXBGzswaMdUx
	 RoivBbeLXJb4VzCc6Gr7/Juj8n2L02C9rRFsGkDI7bCuI0F9U23ixevqlw6s2aNaj32OA
	 DK1MFKQh5uSM3Z5wY8m5/kO1cJfvRdBs2NLTyhjtmqlrTJc0shiJsFUAjPlIYXEmtHuW5
	 IFXaSNoIf68gMDxIy6XdIwEm68DzzjhVwXmkg0TyF2Vd/Get3ly5CQMh9R4A8IMX9nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243156;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=BadfbEzt++8z0w/0JooA8YMHaAQJPS2a003BZBq4VbE=;
	b=FesabsY8DYrcZQwmZLk/3VwQBFyFHYiJCY9rHUmJ5WFVge1pxpRaMDCK3R+K5a44qvKr
	 vM6zVNVLnlxuxAHdlGUo1lngP7umU2TITzWHEyWrGqz/s/ijjNKFcJdV+wjapEAzF4rUt
	 TmpJLg/HuGn9CVICChpChUXtrHDxrxTtw5cSLlIEpyKF30yHmGHCKTE/gCwQAx57tPk0L
	 KYCtUXK95djd/71hkeHUkhRGD3cifMI53yv4/hnmnWsz4XL4/wWOQZ13vKTRrXKLotZRd
	 7VCrvHhpTsSrtoDNdfpDH8sORJqHqowLXX41hUPUYhsBnBWfgrQxN+uvf54boKiC5kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fOTvZvnD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93461606EE9F;
	Mon,  9 Nov 2026 16:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fOTvZvnD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8B41F008A5;
	Mon,  9 Nov 2026 16:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794243156;
	bh=BadfbEzt++8z0w/0JooA8YMHaAQJPS2a003BZBq4VbE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fOTvZvnDDNpHYZVBuar2z0B7PqQqFnLCRG982csJjGxmBavCV6XknJa7dzxn4QvV/
	 y4d6pXcpBjo0MgsPCf8iBWysWdXA/5MffD+vzoUo5UaicU1BE+A372MYC65LL3UhUG
	 0H23torrc0y4LgeTRmLqbJtf6EdXoRal8SWkz2jro4ND6LdFXWpgjZHj5VbLcxYtxW
	 Oq9gg3D3JPeQ2OCr68UropRM2vp5GwScp5ta9RxeIGqx4g25VG+DGZS4PZmKqzbyCS
	 RaOa8HaEIF0h5fvBHCIlHu5mWxG9Ac7yB6FmtYA9MCS47et6fzYCd0iE5I5eBD4CcF
	 zK30HukuI3yBA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 09 Nov 2026 17:51:27 +0100
Subject: [PATCH RFC v3 12/14] minix: drop mmb_sync() from
 minix_evict_inode()
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
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-work-inode-metadata_writeback-v3-12-91ac6c024018@kernel.org>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Cc: Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
 linux-ext4@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Namjae Jeon <namjae.jeon@samsung.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=809; i=brauner@kernel.org;
 h=from:subject:message-id; bh=HxoLuBlB7R3nw39RjarD8ObpVPEAktRzXkj/RV6CKfM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9/KW0NEP1A4+EXu3zQ6qchj2SJzl8Ota/t+5M0ZZ/P
 l8tXlWpo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCL1dxj+KelaBDfV3upvfOc2
 w+Bv19x7nzebdJyW2DE5c3lWW+8aP0aG9qeNupZdcx9eLTKKkuY1fZR7/ODnUzMOSjfIZ1pNmNr
 OCwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

evict() writes out what I_METADATA_WRITEBACK tracks before it calls
->evict_inode() and since mmb_mark_buffer_dirty() sets the bit that
includes the tracked metadata buffers. So there's nothing left for
minix_evict_inode() to sync.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/minix/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 756bef4dc832..9fb938ec5868 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -50,8 +50,6 @@ static void minix_evict_inode(struct inode *inode)
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
 		minix_truncate(inode);
-	} else {
-		mmb_sync(&minix_i(inode)->i_metadata_bhs);
 	}
 	mmb_invalidate(&minix_i(inode)->i_metadata_bhs);
 	clear_inode(inode);

-- 
2.53.0


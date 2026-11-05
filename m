Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882562;
	b=RaOvbwNJgeL3CEaDaa9PM0yNFAgcdBdPTDTRvEqjsf/uYFNgtaqlnhKrChgoUPZEj1SU
	 MT6U5IO7jQsBXGyQNfx5U7l1hdvA3ZPR8KaWF4tnl6j3eqIRbosGr3rNuMYMlCk8LHCJP
	 B5JhjXsMtU/tEibeRIFmoIW6UVrYbdEXXHmRhkOzw2z9Req3h7jKwvMs68mR9cbmNJ8sq
	 SfNSQ8XA53TsJIbsMlRS9fAaYgwr9eBqaXWOF7SZ9ln1Y6b5EHehgF4kFUwQRSrJkd8qE
	 H6espWiFeFJhKKj3/CBKC2nEJHEckCRsWD0tDecKS6msXsskbwfI5pAfoAAlNfYN55g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882562;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=Hl6sqbscgHG/aBgjMq7osjZ79XBWneyS9aAA+qwDiS0=;
	b=Wqwh6lqEA3ht4AVepggkNLdYPAyH605jJE1UsP8zWcVTJWZyJJ0dXb4/mV3L4t3ao8Ur
	 nFR13IU0e48Ss2bYs49ry/kNFnQFxJcX049KUSJnAlEdLOlELMX61ZTAT8c48LWW5emkT
	 YD4QfOCjkHc2TYC0EVuxXi6VVXr79cxA68wjK9gTE67yg2w0t1K40iZfUysn4W4WJvpfu
	 UYuRHQqNzsOYS8oxwAWuchuDpDNhQfYqOLL7JKK5zJJ3B/RHebVK09NPNaaXWM7R+wmOO
	 /GpFzTgPgsizYepgmwTnFeomtDvbQX2QjqsTBGk/yGauS/NW4FMN5EZnW1g1+QN9ZFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UEXMJHt5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D329606D81A;
	Thu,  5 Nov 2026 12:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UEXMJHt5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C6D1F00919;
	Thu,  5 Nov 2026 12:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882561;
	bh=Hl6sqbscgHG/aBgjMq7osjZ79XBWneyS9aAA+qwDiS0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UEXMJHt5p9BW5luwP9eoRJkaQEZsMQi1WSPgpmkje1XRaT0PmJfCcTZCh6qMMFrGk
	 QJ1BQLWWSi6MRGvI/gbCchwvKcj0xSfDfhtjDI/XtozMkHgD5FrFqIpitLyE22/JEH
	 oTGKKAQXqurJGKZeDF1zZOxy1YRBQnTRYE4BMJxukDxj7khE8k9R8x46q5xVCDUnw2
	 BTJb8vhp2fTp1vIl9AQLR2kg2EDp8xlWU9iKrka5VyH9dGnNst/dOix0veT9ZJqA2g
	 Xd4wxcKgZasHke5h+dLhade7R0IiCGeAw1h7JUp+g4/Pnws1dCVjgVgr1sNoQwavi6
	 3qX9AR0X7leLw==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 05 Nov 2026 13:41:38 +0100
Subject: [PATCH RFC v2 09/13] minix: sync inode metadata in
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
Message-Id: <20261105-work-inode-metadata_writeback-v2-9-48628c60c336@kernel.org>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Cc: Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
 linux-ext4@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Namjae Jeon <namjae.jeon@samsung.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1647; i=brauner@kernel.org;
 h=from:subject:message-id; bh=8MjmPLHvMqi2AF6n/8QRWgBxGbXbQuZ70O1S3E5gNis=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9qZzFbNq8OS+67tiWX9cPS3nHT7jpHDdPLFpKtPySL
 8fh7pWaHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPZqsjwvzZ1Xnslc8Kcjdta
 bN/afTPQtEnxC/hzff6VzUxW7HJzLRgZ2mZ/PLe3rCHIZsN7oesTjmYaG1x4aswR4FhZ5b0tc9o
 WFgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

minix_write_inode() copies the inode into its block, marks the block
dirty and sets I_METADATA_WRITEBACK so that a later fsync() writes the
block out and waits for it. But the bit goes away with the inode. If
the inode is evicted and read back in, fsync() finds a clean inode and
returns while the block might still be dirty or under writeback.

Right now that can't happen because inode_lru_isolate() never lets go
of an inode with I_METADATA_WRITEBACK set. That is about to change.

So call minix_sync_inode_metadata() from minix_evict_inode() for a
linked inode that still has the bit set. It syncs the metadata buffers
as well so it replaces the mmb_sync() there, and since the previous
patch it doesn't read anything from disk.

Suggested-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org # v7.3
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/minix/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 756bef4dc832..7d6cc49f7126 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -50,6 +50,14 @@ static void minix_evict_inode(struct inode *inode)
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
 		minix_truncate(inode);
+	} else if (inode_state_read_once(inode) & I_METADATA_WRITEBACK) {
+		/*
+		 * fsync() can't find what I_METADATA_WRITEBACK tracks once the
+		 * inode is gone. This syncs the metadata buffers as well.
+		 */
+		minix_sync_inode_metadata(inode, &(struct writeback_control) {
+			.sync_mode = WB_SYNC_ALL,
+		});
 	} else {
 		mmb_sync(&minix_i(inode)->i_metadata_bhs);
 	}

-- 
2.53.0


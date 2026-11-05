Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882552;
	b=wsIO5UB8NXA6sh/BZrgrazdfAuleic7jt/tP3vGedVCuNo6Iag2VSZVMcXGifUB8yZ3E
	 HqbyutUTCklTD4fXasLn0bTyxVs33AWxT6UiYHrYWqZHTf5yzicffmdTz7A7Hpu7VBPmL
	 9QRKOeGU1zYzUq3Po5ZkzHSeF8yh2pEkkOFyKo4daSjzGps3ULtJ1SYtiBwQMgbtZ1xEb
	 QaWrLiDI8OH/06srro+nLo0mjtzuROMX0BSj/C+XYa6NFbf9RmcpnIK2/sIKSjmPepBNs
	 rQYl4iUHGjBaeFUWNs3gm7QgbHx0tAvRb/piMkxCa0INQoR1tywJrFoMDWDuSlx/oiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882552;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=WNckzbyykmAFSiBfpnbX7dxxuvNhm+VDAvKd8EIewQw=;
	b=abBq4dvt1FHfzI0v/IQIOiaCRw2UOlSZMsguRxT6lQ0k+6Rof2Q3H+n7xYxW3KEOiH0X
	 AmiZwa9tzuFog3ul2aaD2ugFHqWvMAGb9k1JFtaDxtReOA4NnbBHzmz0pv8wqqodW9P9t
	 /qwHWz9XpL3fHFytY4B4mqwdbhlWNSsdTBgAzKlfQ5Dp+3gTK3k1kaIzqP4uaSjE0bHns
	 tR6p+WNgfipFLy55Q2WYVRq10y76iqqpEABsgO2uQhZflm0y491BtglEDFYkrQyyByGJF
	 VRcPzVrhuB/ZYEr2WA/Z2FGOoQJjtMbb+sYncvstmwOaU/AjX+CwHN/9TKl0WN2hsQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="N+HrA/6U";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B989606EE93;
	Thu,  5 Nov 2026 12:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N+HrA/6U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C741F000C1;
	Thu,  5 Nov 2026 12:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882552;
	bh=WNckzbyykmAFSiBfpnbX7dxxuvNhm+VDAvKd8EIewQw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=N+HrA/6U9lJjhYiNis9jgCZ4QfpNx8ug2pltXDrhZOMn/YQFCyL5xjXH6CyrA3noo
	 +4CE0GylKChdeRhfBkA3x1ttKJ41kUEZONNvD4totmTH2ERE3JeM+0y9M5P0j4wnre
	 Gr/n7G9/VW/O0vxI2FlifuqSPCX5Q+jnrTV32kIwdx5i7k3civCOo3DT+euNA1Hx5j
	 z+YtO857oDuxfyw6t2HXZyGPzBpFr/iOHugwGAbbXIJ0SxLeAtOBUKgh3dDMbL5ba1
	 bbt7rC5TqdB1kUJ0zYZwsh11/cUzptojWff7K5zBi4OkwMJmWkILSlj2PTWOOCZ9W9
	 UvGU6rS1+OroA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 05 Nov 2026 13:41:35 +0100
Subject: [PATCH RFC v2 06/13] ext4: sync inode metadata in
 ext4_evict_inode()
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
Message-Id: <20261105-work-inode-metadata_writeback-v2-6-48628c60c336@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1904; i=brauner@kernel.org;
 h=from:subject:message-id; bh=+sJqneJcp790JMYQlvj6BLxamuNqC4eAOIxVwB7k71Y=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9qZy+lEvhyivXS+vfbmBia3z+epbqW70wTr9Th42Kr
 kx++pRpWUcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEXK8y/K+6O/H/u3aNSlX3
 +tVPpki+uDb7meOnjKU88T0n22VUQkUZ/kdLGP922rhhS+4e7g1cYrlOJ4/1M/AmliZorX0sl7j
 ZiQ0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Without a journal ext4_mark_iloc_dirty() copies the inode into the inode
table block, marks the block dirty and sets I_METADATA_WRITEBACK so that
a later fsync() writes the block out and waits for it. But the bit goes
away with the inode. If the inode is evicted and read back in, fsync()
finds a clean inode and returns while the block might still be dirty or
under writeback.

Right now that can't happen because inode_lru_isolate() never lets go
of an inode with I_METADATA_WRITEBACK set. That is about to change.

So call ext4_sync_inode_metadata() from ext4_evict_inode() for a linked
inode that still has the bit set. It syncs the metadata buffers as well
so it replaces the mmb_sync() there, and since the previous patch it
doesn't read anything from disk. With a journal the bit is never set
and nothing changes.

Suggested-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org # v7.3
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/inode.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 18362580097f..c64cedd86826 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -261,9 +261,19 @@ void ext4_evict_inode(struct inode *inode)
 			ext4_warning_inode(inode, "data will be lost");
 
 		truncate_inode_pages_final(&inode->i_data);
-		mmb = ext4_i_metadata_bhs(inode);
-		if (mmb)
-			mmb_sync(mmb);
+		/*
+		 * fsync() can't find what I_METADATA_WRITEBACK tracks once the
+		 * inode is gone. This syncs the metadata buffers as well.
+		 */
+		if (inode_state_read_once(inode) & I_METADATA_WRITEBACK) {
+			ext4_sync_inode_metadata(inode, &(struct writeback_control) {
+				.sync_mode = WB_SYNC_ALL,
+			});
+		} else {
+			mmb = ext4_i_metadata_bhs(inode);
+			if (mmb)
+				mmb_sync(mmb);
+		}
 		goto no_delete;
 	}
 

-- 
2.53.0


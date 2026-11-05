Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882543;
	b=iCrw+fNvO4A/wMZUK0ezTahN1nhGwEIVh5yww+5sAmMbRU70EB/JdIatLZUYKLc+/gbj
	 QjEZWUANoJLK2yinKvv93OFicNsSlwarhoMEdju/8jKfWPmUGTHtzB8WiwHaJlONZ/2Y1
	 T9H9klWv62AQkiVJLaoncl8zmtgue65djx2I24z0Rdb07sfF0xTQTHd0KssrrTBLDsSWh
	 3XzMtJsUgUdSe9Ebfe4lZbo5CRg8Dqn+72zCfvXQVVmWC8HqSQ+AuKwagtEYs7KCbhvdE
	 C+nvThvbVZQ2anRidBYgsWK6F0BQ/ETOp3S+VKtV4+gq3yiJLuMHDyIqRPwzNNuc7hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882543;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=n8sgfxZWs5aeQCtnEj2LbskvBeDcZ31KbOvl6RMS9VA=;
	b=eAn251rjujnQiaC4zcn8EnkMyAL+us2OxHo98xtY00QyWntMbqdxv1BSLTEeL188U02t
	 xzL7r9JW18c0aYYaDuh7pCToiQfeYtLyXvXSMqFWbgAZDBvglNxn99GAmV5iHy5P9u+tS
	 3z4pbC4dLdn+FzqNKdnNN9nHELhuIAdqtLA5Zyrmlp7Q4+CsRNwAS8TUOH9BGCCNn18fq
	 MQF0tU9aqbvdtHSQnALE83RJuVJyIWX2fYIF1FRCo242kJX0P9muqm+5FcKNdt78PEGbo
	 cPNNPiMk4/XLbk27Kx9aicsgRvksdfPrD/enzvXrmhPsoiIKVgMboDOq482iXzV34oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NntReG9o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B96606EE80;
	Thu,  5 Nov 2026 12:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NntReG9o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6521F000C1;
	Thu,  5 Nov 2026 12:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882542;
	bh=n8sgfxZWs5aeQCtnEj2LbskvBeDcZ31KbOvl6RMS9VA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NntReG9o63GbfgadSHXOEXzkTyX12GJeuAV1OISU+sdykhztYDgmLLqRi31nweaB/
	 1EMwb22I7/MsxS4bb8HNYXnftxatilSRWaHu4SSX4llR2MSA8QCpnpvsJv6jWs40lc
	 Bcl5zbm08YcrwVv4O0U/WbPly7jPvV92MXzC18ikM2cEjW7lkrEyHjig7rckUIgkNj
	 qQXNJivGIpdhLYUmTkl6WdaE5dDVNk9kiySwFu8dLbxRlxh+Z75WWLdPvcT/id/C2a
	 FfXrE8sQhXbqch6YRynAvDGN5cyXRx5l0KOHL0RsQmyeGjtSKb+7zy61qPKsjZGzmD
	 Mg8QnTK8JMkEA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 05 Nov 2026 13:41:32 +0100
Subject: [PATCH RFC v2 03/13] ext2: sync inode metadata in
 ext2_evict_inode()
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
Message-Id: <20261105-work-inode-metadata_writeback-v2-3-48628c60c336@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1665; i=brauner@kernel.org;
 h=from:subject:message-id; bh=o2TQmzTnKiSex7q+jVgNC8M7RZNZa20HR+l0cqNKIw4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9qZy8KkrkuJ1+1rOURy27TMRPSx46/WVe8sbkdcrTz
 vZM9A/Z01HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRXbmMDAeWqsezMzBV349q
 fyIRVjb9/ITGw50Vr1bfWXGbaVml7Q+G/15VG+6YTZh30zqi6c+Gkr2fs0z1dQNyP/A7n8la1MH
 sywsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ext2_write_inode() copies the inode into its inode table block, marks
the block dirty and sets I_METADATA_WRITEBACK so that a later fsync()
writes the block out and waits for it. But the bit goes away with the
inode. If the inode is evicted and read back in, fsync() finds a clean
inode and returns while the block might still be dirty or under
writeback.

Right now that can't happen because inode_lru_isolate() never lets go
of an inode with I_METADATA_WRITEBACK set. That is about to change.

So call ext2_sync_inode_metadata() from ext2_evict_inode() for a linked
inode that still has the bit set. It syncs the metadata buffers as well
so it replaces the mmb_sync() there, and since the previous patch it
doesn't read anything from disk.

Suggested-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org # v7.3
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext2/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 9261b666d043..4ed727c3d26d 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -91,6 +91,14 @@ void ext2_evict_inode(struct inode * inode)
 		if (inode->i_blocks)
 			ext2_truncate_blocks(inode, 0);
 		ext2_xattr_delete_inode(inode);
+	} else if (inode_state_read_once(inode) & I_METADATA_WRITEBACK) {
+		/*
+		 * fsync() can't find what I_METADATA_WRITEBACK tracks once the
+		 * inode is gone. This syncs the metadata buffers as well.
+		 */
+		ext2_sync_inode_metadata(inode, &(struct writeback_control) {
+			.sync_mode = WB_SYNC_ALL,
+		});
 	} else {
 		mmb_sync(&EXT2_I(inode)->i_metadata_bhs);
 	}

-- 
2.53.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243153;
	b=qxp0MIYUBc7tbuU29OjNl2Y1dIM/q4cT5I43g+sb7XF7jqQwl5x93Wl0JG6jWsl1SQ7H
	 RTawpPsufVrEhENv8XwOzR1mUS/jC7Pp40G7w+eKrzSyQd/i3uoOOQ8r+Pe7V624r31it
	 1Wgxm8Bii5p2nQdmdLgcsK5S5gBbmP2Ug4VbMexQJS/VWBYaX0YhwDaVTPRuujcrHUNl+
	 hzOfQUulInSG/Ko8vgvZECyZQEHBo7jf4OnClQyQJ4W0dMmQDsr8+4wZtQYHfUWrV3wnZ
	 ivdX4/XesDeRTXv6vsSXC4e2ukwqWkQVRTwxExqJYrN3VaGDdQZdmRraWKRrgIZ8Rdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243153;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=Kaj6giWjqHevpzRO4b+jQwgQAh5EJyh+Gz5z7k8nBS4=;
	b=bSo1q1gEL9Tb+aNEYwXSkpkTBDplRZDaE25Wnaw0uOsTyiXjgotj+u2+8rsyzSAAH+gD
	 EraF0BpSJrXrYHYPBKod6FIjbJbnYaNquqe5dYjTIWrrrcahk69fGHXDEphHeTowRxRFP
	 D83KsFk+rSxCVi3KJaeOO0GXrd1Wmofe3wDCZtkxe4LmDTQ4QTMWV4sulApYgXLAzDsE8
	 lzkNeM2LUNuMPntpxzMRFInpWyYiP5GUsZ0SYtMTcSmPb+U8Yd02A7/ylT2AokJ89uJZR
	 CszrFXNIR5iHvfsgq9lIPi07fCiBxL08VyjWBl3g4fuEZtohfszGaL6LZY5wmoPqEvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aj+UM9sp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DB7606EEAB;
	Mon,  9 Nov 2026 16:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aj+UM9sp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744111F008A4;
	Mon,  9 Nov 2026 16:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794243153;
	bh=Kaj6giWjqHevpzRO4b+jQwgQAh5EJyh+Gz5z7k8nBS4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aj+UM9spyo2OzsPupMYURit0390DHIy1od4wnznP7zwQkCHVhAsEnSr/iZt7TsNSI
	 WrISS0y/CSgunjVZFmJP+0gqvFJr7Mx+Ao4TlloywBwJuPy+f/nxtdEmI4ImSnUAcm
	 JS8xFKw22sj16i5fAHfCi5TkUHHWnUUpjcGGsDxdHeR4JGjeMfcgmovxYaH+HxERFa
	 ZJIlqlI5IhCwkzli7LNdciF9jeeLb1X7dcwoEM01DEcHdpnmFLRwR5Z6XwC2+sd6Ai
	 mGo/e7g6LSWGSaqRn3ktGQNHVaPLbVoZfMfn14eMCKZRUsrG0z4r07GjwKwitAmU8E
	 WEBt7kxL21Rog==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 09 Nov 2026 17:51:26 +0100
Subject: [PATCH RFC v3 11/14] ext4: drop mmb_sync() from ext4_evict_inode()
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
Message-Id: <20261109-work-inode-metadata_writeback-v3-11-91ac6c024018@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1162; i=brauner@kernel.org;
 h=from:subject:message-id; bh=c3fon7IavJ1XRh+WEM85tEGg0Yncax1C54Dr2E5uZTg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9/KUY3jh3xmHVZr55TNG9EWeZXsyZXr/vMNMKmbfl1
 3LEHrxn7yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIvz7Df3+dR2Vhr7+v+DRL
 2a5BaPMp+9nfDeduenK8/tWm1BMqb/0Z/pfx5LNOmPaM+UGdyPfKm6YmCnOmlER4Fan2Hl76Onu
 ZKzcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

evict() writes out what I_METADATA_WRITEBACK tracks before it calls
->evict_inode() and since mmb_mark_buffer_dirty() sets the bit that
includes the tracked metadata buffers. So there's nothing left for
ext4_evict_inode() to sync without a journal, and with a journal there
are no tracked buffers.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/inode.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 18362580097f..b6c8c11525a8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -250,8 +250,6 @@ void ext4_evict_inode(struct inode *inode)
 	if (EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL)
 		ext4_evict_ea_inode(inode);
 	if (inode->i_nlink) {
-		struct mapping_metadata_bhs *mmb;
-
 		/*
 		 * If there's dirty page will lead to data loss, user
 		 * could see stale data.
@@ -261,9 +259,6 @@ void ext4_evict_inode(struct inode *inode)
 			ext4_warning_inode(inode, "data will be lost");
 
 		truncate_inode_pages_final(&inode->i_data);
-		mmb = ext4_i_metadata_bhs(inode);
-		if (mmb)
-			mmb_sync(mmb);
 		goto no_delete;
 	}
 

-- 
2.53.0


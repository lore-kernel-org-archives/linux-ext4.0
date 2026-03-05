Received: from out203-205-221-242.mail.qq.com (out203-205-221-242.mail.qq.com [203.205.221.242])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D293264CB;
	Thu,  5 Mar 2026 14:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.242
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772719937; cv=none; b=poX3oo3b/oP3tjOQhHBHPtXOB5cVtt/jeHIbltGc8tkvO1UNtm6XBksVvUZkNFU96JYiFj18TFnYpzpPVpf8nQj9/PIz3ldL7LUttbnCrea5sfJLEPa2e1tX131HZdvd7B3ReO05Df5kWxI1JThsatHy7BVeyRBkmL/mDkazOo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772719937; c=relaxed/simple;
	bh=Wb1uLyOS4vzEwwmYnNT3U3lQAqgpHdAYmt7MwGrej3E=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=syzcN+UG9ZHMuWZMxWgn5zwS3OxoIE6yxlNpsGetg9JXyZ9ybhceLj7qGFWd6cT8b1gqQuQVyEg5iD6su23Y9TBCBGP98eXfcDxLmQpvf5DDpruDThl73LUAWhEKl7YPTTCX3FKzAVmwWJI6exJdnkhLvkkRtdfCcHF+Zf5zsYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=W6eQAFCh; arc=none smtp.client-ip=203.205.221.242
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="W6eQAFCh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1772719925; bh=dKXK2Sn0hSxdNazYHpkyscbF59y3vQprb24Y46JQf9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W6eQAFChFTvskV8eXYLKuINDUbZ5K9taxIIVJoh9lbvu8dMFrNLXDb5iyOg8U4lSz
	 RND7HAHFpM1rSrkgIrRJLShqVZBj6EC85oQppooHsqt1EZh8Yi9a5yJeUhz7fMogWV
	 aUBMq7iB4s9eid9lmOyOolIDufS/jY9e/H0dKAHc=
Received: from lxu-ped-host.. ([111.201.4.63])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 30227435; Thu, 05 Mar 2026 22:12:02 +0800
X-QQ-mid: xmsmtpt1772719922tfg4wqfjs
Message-ID: <tencent_3ADDAE194DCFFD8DC925858DC11278DDA907@qq.com>
X-QQ-XMAILINFO: Mh8zSn5h7V45ZYVl2YYMMlyLDH6W7EezV5//X3ZCJfPe58l+VIjb8PxYrSIDzH
	 GxWhqxmHhtp8sr1CSYP2bKJkS3tQD8dtN8pcE0m4u0fv6ObSBr01fdFWqFyzfM88QrpMUQkImAc8
	 yswqZSWeejD5PZNMk6hJFkptZ+4HV+EWQ3XI2IVJQcLKTlvpEEYCEpL8usVFw/1S45rl2usG6Ipz
	 AuEeczsmGymBzCul44gZO3v5nWvSJV++R2B5sRGgBXuoGe+pNwHo2iI4VZkyN9oC/NLTgmRv7i9M
	 HgR+eZo8JfaMJgdezd8wUXJRPEuq8AVKMo9ubPBrk8F5n2r5MNdfMdMiB+vts3Gz/kNwPYhZGKqE
	 AzFiiHHf8uMZmlyq7rnV1TcQKFvHhlVvH9Qtper1gatYBRkjvRTOfdZA6+osovvOQNlHHIvLmNXZ
	 POLswdC8wUCqaeUFym6wSJM6bSAFpE2U6Mr5XvDuzmkOsNu26zBFAE9oHD/BWb91VbRvthKLbcLx
	 0z2HlRLCZvwIGOLzJ5e48DzjXXSdsQ0EKgMQgca/bpAx7KH4m//NXmX6XDy2MQYyZKd3HoxLIkAZ
	 f20X0+ebBtX2AqUXsmrZoFljHGmNaKDlUUvKs5Z75I5pJCWtrZ2Q5+tqvLliPAQNYUf3Vlem+jZ3
	 x/OUSjwivOf0zl9/iNi0ugq89IbLxCHt0ymjvuEsI3NvxurJXe9hOBD1McZTz6HuIhatEWumQ6r1
	 z/wCdyPo7bNnL1dMg9DHHeZNU4SB75c1fRDxx8WBfb2F+dYvs6oiN30BJfdaNchSAx0y+bmmwNr8
	 kE8HrviyEg1KY/ZcuEoYa6QwdzMkciHTwRFRpChUL7iAd6ek/ZpbdZV4bz4gX323qeMgeXTLptrQ
	 4DJQb3E9YL4rkXCTCq3MAOQQTtzwyw+32Zz59pPUtrT+TyDGlIsQ/aDLFPkBwxJhRZpEpeduOz7K
	 NN3vhSQHkYtnUPMhlf2r14Ga8gqKJTdfzAsGpc58ckxuQ7Cqzz1Mkj9TTm26lIZy9ph9BJqr5+yD
	 v/laOjJHXWXbRtkr4T01es/lTo7yiL8dk4zgeSF4L335Kw00Gf
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: Edward Adam Davis <eadavis@qq.com>
To: jack@suse.cz
Cc: brauner@kernel.org,
	eadavis@qq.com,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+1659aaaaa8d9d11265d7@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	viro@zeniv.linux.org.uk
Subject: [PATCH v4] ext4: avoid infinite loops caused by residual data
Date: Thu,  5 Mar 2026 22:12:03 +0800
X-OQ-MSGID: <20260305141202.432298-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <uweckkartekmwpzpt2kt34bbjyn3a2a4tc3lw7qyyghkxhfl5l@st7yfcuu73f4>
References: <uweckkartekmwpzpt2kt34bbjyn3a2a4tc3lw7qyyghkxhfl5l@st7yfcuu73f4>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On the mkdir/mknod path, when mapping logical blocks to physical blocks,
if inserting a new extent into the extent tree fails (in this example,
because the file system disabled the huge file feature when marking the
inode as dirty), ext4_ext_map_blocks() only calls ext4_free_blocks() to
reclaim the physical block without deleting the corresponding data in
the extent tree. This causes subsequent mkdir operations to reference
the previously reclaimed physical block number again, even though this
physical block is already being used by the xattr block. Therefore, a
situation arises where both the directory and xattr are using the same
buffer head block in memory simultaneously.

The above causes ext4_xattr_block_set() to enter an infinite loop about
"inserted" and cannot release the inode lock, ultimately leading to the
143s blocking problem mentioned in [1].

By using ext4_ext_remove_space() to delete the inserted logical block
and reclaim the physical block when inserting a new extent fails during
extent block mapping, either delete both as described above, or retain
the data completely (i.e., neither delete the physical block nor the
data in the extent tree), residual extent data can be prevented from
affecting subsequent logical block physical mappings. 

Besides the errors ENOSPC or EDQUOT, this means metadata is corrupted.
We should strive to do as few modifications as possible to limit damage.
So just skip freeing of allocated blocks.

[1]
INFO: task syz.0.17:5995 blocked for more than 143 seconds.
Call Trace:
 inode_lock_nested include/linux/fs.h:1073 [inline]
 __start_dirop fs/namei.c:2923 [inline]
 start_dirop fs/namei.c:2934 [inline]

Reported-by: syzbot+512459401510e2a9a39f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1659aaaaa8d9d11265d7
Tested-by: syzbot+1659aaaaa8d9d11265d7@syzkaller.appspotmail.com
Reported-by: syzbot+1659aaaaa8d9d11265d7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=512459401510e2a9a39f
Tested-by: syzbot+1659aaaaa8d9d11265d7@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
v1 -> v2: fix ci reported issues
v2 -> v3: new fix for removing residual data and update subject and coments
v3 -> v4: filtering already allocated blocks and update comments

 fs/ext4/extents.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ae3804f36535..56b7398a0b40 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4457,20 +4457,19 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	path = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
 	if (IS_ERR(path)) {
 		err = PTR_ERR(path);
-		if (allocated_clusters) {
-			int fb_flags = 0;
-
+		/*
+		 * Gracefully handle out of space conditions. If the filesystem
+		 * is inconsistent, we'll just leak allocated blocks to avoid
+		 * causing even more damage.
+		 */
+		if (allocated_clusters && (err == -EDQUOT || err == -ENOSPC)) {
 			/*
 			 * free data blocks we just allocated.
 			 * not a good idea to call discard here directly,
 			 * but otherwise we'd need to call it every free().
 			 */
 			ext4_discard_preallocations(inode);
-			if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
-				fb_flags = EXT4_FREE_BLOCKS_NO_QUOT_UPDATE;
-			ext4_free_blocks(handle, inode, NULL, newblock,
-					 EXT4_C2B(sbi, allocated_clusters),
-					 fb_flags);
+			ext4_ext_remove_space(inode, newex.ee_block, newex.ee_block);
 		}
 		goto out;
 	}
-- 
2.43.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793033362;
	b=iWCl+6yYWPQ0E293aOCgaL+n4JNieqWyI6X6j4qTOj4MBIiLMI0GK7Eg3DU5lsYXtfvq
	 0czhXBKV6SIC//xtPwcU/FdopCTCl4/A9lDl2DdknuH8PG2GdgQqoAREihDKJm+4HBV+F
	 zy/fWzosTRmxvzo0YcUayacegXVWRN3ePtnhZhHZe4j0mtp2LVQFzyYpr7U8NirAos02d
	 LaHFvllaI6RWTnLj7sBts6j058YcfB47e+AppZGH6pEwo3ZV3F8sTOZoMeu9TgbC71Eus
	 H8oTF/8aCQuPGllU3TcQfL9FBZC7W6I1oa7pn5pZ2G/0Pdf+9bQDTDaupyVHofzb9Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793033362;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=zOM12FDkYioUmtnf7LrlH3YotRwP2jLo9K3Gd96iLwA=;
	b=vbhW1oFOsPRFBQlc/oaLnII1Fibnvw1yWqttvHl10hiI7YCoFciMWfcSuluUsBcKbd3K
	 4cHlcA08LR90RC9rnZpN50VHQjuTVGwObx+EhfAh0dxU67uzYp3EHAJiG26fRBM/+cCXO
	 GRBuswKV3Zzdx/dTcm0b4x4ptUgLKgY1suHubN47dmjMvc/JEacET2nzknyPO/JAgW2cc
	 xRea1SwoK6Rny8f+fbxjIKRZ2yRYlxkNi5x4jGOdVWw/z2SK9KjJxt6iiiGydgKcSkusc
	 zGSlATjEGwI2vCePv82c530HR7J4X6RpMvP20qkndsXuRd0VGdmaYDkbRYEcMQtkbZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=DDj3LsSp;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C58FC606A31A;
	Mon, 26 Oct 2026 16:49:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C58FC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=DDj3LsSp
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id 0D17B20B7166; Mon, 26 Oct 2026 09:49:11 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0D17B20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793033351;
	bh=zOM12FDkYioUmtnf7LrlH3YotRwP2jLo9K3Gd96iLwA=;
	h=From:To:Cc:Subject:Date:From;
	b=DDj3LsSp33RJeFZKAJQjyGWQPNOU5uYGbhqJHC4mnVyQbNNSTmpVZZnTZhoMkvFPC
	 8m2D6CC6ruzEiu9roazIYqktBUtH5cEyRv3l/YHfVw/a2wSjE8z5nrgjGWFyCbMLPC
	 AIUWcUmqjSyt7hC3pPGzITeE7Fi8rzZzRHC3GCEA=
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	stable@vger.kernel.org,
	Simon Brakhane <simon@brakhane.net>
Subject: [PATCH] ext4: validate inode block references during fast commit replay
Date: Mon, 26 Oct 2026 12:48:53 -0400
Message-ID: <20261026164853.3125835-1-hamzamahfooz@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
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

__ext4_iget() currently skips ext4_ext_check_inode() and
ext4_ind_check_inode() when EXT4_FC_REPLAY is set in s_mount_state.
As a result, an extent-mapped inode loaded from disk during fast commit
replay never has its in-inode extent header or root extent entries
validated before replay paths such as ext4_fc_replay_inode() and
ext4_fc_replay_add_range() walk or modify i_data[].

A crafted filesystem image with a fast commit journal and an inode whose
eh_max / eh_entries exceed the four-extent capacity of i_data[] triggers
slab-out-of-bounds reads in ext4_cache_extents() and slab-out-of-bounds
writes in ext4_ext_insert_extent() into adjacent fields of struct
ext4_inode_info and beyond the ext4_inode_cache slab allocation.

ext4_ext_check_inode() and ext4_ind_check_inode() only validate the
in-inode extent header and check block numbers against static superblock
bounds via ext4_inode_block_valid(), not block allocation bitmaps. So,
drop the EXT4_FC_REPLAY exemption in __ext4_iget() so inodes read during
fast commit replay are validated.

Cc: stable@vger.kernel.org
Reported-by: Simon Brakhane <simon@brakhane.net>
Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
---
 fs/ext4/inode.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 26f0f9714f03..cf74c5014fa7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5582,10 +5582,9 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 		goto bad_inode;
 	} else if (!ext4_has_inline_data(inode)) {
 		/* validate the block references in the inode */
-		if (!(EXT4_SB(sb)->s_mount_state & EXT4_FC_REPLAY) &&
-			(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
-			(S_ISLNK(inode->i_mode) &&
-			!ext4_inode_is_fast_symlink(inode)))) {
+		if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
+		    (S_ISLNK(inode->i_mode) &&
+		     !ext4_inode_is_fast_symlink(inode))) {
 			if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 				ret = ext4_ext_check_inode(inode);
 			else
-- 
2.56.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280542;
	b=TC3KWwsNAdMdzOwxCsvqNOe7NOMVNdJutZqStpKoKmLsex4JHR6WqGnw2eyqJO6wlKuM
	 NcLxu4cwilumIp0v8thTWyGikXsRsfFE1HZTUpLvT7IpwEEzQBSdBr/LoKN4OVgVTF0KV
	 FbK0NR7rKlutyHNmoLqYeyrW1O0QurPK2IqQzSeH9EQL7epGNx7TzXdNx3lCWIih4gvlw
	 yIwmGKN9IzbgfAV/QJ2I15KbHDUZuoxXDV5Fd27kIbp9Sb1N/9Gz6l/rEFuc65VCukjKw
	 3ypjae5/D1sDQph1CvWXUF2aANiGCS9b29MHZVr/JxWpBv/hnT3hmYkOpAHBJtuG1tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280542;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=+2u0HojvaNeMbGwzxNwAr4HVxTePDHUlMDvjn+So4pU=;
	b=Vm0sqFZ1J2+IPOi91qiQgCilU/+VjJgSSWw2CV/kDlhQwkckrV4g/oA06eFaEDXnqyRw
	 SakOrrLlEVxZgPwvwWDwExKPSe/H9txCvb6cNT7l4NQIRHAVIvZmlCf4WqiDBbY1p2Scs
	 S4T/m73hJ6KW6DSCJ6kysnokIa7z/jXsy9QQaCIyjd2M/BC8F0w3yThXP0kJrVgoICeGK
	 4xYSO4IcTOc+jXuCH9yI4QTiKrEFE4VL0cpjkQx0x0ca5abc/bcrV1fxwpQizoRxknw6C
	 TFcWgCPLsvyu/tbmLOlzS9L04TM7qz6lbs2b01hozFO2MB4L6if7IjhkwDTXFAd7qew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZTrd9JeK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6042606A31E;
	Thu, 29 Oct 2026 13:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZTrd9JeK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441EB1F031E0;
	Thu, 29 Oct 2026 13:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793280541;
	bh=+2u0HojvaNeMbGwzxNwAr4HVxTePDHUlMDvjn+So4pU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZTrd9JeKydqGaLoG50Pulz35DSZv71fSC7+/h8uyizmlrY5AJQO3Lb4pQBLnhH2UU
	 wwH3r7fHz+Rk4Q6tkBoBG0HWgjgfCVTFH16JiufhDseLnnIkibuRXviVJXTmrE2PhU
	 b69bzZLE6i9PCwed6VJE8s2yo9vQIbY3ozLUVZc64bpW7fTS+5Z5AgPuNIyc5WXAtk
	 0dcHdhKo3Wu5VOeKazr9St1JULY90JI4EFsZVR5AdJBX8/569YvrVHAAnkgfhlQh7a
	 tzudf6rf4CMW2+O554KiDZjS3aZ3O2gy1lzqKZmBCHieTdmrT2s9glGz7urVrejAJH
	 gnero4/F42YZA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 14:28:22 +0100
Subject: [PATCH RFC 7/9] udf: don't allocate the inode block in
 udf_sync_inode_metadata()
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
Message-Id: <20261029-work-inode-metadata_writeback-v1-7-7d6c678a585d@kernel.org>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
In-Reply-To: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1928; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ISCdXpL9QE1VKb5mP4Fg0SoLyfRffNBWgDbqYiV1ur8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ99vy/7KpF9AtxSTNu5daWJ2ttCtUun7j++r33pbtiz
 Aeeln9e0lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCR5WEM/wyf3HKSN1OoXvt4
 4waZVS1eT7c7feRRd+vf1JeR2aNW8JfhrwADe2Txe3XNmMVz7POTJx56tfljUvv2GR1bi1e8uRO
 1iw8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

udf_sync_inode_metadata() looks up the block that holds the inode with
sb_getblk() which allocates a buffer for it if it isn't cached. But a
block that isn't in the buffer cache is neither dirty nor under
writeback. So there's nothing to write or to wait for and allocating a
buffer that just gets thrown away again is pointless.

It's also not something we can afford once inode eviction calls
->sync_inode_metadata() from reclaim. So look the block up with
sb_find_get_block_nonatomic() instead.

Cc: stable@vger.kernel.org # v7.3
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/udf/inode.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index bacf2a86161e..59f8e9bde0b1 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1744,23 +1744,22 @@ int udf_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
 	struct buffer_head *bh;
 	int err = 0;
 
-	bh = sb_getblk(inode->i_sb,
+	/* A block that isn't cached is neither dirty nor under writeback. */
+	bh = sb_find_get_block_nonatomic(inode->i_sb,
 			udf_get_lb_pblock(inode->i_sb,
 					  &UDF_I(inode)->i_location, 0));
-	if (!bh)
-		return -EIO;
-
-	sync_dirty_buffer(bh);
-	if (buffer_write_io_error(bh)) {
-		udf_warn(inode->i_sb, "IO error syncing udf inode [%08llx]\n",
-			 inode->i_ino);
-		err = -EIO;
-		goto out;
+	if (bh) {
+		sync_dirty_buffer(bh);
+		if (buffer_write_io_error(bh)) {
+			udf_warn(inode->i_sb, "IO error syncing udf inode [%08llx]\n",
+				 inode->i_ino);
+			err = -EIO;
+		}
+		brelse(bh);
+		if (err)
+			return err;
 	}
-	err = mmb_sync(&UDF_I(inode)->i_metadata_bhs);
-out:
-	brelse(bh);
-	return err;
+	return mmb_sync(&UDF_I(inode)->i_metadata_bhs);
 }
 
 static void udf_adjust_time(struct udf_inode_info *iinfo, struct timespec64 time)

-- 
2.53.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B64427B343;
	Wed,  7 Oct 2026 00:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791333681; cv=none; b=bzLzGKiKUbzJKjXRGjM5M2Q7Zl9re0PBOi1Ep1bFichzzpT4KdmEMzhdQZ2EKahfI0vcKrjJKIVAtP2SBzlsQMF5pjtojRm3Ye28buqBnvBXV5SboBsSeTL98BvUoEVhTfFffWQbatH5Ib3f2vfzp9+mFhdyPCIjA2xBQAMduOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791333681; c=relaxed/simple;
	bh=B/mIUUnC4iRcGSeflXI2OGVeD2HzpqMA2djBEQfMOu8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qAvqWiDhM6GjXOenbOsptyWmlzs56/Qo15MGfdRjpNMF2EDCEF+A1wbiE1aMqbPIXq9QFYj/04rs8dOxgNWiEtG3UNPj1PQ9R9AvfDiiXfbvPnS/a3QcNZZhz7A9nuVcTyDLSeoYcSjfHcEHj3bnzGg1HeRru0/Z8n2rHsWxTDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XRxuBirV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XRxuBirV"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8090C4AF60;
	Wed,  7 Oct 2026 00:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791333680;
	bh=B/mIUUnC4iRcGSeflXI2OGVeD2HzpqMA2djBEQfMOu8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XRxuBirVuCqHNvdDXevYjwlLdtKSpq7HxrlnBL7mXPEjN2b98uZNs8ZKWgf4RMF6K
	 SqTHTFBBDen5lCo3ie5JuwzH5KxJoUz81gXMcVf0T3uYPd5sxMSM/1XqYstYfJ2/yN
	 RXmfuV1mnu5zo6ea67PUJTZjG02lQRkyH9I0HJFFAX+BRnXBkFRHhAU+hXO/CnJUYF
	 krym4UmuhhxWDbP928RcgdO2VVpfQkY2woiUy6FWNeIF0QnSa5TKMB271l1zLcmGh0
	 kHfSFzzZN+6UTgXxexu3U/IXxD593W4uuLcvf2Sy6dHWdISqwbOCmpTgX9QyuNwnf4
	 5SJMAew1P+djQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D81CA5FFC;
	Wed,  7 Oct 2026 00:41:20 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Wed, 07 Oct 2026 09:41:20 +0900
Subject: [PATCH 1/2] ext4: don't cache unzeroed blocks as written after a
 failed zeroout
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261007-ext4-fc-zeroout-v1-1-b86de6439431@samsung.com>
References: <20261007-ext4-fc-zeroout-v1-0-b86de6439431@samsung.com>
In-Reply-To: <20261007-ext4-fc-zeroout-v1-0-b86de6439431@samsung.com>
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>, 
 Harshad Shirwadkar <harshadshirwadkar@gmail.com>, Li Chen <me@linux.beauty>, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791333679; l=2338;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=RixNJloKlUfTTc2VvX+N9XCtFJeSTCK2879z3k01VHs=;
 b=kq4ONXbnPOq9j/EmanCLfZs3xxBZibjN/oBtHU366YrMSq/c7ud5bKpOiarUOrhtEFuHIv7vg
 4BEYhdjtzOqBu27feR83Tk3wCq6HtjTjBY/uVLkAQWkRKqxxrFwWcZj
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com

From: Daejun Park <daejun7.park@samsung.com>

ext4_ext_convert_to_initialized() may zero out the blocks before and
after the range being written and convert them to written together with
it, instead of splitting them off the unwritten extent. If
ext4_ext_zeroout() fails for one side, it falls back to splitting the
extent, so the blocks on that side stay unwritten in the extent tree.
But zero_ex1 or zero_ex2 keeps its length, and ext4_zeroout_es() still
inserts those blocks into the extent status tree as written.

Until that entry goes away, a read of those blocks returns whatever was
on the disk before the extent was allocated. A write to them is mapped
from the cache and goes in place without converting the extent, so its
data would read back as zeroes once the entry is dropped. To reproduce
on 4 KiB blocks with -o nodelalloc: fallocate 32 KiB, map the last seven
blocks of that extent to dm-error, write the first block, restore the
mapping and read the second block. It returns the old disk contents
instead of zeroes.

Clear the length of an extent that could not be zeroed out, so that
ext4_zeroout_es() skips it, as the comment at the out label intends.

Fixes: 308c57ccf431 ("ext4: if zeroout fails fall back to splitting the extent node")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 fs/ext4/extents.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 836396ea79..d65e30f3c1 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3755,8 +3755,10 @@ ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
 				ext4_ext_pblock(ex) + split_map.m_lblk +
 				split_map.m_len - ee_block);
 			err = ext4_ext_zeroout(inode, &zero_ex1);
-			if (err)
+			if (err) {
+				zero_ex1.ee_len = 0;
 				goto fallback;
+			}
 			split_map.m_len = *allocated;
 		}
 		if (split_map.m_lblk - ee_block + split_map.m_len <
@@ -3769,8 +3771,10 @@ ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
 				ext4_ext_store_pblock(&zero_ex2,
 						      ext4_ext_pblock(ex));
 				err = ext4_ext_zeroout(inode, &zero_ex2);
-				if (err)
+				if (err) {
+					zero_ex2.ee_len = 0;
 					goto fallback;
+				}
 			}
 
 			split_map.m_len += split_map.m_lblk - ee_block;

-- 
2.43.0



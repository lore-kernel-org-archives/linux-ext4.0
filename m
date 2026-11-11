Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794382504;
	b=Jl/vmRjIGZXtBroFO0v8TmYp7Ryu5JECZqi581+Z8yYsO8x6iBPl7kmZrkaCxPRcE3Mx
	 maCGerVFT0DFBDxUBAtlQguPYzYpVRf41Ku3UWGo5+Sxh57lWwFTtzXDP/MmZjJfxZHRI
	 9GRO9PhOLsXmbGu6r4W0lK307b+DyWa9Ui+IKKSOg7iFKHITXg4CO1JTi9NgAvUTfUJK3
	 2kog4k3GoQ609spfTy1xHdwTLkSzYiqraTxzBnCA3CJBSTXZ0P4XBQemqCL51TIOy96m/
	 DzQBF5bH4xg/ak7isVOhrrGEw12xrq72Qeg9ouUL2H+JAMIzay7zRQsGwDAEwsItXQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794382504;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7XkhAgg5EYqR+h9/JZjrfrLfFurW0BTJZdJ2iN0yVDI=;
	b=elGlMUHYkuS832depBlqwcWkdUYsWXg7bHJTBop4o1A12WC3YkmfB3zImDUGA8qfxdlN
	 lgQEyi3Pg5ARQhnFmGpJQc4qlwYqrjKuFDOkj23bGgOoYY0MM14Ym0vVH81ikR7LCz2a5
	 Ls52LwcOV25hZ9EO0xbKICXV3QQ6eFXRFRI+YVqv3S9frgvlsfUab5AYQIYtbfpYR32cx
	 aPZAEb1yPEsAimq8PG1sl9kPxbWscCfc+Q3vTObbbcbpM5TA7piZQYlMmjravS/hWRuoH
	 mUFBsxYei9Y+2rTbMdg1xRiRbicqz7dYWNoSJQPexi5o51m3dld8zFtYHlUwoM7Ys/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b="sUD/0eU5";
	arc=none smtp.remote-ip=162.62.57.210
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28EA606A31C;
	Wed, 11 Nov 2026 07:35:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D28EA606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=sUD/0eU5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794382492; bh=7XkhAgg5EYqR+h9/JZjrfrLfFurW0BTJZdJ2iN0yVDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUD/0eU51KAKT+5BIYGAw1KDMR5geF54yfxZhDB2pbz5SyPuvoga562pXCzM9AVwA
	 Vifoc4YeqS4AL8XlS2LmsZWzcS+hP/boHUpHeWkXY8eZGx1F78bGo755Vs046xR5Ut
	 ypaEDV2n88Wf2Tx+WwyMxW26+cNDkwOeqcrQAX+o=
Received: from ikun ([221.176.157.247])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 8AFBA842; Wed, 11 Nov 2026 15:34:47 +0800
X-QQ-mid: xmsmtpt1794382487tu8l56qym
Message-ID: <tencent_DF25FDEF46DA68C4E18D6DB40F08E30BB705@qq.com>
X-QQ-XMAILINFO: NbgegmlEc3JuquLCMXRl+TrdTYLmF7QIdAEhfhdx0EhL8xJwR36g2aX4Ycvf36
	 jpL2Suh5WvWzW+XmtuLHY2S/Z+o0cGn43pPpJ3tbd4IUr5qXeClnVv1jfFGnMB8ub5m4XWFH5ngt
	 QTsGd3xBQsn5MxGyXtUXKu/KkOCglTKKjbaHwOyPMouIo/9nFZ7IExub80ea9QGsScCH3I9n3g/X
	 du4b67ieZK0TnC/3XtIR3/r1rTjiqpCNzAUcgQCSW/dBwrTDZYa6z71dbRXej5/hw0LQXvByGQZz
	 hEBDnP2afYxRsOLIOu0oW503Om+LafHuITp/1sDKdu6ozr/4O3FLsqjQEgNGxonI9AHHfVYsYxe+
	 ZYo/q4p/0a5YytvowfG1HpCBvpA4fWAA/dRMbANF18su8vN+OZRrRET5Dy111UN29Q36AOx3XLIk
	 Q2iPLT7pDUIJMgPWDEGozs7bvUfeqiH/6PdgZiDQG9EUcrYs3UHXPlRBTprCRe+5OMSSdOnvkPYP
	 WQp0p7AeIFakhAdTlAdEBsKhR4Veibv43jx1D3BE45akFow6ObEYq+bm1BXzkr5hJAxvqpoUexED
	 rFbXeUCvA4vLWJI8TEP9LxR4GCcVJi4/sXTuRc9K3F6BIJ1vM735WzDYTmXvNKMt/hrp/1c+Ychn
	 uVa/bHd2V+fiPY21orc+JtGfCpQieqTDvhU8KAUWFdJ3vstyRuaHgnH7713K/ylQwJIRD3Jyeou/
	 xHX/NDIXR3SgwrZb8dcXQHoY30ELwIeheh3+02McWcyj5nB7K/vEbdmcHnGwaZ7GVDKFYTEqgJrG
	 Ok5eP9Sxd9wvroeVi8QrmAvK7Q+FINsGNG6QYCcExow5SqVPHIY1luFlDlVAAFmxZAynZWvoul7v
	 HfxskOCzIVcXIDsFPLahT8aK6OrdF5EqJQx6LPGkdMh4cdCjjlUiv7vtW0f8lW1yezgTgUvpG4hc
	 PBHj2byoUcW51rjoyzrvq+97j83RHlBES981gHQZJsQekpSkuqoZjTqd5Xha+pWQiHHguNCRiScw
	 7fb8YzBlWiV4RX/FJxFnrJBbL9pU8=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Alan <3164729207@qq.com>
To: tytso@mit.edu
Cc: Alan <3164729207@qq.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] ext4: free the new extent block on failure to grow the tree
Date: Wed, 11 Nov 2026 15:34:44 +0800
X-OQ-MSGID: <20261111073444.8059-1-3164729207@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <tencent_9EB8EBE910378E46C80E006C6A7DA918BA08@qq.com>
References: <tencent_9EB8EBE910378E46C80E006C6A7DA918BA08@qq.com>
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

ext4_ext_grow_indepth() allocates and accounts a metadata block before
getting its buffer, obtaining journal create access and dirtying the
new extent block. If any of these operations fails, the new block has
not been linked into the extent tree. However, the error paths return
without freeing it, leaking the block and leaving i_blocks larger
than the number of blocks reachable from the inode.

Commit 8a83ac54940d ("ext4: call bdev_getblk() from sb_getblk_gfp()")
removed the implicit __GFP_NOFAIL from the buffer allocation, making
the allocation failure path reachable. The two journal error paths
already lacked cleanup before that commit and are fixed here as well.

Route all three failures through a common cleanup label to free the
unpublished metadata block and undo its inode accounting. Keep the
existing buffer unlock and release handling. Once the new block has
been linked by ext4_idx_store_pblock(), an ext4_mark_inode_dirty()
failure must not free it because the extent tree already references it.

Tested on Linux 6.12.1 by injecting NULL for buffer acquisition and
-EIO for each of the two metadata helper calls at their caller
boundaries. Each unfixed case leaves seven unreachable blocks and
i_blocks of 40 instead of 32 on a filesystem with 4 KiB blocks. With
the fix, all three cases retain i_blocks of 32, preserve the original
data and pass e2fsck -fn after a normal unmount. Retry, truncate and
uninjected growth also pass for each case.

Fixes: 8a83ac54940d ("ext4: call bdev_getblk() from sb_getblk_gfp()")
Cc: stable@vger.kernel.org
Signed-off-by: Alan <3164729207@qq.com>
---
 fs/ext4/extents.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ad0d80e33f6090..f0b2852f8a9342 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1333,15 +1333,17 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 		return err;
 
 	bh = sb_getblk_gfp(inode->i_sb, newblock, __GFP_MOVABLE | GFP_NOFS);
-	if (unlikely(!bh))
-		return -ENOMEM;
+	if (unlikely(!bh)) {
+		err = -ENOMEM;
+		goto out_free;
+	}
 	lock_buffer(bh);
 
 	err = ext4_journal_get_create_access(handle, inode->i_sb, bh,
 					     EXT4_JTR_NONE);
 	if (err) {
 		unlock_buffer(bh);
-		goto out;
+		goto out_free;
 	}
 
 	ext_size = sizeof(EXT4_I(inode)->i_data);
@@ -1366,7 +1368,7 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 
 	err = ext4_handle_dirty_metadata(handle, inode, bh);
 	if (err)
-		goto out;
+		goto out_free;
 
 	/* Update top-level index: num,max,pointer */
 	neh = ext_inode_hdr(inode);
@@ -1389,6 +1391,12 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 	brelse(bh);
 
 	return err;
+
+out_free:
+	/* The new block has not been linked into the extent tree yet. */
+	ext4_free_blocks(handle, inode, NULL, newblock, 1,
+			 EXT4_FREE_BLOCKS_METADATA);
+	goto out;
 }
 
 /*

base-commit: d135ab453a7400a34930bdda1ef4bdc8acfac80e
-- 
2.53.0


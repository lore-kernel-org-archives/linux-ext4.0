Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.164
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793785929;
	b=okunbKOBcysmICoOCbUMthCKj47pnf2OjsJNbWhXR5u1SKadcqPOD6bEL4ZeFxp6u1vv
	 sNkKJbDEDKLNnG4y5ZKztF2+bcFBb5jGhlUSnImZ7gOktXNQobBtrwykrXdv6/rgnJmKy
	 b17aqBoQDoe5WGDmtUOYRBNgpqETd+biSg3SB+pDlQzIz95ZQ1AwBhvT7n3Z+K8f84FBS
	 oMVGc4VY3Uy5DVI7v68FZOI3am+u9xgHRsJJwfnO2BfrfoRbBBmgoi4VRWRUbGcg2Wdzx
	 XaFG5ezsxaVsUuQx9Ntmf0c2ThjIryFmtIqR7CiiEP97JyHXc5DaypUwV/+Tqm2YC9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793785929;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RtlB2RV4gJxPXr+Y3wQBEnh9Djwm2pqXP4DUAG2yukY=;
	b=mYP4tdu0vYacRSLOOSpj9fYuoXS+141I2gM18e7C3uANkQW71ko5bAfkCXru7gb3RpQ2
	 KraRCn7MovWlh2zjUGdwl2vm8MoFZ8ZwG+NpPygNnXhMD6HxH1tV4qwAcXVAVxbvZxTCq
	 a8K/WTWco9dqPOsNLQRPFCw1s7VvNzsYzetIIhvuP9vL1ROHbQ9AbeO3qigr2BzPcGh5b
	 jlL+3RkBePrShhqn7M+Nz+Jz0XcduK8KPVXzLssSJKXHfhlh8hON4g3c39n4TW4KzBT/Q
	 9rxuOm/fhXroOgwdQiB4U2d8VxclfCcEIWqYe0Bg0GNOaXbezC0zGAJmxY7S4xGdVjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=gB4lqPQd;
	arc=none smtp.remote-ip=203.205.221.164
Received: from out203-205-221-164.mail.qq.com (out203-205-221-164.mail.qq.com [203.205.221.164])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C6C606A326;
	Wed,  4 Nov 2026 09:52:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83C6C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=gB4lqPQd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1793785918; bh=RtlB2RV4gJxPXr+Y3wQBEnh9Djwm2pqXP4DUAG2yukY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gB4lqPQdr+MDkMM4KcJDS+tf4orXxiB0uIvHcCaBdZUlKYBYCsxexSPqC9wtR0Qyn
	 47sUPDDi4zluk483PdYz7igvRZm+CRsRQ1bHnNQo2i7vBmM5NpMmP4MU7Th8M8Pib0
	 6Arh2pjT2wsTcOcY4wWqUIG4VwngXxiWwmNtTToE=
Received: from shuai-VMware-Virtual-Platform.. ([218.28.192.28])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id CF794E9A; Wed, 04 Nov 2026 17:51:55 +0800
X-QQ-mid: xmsmtpt1793785915ty3h95k9l
Message-ID: <tencent_540C64A2D2BD5D3A8FC54C9EB80917F75305@qq.com>
X-QQ-XMAILINFO: NbgegmlEc3JuH/YWZVHtIvPZDrszXB4hB1yN2O9ZvlIOq1JRDwM+w8+nmIObf0
	 UCCJcyY8j3lw1d5cW2qTVqNJE758T2fIeQwgroxe+ZdE9VE0q+4l9wUDbw8YQtvhNo0/HpqbE5ak
	 0crKRHJ55Cox/dqmynK/Xx42HM2m3ee+2ZGTnEskB5QXUjPca/BmsHYgxgKWuhdI+0smTAWaad8D
	 vZoIumJ9PQrqJJFGuy61mIGdxShIETQixVjfV6jaf/zj9dt6q17fYJbGADbp67AwmNaCNek9GkY6
	 r3QquXotoEQ3PEv/aizv9kmADOU42Fz1zuxyWxJwZdmwEDMO64ISdo4hJptLocGQlc+ZHXirqUko
	 Sgd4INCfnFxxVlZ4ibcis3jsUz53jXKIG7g7ReMSnJ4r0oW7efahNJXQnaAMBQF4V8il2AL2a0TK
	 SL6OGv+7/HUb21FG6/439zUTmODhI29PcAP4kxrE98xEzjNtQ6TIYbRwyidzNdxugYWrDaP9NxRJ
	 9G681A0rzTukyOqkJE5Es5ryeHnWo+qYoa8YYQM2kqJ+1Aciz8bEAN5IFyoprx+NRbL3M82Kv8ML
	 5hKn2o5UvS8R1cJ+hMoZBqFts++U7Y1FVBXORUluNlMzBwgwQmV+nGmdHnFUSn4JC2BoTqKoF6tb
	 RsCkfJ8mfKzaDsdtQmlX5SFdv0WFCYRUbtMeYPmYFvsaJDDP7IbabgSLkU5Lz4y/XsGGODCa684O
	 beINbDIfX845skrKQAQImgDE4Izz7mr0Qx5l30F3Lv+zNHmdSM/fXdzHzuPX2ad64pLp2CguNTMY
	 yt5PDGXxmbKaG5qJkahA9p/kVL9AycNtjJWiZEsAE1EWInlKocmnWvwwGHey4z0PDgMpbTTSJjKT
	 WR6dYmbAx4mVKeFitQO6eNh4dG0CeNb+ju1rkmBy+HTvmoQBuCHIrVKogUEiDCdmBPwPVu+1AO+h
	 MajnGEgnDcrqONs5iFZnkmy6bF4ALGIHfq6f07WaLjPLBQqamBF1iFowZ2jz5e/lHDE1Ve2g50A4
	 4BIZQKgqO3te0Xus6FsJLj2dvE3pyKyiXOuwUH1v2LScQOgic30j13SqOSEIJSRKEVdu1a1AWvld
	 0EnBrzDCvCYBDIFEX8XluEx++6icLO/PEbCS3h7XY39/WatypdC4IKo+k2cUNhSdxbS0cy
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Shuai Liu <847807867@qq.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-kernel@vger.kernel.org,
	syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com,
	sashiko-bot@kernel.org,
	Shuai Liu <847807867@qq.com>,
	stable@vger.kernel.org
Subject: [PATCH v4] ext4: fix slab-use-after-free in do_split()
Date: Wed,  4 Nov 2026 17:51:55 +0800
X-OQ-MSGID: <20261104095155.738649-1-847807867@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-196970@kernel.org>
References: <sashiko-outbox-196970@kernel.org>
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

do_split() allocates a new directory block with ext4_append() to hold
the second half of the entries of the leaf block being split, then
dx_move_dirents() copies entries from the old block (*bh) into the new
one (bh2).  Nothing verifies that the newly allocated block differs
from the block being split.

On a filesystem whose block bitmap is inconsistent with the directory
tree, a block already referenced as a directory leaf or as an htree
index block can still be marked free, so ext4_append() can return that
same block.  With concurrent operations on such a filesystem (as
exercised by the syzbot reproducer), the block can even be freed
between allocations, resulting in bh2 aliasing *bh.  dx_move_dirents()
then copies the block onto itself, corrupting directory entries
mid-copy: a rec_len field can be overwritten with name bytes, so the
subsequent wipe of the stale entry memset()s a bogus length, causing
the slab-use-after-free reported by syzbot.

The same aliasing applies to the htree index blocks: if the leaf block
or the new block aliases any index frame (the parent index block
frame->bh or one of its ancestors in the frames[] array),
dx_move_dirents() and dx_pack_dirents() overwrite the index header,
dx_insert_block() then memmove()s with a corrupted count and writes
out of bounds, and dx_release() can loop past the frames[] array (or
leak frames) with a corrupted indirect_levels.

Fix this by checking for all of these aliases in do_split() and
bailing out with -EFSCORRUPTED before any directory block contents are
modified, reporting the corruption via ext4_error_inode_block().

Reported-by: syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=09bec78ee77613a3efdd
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Shuai Liu <847807867@qq.com>
Changes in v4:
  - Extend the aliasing checks to all htree index frames: do_split()
    now takes the frames[] array and compares *bh and bh2 against
    frames[0..level], not just the parent frame.  An alias with an
    ancestor index block would overwrite its header, letting
    dx_insert_block() memmove() out of bounds and dx_release() loop
    past the frames[] array or leak frames (Sashiko)
  - Mention the index block aliasing checks in the commit message
    (Sashiko)
---
 fs/ext4/namei.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 354fc2d22df1..25bea69ab246 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1922,12 +1922,36 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	if (ext4_has_feature_metadata_csum(dir->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
+	if (*bh == frame->bh) {
+		ext4_error_inode_block(dir, (*bh)->b_blocknr, EFSCORRUPTED,
+				       "leaf block aliased with index block");
+		brelse(*bh);
+		*bh = NULL;
+		return ERR_PTR(-EFSCORRUPTED);
+	}
+
 	bh2 = ext4_append(handle, dir, &newblock);
 	if (IS_ERR(bh2)) {
 		brelse(*bh);
 		*bh = NULL;
 		return ERR_CAST(bh2);
 	}
+	if (bh2 == *bh) {
+		ext4_error_inode_block(dir, (*bh)->b_blocknr, EFSCORRUPTED,
+				       "cannot split aliased directory block");
+		brelse(bh2);
+		brelse(*bh);
+		*bh = NULL;
+		return ERR_PTR(-EFSCORRUPTED);
+	}
+	if (bh2 == frame->bh) {
+		ext4_error_inode_block(dir, bh2->b_blocknr, EFSCORRUPTED,
+				       "leaf block aliased with index block");
+		brelse(bh2);
+		brelse(*bh);
+		*bh = NULL;
+		return ERR_PTR(-EFSCORRUPTED);
+	}
 
 	BUFFER_TRACE(*bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, dir->i_sb, *bh,
-- 
2.43.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794893291;
	b=nzWp/UIPRWUJtTfZIKayOlhyimz8mPWtlggSfPyM9p3ZsqlnCKdL1EE0LTzno3dNwx9a
	 U9ksUocP8Nu29j6fuJsSjThbjaA2AoXpWPjHH6VzQtCYxYXqCkLLhtB/H7WpcadZzJSxi
	 esN/o4GatXXM1VuLx/aPVKJIAmxTmJ8b1gsmCPJTe4gu4EbjDIBBPL6ecgSK46FaK7qRU
	 w79fNMKpWVTDIHpJrpjF3g/VFCvIXpw81/GJYP9Y7rzrxchzGF8LCtlL1Qz23OfKTeR3G
	 KDVAr24PxVgaLWwXQk4SSMfmttF//jPy+XYfw87i+kmlW7oWVrTj6yMSMY6X5hsUGtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794893291;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=F0BfjDuPCwYzytmSMe8p4WKLbs7JbmnbinkYTy+oL80=;
	b=wLU0n8GF2dY6sEQBPqy4CabZ47pCuFmX012UD6Bfm4tS14HSPPJzcq2xLUivqbAYiLm+
	 WLxGudjLH8sS1QYV9M4+zW6MEquIc9WOo7+bK5rqoS8cGFdjP4OsjWkHgnNgMcLtZt+mE
	 Vb0UYyY+hbzb+xZXZv2j8mW/Vjc2ZzLeeQ5Yicg14zev7Eb4XeX09XtJA8rdeHw/8taYs
	 HCC7836jxDpIi2T6v5XOsXBbm515ichf0VO8XdzOMF9C7R0xpZcN5BnVwlxv/IaiQSTw4
	 HNhOTyaJz6iYDk+xqgqsNWAVdYHcc8EnpRm6GSaQgp4m14pFn4SpmQHWsteZaRRc8eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=logarcheon.com;
	spf=pass smtp.mailfrom=logarcheon.com;
	dkim=pass header.d=logarcheon.com header.i=@logarcheon.com header.a=rsa-sha256 header.s=protonmail3 header.b="lm/5TxJx";
	arc=none smtp.remote-ip=109.224.244.20
Received: from mail-24420.protonmail.ch (mail-24420.protonmail.ch [109.224.244.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617AA606A32A
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2026 05:28:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 617AA606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=logarcheon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=logarcheon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=logarcheon.com header.i=@logarcheon.com header.a=rsa-sha256 header.s=protonmail3 header.b=lm/5TxJx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=logarcheon.com;
	s=protonmail3; t=1794893288; x=1795152488;
	bh=F0BfjDuPCwYzytmSMe8p4WKLbs7JbmnbinkYTy+oL80=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=lm/5TxJx8VE7ORU4aDFXSYn1lgNKFOirHog6nJDzNKABDXtWWkvKQ5CBBI183LO7/
	 jduQvYGy94cGtV6+smDi9Xw++jf0+KrXXZsjTNo6Cd5aHTsrwDTLuFd7+b7fSL50Hj
	 IbiivlrljqDGCPfR3AJ540m/+dJgZkdLDA7y5GiutiNf5Ml60G3s3SkG9EaFadoa2m
	 hkL23AX8RrC5df6MPCS75sSRzA9ePWVp4wysytloxdSemATu1azrI5hZR65fH+QS2w
	 fpK3r6/CE1RuDkVqpID+4fCq2JZhySE5uAi4/mTRcQmwyKTXvZmVJONOGY+t1YRHSb
	 soFld53a8cZxA==
Date: Tue, 17 Nov 2026 05:28:04 +0000
To: Theodore Ts'o <tytso@mit.edu>
From: William Chuang <founder@logarcheon.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, syzbot+e8180f5590685cbc9037@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: [PATCH 1/2] ext4: reserve quota credits in swap_inode_boot_loader()
Message-ID: <20261117052750.2955-2-founder@logarcheon.com>
In-Reply-To: <20261117052750.2955-1-founder@logarcheon.com>
References: <20261117052750.2955-1-founder@logarcheon.com>
Feedback-ID: 145408520:user:proton
X-Pm-Message-ID: 6a86ac27491d2e56f2b2503700f7257f3972ec44
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

swap_inode_boot_loader() starts its handle with 2 credits, enough for
the two inode table blocks it dirties.  Since commit aa507b5faf38
("ext4: update quota information while swapping boot loader inode") it
also calls dquot_free_space() or dquot_alloc_space() under the same
handle.  On a filesystem with quota enabled, that marks the dquots
dirty and ext4_write_dquot() writes them to the quota file.  The
nested ext4_journal_start() in ext4_write_dquot() reuses the running
handle and adds no credits, so the quota block write can find the
handle with no credits left:

  WARNING: fs/jbd2/transaction.c:1598 at jbd2_journal_dirty_metadata
  Call Trace:
   __ext4_handle_dirty_metadata
   ext4_quota_write
   qtree_write_dquot
   v2_write_dquot
   dquot_commit
   ext4_write_dquot
   mark_all_dquot_dirty
   __dquot_free_space
   swap_inode_boot_loader
   ext4_ioctl

jbd2 returns -ENOSPC and the journal is aborted.  The ioctl still
returns 0, and the filesystem is left with the wrong i_blocks on the
swapped inode and inconsistent quota usage, which e2fsck reports.

Reserve one quota block per quota type, as ext4_ext_migrate() does.

Tested on UML with a filesystem made by "mke2fs -O quota": write and
sync a file, then issue EXT4_IOC_SWAP_BOOT on it.  Without this patch
the WARN fires ("credits 3/0") and e2fsck -fn reports errors; with it
there is no warning and e2fsck -fn is clean.

Fixes: aa507b5faf38 ("ext4: update quota information while swapping boot lo=
ader inode")
Reported-by: syzbot+e8180f5590685cbc9037@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3De8180f5590685cbc9037
Signed-off-by: William Chuang <founder@logarcheon.com>
---
 fs/ext4/ioctl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index e8e579498..ae03eb834 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -425,7 +425,12 @@ static long swap_inode_boot_loader(struct super_block =
*sb,
 =09truncate_inode_pages(&inode->i_data, 0);
 =09truncate_inode_pages(&inode_bl->i_data, 0);
=20
-=09handle =3D ext4_journal_start(inode_bl, EXT4_HT_MOVE_EXTENTS, 2);
+=09/*
+=09 * Two inode table blocks, plus one quota block per quota type for
+=09 * the dquot_free_space()/dquot_alloc_space() update below.
+=09 */
+=09handle =3D ext4_journal_start(inode_bl, EXT4_HT_MOVE_EXTENTS,
+=09=09=09=09    2 + EXT4_MAXQUOTAS_TRANS_BLOCKS(sb));
 =09if (IS_ERR(handle)) {
 =09=09err =3D -EINVAL;
 =09=09goto err_out;
--=20
2.43.0



Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795457707;
	b=T4LzfNZp/S3ZeFxoTmwL9jxuPhiuaK/LMH6ZtTTsf5tcQFFC9q0XHDyq/S0/4u9x1Yd3
	 75f/3xgH2gkYcAbIoLTtZrKhiY+S1uVog5c7YW7rwtKFlU2KXlKElI97fWX1b3ui+C5yz
	 wyPxw+BVzfslxZpLOHYYPzHXqbz61ANnsOnWTeDSastn3bysRXY6qNHogFDZU99eDyyhg
	 lPc9ctf/fPpTyMtnWKX/WXDHqYFiBPJmyxAF2M0dv+8T99YuIOT5ZVgP1Lio7JUd1nVyj
	 SNaBksuA/VUMFUIghOdt/rbtNwuFSYI7bl2AFZzc3pRuJjV8Tgu+1tdh6q5qmNoJ/qQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795457707;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=4RwVRi4lv4NFCDPuBReyKfH02H3CYgQbpkPiInk4r68=;
	b=gGHP+xEufN+507oMWJCmXPE+psWuub8B/Kdi1pcvrYVn0YzJnEnBBnJ5WLP/jqkHIJc6
	 elcciTU/Lpgc96Iu8pup4iTBn0rgyYGR/4OsbNNxp1KJrf5QPqnAWvC2L1iGazcwKnSBh
	 ZDRuvWJE9VbKyDjAeJa3LzecJtWYjyAF9MEc8MJuqZ/HlLjaoDA46IN4Ii8+oOFtAhAnR
	 RZdSMeCLhF0a4Lf7gvgEu4kAwPPupwfHwi8Z+p92DlEdm8wQW5xZiRDwlU2GQx0HrK7pk
	 6mtOVZkr3m9ZM/F+yRYkH123csMWGYMLHzi0q5eHOlALt1G/9M/19avSM+OyIXKWBaA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=amGZ0qx+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C763606A31E;
	Mon, 23 Nov 2026 18:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=amGZ0qx+
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795457706;
	b=n8eqTMkSReYnqMgTt/2aeepPVT3VcI07xOduI/FrzKHRpjR5jjpVFQMGcS4dQ/q4wdUK
	 o579f6SjtPf/gUg5bIfkNFuYffvrxVaBhAB+bfDQJbt3DoSNOeifqUEODr7Ye371B/nuh
	 u3EYucw7XuAXiHkEizFLNb+3NNw4EXgIw3/MFiYyaONKe2P6JGc2ly1esVrIJipQVSSh2
	 g4qhIjlVkJ69e37/Hy7iMKbwqQt84nX6f2lpbN7owrFuRyeNrP8hl8HNwoFfkPb3DuYu2
	 UpCusx6l1joXDbqigKSKsX0DxFxc8f9p0FetBPL3Lbcj/0x9AvOYqiiackK3oXbWYVw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795457706;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=4RwVRi4lv4NFCDPuBReyKfH02H3CYgQbpkPiInk4r68=;
	b=BS/gTQCkfg21EwAVaMzIKUZyJEAKP+LPv5sbtHCqh5NxE/erxouF0VsAb1X3P88+z1Ls
	 34oa6Oky8stAwMZNZ6/vn/se5qQnd1KOM1kAXYAKxv8x0EyW5Y1ycQe3QRXZjZ+Lig2cM
	 quH8PbGGG4r/bJBM4lSCg8VB8p1Oe1+sTor19mSqUc+gBpHjgNSXWTAPu655dii70C06i
	 O+TUkonzITA7OXiPZYvrZOD1zZB23oZP2El1GFK11DNXqnsZc91kGMKke6s6bf9sM/WY1
	 K1vvKmurSYOEGtcjzMBtsO9UyllJh0B0IQC9WT2HCBL139+oThygyOb0NYt7k6FoZ+w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5B7651F000C0;
	Mon, 23 Nov 2026 18:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795457706;
	bh=4RwVRi4lv4NFCDPuBReyKfH02H3CYgQbpkPiInk4r68=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=amGZ0qx+yaSKQilg6liPp5xrFJJc/BaXguXIZmDDoZqr+vJTUuba9QxL5wABfFYFa
	 UCPPG/5ADbhQO1zEpy8B1vNoOz1m7rP4SpvhRAmrV7yJOQ/QDcyA2giyDwFTl8bKYW
	 LFhLA5ds3XlsAn/K+g53F2rlBndCVxxN1zQtacjjGYzQEZ5Rhf/FOkdpfCqUZ8VB0F
	 ROEPDtVgXo9JhgCXtLkc3GZVSagZY0JRCmoWrnEThkrIFMyYvXv3w/V+vMcFg/jNsZ
	 S4Yq0KUaQE6/ka0/bXmmCfDGKQquZjew3rC6JcaUfIpt4BdeyXQOSMoR/jdWBBb7nV
	 pBcA06qXFxQHw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id C52554C599;
	Mon, 23 Nov 2026 18:15:01 +0000 (UTC)
From: =?utf-8?q?Aykut_C=C4=B1nc=C4=B1k_via_B4_Relay?= <devnull+aykutcincik.ogr.eskisehir.edu.tr@kernel.org>
Date: Mon, 23 Nov 2026 21:15:01 +0300
Subject: [PATCH] ext4: undo the splice when ext4_splice_branch() fails
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
Message-Id: <20261123-ext4-splice-unsplice-v1-1-d291b741d15a@ogr.eskisehir.edu.tr>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/y3M0Q5EMBCF4VeRudZES5B9FdmLdgxGpKSDSMS76
 1p357s4/wlCgUngk5wQaGfh2UfoNAEcrO9JcRsNJjOl1iZXdKyFkmViJLX5d1S1zW2LrjboIF6
 XQB0fT7b5/i2bGwnXXwuu6wYXwdFleAAAAA==
X-Change-ID: 20261123-ext4-splice-unsplice-78a3adcb82cb
To: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, 
 stable@vger.kernel.org, 
 =?utf-8?q?Aykut_C=C4=B1nc=C4=B1k?= <aykutcincik@ogr.eskisehir.edu.tr>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795457701; l=2094;
 i=aykutcincik@ogr.eskisehir.edu.tr; s=20261121; h=from:subject:message-id;
 bh=Ls4C+dOUY3TCmbcSSyBWCu5aT7wRmuBH47WNxUck0+g=;
 b=OFJbPSfHX2f9wrqb18yNB7lNY7h+rGZD3Mu739L7AigYtB4io6L/8uULPlHKIZE0wWIeWpVON
 cSPhkJ2DarrAn51ImuhxUY4U0LaOhRcHSt0/eqneOZ+qDWCCNzl1621
X-Developer-Key: i=aykutcincik@ogr.eskisehir.edu.tr; a=ed25519;
 pk=0VzUGJI+NLEekrIgYW4SWfh5kCTg8XsSWzEwmTagNes=
X-Endpoint-Received: by B4 Relay for
 aykutcincik@ogr.eskisehir.edu.tr/20261121 with auth_id=1593
X-Original-From: =?utf-8?q?Aykut_C=C4=B1nc=C4=B1k?= <aykutcincik@ogr.eskisehir.edu.tr>
Reply-To: aykutcincik@ogr.eskisehir.edu.tr
Content-Transfer-Encoding: 8bit

From: Aykut Cıncık <aykutcincik@ogr.eskisehir.edu.tr>

If ext4_handle_dirty_metadata() or ext4_mark_inode_dirty() fails,
ext4_splice_branch() frees the new blocks but leaves the pointers to
them in place.  A later write then reuses the freed blocks, which can
silently overwrite another file's data.

Clear the pointers before freeing the blocks.

Found and fixed with the help of Claude Code (Claude Opus).

Fixes: ac27a0ec112a ("[PATCH] ext4: initial copy of files from ext3")
Cc: stable@vger.kernel.org
Signed-off-by: Aykut Cıncık <aykutcincik@ogr.eskisehir.edu.tr>
---
Tested in QEMU by making each of the two calls fail with the dm "error"
target.  Without the fix all 12 runs showed corruption (another file
overwritten, or a double free); with it all 12 were clean, with KASAN
and lockdep enabled.

Tested on top of [1]; the two patches apply in either order.

[1] https://patch.msgid.link/20261121-ext4-ind-discard-pa-v1-1-ee92928f7797@ogr.eskisehir.edu.tr
---
 fs/ext4/indirect.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index a495080df710..764f01057aca 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -471,18 +471,21 @@ static int ext4_splice_branch(handle_t *handle,
 		BUFFER_TRACE(where->bh, "call ext4_handle_dirty_metadata");
 		err = ext4_handle_dirty_metadata(handle, ar->inode, where->bh);
 		if (err)
-			goto err_out;
+			goto err_unsplice;
 	} else {
 		/*
 		 * OK, we spliced it into the inode itself on a direct block.
 		 */
 		err = ext4_mark_inode_dirty(handle, ar->inode);
 		if (unlikely(err))
-			goto err_out;
+			goto err_unsplice;
 		ext4_debug("splicing direct\n");
 	}
 	return err;
 
+err_unsplice:
+	/* Do not leave the tree pointing at the blocks freed below. */
+	memset(where->p, 0, sizeof(*where->p) * (num == 0 ? ar->len : 1));
 err_out:
 	for (i = 1; i <= num; i++) {
 		/*

---
base-commit: c44104f3642da720164042623e4832836aefdd8e
change-id: 20261123-ext4-splice-unsplice-78a3adcb82cb

Best regards,
--  
Aykut Cıncık <aykutcincik@ogr.eskisehir.edu.tr>



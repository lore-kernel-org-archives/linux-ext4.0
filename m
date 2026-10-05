Received: from mail-vs2-f36.google.com (mail-vs2-f36.google.com [74.125.227.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A85221FD4
	for <linux-ext4@vger.kernel.org>; Mon,  5 Oct 2026 00:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791160545; cv=none; b=T58vwWpbm+LFKVr1oUGH6rG6Szpd6deTOi6zvRoHEdP/68AhzmRSI2svwFx16JWyxmRXCO6B8I//cYajswz0U3KBzVP2HVbi7udI6//jVr2oMTjzm/NuRnZXvHK/Z7vPxKTw/+xI8S9dZ2pgtwEHzcF9xw8xTD0dsinAOjIcXO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791160545; c=relaxed/simple;
	bh=2FrvFsvX2x9s1teS7gnxDFE6GIWl1nvTF/TpcSBVZGA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G9f80Vch9b9NUwHxkHqNoplDzdDYAg7VI1TUhWfbSjfVgLQorGg+IY9er9syI15dE4g9DAcrg1xYQURwVUcdWwNc8slAW3ird7Z6azpzS7qmkhOZob/jO0nmulT6/NBv1oWkedIkSuajkiJXt8NGlllE5ixWo+DIz4AU2YDrRQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fMAWBAoK; arc=none smtp.client-ip=74.125.227.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fMAWBAoK"
Received: by mail-vs2-f36.google.com with SMTP id ada2fe7eead31-7bad9d27d58so627376137.1
        for <linux-ext4@vger.kernel.org>; Sun, 04 Oct 2026 17:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791160542; x=1791765342; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DIFlMzCD+Q6Ytncf1DaxxppB9CiAQqNyy2tvfDerbIY=;
        b=fMAWBAoKMJtVrU+8ykYaOI2c0O3assXEyghTNSb9XhOWROzs0X/lQrldmdawYggh5v
         DkhzKh5MsB7So2567csqx3VvtNYbJsgiJtKQNrmCR2mfa0Gb6p8mGItsi2cXn9Ua9EqN
         GLas686JRmTI3oPImyEnz0cb+A5xfo/H8TBr5VbUFB4pBoHIQVe9CPpbpcWHySRovz8L
         wLIr0DZyU8sTmRmNPBIIvArkAWrPhX8OxISoaBl2AxDpLBaqa8P8lmE/fylmYJ6jGdSu
         RNsQgzoARPo8wLQZsjmUgb5ybRbhn8urZVgTaOWAtTbilsrKJgWy/+jpG7NK+7NcslwJ
         rXtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791160542; x=1791765342;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DIFlMzCD+Q6Ytncf1DaxxppB9CiAQqNyy2tvfDerbIY=;
        b=IAZ+95lu/xWnk+6vo5NPx1iKsy4Jz+ZH7uf0pOtyoAwELS23mMeel7M67gP71qgtP7
         nXN61m6YNpISNidVORcLCkTiwXXnY4QBtbBdaTnNODyQL7AHhbn22tb+K3X0tUinQ2K9
         jcGouwX5LRdKbyAYYm3xQs5AacNbdDhsTMSztum3qwvJhPipkAzC0vgL5mwC6szfzw1V
         3vNH2/mRsnTTgg8sSo30gPHf/ODN98aKLG4Q+467MstZ+g2J2OKY7o08ozvjZz00Fhbp
         D8hFqUHmAEocePYr9wJ6tmSA9s/Jg3Qx7w/kguCluokyRsiWORC0aJy+QidCrjUbRDcW
         cTUw==
X-Forwarded-Encrypted: i=1; AKwUvBzg6Nq4m7JCgpgOUz0bmP21k92ZgcbRYpA++jyQdF1JUgEM6k6ZihjGuqNCroN/FGSbfm59HXZeffaf@vger.kernel.org
X-Gm-Message-State: AFq9FYIfY4Mm1CcB2EgxzBbRDEz+rLwiW3DNcqJcCglfx/CBeRMehxxp
	ULvZJsz8YdQUrEqiVhhuCaO6tbNwCPBJTlbp/jyzZqp71jlmJBzDbQXZ
X-Gm-Gg: AYBFou2p7AvauU6SOdhCodK/sULvW11vO96LdSOPa1P51mA3WNCsWWai9FzK8n1+LzM
	qbSNr0lRJHWd+OZ7HX4O8bS71QfE00DAvdR4ul4luYdQzGCbHrCzqq9S1pHtcCOPFZcpvHOUVAe
	ahpKAWcPf43Q0jhzkhnvGYrzahvBaExpl6O67lVNsbKMbS8EhZCS3BtJYIFAMLpjdts0u1TsEGb
	V3rjk0sqCrYV++CqbQDvVKTSc+Add4ryXJ7mUDzSrkZ2xjkIxHfc5SSqMEnomMjgsQHPVZGbIHH
	O65B2UPUnN6sfs4M4Dj53c5U6ncCEV1lsTaa+RtH/i63b0BIrqdh2zFGXyeAzwjnaPTVbuXW6X1
	MrWTDKz8PSz2+P84QJEsfEIR5QgKaY8An+Dc0KnxGAwbtMn2XDv/jdtKC1vO0uEkj9yBGyAum4S
	Jfh1/EmpE1Tt5Ou+lw3y70R3JMZfkUnkr8T3IIwQNJTaGXsgBzg2DO5ickaMBzchR7mG1UPumBd
	T4=
X-Received: by 2002:a05:6102:6b03:b0:7a8:1837:9eb9 with SMTP id ada2fe7eead31-7c0f57aaf35mr2393143137.27.1791160542463;
        Sun, 04 Oct 2026 17:35:42 -0700 (PDT)
Received: from adriano ([190.215.95.120])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7c100026109sm8546639137.9.2026.10.04.17.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 17:35:41 -0700 (PDT)
From: Adriano Cordova <adrianox@gmail.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Adriano Cordova <adrianox@gmail.com>,
	syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
Subject: [PATCH v2] ext4: don't append a directory block already mapped in the inode
Date: Sun,  4 Oct 2026 21:35:28 -0300
Message-ID: <20261005003528.92046-1-adrianox@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_append() grows a directory by one block.  It checks that the target
logical block is a hole, but a corrupt block bitmap can still make the
allocator hand back a physical block that is already in use by this
inode.  The in-memory copy of a block is keyed by its physical block
number, so the "new" block and that existing one are the same memory;
callers that split a directory (make_indexed_dir()/do_split()) then move
entries between two aliased buffers and corrupt the directory, until a
bogus rec_len read from the middle of a name runs the wipe out of bounds:

  BUG: KASAN: slab-use-after-free in dx_move_dirents [inline]
  Write of size 90458 ...

Reject the block and report the corrupt bitmap instead of corrupting
memory.

Reported-by: syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=09bec78ee77613a3efdd
Tested-by: syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
Signed-off-by: Adriano Cordova <adrianox@gmail.com>
---
Changes in v2:
- Rework after review of v1 ("ext4: wipe moved dirents with their real
  length"). dx_make_map() already validates each entry, so the bad
  rec_len does not come from disk. The problem is that the block
  allocator was handing back a block already mapped by the inode.

 fs/ext4/namei.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 3b9740c1c16d..ff6013306b74 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -83,6 +83,25 @@ static struct buffer_head *ext4_append(handle_t *handle,
 	bh = ext4_bread(handle, inode, *block, EXT4_GET_BLOCKS_CREATE);
 	if (IS_ERR(bh))
 		return bh;
+
+	for (map.m_lblk = 0; map.m_lblk < *block; map.m_lblk += map.m_len) {
+		map.m_len = *block - map.m_lblk;
+		err = ext4_map_blocks(NULL, inode, &map, 0);
+		if (err < 0)
+			goto out;
+		if (err == 0) {
+			map.m_len = 1;
+			continue;
+		}
+		if (unlikely(map.m_pblk == bh->b_blocknr)) {
+			EXT4_ERROR_INODE(inode,
+					 "new block %llu already mapped",
+					 (unsigned long long)bh->b_blocknr);
+			err = -EFSCORRUPTED;
+			goto out;
+		}
+	}
+
 	inode->i_size += inode->i_sb->s_blocksize;
 	EXT4_I(inode)->i_disksize = inode->i_size;
 	err = ext4_mark_inode_dirty(handle, inode);
-- 
2.51.0


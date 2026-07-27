Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A213F8717
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149407; cv=none; b=dmj7vMFCwBjOphXyAHj3uwSxfK3TDPU4v0qWH29ZGzeb0kBWRFJmD+YcRLQmA1sCVi/1UAQtsGkbLmWs7D6i58+Xe7pUXCW8ctEEyTzqDhSLFbYZjzHCQCODD6bZGf6vtLG6+iuO/kWfhlheKPxyKGal4CH9pgTRf07FhzQutFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149407; c=relaxed/simple;
	bh=+ZKbN4NqjhaM+0lCSrPLsOilVhhoRSuqkjArQtLqXYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngWFgnbPoDxx6X1ep6ti7O9kx0DMorDPUUBdpCYpWar1EktY8f+/ktN8tTxH3vxe+K4w3CCJrPNsPQPXOG+bgQCqBueZtZqoIaymuON8TnadCi02ZQmZ8DIGV04dQDhuHjVpsQS/RS4EcWtrppoJL4nGdo9L+L6CCYRVjXuVyio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pUb0eP5O; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JFMbFAYA; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NNTvosb+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=gePsblTo; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pUb0eP5O";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JFMbFAYA";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NNTvosb+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="gePsblTo"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AF3237DAEC;
	Mon, 27 Jul 2026 10:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tAFRks1qgzKY9cotCQENW0yAlxLgfmgBSKjpokaxh+s=;
	b=pUb0eP5OMfoZKDue/VCPBxM02mtzt5hVSZB98dGWC2ObGssmAKpFgmoacV7HH/5gWclmG9
	56+7pRhM7k4yA6x5EwTUXrJ3hV6/sXzqxqL6SkKDDwNKG7avYKYaTyazbuV0gI+sNpbdE1
	989Ycn5TlhqPwUeKh8Gd17q5+XqPL/Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149391;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tAFRks1qgzKY9cotCQENW0yAlxLgfmgBSKjpokaxh+s=;
	b=JFMbFAYAXKO6voMsMYv8DBlyBWTTeMvMxJNTqxBAPR0we+GM0xQDejvtOJUJWwIS8nYf7L
	OzqnoZknjEw/5ADQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NNTvosb+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gePsblTo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tAFRks1qgzKY9cotCQENW0yAlxLgfmgBSKjpokaxh+s=;
	b=NNTvosb+2kVEfaQGrjRkmfOPjFQt6DDG0aGNBUwHULJwDM4wq6oQrxJRKVD961ZkAFqt1D
	EJGwf8rDbgRS0gLAi/wuM45kW2+P0r0bPpQ4ns/MqqjSMHsRwHM9IS+V/1VsCzJr846WpL
	moftPfq6C0DEdOB4RFL/a9c/0UN2Ff8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149387;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tAFRks1qgzKY9cotCQENW0yAlxLgfmgBSKjpokaxh+s=;
	b=gePsblTo49cMeIW/5o+XZyL7PhvrZKK0blZ3r04ew+D9wB0VMJr+hzPBDa+dk8uj3qaaWb
	J+Q3e+ap3BCtyxAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9CA37779C1;
	Mon, 27 Jul 2026 10:49:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YZo8Jss3Z2oAawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:49:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2C5A3A0ADE; Mon, 27 Jul 2026 12:49:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH v5 01/20] affs: Drop support for metadata bh tracking
Date: Mon, 27 Jul 2026 12:49:19 +0200
Message-ID: <20260727104923.3828017-21-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260727101509.21667-1-jack@suse.cz>
References: <20260727101509.21667-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10948; i=jack@suse.cz; h=from:subject; bh=+ZKbN4NqjhaM+0lCSrPLsOilVhhoRSuqkjArQtLqXYU=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGLLSzTdPnd44+9i8dpk/rUdeb1SN42mp1trpmf+44/xRm Y7bbC9sOhmNWRgYORhkxRRZVkde1L42z6hra6iGDMwgViaQKQxcnAIwkQVL2f8X/9FUyMzbaxDU px/11ZvXt2e5mF9ez3Q/26L3RyqPd860e5j4SPhi2kKBlbz+BvnP1pkEsX3inOUsrtJv2hxq9uW E5hmBwFYFLfaNL/O+fGfe+k3obBrjmt+eMbGNxsveVR6YuKvfrMfkyguVbTymfiYprdzfWLMPso W434l99v6eBHNBE9vLn4/EF+zwnCX+jv3B2ni3pTlL2mvOMB0UUtn0dvWa7rul//VZJfnnfzavs nCQnOb7a6YKv9hujq+rAo5pXNvM3ru9e26ESO73oCXc209Zdum7uQaY64tH+pRK8bR87SpzKt+x 0FC+rWGWSLnIZMH94TcSC1Q1P0fNm3CuVuVO4eRPZsK3AA==
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: AF3237DAEC
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[suse.cz:mid,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:mid,suse.cz:email,suse.cz:dkim,suse.com:email];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz,suse.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

AFFS did all the hard work of tracking metadata bhs dirtied for an inode
but it actually never used this information as affs_file_fsync() just
calls sync_blockdev() to writeback all filesystem metadata bhs. After a
discussion with AFFS maintainer nobody cares about AFFS performance
so let's keep this affs_file_fsync() behavior and just drop all the
pointless tracking from AFFS.

CC: David Sterba <dsterba@suse.com>
Acked-by: David Sterba <dsterba@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/affs/affs.h     |  2 --
 fs/affs/amigaffs.c | 12 ++++++------
 fs/affs/file.c     | 25 +++++++++++--------------
 fs/affs/inode.c    | 13 +++++--------
 fs/affs/namei.c    |  9 ++++-----
 fs/affs/super.c    |  1 -
 6 files changed, 26 insertions(+), 36 deletions(-)

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index 44a3f69d275f..a7faa91deed5 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -44,7 +44,6 @@ struct affs_inode_info {
 	struct mutex i_link_lock;		/* Protects internal inode access. */
 	struct mutex i_ext_lock;		/* Protects internal inode access. */
 #define i_hash_lock i_ext_lock
-	struct mapping_metadata_bhs i_metadata_bhs;
 	u32	 i_blkcnt;			/* block count */
 	u32	 i_extcnt;			/* extended block count */
 	u32	*i_lc;				/* linear cache of extended blocks */
@@ -152,7 +151,6 @@ extern bool	affs_nofilenametruncate(const struct dentry *dentry);
 extern int	affs_check_name(const unsigned char *name, int len,
 				bool notruncate);
 extern int	affs_copy_name(unsigned char *bstr, struct dentry *dentry);
-struct mapping_metadata_bhs *affs_get_metadata_bhs(struct inode *inode);
 
 /* bitmap. c */
 
diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index bed4fc805e8e..6cc0fc9a4cbf 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -57,7 +57,7 @@ affs_insert_hash(struct inode *dir, struct buffer_head *bh)
 		AFFS_TAIL(sb, dir_bh)->hash_chain = cpu_to_be32(ino);
 
 	affs_adjust_checksum(dir_bh, ino);
-	mmb_mark_buffer_dirty(dir_bh, &AFFS_I(dir)->i_metadata_bhs);
+	mark_buffer_dirty(dir_bh);
 	affs_brelse(dir_bh);
 
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
@@ -100,7 +100,7 @@ affs_remove_hash(struct inode *dir, struct buffer_head *rem_bh)
 			else
 				AFFS_TAIL(sb, bh)->hash_chain = ino;
 			affs_adjust_checksum(bh, be32_to_cpu(ino) - hash_ino);
-			mmb_mark_buffer_dirty(bh, &AFFS_I(dir)->i_metadata_bhs);
+			mark_buffer_dirty(bh);
 			AFFS_TAIL(sb, rem_bh)->parent = 0;
 			retval = 0;
 			break;
@@ -180,7 +180,7 @@ affs_remove_link(struct dentry *dentry)
 			affs_unlock_dir(dir);
 			goto done;
 		}
-		mmb_mark_buffer_dirty(link_bh, &AFFS_I(inode)->i_metadata_bhs);
+		mark_buffer_dirty(link_bh);
 
 		memcpy(AFFS_TAIL(sb, bh)->name, AFFS_TAIL(sb, link_bh)->name, 32);
 		retval = affs_insert_hash(dir, bh);
@@ -188,7 +188,7 @@ affs_remove_link(struct dentry *dentry)
 			affs_unlock_dir(dir);
 			goto done;
 		}
-		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+		mark_buffer_dirty(bh);
 
 		affs_unlock_dir(dir);
 		iput(dir);
@@ -203,7 +203,7 @@ affs_remove_link(struct dentry *dentry)
 			__be32 ino2 = AFFS_TAIL(sb, link_bh)->link_chain;
 			AFFS_TAIL(sb, bh)->link_chain = ino2;
 			affs_adjust_checksum(bh, be32_to_cpu(ino2) - link_ino);
-			mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+			mark_buffer_dirty(bh);
 			retval = 0;
 			/* Fix the link count, if bh is a normal header block without links */
 			switch (be32_to_cpu(AFFS_TAIL(sb, bh)->stype)) {
@@ -306,7 +306,7 @@ affs_remove_header(struct dentry *dentry)
 	retval = affs_remove_hash(dir, bh);
 	if (retval)
 		goto done_unlock;
-	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+	mark_buffer_dirty(bh);
 
 	affs_unlock_dir(dir);
 
diff --git a/fs/affs/file.c b/fs/affs/file.c
index 144b17482d12..23e088a7ed4f 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -140,14 +140,14 @@ affs_alloc_extblock(struct inode *inode, struct buffer_head *bh, u32 ext)
 	AFFS_TAIL(sb, new_bh)->parent = cpu_to_be32(inode->i_ino);
 	affs_fix_checksum(sb, new_bh);
 
-	mmb_mark_buffer_dirty(new_bh, &AFFS_I(inode)->i_metadata_bhs);
+	mark_buffer_dirty(new_bh);
 
 	tmp = be32_to_cpu(AFFS_TAIL(sb, bh)->extension);
 	if (tmp)
 		affs_warning(sb, "alloc_ext", "previous extension set (%x)", tmp);
 	AFFS_TAIL(sb, bh)->extension = cpu_to_be32(blocknr);
 	affs_adjust_checksum(bh, blocknr - tmp);
-	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+	mark_buffer_dirty(bh);
 
 	AFFS_I(inode)->i_extcnt++;
 	mark_inode_dirty(inode);
@@ -581,7 +581,7 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 		memset(AFFS_DATA(bh) + boff, 0, tmp);
 		be32_add_cpu(&AFFS_DATA_HEAD(bh)->size, tmp);
 		affs_fix_checksum(sb, bh);
-		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+		mark_buffer_dirty(bh);
 		size += tmp;
 		bidx++;
 	} else if (bidx) {
@@ -603,7 +603,7 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 		AFFS_DATA_HEAD(bh)->size = cpu_to_be32(tmp);
 		affs_fix_checksum(sb, bh);
 		bh->b_state &= ~(1UL << BH_New);
-		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+		mark_buffer_dirty(bh);
 		if (prev_bh) {
 			u32 tmp_next = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
 
@@ -613,8 +613,7 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 					     bidx, tmp_next);
 			AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
 			affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp_next);
-			mmb_mark_buffer_dirty(prev_bh,
-					      &AFFS_I(inode)->i_metadata_bhs);
+			mark_buffer_dirty(prev_bh);
 			affs_brelse(prev_bh);
 		}
 		size += bsize;
@@ -733,7 +732,7 @@ static int affs_write_end_ofs(const struct kiocb *iocb,
 		AFFS_DATA_HEAD(bh)->size = cpu_to_be32(
 			max(boff + tmp, be32_to_cpu(AFFS_DATA_HEAD(bh)->size)));
 		affs_fix_checksum(sb, bh);
-		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+		mark_buffer_dirty(bh);
 		written += tmp;
 		from += tmp;
 		bidx++;
@@ -766,13 +765,12 @@ static int affs_write_end_ofs(const struct kiocb *iocb,
 						     bidx, tmp_next);
 				AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
 				affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp_next);
-				mmb_mark_buffer_dirty(prev_bh,
-					&AFFS_I(inode)->i_metadata_bhs);
+				mark_buffer_dirty(prev_bh);
 			}
 		}
 		affs_brelse(prev_bh);
 		affs_fix_checksum(sb, bh);
-		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+		mark_buffer_dirty(bh);
 		written += bsize;
 		from += bsize;
 		bidx++;
@@ -801,14 +799,13 @@ static int affs_write_end_ofs(const struct kiocb *iocb,
 						     bidx, tmp_next);
 				AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
 				affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp_next);
-				mmb_mark_buffer_dirty(prev_bh,
-						&AFFS_I(inode)->i_metadata_bhs);
+				mark_buffer_dirty(prev_bh);
 			}
 		} else if (be32_to_cpu(AFFS_DATA_HEAD(bh)->size) < tmp)
 			AFFS_DATA_HEAD(bh)->size = cpu_to_be32(tmp);
 		affs_brelse(prev_bh);
 		affs_fix_checksum(sb, bh);
-		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+		mark_buffer_dirty(bh);
 		written += tmp;
 		from += tmp;
 		bidx++;
@@ -945,7 +942,7 @@ affs_truncate(struct inode *inode)
 	}
 	AFFS_TAIL(sb, ext_bh)->extension = 0;
 	affs_fix_checksum(sb, ext_bh);
-	mmb_mark_buffer_dirty(ext_bh, &AFFS_I(inode)->i_metadata_bhs);
+	mark_buffer_dirty(ext_bh);
 	affs_brelse(ext_bh);
 
 	if (inode->i_size) {
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 5dd1b016bcb0..d4a3f381c4bc 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -206,7 +206,7 @@ affs_write_inode(struct inode *inode, struct writeback_control *wbc)
 		}
 	}
 	affs_fix_checksum(sb, bh);
-	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+	mark_buffer_dirty(bh);
 	affs_brelse(bh);
 	affs_free_prealloc(inode);
 	return 0;
@@ -266,11 +266,8 @@ affs_evict_inode(struct inode *inode)
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
 		affs_truncate(inode);
-	} else {
-		mmb_sync(&AFFS_I(inode)->i_metadata_bhs);
 	}
 
-	mmb_invalidate(&AFFS_I(inode)->i_metadata_bhs);
 	clear_inode(inode);
 	affs_free_prealloc(inode);
 	cache_page = (unsigned long)AFFS_I(inode)->i_lc;
@@ -305,7 +302,7 @@ affs_new_inode(struct inode *dir)
 	bh = affs_getzeroblk(sb, block);
 	if (!bh)
 		goto err_bh;
-	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+	mark_buffer_dirty(bh);
 	affs_brelse(bh);
 
 	inode->i_uid     = current_fsuid();
@@ -393,17 +390,17 @@ affs_add_entry(struct inode *dir, struct inode *inode, struct dentry *dentry, s3
 		AFFS_TAIL(sb, bh)->link_chain = chain;
 		AFFS_TAIL(sb, inode_bh)->link_chain = cpu_to_be32(block);
 		affs_adjust_checksum(inode_bh, block - be32_to_cpu(chain));
-		mmb_mark_buffer_dirty(inode_bh, &AFFS_I(inode)->i_metadata_bhs);
+		mark_buffer_dirty(inode_bh);
 		set_nlink(inode, 2);
 		ihold(inode);
 	}
 	affs_fix_checksum(sb, bh);
-	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+	mark_buffer_dirty(bh);
 	dentry->d_fsdata = (void *)(long)bh->b_blocknr;
 
 	affs_lock_dir(dir);
 	retval = affs_insert_hash(dir, bh);
-	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+	mark_buffer_dirty(bh);
 	affs_unlock_dir(dir);
 	affs_unlock_link(inode);
 
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index c3c6532da4b0..57d8d755aada 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -373,7 +373,7 @@ affs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	}
 	*p = 0;
 	inode->i_size = i + 1;
-	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
+	mark_buffer_dirty(bh);
 	affs_brelse(bh);
 	mark_inode_dirty(inode);
 
@@ -443,8 +443,7 @@ affs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	/* TODO: move it back to old_dir, if error? */
 
 done:
-	mmb_mark_buffer_dirty(bh,
-			&AFFS_I(retval ? old_dir : new_dir)->i_metadata_bhs);
+	mark_buffer_dirty(bh);
 	affs_brelse(bh);
 	return retval;
 }
@@ -497,8 +496,8 @@ affs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 	retval = affs_insert_hash(old_dir, bh_new);
 	affs_unlock_dir(old_dir);
 done:
-	mmb_mark_buffer_dirty(bh_old, &AFFS_I(new_dir)->i_metadata_bhs);
-	mmb_mark_buffer_dirty(bh_new, &AFFS_I(old_dir)->i_metadata_bhs);
+	mark_buffer_dirty(bh_old);
+	mark_buffer_dirty(bh_new);
 	affs_brelse(bh_old);
 	affs_brelse(bh_new);
 	return retval;
diff --git a/fs/affs/super.c b/fs/affs/super.c
index b232251aa7bb..0ad5127e9fb8 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -108,7 +108,6 @@ static struct inode *affs_alloc_inode(struct super_block *sb)
 	i->i_lc = NULL;
 	i->i_ext_bh = NULL;
 	i->i_pa_cnt = 0;
-	mmb_init(&i->i_metadata_bhs, &i->vfs_inode.i_data);
 
 	return &i->vfs_inode;
 }
-- 
2.51.0


Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DFA3C13E3
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774519086; cv=none; b=fWdihGegYKkLEpw+k3gHWUrR5DxsgTkoglBX1I43UeZFKWY6T4kSUhndZ5dYmd81UDQQ7iMLVmnelDXfwPP9ok8BH1GaoFENcoOCQcPf8Se81OQE707MVkMVDn4HxuEhDBEnSlmfcJTC/A9mKLxpK3xDhwvv2oeoX98hQq9QGkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774519086; c=relaxed/simple;
	bh=LB5f9ZM6VTG6f7M+4eM1ibxL/c9eLkxT6oy6CEVQ+ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jO21ViXZPzhkT3YXzMXgCeWbo/+u74fUWpaig3SvAcQQ0NDrALRP7P/rdDrG6mSEe4T4vd2//48zSfMQzkbgEx//kj1mq9gpbHlJdIW2KjjytC9yqatoUdZBwEoejOQS/xaFsBT9qiwcL77Swag8d0bHrphy70z48CIZ2ixBdkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=k2IXJsi0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+Cu1Sqrs; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=k2IXJsi0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+Cu1Sqrs; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="k2IXJsi0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+Cu1Sqrs";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="k2IXJsi0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+Cu1Sqrs"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BBDDF5BDD3;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7q8Kx1FkVvzvC3Q+vN0M/TZAWD4PkwxVk8bUtCe8P+o=;
	b=k2IXJsi0SUU38wKdBvypl6ZnpttNNVynrB3dl8xeNInC4Con3yagBcilXHWfutQEEJbsMC
	L98tWf6D/jTdUcM9c1tX7bH8gbUF2eeuGhvAXeX7DsfeYoQqqN0sfiYM0AgAlxETMglZWg
	agE7qYC0vhveRgQOY7kAluMopfxQHDs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7q8Kx1FkVvzvC3Q+vN0M/TZAWD4PkwxVk8bUtCe8P+o=;
	b=+Cu1Sqrs9JhQuPOKTkxkGxMDSyqfn0ulyrAC4vq9Q6SIu1uXxzDRpvXlp7Kp2pP2AaLPXE
	PHwbdO3200g7UqDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7q8Kx1FkVvzvC3Q+vN0M/TZAWD4PkwxVk8bUtCe8P+o=;
	b=k2IXJsi0SUU38wKdBvypl6ZnpttNNVynrB3dl8xeNInC4Con3yagBcilXHWfutQEEJbsMC
	L98tWf6D/jTdUcM9c1tX7bH8gbUF2eeuGhvAXeX7DsfeYoQqqN0sfiYM0AgAlxETMglZWg
	agE7qYC0vhveRgQOY7kAluMopfxQHDs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7q8Kx1FkVvzvC3Q+vN0M/TZAWD4PkwxVk8bUtCe8P+o=;
	b=+Cu1Sqrs9JhQuPOKTkxkGxMDSyqfn0ulyrAC4vq9Q6SIu1uXxzDRpvXlp7Kp2pP2AaLPXE
	PHwbdO3200g7UqDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A5F274A0AB;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9gGRKHUCxWkGYQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D678FA0C7F; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-block@vger.kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	<linux-ext4@vger.kernel.org>,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-aio@kvack.org,
	Benjamin LaHaise <bcrl@kvack.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 39/42] minix: Track metadata bhs in fs-private inode part
Date: Thu, 26 Mar 2026 10:54:33 +0100
Message-ID: <20260326095354.16340-81-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4731; i=jack@suse.cz; h=from:subject; bh=LB5f9ZM6VTG6f7M+4eM1ibxL/c9eLkxT6oy6CEVQ+ic=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJTqj+aOzlKcPkCimm7IqpQm2fU61zijKeKW 5HhKtDTckGJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCUwAKCRCcnaoHP2RA 2TCJB/490VA3we2/AivSVCUBWocvHEyG25ixMq2H4qxIqT2Kd/r8p/4yiXj8YEXR3cO4jiD0KX/ pofRf+wwtm3lsZyz4ScERTu11HFuTm40DjhGPiJ24IHIo90+iANsl7fNt777dCSU0VWbJliaWQJ D/QBlJhGbKvE6k1GJEmb1ifthzuddz473YVtw3fBo4dJ9Wfqj6CAiYTyK0iIGI/k48DYVe5ENlk eQ5ILiyrBw/Zz/i+kH2ELXLuvluJKGeLnjQOMG2LtuiSmuWa6N1YDiFL66rlbovT5eMI7EslIZz 67ugOsQXYmuIUBf9i1KIjiefsjCTwrw+vMGNu0WLpksqgJps
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.30
X-Spam-Level: 
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it),to(RLpnp1psq57oqao6ocwdpbxen9)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

Track metadata bhs for an inode in fs-private part of the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/minix/dir.c          |  2 +-
 fs/minix/file.c         | 10 +++++++++-
 fs/minix/inode.c        |  6 ++++--
 fs/minix/itree_common.c | 11 +++++++----
 fs/minix/minix.h        |  3 +++
 5 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index a74d000327fa..361d26d87d2e 100644
--- a/fs/minix/dir.c
+++ b/fs/minix/dir.c
@@ -23,7 +23,7 @@ const struct file_operations minix_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.iterate_shared	= minix_readdir,
-	.fsync		= generic_buffers_fsync,
+	.fsync		= minix_fsync,
 };
 
 /*
diff --git a/fs/minix/file.c b/fs/minix/file.c
index 282b3cd1fea3..86e5943cd2ff 100644
--- a/fs/minix/file.c
+++ b/fs/minix/file.c
@@ -7,8 +7,16 @@
  *  minix regular file handling primitives
  */
 
+#include <linux/buffer_head.h>
 #include "minix.h"
 
+int minix_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	return mmb_fsync(file,
+			&minix_i(file->f_mapping->host)->i_metadata_bhs,
+			start, end, datasync);
+}
+
 /*
  * We have mostly NULLs here: the current defaults are OK for
  * the minix filesystem.
@@ -18,7 +26,7 @@ const struct file_operations minix_file_operations = {
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
 	.mmap_prepare	= generic_file_mmap_prepare,
-	.fsync		= generic_buffers_fsync,
+	.fsync		= minix_fsync,
 	.splice_read	= filemap_splice_read,
 };
 
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index ab7c06efb139..63f378f38d43 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -49,9 +49,9 @@ static void minix_evict_inode(struct inode *inode)
 		inode->i_size = 0;
 		minix_truncate(inode);
 	} else {
-		sync_mapping_buffers(&inode->i_data);
+		mmb_sync(&minix_i(inode)->i_metadata_bhs);
 	}
-	invalidate_inode_buffers(inode);
+	mmb_invalidate(&minix_i(inode)->i_metadata_bhs);
 	clear_inode(inode);
 	if (!inode->i_nlink)
 		minix_free_inode(inode);
@@ -85,6 +85,8 @@ static struct inode *minix_alloc_inode(struct super_block *sb)
 	ei = alloc_inode_sb(sb, minix_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
+	mmb_init(&ei->i_metadata_bhs, &ei->vfs_inode.i_data);
+
 	return &ei->vfs_inode;
 }
 
diff --git a/fs/minix/itree_common.c b/fs/minix/itree_common.c
index dad131e30c05..c3cd2c75af9c 100644
--- a/fs/minix/itree_common.c
+++ b/fs/minix/itree_common.c
@@ -98,7 +98,7 @@ static int alloc_branch(struct inode *inode,
 		*branch[n].p = branch[n].key;
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
-		mark_buffer_dirty_inode(bh, inode);
+		mmb_mark_buffer_dirty(bh, &minix_i(inode)->i_metadata_bhs);
 		parent = nr;
 	}
 	if (n == num)
@@ -135,7 +135,8 @@ static inline int splice_branch(struct inode *inode,
 
 	/* had we spliced it onto indirect block? */
 	if (where->bh)
-		mark_buffer_dirty_inode(where->bh, inode);
+		mmb_mark_buffer_dirty(where->bh,
+				      &minix_i(inode)->i_metadata_bhs);
 
 	mark_inode_dirty(inode);
 	return 0;
@@ -328,14 +329,16 @@ static inline void truncate (struct inode * inode)
 		if (partial == chain)
 			mark_inode_dirty(inode);
 		else
-			mark_buffer_dirty_inode(partial->bh, inode);
+			mmb_mark_buffer_dirty(partial->bh,
+					      &minix_i(inode)->i_metadata_bhs);
 		free_branches(inode, &nr, &nr+1, (chain+n-1) - partial);
 	}
 	/* Clear the ends of indirect blocks on the shared branch */
 	while (partial > chain) {
 		free_branches(inode, partial->p + 1, block_end(partial->bh),
 				(chain+n-1) - partial);
-		mark_buffer_dirty_inode(partial->bh, inode);
+		mmb_mark_buffer_dirty(partial->bh,
+				      &minix_i(inode)->i_metadata_bhs);
 		brelse (partial->bh);
 		partial--;
 	}
diff --git a/fs/minix/minix.h b/fs/minix/minix.h
index 7e1f652f16d3..f2025c9b5825 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -19,6 +19,7 @@ struct minix_inode_info {
 		__u16 i1_data[16];
 		__u32 i2_data[16];
 	} u;
+	struct mapping_metadata_bhs i_metadata_bhs;
 	struct inode vfs_inode;
 };
 
@@ -57,6 +58,8 @@ unsigned long minix_count_free_blocks(struct super_block *sb);
 int minix_getattr(struct mnt_idmap *, const struct path *,
 		struct kstat *, u32, unsigned int);
 int minix_prepare_chunk(struct folio *folio, loff_t pos, unsigned len);
+struct mapping_metadata_bhs *minix_get_metadata_bhs(struct inode *inode);
+int minix_fsync(struct file *file, loff_t start, loff_t end, int datasync);
 
 extern void V1_minix_truncate(struct inode *);
 extern void V2_minix_truncate(struct inode *);
-- 
2.51.0


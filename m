Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1653139A04F
	for <linux-ext4@vger.kernel.org>; Tue,  3 Mar 2026 10:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772534155; cv=none; b=QBDO1Ek70ABmpgWQcJCjJPtBSHgaiPeptVUD0bhU4Qep2w76lIEdHfMC7BNdbnzHDKn2b76La/AnPJuz1nuAgcFsmoV1qnFxBGxxSufkDwiDFVp6sgzJngHwZDhXXOgpTaWXeglZ2cbSsXCsLaikjibyuxCestyPk3P7R2us/v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772534155; c=relaxed/simple;
	bh=Klr3Q6lGdMhw22T2C4rNmSbbaDsuD4ARFy1ctXsRIyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPWbuoL0yXRZMkKSEvHWswxkD9AnGJUCCU6nnxtA15Ipy3oGV2IqywEkBUIpJLYu2YuatSHj8Y/zrBln6SEHWttBAMACcRpX1WXCUm4wWaaieNATFlffKf709oG2nz46sjDb5cDIyOq7dUv0u0WRcQRuxPgTXHlOGtmtZrkUodM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YPNl6puQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MySXVhPw; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YPNl6puQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MySXVhPw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YPNl6puQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MySXVhPw";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YPNl6puQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MySXVhPw"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5CFF65BE2D;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=98i2n81N22OjNxKD8z5Vzb+jgcXij4nWl4IDEvXjQWE=;
	b=YPNl6puQLgVKkD63r6SIjtVutZoZY061kfpbMYqVFc2f7+gRoL4+rtatybiqHH2ejyaFoo
	WYE3oomFZNscJP/Luqkf8x70U1BaM1mbf6S0Z8pM9EeOPMQN5BOU0rsVTwt6pQ7+inpn1b
	YTYnIYofqbTHtHgpXuzz8vGr3O5h47w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=98i2n81N22OjNxKD8z5Vzb+jgcXij4nWl4IDEvXjQWE=;
	b=MySXVhPwE6CN6puHiMqP6OrbSBNSa26DpHC97nbsPILgayNAPBOU/hREv1F29a1de5E9QL
	kHutncMOnjtEoHAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=98i2n81N22OjNxKD8z5Vzb+jgcXij4nWl4IDEvXjQWE=;
	b=YPNl6puQLgVKkD63r6SIjtVutZoZY061kfpbMYqVFc2f7+gRoL4+rtatybiqHH2ejyaFoo
	WYE3oomFZNscJP/Luqkf8x70U1BaM1mbf6S0Z8pM9EeOPMQN5BOU0rsVTwt6pQ7+inpn1b
	YTYnIYofqbTHtHgpXuzz8vGr3O5h47w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=98i2n81N22OjNxKD8z5Vzb+jgcXij4nWl4IDEvXjQWE=;
	b=MySXVhPwE6CN6puHiMqP6OrbSBNSa26DpHC97nbsPILgayNAPBOU/hREv1F29a1de5E9QL
	kHutncMOnjtEoHAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5336D3EA6E;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8T9QFEW5pmmVFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 28334A0B7B; Tue,  3 Mar 2026 11:34:41 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
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
Subject: [PATCH 26/32] fat: Track metadata bhs in fs-private inode part
Date: Tue,  3 Mar 2026 11:34:15 +0100
Message-ID: <20260303103406.4355-58-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3643; i=jack@suse.cz; h=from:subject; bh=Klr3Q6lGdMhw22T2C4rNmSbbaDsuD4ARFy1ctXsRIyk=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprk0Nb8WTsiqrQ3wqnPABtD09KVhX/JnKzkH3 rJjNnj+NYuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5NAAKCRCcnaoHP2RA 2eBUB/9c2t4EJuyg5ObQzoujC/9QbgxvCribk+6P6bTsMxvA37XBmEqV+SkD+FVEUhka6b0j9sg BQDNaItJOfnpGhaxyPNv5cRkSGtAh9a0J2GCubFQo0WoF5ecngxkUDsgnHN6d3j/3CHUtxsvDDf xYVv7/ISwTP1YGY7do1bbUKPFbsIqzt41T0c+ljeZbaDfOXP87RnDKnUtm/bygbnCZoDXmOsLKi oGHLeazAQ+eBGyiUnhxO9VGOdDQdT4QLSQxKNtZbvz0mrfyBBKA3t5x1imOElYSpOGzkEUhMyhb ybtTjz5zMRKRnsf03fWfeNTplX7eKUkP+c0mEDAG/OSot9gr
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,ZenIV.linux.org.uk,vger.kernel.org,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -5.30
X-Spam-Level: 

Track metadata bhs for an inode in fs-private part of the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fat/fat.h         |  2 ++
 fs/fat/file.c        |  1 +
 fs/fat/inode.c       | 12 ++++++++++++
 fs/fat/namei_msdos.c |  1 +
 fs/fat/namei_vfat.c  |  1 +
 5 files changed, 17 insertions(+)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 0d269dba897b..2b2f6ad32f24 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -130,6 +130,7 @@ struct msdos_inode_info {
 	struct hlist_node i_dir_hash;	/* hash by i_logstart */
 	struct rw_semaphore truncate_lock; /* protect bmap against truncate */
 	struct timespec64 i_crtime;	/* File creation (birth) time */
+	struct mapping_metadata_bhs i_metadata_bhs;
 	struct inode vfs_inode;
 };
 
@@ -424,6 +425,7 @@ extern int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de);
 
 extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
 			    struct inode *i2);
+struct mapping_metadata_bhs *fat_get_metadata_bhs(struct inode *inode);
 
 extern const struct fs_parameter_spec fat_param_spec[];
 int fat_init_fs_context(struct fs_context *fc, bool is_vfat);
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 124d9c5431c8..da21636d3874 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -574,4 +574,5 @@ const struct inode_operations fat_file_inode_operations = {
 	.setattr	= fat_setattr,
 	.getattr	= fat_getattr,
 	.update_time	= fat_update_time,
+	.get_metadata_bhs = fat_get_metadata_bhs,
 };
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index ce88602b0d57..8561b8be5ca2 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -763,6 +763,7 @@ static struct inode *fat_alloc_inode(struct super_block *sb)
 	ei->i_pos = 0;
 	ei->i_crtime.tv_sec = 0;
 	ei->i_crtime.tv_nsec = 0;
+	mmb_init(&ei->i_metadata_bhs);
 
 	return &ei->vfs_inode;
 }
@@ -807,6 +808,12 @@ static void __exit fat_destroy_inodecache(void)
 	kmem_cache_destroy(fat_inode_cachep);
 }
 
+struct mapping_metadata_bhs *fat_get_metadata_bhs(struct inode *inode)
+{
+	return &MSDOS_I(inode)->i_metadata_bhs;
+}
+EXPORT_SYMBOL_GPL(fat_get_metadata_bhs);
+
 int fat_reconfigure(struct fs_context *fc)
 {
 	bool new_rdonly;
@@ -1531,6 +1538,10 @@ static int fat_read_static_bpb(struct super_block *sb,
 	return error;
 }
 
+static const struct inode_operations fat_table_inode_operations = {
+	.get_metadata_bhs = fat_get_metadata_bhs,
+};
+
 /*
  * Read the super block of an MS-DOS FS.
  */
@@ -1806,6 +1817,7 @@ int fat_fill_super(struct super_block *sb, struct fs_context *fc,
 	fat_inode = new_inode(sb);
 	if (!fat_inode)
 		goto out_fail;
+	fat_inode->i_op = &fat_table_inode_operations;
 	sbi->fat_inode = fat_inode;
 
 	fsinfo_inode = new_inode(sb);
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index 048c103b506a..1526b8910d51 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -643,6 +643,7 @@ static const struct inode_operations msdos_dir_inode_operations = {
 	.setattr	= fat_setattr,
 	.getattr	= fat_getattr,
 	.update_time	= fat_update_time,
+	.get_metadata_bhs = fat_get_metadata_bhs,
 };
 
 static void setup(struct super_block *sb)
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 87dcdd86272b..ca5e0e9822a6 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -1186,6 +1186,7 @@ static const struct inode_operations vfat_dir_inode_operations = {
 	.setattr	= fat_setattr,
 	.getattr	= fat_getattr,
 	.update_time	= fat_update_time,
+	.get_metadata_bhs = fat_get_metadata_bhs,
 };
 
 static void setup(struct super_block *sb)
-- 
2.51.0


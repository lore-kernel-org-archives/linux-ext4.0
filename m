Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DAA3BED6E
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518933; cv=none; b=MQO2HNMejm8x8IaeEmPIuZ3dfAVNuGLctfh+gvC7ENVnGs+9NQLsXHyrg9K1yZedXLT/5ArB/4h7dzPy0oxVp4ydAO2bW8GiSSSzMzWJ6bPwDp90e0s0Umvg7m1hYkl2x008fMX0/QbhSrx365EN3c7nKj364U0vh6bseMoZcGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518933; c=relaxed/simple;
	bh=fPJkdtE9HIUWD963RofAKXHTr9yY2ungJEXA11VPK4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XH74PGNxeGuw5PKyazjzXU64H+JRctMtd6y5fHtDY0SJLECPofQ7DPd0dWgURI7BkCd4vweIJ8T1/2TiH1+sEj63OZhKnegAypUiSU1DF5t/NAY87nnfg+HmJxB3UUinPspfHyyeZjuKxXSMiTGLda3E4lp8/vWgQK3mdx5k+Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kZE4RrNN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ftluw92P; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kZE4RrNN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ftluw92P; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kZE4RrNN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ftluw92P";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kZE4RrNN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ftluw92P"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2EE2A4D27F;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rW80C6AuNNamkUQ9haKOUGA55hbQ71BVZqxu2HXjQpY=;
	b=kZE4RrNNdLTLuWN5RPCoxgFYXXE9zDXKfCGafFlMmh+Cu8e0Ol+lfoYL75PfV/EAOe/trO
	tgh9xQKddQpLaot8fSgcxmjjPD34PbZZSKwxMNGKur9cUu+nHuRXRijku6eiaxVo2NE6VC
	lJ0rETumkD3FR0Y6tlr+t/13pnqvLgY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rW80C6AuNNamkUQ9haKOUGA55hbQ71BVZqxu2HXjQpY=;
	b=ftluw92PLfQAyjYGTv9/iNz1MGwGCLQvby/dsMa6kTyax8l6sQkvF6htKDRUrw7GRU7YMs
	UH5H4g3kmK5FskAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rW80C6AuNNamkUQ9haKOUGA55hbQ71BVZqxu2HXjQpY=;
	b=kZE4RrNNdLTLuWN5RPCoxgFYXXE9zDXKfCGafFlMmh+Cu8e0Ol+lfoYL75PfV/EAOe/trO
	tgh9xQKddQpLaot8fSgcxmjjPD34PbZZSKwxMNGKur9cUu+nHuRXRijku6eiaxVo2NE6VC
	lJ0rETumkD3FR0Y6tlr+t/13pnqvLgY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rW80C6AuNNamkUQ9haKOUGA55hbQ71BVZqxu2HXjQpY=;
	b=ftluw92PLfQAyjYGTv9/iNz1MGwGCLQvby/dsMa6kTyax8l6sQkvF6htKDRUrw7GRU7YMs
	UH5H4g3kmK5FskAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 225944A0AE;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rhFiCHECxWnDYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E6087A0BC4; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH 14/42] fs: Rename generic_file_fsync() to simple_fsync()
Date: Thu, 26 Mar 2026 10:54:08 +0100
Message-ID: <20260326095354.16340-56-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7169; i=jack@suse.cz; h=from:subject; bh=fPJkdtE9HIUWD963RofAKXHTr9yY2ungJEXA11VPK4c=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI+K+GSrneinOSDRxrfJGqm8QflH7K2MAw1q Oaj6xF4l2iJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCPgAKCRCcnaoHP2RA 2W+wB/98NzHfSwSJB7lub0JKUpOYSs9hmi+KgU8jgNUW4ZNt8Dvov5SZ6Vuf6qZG+36h934dLmb Sx11SvYjaomANJ7bsoYnIpXbQGz99ty0YagA4wCpLsxsMxQgjS9s6KdnSRdR9G+Z5q6bQkx28KJ W5RNJTckz8VLEioNsxnyolpncbHBvBCkMi5jPg3r2aS20eg7OMoR5hQV1iluSy464I1k8KgTBd5 HdRh5ke2sGJjbPtMafeUrh9OvMpDXhc2ojR+mK5EH+KaS5ebyhnJLDhcw+MSCAiYtlyScEJdTSR 6jIkHipx+aSKVmiE1xGHebNSKCzaIUtVaehZIPGtLea3B9al
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
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

The implementation is now really basic so rename generic_file_fsync()
simple_fsync() and __generic_file_fsync() to simple_fsync_noflush().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/adfs/dir.c      |  2 +-
 fs/adfs/file.c     |  2 +-
 fs/exfat/file.c    |  2 +-
 fs/libfs.c         | 26 ++++++++++++--------------
 fs/omfs/file.c     |  2 +-
 fs/qnx4/dir.c      |  2 +-
 fs/qnx6/dir.c      |  2 +-
 fs/ufs/dir.c       |  2 +-
 fs/ufs/file.c      |  2 +-
 include/linux/fs.h |  4 ++--
 10 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/fs/adfs/dir.c b/fs/adfs/dir.c
index 493500f37cb9..b8e23e8124ed 100644
--- a/fs/adfs/dir.c
+++ b/fs/adfs/dir.c
@@ -389,7 +389,7 @@ const struct file_operations adfs_dir_operations = {
 	.read		= generic_read_dir,
 	.llseek		= generic_file_llseek,
 	.iterate_shared	= adfs_iterate,
-	.fsync		= generic_file_fsync,
+	.fsync		= simple_fsync,
 };
 
 static int
diff --git a/fs/adfs/file.c b/fs/adfs/file.c
index cd13165fd904..4a1828b3f88f 100644
--- a/fs/adfs/file.c
+++ b/fs/adfs/file.c
@@ -26,7 +26,7 @@ const struct file_operations adfs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read_iter	= generic_file_read_iter,
 	.mmap_prepare	= generic_file_mmap_prepare,
-	.fsync		= generic_file_fsync,
+	.fsync		= simple_fsync,
 	.write_iter	= generic_file_write_iter,
 	.splice_read	= filemap_splice_read,
 };
diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 90cd540afeaa..4e8d34a75b66 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -577,7 +577,7 @@ int exfat_file_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 	if (unlikely(exfat_forced_shutdown(inode->i_sb)))
 		return -EIO;
 
-	err = __generic_file_fsync(filp, start, end, datasync);
+	err = simple_fsync_noflush(filp, start, end, datasync);
 	if (err)
 		return err;
 
diff --git a/fs/libfs.c b/fs/libfs.c
index e67e43c6509a..327d8108ed9f 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1538,19 +1538,18 @@ struct dentry *generic_fh_to_parent(struct super_block *sb, struct fid *fid,
 EXPORT_SYMBOL_GPL(generic_fh_to_parent);
 
 /**
- * __generic_file_fsync - generic fsync implementation for simple filesystems
+ * simple_fsync_noflush - generic fsync implementation for simple filesystems
  *
  * @file:	file to synchronize
  * @start:	start offset in bytes
  * @end:	end offset in bytes (inclusive)
  * @datasync:	only synchronize essential metadata if true
  *
- * This is a generic implementation of the fsync method for simple
- * filesystems which track all non-inode metadata in the buffers list
- * hanging off the address_space structure.
+ * This function is an fsync handler for simple filesystems. It writes out
+ * dirty data, inode (if dirty), but does not issue a cache flush.
  */
-int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
-				 int datasync)
+int simple_fsync_noflush(struct file *file, loff_t start, loff_t end,
+			 int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	int err;
@@ -1573,30 +1572,29 @@ int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
 		ret = err;
 	return ret;
 }
-EXPORT_SYMBOL(__generic_file_fsync);
+EXPORT_SYMBOL(simple_fsync_noflush);
 
 /**
- * generic_file_fsync - generic fsync implementation for simple filesystems
- *			with flush
+ * simple_fsync - fsync implementation for simple filesystems with flush
  * @file:	file to synchronize
  * @start:	start offset in bytes
  * @end:	end offset in bytes (inclusive)
  * @datasync:	only synchronize essential metadata if true
  *
+ * This function is an fsync handler for simple filesystems. It writes out
+ * dirty data, inode (if dirty), and issues a cache flush.
  */
-
-int generic_file_fsync(struct file *file, loff_t start, loff_t end,
-		       int datasync)
+int simple_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	int err;
 
-	err = __generic_file_fsync(file, start, end, datasync);
+	err = simple_fsync_noflush(file, start, end, datasync);
 	if (err)
 		return err;
 	return blkdev_issue_flush(inode->i_sb->s_bdev);
 }
-EXPORT_SYMBOL(generic_file_fsync);
+EXPORT_SYMBOL(simple_fsync);
 
 /**
  * generic_check_addressable - Check addressability of file system
diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index 49a1de5a827f..28f3b113340e 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -334,7 +334,7 @@ const struct file_operations omfs_file_operations = {
 	.read_iter = generic_file_read_iter,
 	.write_iter = generic_file_write_iter,
 	.mmap_prepare = generic_file_mmap_prepare,
-	.fsync = generic_file_fsync,
+	.fsync = simple_fsync,
 	.splice_read = filemap_splice_read,
 };
 
diff --git a/fs/qnx4/dir.c b/fs/qnx4/dir.c
index 6402715ab377..a9038d231be4 100644
--- a/fs/qnx4/dir.c
+++ b/fs/qnx4/dir.c
@@ -71,7 +71,7 @@ const struct file_operations qnx4_dir_operations =
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.iterate_shared	= qnx4_readdir,
-	.fsync		= generic_file_fsync,
+	.fsync		= simple_fsync,
 	.setlease	= generic_setlease,
 };
 
diff --git a/fs/qnx6/dir.c b/fs/qnx6/dir.c
index ae0c9846833d..135fb42f6936 100644
--- a/fs/qnx6/dir.c
+++ b/fs/qnx6/dir.c
@@ -275,7 +275,7 @@ const struct file_operations qnx6_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.iterate_shared	= qnx6_readdir,
-	.fsync		= generic_file_fsync,
+	.fsync		= simple_fsync,
 	.setlease	= generic_setlease,
 };
 
diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
index 43f1578ab866..f611f965cb96 100644
--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -652,7 +652,7 @@ const struct file_operations ufs_dir_operations = {
 	.release	= ufs_dir_release,
 	.read		= generic_read_dir,
 	.iterate_shared	= ufs_readdir,
-	.fsync		= generic_file_fsync,
+	.fsync		= simple_fsync,
 	.llseek		= ufs_dir_llseek,
 	.setlease	= generic_setlease,
 };
diff --git a/fs/ufs/file.c b/fs/ufs/file.c
index 809c7a4603f8..85c509ced7f9 100644
--- a/fs/ufs/file.c
+++ b/fs/ufs/file.c
@@ -41,7 +41,7 @@ const struct file_operations ufs_file_operations = {
 	.write_iter	= generic_file_write_iter,
 	.mmap_prepare	= generic_file_mmap_prepare,
 	.open           = generic_file_open,
-	.fsync		= generic_file_fsync,
+	.fsync		= simple_fsync,
 	.splice_read	= filemap_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.setlease	= generic_setlease,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8b3dd145b25e..0fc0cb23000e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3295,8 +3295,8 @@ void simple_offset_destroy(struct offset_ctx *octx);
 
 extern const struct file_operations simple_offset_dir_operations;
 
-extern int __generic_file_fsync(struct file *, loff_t, loff_t, int);
-extern int generic_file_fsync(struct file *, loff_t, loff_t, int);
+extern int simple_fsync_noflush(struct file *, loff_t, loff_t, int);
+extern int simple_fsync(struct file *, loff_t, loff_t, int);
 
 extern int generic_check_addressable(unsigned, u64);
 
-- 
2.51.0


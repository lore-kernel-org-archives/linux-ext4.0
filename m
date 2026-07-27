Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB25E3F9F50
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149433; cv=none; b=KVWvpr6mIjZIcWxUyvrXCW1HbXv2o5zOERAZo3Jp+fRaCB7r/tszf0Yx3Cpl1uWDGjap+M+oi1A/SEVIzxhVigerGVt/qgwZClw1ci2k4MZzgC43N26V1bzGCmvMJJQivvhmQG5yFpA+J8i9w3bovb9Qj1r63TRdo+K68/Uytf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149433; c=relaxed/simple;
	bh=g/EjVrCp9qw2a0yhznWwteBPNGlY9a0ZGTPPlFwYf+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8cCYD9gbpxjcp4ABnNHH6S3O3tuBUWJevA7iOTcO/bppyQoBJzw/MDZ7lOcCsUWSd/PHx9TR5PzUYhvKZXEbx5+Ah8lpxJ124kwrrhYXNoiQ0yXtjyO0gBUebiZNvnH5cdr6dF6fAKc90L5YkfFSsVhyHrafXbY2oNFHFIkDqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rwehFvm9; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Wb4bX+8y; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Pn9dgw8r; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=D0kiOET0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rwehFvm9";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Wb4bX+8y";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Pn9dgw8r";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="D0kiOET0"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0D8EA45DD;
	Mon, 27 Jul 2026 10:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1llU44HnO0kmvcexs5uFedunFk2dHCmGlWp7Fe9D+Ps=;
	b=rwehFvm9S50w0opfVzi99aLySfDXb8nvu+dJ/gMGH1v327ZO9+xg2UawU11c6AV7q4bzbE
	XjQLmVpZr1Xbn8khE+dozxlDYlquEwPHnjWdVTnapND/4bcov2SC7p8zrSiqlWqGW6LrBH
	oVpf27a42LUInWYojLiOvxIZyow40cg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149400;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1llU44HnO0kmvcexs5uFedunFk2dHCmGlWp7Fe9D+Ps=;
	b=Wb4bX+8y0lNnRtgHcs3Qgpx+vcU/lIx+7iqiWUht1sTnPhK8SMUaGVlxJlV13mVxTn+gWq
	+4CvYB3+XkxxxwCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Pn9dgw8r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=D0kiOET0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1llU44HnO0kmvcexs5uFedunFk2dHCmGlWp7Fe9D+Ps=;
	b=Pn9dgw8r1y8b85eM8K+03BTljlsclxRMink1OJT/sc0tt98IW2UmDp22mSGFBc+hhp0exQ
	euVn7hGBcHJBk546BYkE5bImI1hIsAfeXMQi6QuVZU+3XvaUl0hATCdIzbQttV2cgExS7e
	w5NdygtJiqxJT8DToI3iSf19xtwVyaI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149396;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1llU44HnO0kmvcexs5uFedunFk2dHCmGlWp7Fe9D+Ps=;
	b=D0kiOET0J0enIBqSOCEaY6gYslg3LMucRfoA6g0179pgdvRhfiKUoNkkd5mRaN0P2nGbWH
	K5qVvVI37+yBcKBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E9FE8779CE;
	Mon, 27 Jul 2026 10:49:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 05AfOcs3Z2oQawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:49:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 40DD2A1325; Mon, 27 Jul 2026 12:49:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v5 05/20] fs: Provide way for filesystem to wait for metadata writeback
Date: Mon, 27 Jul 2026 12:49:23 +0200
Message-ID: <20260727104923.3828017-25-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260727101509.21667-1-jack@suse.cz>
References: <20260727101509.21667-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6951; i=jack@suse.cz; h=from:subject; bh=g/EjVrCp9qw2a0yhznWwteBPNGlY9a0ZGTPPlFwYf+8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqZze2KeF7y8aSoTPEPeOu4SPyLWdHjIDw5EVD5 n/BeOWvQuyJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCamc3tgAKCRCcnaoHP2RA 2UXSB/9Kf6M5ihz5k25OuVcllgAF61ZmpVmMMkD95i/YDvZDEG/44w51r3S9CjhF4YermVFjXpW PgGchmFw1BpnfMSXtU5f+HU3arOXYfLuZXQdxOTwr7uWxjvWoAO6oDWt8beic/luJF3taW6ef9y V7Jw5CZeZt5FYGp+3w06UF29ELodGHdtVBpOCYcXCyTBHK77hYwzzX181PaAsMpy13Dui/SXrDF SZTJUN6Xen5IRXyeRx6dnzBcwoEcWvH3bcNUbO5F6i7A2wJ522EeIVpUCNII/EZYU8gVoug15Mt F4QStFgydvP6GlrRtDmwHDW56lsF4HDZ7YDvBXTze6ksPn+T
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
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
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:mid,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	R_RATELIMIT(0.00)[to_ip_from(RLhafujjw6m7bafrsz8p45s31g)];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 0D8EA45DD
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

Currently, inode and in general metadata writeback is handled in a lazy
manner. When inode is dirty, __writeback_single_inode() calls
.write_inode method which for lots of filesystems just copies inode
metadata into the underlying block buffer. Writeback of other metadata
associated with the inode (as well as buffers underlying inodes) is
usually handled completely separately and implicitely during writeback
of block device inode. This is good for efficiency of WB_SYNC_NONE
writeback or sync(2). However it becomes problematic for situations
where we want to make sure inode and its metadata is really persistent
on disk. fsync(2) is the most pronounced example of this and thus we
have grown a special file operation and various helper functions to
assist with this task. However fsync(2) is not the only case, For
example directories with DIRSYNC flag need similar functionality and
current use of sync_inode_metadata() for this task in filesystems
generally misses writeout of necessary metadata.

Furthermore even fsync(2) handling as implemented by simple_fsync() or
similar helpers is racy and can fail to properly persist the inode. The
problem is that WB_SYNC_NONE writeback can copy inode metadata into
underlying buffer and clean inode dirty bits. Following fsync(2) will
see inode is clean and will fail to make sure underlying buffer is
written out.

When multiple fsync(2) calls race, there's also another type of race
involving mmb_fsync(). There the problem is buffers already submitted to
the disk are no longer tracked in the mmb list and so racing mmb_sync()
can return before all of the IO completes.

Provide a new inode state bit I_METADATA_WRITEBACK tracking whether
writeback of inode related metadata may be needed for successful data
integrity sync and if this bit is set __writeback_single_inode() for
data integrity writeback will call new superblock operation
.sync_inode_metadata whose task is to make sure all metadata associated
with the inode (including the inode itself) is properly persisted. This
will allow filesystems to address the data integrity issues described
above and at the same time somewhat simplify our fsync implementations.
Issues with racing fsync(2) calls will be addressed by synchronization on
I_SYNC inode state which is set while calling .sync_inode_metadata, issues
with missed inode buffer writeback are fixed by filesystems looking up
corresponding buffer head and writing it out if needed.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c              | 33 ++++++++++++++++++++++++++-------
 fs/libfs.c                     |  6 ++++--
 include/linux/fs.h             | 10 +++++++++-
 include/linux/fs/super_types.h |  2 ++
 4 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index fdb8766d275a..9d96357731a3 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1851,6 +1851,22 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 		if (ret == 0)
 			ret = err;
 	}
+
+	/*
+	 * Do we need to wait for inode metadata IO possibly submitted
+	 * by previous WB_SYNC_NONE writeback?
+	 */
+	if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync &&
+	    inode_state_read_once(inode) & I_METADATA_WRITEBACK) {
+		int err;
+
+		spin_lock(&inode->i_lock);
+		inode_state_clear(inode, I_METADATA_WRITEBACK);
+		spin_unlock(&inode->i_lock);
+		err = inode->i_sb->s_op->sync_inode_metadata(inode, wbc);
+		if (ret == 0)
+			ret = err;
+	}
 	wbc->unpinned_netfs_wb = false;
 	trace_writeback_single_inode(inode, wbc, nr_to_write);
 	return ret;
@@ -1892,14 +1908,17 @@ static int writeback_single_inode(struct inode *inode,
 	/*
 	 * If the inode is already fully clean, then there's nothing to do.
 	 *
-	 * For data-integrity syncs we also need to check whether any pages are
-	 * still under writeback, e.g. due to prior WB_SYNC_NONE writeback.  If
-	 * there are any such pages, we'll need to wait for them.
+	 * For data-integrity syncs we also need to check whether any folios or
+	 * metadata are still under writeback, e.g. due to prior WB_SYNC_NONE
+	 * writeback. If there, we'll need to wait for them.
 	 */
-	if (!(inode_state_read(inode) & I_DIRTY_ALL) &&
-	    (wbc->sync_mode != WB_SYNC_ALL ||
-	     !mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK)))
-		goto out;
+	if (!(inode_state_read(inode) & I_DIRTY_ALL)) {
+		if (wbc->sync_mode != WB_SYNC_ALL)
+			goto out;
+		if (!mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK) &&
+		    !(inode_state_read(inode) & I_METADATA_WRITEBACK))
+			goto out;
+	}
 	inode_state_set(inode, I_SYNC);
 	wbc_attach_and_unlock_inode(wbc, inode);
 
diff --git a/fs/libfs.c b/fs/libfs.c
index 57e5971b6331..27d7dc16fcb0 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1559,10 +1559,12 @@ int simple_fsync_noflush(struct file *file, loff_t start, loff_t end,
 	if (err)
 		return err;
 
-	if (!(inode_state_read_once(inode) & (I_DIRTY_ALL | I_SYNC)))
+	if (!(inode_state_read_once(inode) &
+			(I_DIRTY_ALL | I_SYNC | I_METADATA_WRITEBACK)))
 		goto out;
 	if (datasync &&
-	    !(inode_state_read_once(inode) & (I_DIRTY_DATASYNC | I_SYNC)))
+	    !(inode_state_read_once(inode) &
+			(I_DIRTY_DATASYNC | I_SYNC | I_METADATA_WRITEBACK)))
 		goto out;
 
 	ret = sync_inode_metadata(inode, 1);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 50ce731a2b78..729e3cb89e38 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -740,7 +740,8 @@ enum inode_state_flags_enum {
 	I_CREATING		= (1U << 15),
 	I_DONTCACHE		= (1U << 16),
 	I_SYNC_QUEUED		= (1U << 17),
-	I_PINNING_NETFS_WB	= (1U << 18)
+	I_PINNING_NETFS_WB	= (1U << 18),
+	I_METADATA_WRITEBACK	= (1U << 19),
 };
 
 #define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
@@ -2213,6 +2214,13 @@ static inline void mark_inode_dirty_sync(struct inode *inode)
 	__mark_inode_dirty(inode, I_DIRTY_SYNC);
 }
 
+static inline void set_inode_metadata_writeback(struct inode *inode)
+{
+	spin_lock(&inode->i_lock);
+	inode_state_set(inode, I_METADATA_WRITEBACK);
+	spin_unlock(&inode->i_lock);
+}
+
 /*
  * returns the refcount on the inode. it can change arbitrarily.
  */
diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
index ef7941e9dc79..170561e8f2e2 100644
--- a/include/linux/fs/super_types.h
+++ b/include/linux/fs/super_types.h
@@ -86,6 +86,8 @@ struct super_operations {
 	void (*free_inode)(struct inode *inode);
 	void (*dirty_inode)(struct inode *inode, int flags);
 	int (*write_inode)(struct inode *inode, struct writeback_control *wbc);
+	int (*sync_inode_metadata)(struct inode *inode,
+				   struct writeback_control *wbc);
 	int (*drop_inode)(struct inode *inode);
 	void (*evict_inode)(struct inode *inode);
 	void (*put_super)(struct super_block *sb);
-- 
2.51.0


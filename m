Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840913AA1BA
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 18:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783016517; cv=none; b=Zuorygy7KLub97q5hWxojp4mSJ4vOIe5aY9S8hproKNRGXMxBXSAzNKpDOeobbC5ZzTUZEoEZSZTFJ85XdHqW6OdW2EcAVqrpkfCG0k2eXis0M7yqP7LlY6JtVJ6GdUXj1MXxw+BigwBwxau9MgBdggX/lXVJY+AuVCxEMWXGlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783016517; c=relaxed/simple;
	bh=bVc0uxAXasi/pbgM8VsneGMQCbmI++0vB72AZh1sogk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnWQ7JQPe9s4yqV18Tf8JZBAnqUAKn3qGMx03PKAkH5TFZ9ooDrXNfrSdZmomYOXYSepBjsbQyghUps0AstQT184FGpHVQ3v5IJtSOVAbOcL8pTD6h+CxKv3e4glHkDWxyNdMVI9wmNbvpnSqKoV+l1o2DLvzenMIXz8Tc8r3L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0992E760E5;
	Thu,  2 Jul 2026 18:21:21 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E9042779AD;
	Thu,  2 Jul 2026 18:21:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id STDgOCCsRmr6FwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 18:21:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 28E9FA10A9; Thu, 02 Jul 2026 20:21:16 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v3 07/19] fs: Provide way for filesystem to wait for metadata writeback
Date: Thu,  2 Jul 2026 20:21:04 +0200
Message-ID: <20260702182057.2832980-26-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260702175436.12226-1-jack@suse.cz>
References: <20260702175436.12226-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6248; i=jack@suse.cz; h=from:subject; bh=bVc0uxAXasi/pbgM8VsneGMQCbmI++0vB72AZh1sogk=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqRqwOAy5IoZ04RrILdC7DPBvuYZFaSWyYbP2Vh CYuJBrkS2iJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCakasDgAKCRCcnaoHP2RA 2dcKB/4wAAYuR4d+GcAWA99j9H3HEKte7DTMolFsj85H7fNBQ7KT/7EZ72pBMqwkOEgwwZnUECf rTXkK7jU1WBFOt8r3LSSv3cx7s4PA4KJ3BeFwLtG8IVMtcekt3L/uArAHqLnlvu2UvrDxzbSSFJ 3ECRW9drcz17qffKrhiQ8dfVd2Z7FFDFlfDQ9DlG8LleYmtEPa377NSGMKYJ4qbcEmsqH4BWcwL dHbPhhuVRjzWqV9ErlvYPxNlMtkAsdVIrhHHkhpBnNX+KTkPzIBdxKc0F+AZHgTfJjS3Iv/iI0O Yf9xsVuu/SGF4rO6+IrwhRnGJINwYMJimM8EgyXtmJiIVrhW
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Queue-Id: 0992E760E5
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
 include/linux/fs.h             | 10 +++++++++-
 include/linux/fs/super_types.h |  2 ++
 3 files changed, 37 insertions(+), 8 deletions(-)

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
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d10897b3a1e3..b17e0d42071d 100644
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


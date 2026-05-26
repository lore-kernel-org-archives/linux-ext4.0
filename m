Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867823FFACC;
	Tue, 26 May 2026 15:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779808166; cv=none; b=mUGt9ubCa/DwJZ8/T0qGdloV1o5ebhHjvi0mStGp7c9N2uHMsr4p8EqzMwr+ZSEpjIJRuKpmiM94Sl60g2l1tlfLB7FJzOxSN060GFGQzVX9/jhH6BfW6OONMmDWwakOeJ0QGPynONhg4uDIiqWB9Ur5w00GYEgOxeuxY6dYnPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779808166; c=relaxed/simple;
	bh=KOBtZuPTgrJC+dZMhfC91v9mwXHF8GOtBZxrKD5tDKU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LNVKDKwRYW1EG7N+OhxA8TZKHlz0J+8sNi3CxhZ9YEgVAL7gi+fuoIosUJ+hA6v1tPpT9cNBr39V1zJfGrnSahBVcHiukXWyuVzIvkUma2w6oySqtE2GK3CAxo6/U6HK/AZvQSN9tP7iPadpGGIWZ/j8MMNsUQNLa0G7yumVAt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W7COo8zO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W7COo8zO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCF51F000E9;
	Tue, 26 May 2026 15:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779808165;
	bh=lPTSEQkCqju5xOcNWwjQP4gph/sltq+tC4EgXJSVwx4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=W7COo8zOsuc1BUm//6g8aq8Xpgkss8h9nKaCweph+ji1u/q/uKNRwDExO4QZRR4cx
	 MTAa+yPZxIhqvqd3h3ETPiqLuSS5S8++uxtM7s/z9yxzVyTG8iPPQaKKqa9Gy6fWS9
	 ZGgWSgVLLBqfVrCWv8Wxn/loXE0uyDN/IKI+kb8Fk3/rNN+fdlIdTpuvi7NmLlAZvs
	 X4AfH3a5nHyZuL5uRtWFryY72eOKHAmmKlzIcJfb7nfbqkZaoTkGF2J/zR5uat4AI9
	 rNXYkirx/50zR/1ahgy/nwbfBnlYTvQ/Wrw8zekaKPQ6DbEsnTtBtp2py2CvxhoaPj
	 tsPwhSWUWEUaA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 26 May 2026 17:09:05 +0200
Subject: [PATCH 3/8] smb: client: convert cifs_smb3_do_mount() to sget_fc()
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-work-sget-v1-3-263f7025cedd@kernel.org>
References: <20260526-work-sget-v1-0-263f7025cedd@kernel.org>
In-Reply-To: <20260526-work-sget-v1-0-263f7025cedd@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, 
 linux-cifs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-fffa9
X-Developer-Signature: v=1; a=openpgp-sha256; l=7596; i=brauner@kernel.org;
 h=from:subject:message-id; bh=KOBtZuPTgrJC+dZMhfC91v9mwXHF8GOtBZxrKD5tDKU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSJbp/d+uNsuIdar1bs/A09aTbx+qYcCRxsMm9MXKzV9
 E2vX9LuKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmMhSPoZ/9q/nVN57+dbcqeSB
 vuPbDY5W52efmn40nWnf2uvWum2uTxgZ1sbt+K7l8o7x4ZH32otfX088XS3nGTt1XXPLsujdz13
 2cQIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

The CIFS mount path already runs through fs_context: smb3_get_tree()
calls smb3_get_tree_common() with a struct fs_context * in hand. But
the fc is dropped on the way to sget(). Plumb it through to sget_fc()
so the legacy sget() interface can go.

cifs_smb3_do_mount() now takes (struct fs_context *, struct
smb3_fs_context *). The old (fs_type, flags) pair is reconstructed
from fc->fs_type and fc->sb_flags. The flags argument was always
passed as 0 by the sole caller anyway. The cifs_dbg diagnostic now
prints fc->sb_flags directly.

cifs_match_super() and cifs_set_super() were the two void-data
callbacks for sget(). The match callback now takes
(struct super_block *, struct fs_context *) and reads struct
cifs_mnt_data out of fc->sget_key. The set callback is gone entirely:
sget_fc() pre-populates sb->s_fs_info from fc->s_fs_info before
invoking set() so set_anon_super_fc() (which just allocates an anon
bdev) is sufficient.

Before sget_fc() we stash cifs_sb in fc->s_fs_info, the per-mount data
in fc->sget_key and force fc->sb_flags to SB_NODIRATIME | SB_NOATIME
to reproduce the previous hard-coded behaviour (alloc_super() reads
fc->sb_flags). The original sb_flags is saved and restored around the
call so the rest of the mount path sees the same fc semantics as
before.

mnt_data.flags keeps its historical value of 0 so the CIFS_MS_MASK
comparison in compare_mount_options() returns the same (always-equal)
result.

No functional change. With this in place sget() has no remaining CIFS
caller.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/smb/client/cifsfs.c     | 43 ++++++++++++++++++++++++++-----------------
 fs/smb/client/cifsfs.h     |  3 ++-
 fs/smb/client/cifsproto.h  |  3 ++-
 fs/smb/client/connect.c    |  5 +++--
 fs/smb/client/fs_context.c |  2 +-
 5 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 9f76b0347fa9..d5074e3fbb85 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -12,6 +12,7 @@
 
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/fs_context.h>
 #include <linux/filelock.h>
 #include <linux/mount.h>
 #include <linux/slab.h>
@@ -966,26 +967,19 @@ cifs_get_root(struct smb3_fs_context *ctx, struct super_block *sb)
 	return dentry;
 }
 
-static int cifs_set_super(struct super_block *sb, void *data)
-{
-	struct cifs_mnt_data *mnt_data = data;
-	sb->s_fs_info = mnt_data->cifs_sb;
-	return set_anon_super(sb, NULL);
-}
-
 struct dentry *
-cifs_smb3_do_mount(struct file_system_type *fs_type,
-	      int flags, struct smb3_fs_context *old_ctx)
+cifs_smb3_do_mount(struct fs_context *fc, struct smb3_fs_context *old_ctx)
 {
 	struct cifs_mnt_data mnt_data;
 	struct cifs_sb_info *cifs_sb;
 	struct super_block *sb;
 	struct dentry *root;
+	unsigned int saved_sb_flags;
 	int rc;
 
 	if (cifsFYI) {
-		cifs_dbg(FYI, "%s: devname=%s flags=0x%x\n", __func__,
-			 old_ctx->source, flags);
+		cifs_dbg(FYI, "%s: devname=%s sb_flags=0x%x\n", __func__,
+			 old_ctx->source, fc->sb_flags);
 	} else {
 		cifs_info("Attempting to mount %s\n", old_ctx->source);
 	}
@@ -1012,7 +1006,7 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 
 	rc = cifs_mount(cifs_sb, cifs_sb->ctx);
 	if (rc) {
-		if (!(flags & SB_SILENT))
+		if (!(fc->sb_flags & SB_SILENT))
 			cifs_dbg(VFS, "cifs_mount failed w/return code = %d\n",
 				 rc);
 		root = ERR_PTR(rc);
@@ -1021,12 +1015,27 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 
 	mnt_data.ctx = cifs_sb->ctx;
 	mnt_data.cifs_sb = cifs_sb;
-	mnt_data.flags = flags;
+	mnt_data.flags = 0;
 
-	/* BB should we make this contingent on mount parm? */
-	flags |= SB_NODIRATIME | SB_NOATIME;
-
-	sb = sget(fs_type, cifs_match_super, cifs_set_super, flags, &mnt_data);
+	/*
+	 * sb->s_flags is set from fc->sb_flags by alloc_super(). CIFS has
+	 * historically forced SB_NODIRATIME | SB_NOATIME on every mount and
+	 * ignored the caller-supplied SB_* flags. Preserve that behaviour by
+	 * overriding fc->sb_flags around the sget_fc() call.
+	 *
+	 * Hand cifs_sb to sget_fc() via fc->s_fs_info; sget_fc() copies it
+	 * onto sb->s_fs_info before running set() and clears fc->s_fs_info
+	 * on successful publish. Pass the rest of the per-mount context to
+	 * cifs_match_super() through fc->sget_key.
+	 */
+	saved_sb_flags = fc->sb_flags;
+	fc->sb_flags = SB_NODIRATIME | SB_NOATIME;
+	fc->s_fs_info = cifs_sb;
+	fc->sget_key = &mnt_data;
+	sb = sget_fc(fc, cifs_match_super, set_anon_super_fc);
+	fc->sget_key = NULL;
+	fc->s_fs_info = NULL;
+	fc->sb_flags = saved_sb_flags;
 	if (IS_ERR(sb)) {
 		cifs_umount(cifs_sb);
 		return ERR_CAST(sb);
diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index c455b15f2778..0a93f48924a5 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -144,8 +144,9 @@ ssize_t cifs_file_copychunk_range(unsigned int xid, struct file *src_file,
 long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg);
 void cifs_setsize(struct inode *inode, loff_t offset);
 
+struct fs_context;
 struct smb3_fs_context;
-struct dentry *cifs_smb3_do_mount(struct file_system_type *fs_type, int flags,
+struct dentry *cifs_smb3_do_mount(struct fs_context *fc,
 				  struct smb3_fs_context *old_ctx);
 
 char *cifs_silly_fullpath(struct dentry *dentry);
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 4a25afda9448..a39572cbaadb 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -19,6 +19,7 @@
 struct statfs;
 struct smb_rqst;
 struct smb3_fs_context;
+struct fs_context;
 
 /*
  *****************************************************************
@@ -236,7 +237,7 @@ void cifs_mount_put_conns(struct cifs_mount_ctx *mnt_ctx);
 int cifs_mount_get_session(struct cifs_mount_ctx *mnt_ctx);
 int cifs_is_path_remote(struct cifs_mount_ctx *mnt_ctx);
 int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt_ctx);
-int cifs_match_super(struct super_block *sb, void *data);
+int cifs_match_super(struct super_block *sb, struct fs_context *fc);
 int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx);
 void cifs_umount(struct cifs_sb_info *cifs_sb);
 void cifs_mark_open_files_invalid(struct cifs_tcon *tcon);
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index dcde25da468d..79762e6bbe50 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -6,6 +6,7 @@
  *
  */
 #include <linux/fs.h>
+#include <linux/fs_context.h>
 #include <linux/net.h>
 #include <linux/string.h>
 #include <linux/sched/mm.h>
@@ -2991,9 +2992,9 @@ static int match_prepath(struct super_block *sb,
 }
 
 int
-cifs_match_super(struct super_block *sb, void *data)
+cifs_match_super(struct super_block *sb, struct fs_context *fc)
 {
-	struct cifs_mnt_data *mnt_data = data;
+	struct cifs_mnt_data *mnt_data = fc->sget_key;
 	struct smb3_fs_context *ctx;
 	struct cifs_sb_info *cifs_sb;
 	struct TCP_Server_Info *tcp_srv;
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index b9544eb0381b..6aba4e1c9c27 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -920,7 +920,7 @@ static int smb3_get_tree_common(struct fs_context *fc)
 	struct dentry *root;
 	int rc = 0;
 
-	root = cifs_smb3_do_mount(fc->fs_type, 0, ctx);
+	root = cifs_smb3_do_mount(fc, ctx);
 	if (IS_ERR(root))
 		return PTR_ERR(root);
 

-- 
2.47.3


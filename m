From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH 2/5] ext4 : Update low level ext4 journal routines to
 specify gfp_mask for transaction allocation.
Date: Sat, 21 May 2011 19:43:10 -0700
Message-ID: <BANLkTimEpNq5L3p2UsByTMEYG2G2ORA0dw@mail.gmail.com>
References: <BANLkTinfvAXWwjtMnYRBL5JHLmYJGhS-aQ@mail.gmail.com> <20110511160447.GJ5057@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 <linux-ext4@vger.kernel.org>, mkatiyar@gmail.com,
	"Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58687 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab1EVCnb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 May 2011 22:43:31 -0400
Received: by qyg14 with SMTP id 14so2697944qyg.19
        for <linux-ext4@vger.kernel.org>; Sat, 21 May 2011 19:43:30 -0700 (PDT)
In-Reply-To: <20110511160447.GJ5057@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 11, 2011 at 9:04 AM, Jan Kara <jack@suse.cz> wrote:
> On Sun 24-04-11 17:13:18, Manish Katiyar wrote:
>> Update low level ext4 journal routines to pass an extra parameter
>> to journal allocation routines to specify whether transaction alloca=
tion
>> can fail or not. With this patch ext4_journal_start() can fail due t=
o
>> ENOMEM. Added a new interface ext4_journal_start_tryhard() which isn=
't
>> supposed to fail and keep retrying till the allocation succeeds.
> =A0As I wrote in a comment in the comment to the first patch, first j=
ust
> make ext4_journal_start_sb() and similar functions pass false as a pa=
rt of
> the first patch.
>
> Then it would be better to create a new function that passes true - t=
he
> name does not really matter since it will be removed later in the ser=
ies
> but it will help the review process. You can call it
> ext4_journal_start_sb_enomem() or whatever. This way we keep backward
> compatibility because currently all call sites really expect the retr=
y
> behavior.

Hi Jan,

Here is the updated patch incorporating your comments. This adds a new
function ext4_journal_start_failok and updates the ext4 code where we
can fail.

This patch adds a new wrapper ext4_journal_start_failok() which
can fail with -ENOMEM. Update the ext4 code with this, where callers
are ok failing the transaction start.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext4/acl.c         |    6 +++---
 fs/ext4/ext4_jbd2.h   |   10 +++++++++-
 fs/ext4/extents.c     |    2 +-
 fs/ext4/inode.c       |   19 +++++++++++--------
 fs/ext4/ioctl.c       |    4 ++--
 fs/ext4/migrate.c     |    4 ++--
 fs/ext4/move_extent.c |    2 +-
 fs/ext4/namei.c       |   23 +++++++++++++++--------
 fs/ext4/super.c       |   17 ++++++++++++++---
 fs/ext4/xattr.c       |    3 ++-
 fs/jbd2/transaction.c |    4 +++-
 11 files changed, 63 insertions(+), 31 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 21eacd7..cdb1f51 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -350,11 +350,10 @@ ext4_acl_chmod(struct inode *inode)
 		int retries =3D 0;

 	retry:
-		handle =3D ext4_journal_start(inode,
+		handle =3D ext4_journal_start_failok(inode,
 				EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
 		if (IS_ERR(handle)) {
 			error =3D PTR_ERR(handle);
-			ext4_std_error(inode->i_sb, error);
 			goto out;
 		}
 		error =3D ext4_set_acl(handle, inode, ACL_TYPE_ACCESS, clone);
@@ -449,7 +448,8 @@ ext4_xattr_set_acl(struct dentry *dentry, const
char *name, const void *value,
 		acl =3D NULL;

 retry:
-	handle =3D ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_=
sb));
+	handle =3D ext4_journal_start_failok(inode,
+					   EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	error =3D ext4_set_acl(handle, inode, type, acl);
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 0abee1b..eae4c0a 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -161,6 +161,7 @@ int __ext4_handle_dirty_super(const char *where,
unsigned int line,
 #define ext4_handle_dirty_super(handle, sb) \
 	__ext4_handle_dirty_super(__func__, __LINE__, (handle), (sb))

+handle_t *ext4_journal_start_sb_failok(struct super_block *sb, int nbl=
ocks);
 handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks);
 int __ext4_journal_stop(const char *where, unsigned int line,
handle_t *handle);

@@ -202,7 +203,14 @@ static inline int
ext4_handle_has_enough_credits(handle_t *handle, int needed)
 	return 1;
 }

-static inline handle_t *ext4_journal_start(struct inode *inode, int nb=
locks)
+static inline handle_t *ext4_journal_start_failok(struct inode *inode,
+						  int nblocks)
+{
+	return ext4_journal_start_sb_failok(inode->i_sb, nblocks);
+}
+
+static inline handle_t *ext4_journal_start(struct inode *inode,
+						  int nblocks)
 {
 	return ext4_journal_start_sb(inode->i_sb, nblocks);
 }
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4890d6f..5cb3cb2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3685,7 +3685,7 @@ retry:
 	while (ret >=3D 0 && ret < max_blocks) {
 		map.m_lblk =3D map.m_lblk + ret;
 		map.m_len =3D max_blocks =3D max_blocks - ret;
-		handle =3D ext4_journal_start(inode, credits);
+		handle =3D ext4_journal_start_failok(inode, credits);
 		if (IS_ERR(handle)) {
 			ret =3D PTR_ERR(handle);
 			break;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f2fa5e8..f7b2d4d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1624,7 +1624,7 @@ static int ext4_write_begin(struct file *file,
struct address_space *mapping,
 	to =3D from + len;

 retry:
-	handle =3D ext4_journal_start(inode, needed_blocks);
+	handle =3D ext4_journal_start_failok(inode, needed_blocks);
 	if (IS_ERR(handle)) {
 		ret =3D PTR_ERR(handle);
 		goto out;
@@ -3126,7 +3126,7 @@ retry:
 	 * to journalling the i_disksize update if writes to the end
 	 * of file which has an already mapped buffer.
 	 */
-	handle =3D ext4_journal_start(inode, 1);
+	handle =3D ext4_journal_start_failok(inode, 1);
 	if (IS_ERR(handle)) {
 		ret =3D PTR_ERR(handle);
 		goto out;
@@ -3480,7 +3480,7 @@ static ssize_t ext4_ind_direct_IO(int rw, struct
kiocb *iocb,

 		if (final_size > inode->i_size) {
 			/* Credits for sb + inode write */
-			handle =3D ext4_journal_start(inode, 2);
+			handle =3D ext4_journal_start_failok(inode, 2);
 			if (IS_ERR(handle)) {
 				ret =3D PTR_ERR(handle);
 				goto out;
@@ -3523,7 +3523,7 @@ retry:
 		int err;

 		/* Credits for sb + inode write */
-		handle =3D ext4_journal_start(inode, 2);
+		handle =3D ext4_journal_start_failok(inode, 2);
 		if (IS_ERR(handle)) {
 			/* This is really bad luck. We've written the data
 			 * but cannot extend i_size. Bail out and pretend
@@ -5279,8 +5279,9 @@ int ext4_setattr(struct dentry *dentry, struct
iattr *attr)

 		/* (user+group)*(old+new) structure, inode write (sb,
 		 * inode block, ? - but truncate inode update has it) */
-		handle =3D ext4_journal_start(inode, (EXT4_MAXQUOTAS_INIT_BLOCKS(ino=
de->i_sb)+
-					EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3);
+		handle =3D ext4_journal_start_failok(inode,
+					    (EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
+					    EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3);
 		if (IS_ERR(handle)) {
 			error =3D PTR_ERR(handle);
 			goto err_out;
@@ -5315,7 +5316,7 @@ int ext4_setattr(struct dentry *dentry, struct
iattr *attr)
 	     (ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS)))) {
 		handle_t *handle;

-		handle =3D ext4_journal_start(inode, 3);
+		handle =3D ext4_journal_start_failok(inode, 3);
 		if (IS_ERR(handle)) {
 			error =3D PTR_ERR(handle);
 			goto err_out;
@@ -5371,7 +5372,9 @@ int ext4_setattr(struct dentry *dentry, struct
iattr *attr)
 		rc =3D ext4_acl_chmod(inode);

 err_out:
-	ext4_std_error(inode->i_sb, error);
+	if (error !=3D -ENOMEM) {
+		ext4_std_error(inode->i_sb, error);
+	}
 	if (!error)
 		error =3D rc;
 	return error;
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 808c554..4fc2630 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -101,7 +101,7 @@ long ext4_ioctl(struct file *filp, unsigned int
cmd, unsigned long arg)
 		} else if (oldflags & EXT4_EOFBLOCKS_FL)
 			ext4_truncate(inode);

-		handle =3D ext4_journal_start(inode, 1);
+		handle =3D ext4_journal_start_failok(inode, 1);
 		if (IS_ERR(handle)) {
 			err =3D PTR_ERR(handle);
 			goto flags_out;
@@ -157,7 +157,7 @@ flags_out:
 			goto setversion_out;
 		}

-		handle =3D ext4_journal_start(inode, 1);
+		handle =3D ext4_journal_start_failok(inode, 1);
 		if (IS_ERR(handle)) {
 			err =3D PTR_ERR(handle);
 			goto setversion_out;
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 92816b4..8870746 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -484,7 +484,7 @@ int ext4_ext_migrate(struct inode *inode)
 		 */
 		return retval;

-	handle =3D ext4_journal_start(inode,
+	handle =3D ext4_journal_start_failok(inode,
 					EXT4_DATA_TRANS_BLOCKS(inode->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
 					EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)
@@ -533,7 +533,7 @@ int ext4_ext_migrate(struct inode *inode)
 	ext4_set_inode_state(inode, EXT4_STATE_EXT_MIGRATE);
 	up_read((&EXT4_I(inode)->i_data_sem));

-	handle =3D ext4_journal_start(inode, 1);
+	handle =3D ext4_journal_start_failok(inode, 1);
 	if (IS_ERR(handle)) {
 		/*
 		 * It is impossible to update on-disk structures without
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index b9f3e78..3afd60d 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -813,7 +813,7 @@ move_extent_per_page(struct file *o_filp, struct
inode *donor_inode,
 	 * inode and donor_inode may change each different metadata blocks.
 	 */
 	jblocks =3D ext4_writepage_trans_blocks(orig_inode) * 2;
-	handle =3D ext4_journal_start(orig_inode, jblocks);
+	handle =3D ext4_journal_start_failok(orig_inode, jblocks);
 	if (IS_ERR(handle)) {
 		*err =3D PTR_ERR(handle);
 		return 0;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 67fd0b0..0ad321b5 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1738,7 +1738,8 @@ static int ext4_create(struct inode *dir, struct
dentry *dentry, int mode,
 	dquot_initialize(dir);

 retry:
-	handle =3D ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) =
+
+	handle =3D ext4_journal_start_failok(dir,
+					EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
 					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
 	if (IS_ERR(handle))
@@ -1774,7 +1775,8 @@ static int ext4_mknod(struct inode *dir, struct
dentry *dentry,
 	dquot_initialize(dir);

 retry:
-	handle =3D ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) =
+
+	handle =3D ext4_journal_start_failok(dir,
+					EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
 					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
 	if (IS_ERR(handle))
@@ -1813,7 +1815,8 @@ static int ext4_mkdir(struct inode *dir, struct
dentry *dentry, int mode)
 	dquot_initialize(dir);

 retry:
-	handle =3D ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) =
+
+	handle =3D ext4_journal_start_failok(dir,
+					EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
 					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
 	if (IS_ERR(handle))
@@ -2128,7 +2131,8 @@ static int ext4_rmdir(struct inode *dir, struct
dentry *dentry)
 	dquot_initialize(dir);
 	dquot_initialize(dentry->d_inode);

-	handle =3D ext4_journal_start(dir, EXT4_DELETE_TRANS_BLOCKS(dir->i_sb=
));
+	handle =3D ext4_journal_start_failok(dir,
+					EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

@@ -2190,7 +2194,8 @@ static int ext4_unlink(struct inode *dir, struct
dentry *dentry)
 	dquot_initialize(dir);
 	dquot_initialize(dentry->d_inode);

-	handle =3D ext4_journal_start(dir, EXT4_DELETE_TRANS_BLOCKS(dir->i_sb=
));
+	handle =3D ext4_journal_start_failok(dir,
+					EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

@@ -2248,7 +2253,8 @@ static int ext4_symlink(struct inode *dir,
 	dquot_initialize(dir);

 retry:
-	handle =3D ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) =
+
+	handle =3D ext4_journal_start_failok(dir,
+					EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 5 +
 					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
 	if (IS_ERR(handle))
@@ -2308,7 +2314,8 @@ static int ext4_link(struct dentry *old_dentry,
 	dquot_initialize(dir);

 retry:
-	handle =3D ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) =
+
+	handle =3D ext4_journal_start_failok(dir,
+					EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
@@ -2359,7 +2366,7 @@ static int ext4_rename(struct inode *old_dir,
struct dentry *old_dentry,
 	 * in separate transaction */
 	if (new_dentry->d_inode)
 		dquot_initialize(new_dentry->d_inode);
-	handle =3D ext4_journal_start(old_dir, 2 *
+	handle =3D ext4_journal_start_failok(old_dir, 2 *
 					EXT4_DATA_TRANS_BLOCKS(old_dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2);
 	if (IS_ERR(handle))
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4e4c17f..2d57a57 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -247,7 +247,8 @@ static void ext4_put_nojournal(handle_t *handle)
  * ext4 prevents a new handle from being started by s_frozen, which
  * is in an upper layer.
  */
-handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
+static handle_t *ext4_journal_start_sb_int(struct super_block *sb,
+				    	   int nblocks, bool errok)
 {
 	journal_t *journal;
 	handle_t  *handle;
@@ -279,7 +280,17 @@ handle_t *ext4_journal_start_sb(struct
super_block *sb, int nblocks)
 		ext4_abort(sb, "Detected aborted journal");
 		return ERR_PTR(-EROFS);
 	}
-	return jbd2_journal_start(journal, nblocks, false);
+	return jbd2_journal_start(journal, nblocks, errok);
+}
+
+handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
+{
+	return ext4_journal_start_sb_int(sb, nblocks, false);
+}
+
+handle_t *ext4_journal_start_sb_failok(struct super_block *sb, int nbl=
ocks)
+{
+	return ext4_journal_start_sb_int(sb, nblocks, true);
 }

 /*
@@ -4654,7 +4665,7 @@ static int ext4_quota_off(struct super_block
*sb, int type)

 	/* Update modification times of quota files when userspace can
 	 * start looking at them */
-	handle =3D ext4_journal_start(inode, 1);
+	handle =3D ext4_journal_start_failok(inode, 1);
 	if (IS_ERR(handle))
 		goto out;
 	inode->i_mtime =3D inode->i_ctime =3D CURRENT_TIME;
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index b545ca1..a4be614 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1084,7 +1084,8 @@ ext4_xattr_set(struct inode *inode, int
name_index, const char *name,
 	int error, retries =3D 0;

 retry:
-	handle =3D ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_=
sb));
+	handle =3D ext4_journal_start_failok(inode,
+					EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
 	if (IS_ERR(handle)) {
 		error =3D PTR_ERR(handle);
 	} else {
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index b5c2550..3453c29 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -308,6 +308,8 @@ static handle_t *new_handle(int nblocks)
  * handle_t *jbd2_journal_start() - Obtain a new handle.
  * @journal: Journal to start transaction on.
  * @nblocks: number of block buffer we might modify
+ * @errok : True if the transaction allocation can fail
+ *          with ENOMEM.
  *
  * We make sure that the transaction can guarantee at least nblocks of
  * modified buffers in the log.  We block until the log can guarantee
@@ -338,7 +340,7 @@ handle_t *jbd2_journal_start(journal_t *journal,
int nblocks, bool errok)

 	current->journal_info =3D handle;

-	err =3D start_this_handle(journal, handle, GFP_NOFS);
+	err =3D start_this_handle(journal, handle, errok ? GFP_KERNEL : GFP_N=
OFS);
 	if (err < 0) {
 		jbd2_free_handle(handle);
 		current->journal_info =3D NULL;
--=20
1.7.4.1


--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

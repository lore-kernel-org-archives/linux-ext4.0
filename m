From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2] ext3: Add journal error check into ext3_rename()
Date: Tue, 23 Nov 2010 09:58:58 +0200
Message-ID: <AANLkTi=Ve03g026yb_x1VMDcuq4nrppuRcovPvDwHEc8@mail.gmail.com>
References: <1290486633-4534-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52497 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab0KWH67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Nov 2010 02:58:59 -0500
In-Reply-To: <1290486633-4534-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 23, 2010 at 6:30 AM, Namhyung Kim <namhyung@gmail.com> wrot=
e:
> Check return value of ext3_journal_get_write_access() and
> ext3_journal_dirty_metadata().
>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
> =A0fs/ext3/namei.c | =A0 19 +++++++++++++++----
> =A01 files changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index 672cea1..c8415e7 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -2371,7 +2371,9 @@ static int ext3_rename (struct inode * old_dir,=
 struct dentry *old_dentry,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto end_rename;
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUFFER_TRACE(new_bh, "get write access=
");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext3_journal_get_write_access(handle, n=
ew_bh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D ext3_journal_get_write_acces=
s(handle, new_bh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (retval)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto journal_error;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0new_de->inode =3D cpu_to_le32(old_inod=
e->i_ino);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (EXT3_HAS_INCOMPAT_FEATURE(new_dir-=
>i_sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0EXT3_FEATURE_INCOMPAT_FILETYPE))
> @@ -2380,7 +2382,9 @@ static int ext3_rename (struct inode * old_dir,=
 struct dentry *old_dentry,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0new_dir->i_ctime =3D new_dir->i_mtime =
=3D CURRENT_TIME_SEC;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext3_mark_inode_dirty(handle, new_dir)=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUFFER_TRACE(new_bh, "call ext3_journa=
l_dirty_metadata");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext3_journal_dirty_metadata(handle, new=
_bh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D ext3_journal_dirty_metadata(=
handle, new_bh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (retval)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto journal_error;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0brelse(new_bh);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0new_bh =3D NULL;
> =A0 =A0 =A0 =A0}
> @@ -2429,10 +2433,17 @@ static int ext3_rename (struct inode * old_di=
r, struct dentry *old_dentry,
> =A0 =A0 =A0 =A0ext3_update_dx_flag(old_dir);
> =A0 =A0 =A0 =A0if (dir_bh) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUFFER_TRACE(dir_bh, "get_write_access=
");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext3_journal_get_write_access(handle, d=
ir_bh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D ext3_journal_get_write_acces=
s(handle, dir_bh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (retval)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto journal_error;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PARENT_INO(dir_bh->b_data) =3D cpu_to_=
le32(new_dir->i_ino);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUFFER_TRACE(dir_bh, "call ext3_journa=
l_dirty_metadata");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext3_journal_dirty_metadata(handle, dir=
_bh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D ext3_journal_dirty_metadata(=
handle, dir_bh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (retval) {
> +journal_error:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext3_std_error(new_dir-=
>i_sb, retval);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto end_rename;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }


Hi Kim,

A better way to handle this situation is to get_write_access much soone=
r,
when things can still be rolled back properly.
Please find below a patch I am using in next3 to fix some un-handled
journal errors
and see if you can/want to use any of it as reference for your patches.

Amir.


Some places in Ext3 original code don't check for return value of
JBD functions.  Check for snapshot/journal errors in those places.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>

-----------------------------------------------------------------------=
---------
diff -Nuarp a/fs/ext3/balloc.c b/fs/ext3/balloc.c
--- a/fs/ext3/balloc.c  2010-11-23 09:38:13.395922811 +0200
+++ b/fs/ext3/balloc.c  2010-11-23 09:38:13.185923236 +0200
@@ -674,7 +674,9 @@ do_more:

    /* We dirtied the bitmap block */
    BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
-   err =3D ext3_journal_dirty_metadata(handle, bitmap_bh);
+   ret =3D ext3_journal_dirty_metadata(handle, bitmap_bh);
+   if (!err)
+       err =3D ret;

    /* And the group descriptor block */
    BUFFER_TRACE(gd_bh, "dirtied group descriptor block");

diff -Nuarp a/fs/ext3/inode.c b/fs/ext3/inode.c
--- a/fs/ext3/inode.c   2010-11-23 09:38:13.405923214 +0200
+++ b/fs/ext3/inode.c   2010-11-23 09:38:13.195922747 +0200
@@ -2362,6 +2362,9 @@ static void ext3_clear_blocks(handle_t
        if (bh) {
            BUFFER_TRACE(bh, "retaking write access");
            ext3_journal_get_write_access_inode(handle, inode, bh);
+           /* we may have lost write_access on bh */
+           if (is_handle_aborted(handle))
+               return;
        }
    }

@@ -2444,6 +2447,9 @@ static void ext3_free_data(handle_t *ha
                ext3_clear_blocks(handle, inode, this_bh,
                          block_to_free,
                          count, block_to_free_p, p);
+               /* we may have lost write_access on this_bh */
+               if (is_handle_aborted(handle))
+                   return;
                block_to_free =3D nr;
                block_to_free_p =3D p;
                count =3D 1;
@@ -2454,6 +2460,9 @@ static void ext3_free_data(handle_t *ha
    if (count > 0)
        ext3_clear_blocks(handle, inode, this_bh, block_to_free,
                  count, block_to_free_p, p);
+   /* we may have lost write_access on this_bh */
+   if (is_handle_aborted(handle))
+       return;

    if (this_bh) {
        BUFFER_TRACE(this_bh, "call ext3_journal_dirty_metadata");

diff -Nuarp a/fs/ext3/namei.c b/fs/ext3/namei.c
--- a/fs/ext3/namei.c   2010-11-23 09:38:13.415922664 +0200
+++ b/fs/ext3/namei.c   2010-11-23 09:38:13.205923227 +0200
@@ -1649,8 +1649,12 @@ static int ext3_delete_entry (handle_t
        if (!ext3_check_dir_entry("ext3_delete_entry", dir, de, bh, i))
            return -EIO;
        if (de =3D=3D de_del)  {
+           int err;
+
            BUFFER_TRACE(bh, "get_write_access");
-           ext3_journal_get_write_access(handle, bh);
+           err =3D ext3_journal_get_write_access(handle, bh);
+           if (err)
+               return err;
            if (pde)
                pde->rec_len =3D ext3_rec_len_to_disk(
                    ext3_rec_len_from_disk(pde->rec_len) +
@@ -1797,7 +1801,16 @@ retry:
        goto out_stop;
    }
    BUFFER_TRACE(dir_block, "get_write_access");
-   ext3_journal_get_write_access(handle, dir_block);
+   err =3D ext3_journal_get_write_access(handle, dir_block);
+   if (err) {
+       drop_nlink(inode); /* is this nlink =3D=3D 0? */
+       unlock_new_inode(inode);
+       /* no need to check for errors - we failed anyway */
+       (void) ext3_mark_inode_dirty(handle, inode);
+       iput(inode);
+       brelse(dir_block);
+       goto out_stop;
+   }
    de =3D (struct ext3_dir_entry_2 *) dir_block->b_data;
    de->inode =3D cpu_to_le32(inode->i_ino);
    de->name_len =3D 1;

@@ -2337,6 +2350,10 @@ static int ext3_rename (struct inode *
        if (!new_inode && new_dir!=3Dold_dir &&
                new_dir->i_nlink >=3D EXT3_LINK_MAX)
            goto end_rename;
+       BUFFER_TRACE(dir_bh, "get_write_access");
+       retval =3D ext3_journal_get_write_access(handle, dir_bh);
+       if (retval)
+           goto end_rename;
    }
    if (!new_bh) {
        retval =3D ext3_add_entry (handle, new_dentry, old_inode);
@@ -2344,7 +2361,9 @@ static int ext3_rename (struct inode *
            goto end_rename;
    } else {
        BUFFER_TRACE(new_bh, "get write access");
-       ext3_journal_get_write_access(handle, new_bh);
+       retval =3D ext3_journal_get_write_access(handle, new_bh);
+       if (retval)
+           goto end_rename;
        new_de->inode =3D cpu_to_le32(old_inode->i_ino);
        if (EXT3_HAS_INCOMPAT_FEATURE(new_dir->i_sb,
                          EXT3_FEATURE_INCOMPAT_FILETYPE))
@@ -2401,8 +2420,6 @@ static int ext3_rename (struct inode *
    old_dir->i_ctime =3D old_dir->i_mtime =3D CURRENT_TIME_SEC;
    ext3_update_dx_flag(old_dir);
    if (dir_bh) {
-       BUFFER_TRACE(dir_bh, "get_write_access");
-       ext3_journal_get_write_access(handle, dir_bh);
        PARENT_INO(dir_bh->b_data) =3D cpu_to_le32(new_dir->i_ino);
        BUFFER_TRACE(dir_bh, "call ext3_journal_dirty_metadata");
        ext3_journal_dirty_metadata(handle, dir_bh);
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

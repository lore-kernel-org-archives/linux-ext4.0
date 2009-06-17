From: akpm@linux-foundation.org
Subject: [patch 027/133] ext2: Do not update mtime of a moved directory
Date: Wed, 17 Jun 2009 16:26:20 -0700
Message-ID: <200906172326.n5HNQKOY011080@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, jack@suse.cz, hare@suse.de,
	joern@logfs.org, linux-ext4@vger.kernel.org, ronny.pretzsch@dfs.de
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763247AbZFQX1D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jun 2009 19:27:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=46rom: Jan Kara <jack@suse.cz>

One of our users is complaining that his backup tool is upset on ext2
(while it's happy on ext3, xfs, ...) because of the mtime change.

The problem is:

mkdir foo
mkdir bar
mkdir foo/a

Now under ext2:
mv foo/a foo/b

changes mtime of 'foo/a' (foo/b after the move).  That does not really
make sence and it does not happen under any other filesystem I've seen.

More complicated is:
mv foo/a bar/a

This changes mtime of foo/a (bar/a after the move) and it makes some se=
nce
since we had to update parent directory pointer of foo/a. But again, no
other filesystem does this. So after some thoughts I'd vote for consist=
ency
and change ext2 to behave the same as other filesystems.



Do not update mtime of a moved directory.  Specs don't say anything
about it (neither that it should, nor that it should not be updated)
and other common filesystems (ext3, ext4, xfs, reiserfs, fat, ...)
don't do it.  So let's become more consistent.

Spotted by ronny.pretzsch@dfs.de, initial fix by J=F6rn Engel.

Reported-by: <ronny.pretzsch@dfs.de>
Cc: <hare@suse.de>
Cc: J=F6rn Engel <joern@logfs.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/dir.c   |    5 +++--
 fs/ext2/ext2.h  |    2 +-
 fs/ext2/namei.c |    5 +++--
 3 files changed, 7 insertions(+), 5 deletions(-)

diff -puN fs/ext2/dir.c~ext2-do-not-update-mtime-of-a-moved-directory f=
s/ext2/dir.c
--- a/fs/ext2/dir.c~ext2-do-not-update-mtime-of-a-moved-directory
+++ a/fs/ext2/dir.c
@@ -450,7 +450,7 @@ ino_t ext2_inode_by_name(struct inode *d
=20
 /* Releases the page */
 void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
-			struct page *page, struct inode *inode)
+		   struct page *page, struct inode *inode, int update_times)
 {
 	loff_t pos =3D page_offset(page) +
 			(char *) de - (char *) page_address(page);
@@ -465,7 +465,8 @@ void ext2_set_link(struct inode *dir, st
 	ext2_set_de_type(de, inode);
 	err =3D ext2_commit_chunk(page, pos, len);
 	ext2_put_page(page);
-	dir->i_mtime =3D dir->i_ctime =3D CURRENT_TIME_SEC;
+	if (update_times)
+		dir->i_mtime =3D dir->i_ctime =3D CURRENT_TIME_SEC;
 	EXT2_I(dir)->i_flags &=3D ~EXT2_BTREE_FL;
 	mark_inode_dirty(dir);
 }
diff -puN fs/ext2/ext2.h~ext2-do-not-update-mtime-of-a-moved-directory =
fs/ext2/ext2.h
--- a/fs/ext2/ext2.h~ext2-do-not-update-mtime-of-a-moved-directory
+++ a/fs/ext2/ext2.h
@@ -111,7 +111,7 @@ extern struct ext2_dir_entry_2 * ext2_fi
 extern int ext2_delete_entry (struct ext2_dir_entry_2 *, struct page *=
);
 extern int ext2_empty_dir (struct inode *);
 extern struct ext2_dir_entry_2 * ext2_dotdot (struct inode *, struct p=
age **);
-extern void ext2_set_link(struct inode *, struct ext2_dir_entry_2 *, s=
truct page *, struct inode *);
+extern void ext2_set_link(struct inode *, struct ext2_dir_entry_2 *, s=
truct page *, struct inode *, int);
=20
 /* ialloc.c */
 extern struct inode * ext2_new_inode (struct inode *, int);
diff -puN fs/ext2/namei.c~ext2-do-not-update-mtime-of-a-moved-directory=
 fs/ext2/namei.c
--- a/fs/ext2/namei.c~ext2-do-not-update-mtime-of-a-moved-directory
+++ a/fs/ext2/namei.c
@@ -320,7 +320,7 @@ static int ext2_rename (struct inode * o
 		if (!new_de)
 			goto out_dir;
 		inode_inc_link_count(old_inode);
-		ext2_set_link(new_dir, new_de, new_page, old_inode);
+		ext2_set_link(new_dir, new_de, new_page, old_inode, 1);
 		new_inode->i_ctime =3D CURRENT_TIME_SEC;
 		if (dir_de)
 			drop_nlink(new_inode);
@@ -352,7 +352,8 @@ static int ext2_rename (struct inode * o
 	inode_dec_link_count(old_inode);
=20
 	if (dir_de) {
-		ext2_set_link(old_inode, dir_de, dir_page, new_dir);
+		if (old_dir !=3D new_dir)
+			ext2_set_link(old_inode, dir_de, dir_page, new_dir, 0);
 		inode_dec_link_count(old_dir);
 	}
 	return 0;
_
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

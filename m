From: akpm@linux-foundation.org
Subject: + ext2-do-not-update-mtime-of-a-moved-directory.patch added to -mm tree
Date: Fri, 10 Apr 2009 13:55:35 -0700
Message-ID: <200904102055.n3AKtap9016957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jack@suse.cz, hare@suse.de, joern@logfs.org,
	linux-ext4@vger.kernel.org, ronny.pretzsch@dfs.de
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext2: Do not update mtime of a moved directory
has been added to the -mm tree.  Its filename is
     ext2-do-not-update-mtime-of-a-moved-directory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: ext2: Do not update mtime of a moved directory
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
@@ -453,7 +453,7 @@ ino_t ext2_inode_by_name(struct inode *d
=20
 /* Releases the page */
 void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
-			struct page *page, struct inode *inode)
+		   struct page *page, struct inode *inode, int update_times)
 {
 	loff_t pos =3D page_offset(page) +
 			(char *) de - (char *) page_address(page);
@@ -468,7 +468,8 @@ void ext2_set_link(struct inode *dir, st
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
 /* fsync.c */
 extern int ext2_sync_file (struct file *, struct dentry *, int);
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

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
jbd-update-locking-coments.patch
ext2-add-blk_issue_flush-to-syncing-paths.patch
ext2-do-not-update-mtime-of-a-moved-directory.patch
ext2-fix-data-corruption-for-racing-writes.patch
ext3-fix-chain-verification-in-ext3_get_blocks.patch
quota-remove-obsolete-comments-in-fs-quota-makefile.patch
reiser4-update-names-of-quota-methods.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

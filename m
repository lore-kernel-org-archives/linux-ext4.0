From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2: Do not update mtime of a move directory when
	parent has not changed
Date: Fri, 10 Apr 2009 16:13:32 +0200
Message-ID: <20090410141332.GA1127@duck.suse.cz>
References: <1239302492-10455-1-git-send-email-jack@suse.cz> <20090409115132.9f7ccaf0.akpm@linux-foundation.org> <20090409191515.GB3886@duck.suse.cz> <20090409132044.052b40ab.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="r5Pyd7+fXNt84Ff3"
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, ronny.pretzsch@dfs.de, hare@suse.de
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53172 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbZDJONf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Apr 2009 10:13:35 -0400
Content-Disposition: inline
In-Reply-To: <20090409132044.052b40ab.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 09-04-09 13:20:44, Andrew Morton wrote:
> On Thu, 9 Apr 2009 21:15:15 +0200
> Jan Kara <jack@suse.cz> wrote:
> 
> > On Thu 09-04-09 11:51:32, Andrew Morton wrote:
> > > On Thu,  9 Apr 2009 20:41:32 +0200
> > > Jan Kara <jack@suse.cz> wrote:
> > > 
> > > > If the parent of the moved directory has not changed, there's no real
> > > > reason to change mtime. Specs doesn't seem to say anything about this
> > > > particular case and e.g. ext3 does not change mtime in this case.
> > > > So we become a tiny bit more consistent.
> > > > 
> > > > Spotted by ronny.pretzsch@dfs.de, initial fix by J__rn Engel <joern@logfs.org>.
> > > > 
> > > > CC: ronny.pretzsch@dfs.de
> > > > CC: hare@suse.de
> > > > Acked-by: J__rn Engel <joern@logfs.org>
> > > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > > ---
> > > >  fs/ext2/namei.c |    5 ++++-
> > > >  1 files changed, 4 insertions(+), 1 deletions(-)
> > > > 
> > > > diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
> > > > index 90ea179..556f258 100644
> > > > --- a/fs/ext2/namei.c
> > > > +++ b/fs/ext2/namei.c
> > > > @@ -352,7 +352,10 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
> > > >  	inode_dec_link_count(old_inode);
> > > >  
> > > >  	if (dir_de) {
> > > > -		ext2_set_link(old_inode, dir_de, dir_page, new_dir);
> > > > +		/* Set link only if parent has changed and thus avoid setting
> > > > +		 * of mtime of the moved directory on a pure rename. */
> > > > +		if (old_dir != new_dir)
> > > > +			ext2_set_link(old_inode, dir_de, dir_page, new_dir);
> > > >  		inode_dec_link_count(old_dir);
> > > >  	}
> > > >  	return 0;
> > > 
> > > hm, what do other filesystems do?  We risk breaking things in either case.
> > > Probably changing ext2 is safer than changing ext3/4, given that ext2 is
> > > used less.
> >   Yes, I think so as well. Looking more into what other filesystems do, it
> > seems that FAT, UDF, reiserfs, ext3, ext4 actually never update mtime of
> > the moved directory, even if the parent has changed. So maybe it would make
> > more sence to change ext2 in this way as well. What do you think?
> 
> urgh, stop asking difficult questions.
> 
> Given that our behaviour here is basically random, I guess that nobody
> is depending on it much.
  Well, one of our users is complaining that his backup tool is upset on
ext2 (while it's happy on ext3, xfs, ...) because of the mtime change. So
there are some programs checking this. But I don't believe anybody relies
on *ext2* behavior these days...

> Probably bringing everything into line with ext3 behaviour is safest. 
> otoh we want the behaviour to a) be standards compiant and b) make
> sense.
  Definitely.

> What _is_ the behaviour?
> 
> mkdir ./foo
> mv ./foo ./bar
> 
> will update .'s mtime?  If so, that seems correct?
  Yes, it will. The problem is:

mkdir foo
mkdir bar
mkdir foo/a

Now under ext2:
mv foo/a foo/b

changes mtime of 'foo/a' (foo/b after the move). That does not really make
sence and it does not happen under any other filesystem I've seen.

More complicated is:
mv foo/a bar/a

This changes mtime of foo/a (bar/a after the move) and it makes some sence
since we had to update parent directory pointer of foo/a. But again, no
other filesystem does this. So after some thoughts I'd vote for consistency
and change ext2 to behave the same as other filesystems. Patch attached.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--r5Pyd7+fXNt84Ff3
Content-Type: text/x-patch; charset=iso-8859-1
Content-Disposition: attachment; filename="0001-ext2-Do-not-update-mtime-of-a-moved-directory.patch"
Content-Transfer-Encoding: 8bit

>From 29e12aa5d24bde1412d4ab0c7559843d030fd89a Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 9 Apr 2009 16:09:26 +0200
Subject: [PATCH] ext2: Do not update mtime of a moved directory
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Do not update mtime of a moved directory. Specs don't say anything
about it (neither that it should, nor that it should not be updated)
and other common filesystems (ext3, ext4, xfs, reiserfs, fat, ...)
don't do it. So let's become more consistent.

Spotted by ronny.pretzsch@dfs.de, initial fix by Jörn Engel <joern@logfs.org>.

CC: ronny.pretzsch@dfs.de
CC: hare@suse.de
CC: Jörn Engel <joern@logfs.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/dir.c   |    5 +++--
 fs/ext2/ext2.h  |    2 +-
 fs/ext2/namei.c |    5 +++--
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 2999d72..bce9080 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -450,7 +450,7 @@ ino_t ext2_inode_by_name(struct inode *dir, struct qstr *child)
 
 /* Releases the page */
 void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
-			struct page *page, struct inode *inode)
+		   struct page *page, struct inode *inode, int update_times)
 {
 	loff_t pos = page_offset(page) +
 			(char *) de - (char *) page_address(page);
@@ -465,7 +465,8 @@ void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
 	ext2_set_de_type(de, inode);
 	err = ext2_commit_chunk(page, pos, len);
 	ext2_put_page(page);
-	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+	if (update_times)
+		dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
 	EXT2_I(dir)->i_flags &= ~EXT2_BTREE_FL;
 	mark_inode_dirty(dir);
 }
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 3203042..876b637 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -111,7 +111,7 @@ extern struct ext2_dir_entry_2 * ext2_find_entry (struct inode *,struct qstr *,
 extern int ext2_delete_entry (struct ext2_dir_entry_2 *, struct page *);
 extern int ext2_empty_dir (struct inode *);
 extern struct ext2_dir_entry_2 * ext2_dotdot (struct inode *, struct page **);
-extern void ext2_set_link(struct inode *, struct ext2_dir_entry_2 *, struct page *, struct inode *);
+extern void ext2_set_link(struct inode *, struct ext2_dir_entry_2 *, struct page *, struct inode *, int);
 
 /* fsync.c */
 extern int ext2_sync_file (struct file *, struct dentry *, int);
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 90ea179..6524eca 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -320,7 +320,7 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 		if (!new_de)
 			goto out_dir;
 		inode_inc_link_count(old_inode);
-		ext2_set_link(new_dir, new_de, new_page, old_inode);
+		ext2_set_link(new_dir, new_de, new_page, old_inode, 1);
 		new_inode->i_ctime = CURRENT_TIME_SEC;
 		if (dir_de)
 			drop_nlink(new_inode);
@@ -352,7 +352,8 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 	inode_dec_link_count(old_inode);
 
 	if (dir_de) {
-		ext2_set_link(old_inode, dir_de, dir_page, new_dir);
+		if (old_dir != new_dir)
+			ext2_set_link(old_inode, dir_de, dir_page, new_dir, 0);
 		inode_dec_link_count(old_dir);
 	}
 	return 0;
-- 
1.6.0.2


--r5Pyd7+fXNt84Ff3--

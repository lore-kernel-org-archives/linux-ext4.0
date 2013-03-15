From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Ext4:can not rm directories on 2.6.3x
Date: Fri, 15 Mar 2013 10:53:14 -0400
Message-ID: <20130315145314.GB7403@thunk.org>
References: <CAAO_Xo5g2LR54ry=SU7UhGbv-chdkdd6foq+-LjnuE8yAj8ikg@mail.gmail.com>
 <513EDC2B.9020604@gmail.xom>
 <20130312134229.GJ18595@thunk.org>
 <513FF163.7080606@gmail.xom>
 <5142CAE4.3070400@gmail.xom>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Cc: linux-ext4@vger.kernel.org, stable@kernel.org,
	Willy Tarreau <w@1wt.eu>,
	Paul Gortmaker <paul.gortmaker@windriver.com>
To: zhuyj <zyjzyj2000@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53638 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187Ab3COOxW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Mar 2013 10:53:22 -0400
Content-Disposition: inline
In-Reply-To: <5142CAE4.3070400@gmail.xom>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 15, 2013 at 03:16:52PM +0800, zhuyj wrote:
> Hi, all
> 
> The two patches can fix this problem.
> ext4: Fix fs corruption when make_indexed_dir() fails
> ext4: don't dereference null pointer when make_indexed_dir() fails

Thanks, Zhujh for figuring this out.  Those two patches weren't
taggled with cc: stable@vger.kernel.org, but they probably should have
been.  Since they first appeared in v3.0, the two long-term stable
kernels that would benefit with these patches are v3.0.x and v3.2.x.

Willy, Paul, would you consider cherry-picking the following commits
for your respective stable kernels?

git cherry-pick 7ad8e4e6ae2a7c95445ee1715b1714106fb95037
git cherry-pick 6976a6f2acde2b0443cd64f1d08af90630e4ce81

Thanks!!

				- Ted


--pWyiEgJYm5f9v55/
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Fix-fs-corruption-when-make_indexed_dir-fails.patch"

>From 7ad8e4e6ae2a7c95445ee1715b1714106fb95037 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 3 May 2011 11:05:55 -0400
Subject: [PATCH] ext4: Fix fs corruption when make_indexed_dir() fails

When make_indexed_dir() fails (e.g. because of ENOSPC) after it has
allocated block for index tree root, we did not properly mark all
changed buffers dirty.  This lead to only some of these buffers being
written out and thus effectively corrupting the directory.

Fix the issue by marking all changed data dirty even in the error
failure case.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/namei.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 67fd0b0..cadf04b 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1414,9 +1414,19 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	frame->bh = bh;
 	bh = bh2;
 	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
-	dx_release (frames);
-	if (!(de))
+	if (!de) {
+		/*
+		 * Even if the block split failed, we have to properly write
+		 * out all the changes we did so far. Otherwise we can end up
+		 * with corrupted filesystem.
+		 */
+		ext4_mark_inode_dirty(handle, dir);
+		ext4_handle_dirty_metadata(handle, dir, frame->bh);
+		ext4_handle_dirty_metadata(handle, dir, bh);
+		dx_release(frames);
 		return retval;
+	}
+	dx_release(frames);
 
 	retval = add_dirent_to_buf(handle, dentry, inode, de, bh);
 	brelse(bh);
-- 
1.7.12.rc0.22.gcdd159b


--pWyiEgJYm5f9v55/
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-don-t-dereference-null-pointer-when-make_indexe.patch"

>From 6976a6f2acde2b0443cd64f1d08af90630e4ce81 Mon Sep 17 00:00:00 2001
From: Allison Henderson <achender@linux.vnet.ibm.com>
Date: Sun, 15 May 2011 00:19:41 -0400
Subject: [PATCH] ext4: don't dereference null pointer when make_indexed_dir()
 fails

Fix for a null pointer bug found while running punch hole tests

Signed-off-by: Allison Henderson <achender@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/namei.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 3c7a06e..b754b77 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1413,6 +1413,10 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	frame->at = entries;
 	frame->bh = bh;
 	bh = bh2;
+
+	ext4_handle_dirty_metadata(handle, dir, frame->bh);
+	ext4_handle_dirty_metadata(handle, dir, bh);
+
 	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
 	if (!de) {
 		/*
@@ -1421,8 +1425,6 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 		 * with corrupted filesystem.
 		 */
 		ext4_mark_inode_dirty(handle, dir);
-		ext4_handle_dirty_metadata(handle, dir, frame->bh);
-		ext4_handle_dirty_metadata(handle, dir, bh);
 		dx_release(frames);
 		return retval;
 	}
-- 
1.7.12.rc0.22.gcdd159b


--pWyiEgJYm5f9v55/--

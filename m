From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 09/28] libext2fs: handle inline data in dir iterator
 function
Date: Tue, 3 Dec 2013 23:33:20 -0800
Message-ID: <20131204073320.GR9535@birch.djwong.org>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
 <1386072715-9869-10-git-send-email-wenqing.lz@taobao.com>
 <20131203221349.GF9535@birch.djwong.org>
 <20131204045736.GF20409@gmail.com>
 <20131204051025.GF9541@birch.djwong.org>
 <20131204052619.GH20409@gmail.com>
 <20131204060742.GQ9535@birch.djwong.org>
 <20131204062142.GB26103@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51572 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3LDHda (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Dec 2013 02:33:30 -0500
Content-Disposition: inline
In-Reply-To: <20131204062142.GB26103@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 04, 2013 at 02:21:42PM +0800, Zheng Liu wrote:
> On Tue, Dec 03, 2013 at 10:07:42PM -0800, Darrick J. Wong wrote:
> > On Wed, Dec 04, 2013 at 01:26:19PM +0800, Zheng Liu wrote:
> > > On Tue, Dec 03, 2013 at 09:10:25PM -0800, Darrick J. Wong wrote:
> > > > On Wed, Dec 04, 2013 at 12:57:36PM +0800, Zheng Liu wrote:
> > > > > On Tue, Dec 03, 2013 at 02:13:49PM -0800, Darrick J. Wong wrote:
> > > > > > On Tue, Dec 03, 2013 at 08:11:36PM +0800, Zheng Liu wrote:
> > > > > > > From: Zheng Liu <wenqing.lz@taobao.com>
> > > > > > > 
> > > > > > > Inline_data is handled in dir iterator because a lot of commands use
> > > > > > > this function to traverse directory entries in debugfs.  We need to
> > > > > > > handle inline_data individually because inline_data is saved in two
> > > > > > > places.  One is in i_block, and another is in ibody extended attribute.
> > > > > > > 
> > > > > > > After applied this commit, the following commands in debugfs can
> > > > > > > support the inline_data feature:
> > > > > > > 	- cd
> > > > > > > 	- chroot
> > > > > > > 	- link*
> > > > > > > 	- ls
> > > > > > > 	- ncheck
> > > > > > > 	- pwd
> > > > > > > 	- unlink
> > > > > > > 
> > > > > > > * TODO: Inline_data doesn't expand to ibody extended attribute because
> > > > > > >   link command doesn't handle DIR_NO_SPACE error until now.  But if we
> > > > > > >   have already expanded inline data to ibody ea area, link command can
> > > > > > >   occupy this space.
> > > > > > 
> > > > > > A patch for this TODO is coming, right?
> > > > > 
> > > > > TBH, I don't have a patch for this because I don't know why ext2fs_link
> > > > > doesn't handle DIR_NO_SPACE error.  So I will try to fix it later.
> > > > 
> > > > Yeah, it's sort of annoying that it doesn't do that.  You might notice that
> > > > fuse2fs will detect that error code, call ext2fs_expand_dir(), and try again.
> > > > On the other hand, none of the other programs do that...
> > > > 
> > > > ...it's not difficult to change ext2fs_link() to do that, though.
> > > > 
> > > > again:
> > > > 
> > > > /* link_proc magic... */
> > > > 
> > > > if (!ls.done && !not_again) {
> > > > 	ext2fs_expand_dir(fs, dir...);
> > > > 	not_again = 1;
> > > > 	goto again;
> > > > }
> > > > 
> > > > Hmm.  That /is/ easy to fix.  I might as well fix that.
> > > 
> > > I don't think we should fix it in ext2fs_link because I am afraid that
> > > we could break the client that has handled this problem.  So I am plan
> > > to fix it in make_link().  What do you think?
> > 
> > I think the clients will be fine.  Most likely, if the dir can't be expanded,
> > then ext2fs_link will return ext2fs_expand_directory's failure code.
> > 
> > On the off chance there's a weird bug somewhere such that we successfully
> > expand the dir but _link's built-in retry fails again, then the client will see
> > the "no dir space" error, expand the dir (again!), and retry the link, which
> > will again fail.  Assuming the client doesn't madly retry in a loop, all that
> > means is that we bang our heads against the wall a few more times than we need
> > to.
> > 
> > Luckily, most of the _link clients in the e2fsprogs source are too stupid even
> > to expand-and-retry.
> 
> OK.  So let me fix it. :)

Well, I need to fix up fuse2fs too anyway... something like this?

--D

diff --git a/lib/ext2fs/link.c b/lib/ext2fs/link.c
index 09e6cb4..2cbf335 100644
--- a/lib/ext2fs/link.c
+++ b/lib/ext2fs/link.c
@@ -158,12 +158,14 @@ errcode_t ext2fs_link(ext2_filsys fs, ext2_ino_t dir, const char *name,
 	errcode_t		retval;
 	struct link_struct	ls;
 	struct ext2_inode	inode;
+	int			tries = 0;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
 	if (!(fs->flags & EXT2_FLAG_RW))
 		return EXT2_ET_RO_FILSYS;
 
+again:
 	ls.fs = fs;
 	ls.name = name;
 	ls.namelen = name ? strlen(name) : 0;
@@ -181,8 +183,16 @@ errcode_t ext2fs_link(ext2_filsys fs, ext2_ino_t dir, const char *name,
 	if (ls.err)
 		return ls.err;
 
-	if (!ls.done)
-		return EXT2_ET_DIR_NO_SPACE;
+	/* If we didn't find space, expand the dir and try again */
+	if (!ls.done) {
+		if (tries)
+			return EXT2_ET_DIR_NO_SPACE;
+		retval = ext2fs_expand_dir(fs, dir);
+		if (retval)
+			return retval;
+		tries++;
+		goto again;
+	}
 
 	if ((retval = ext2fs_read_inode(fs, dir, &inode)) != 0)
 		return retval;

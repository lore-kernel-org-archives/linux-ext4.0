From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] ext2: Resolve i_nlink race in ext2_rename
Date: Thu, 24 Feb 2011 12:20:10 +0100
Message-ID: <20110224112010.GB23042@quack.suse.cz>
References: <1298528501-32176-1-git-send-email-johunt@akamai.com>
 <20110224063749.GV22723@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
Cc: Josh Hunt <johunt@akamai.com>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, sandeen@redhat.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:43846 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755641Ab1BXLUO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Feb 2011 06:20:14 -0500
Content-Disposition: inline
In-Reply-To: <20110224063749.GV22723@ZenIV.linux.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 24-02-11 06:37:49, Al Viro wrote:
> On Wed, Feb 23, 2011 at 10:21:41PM -0800, Josh Hunt wrote:
> > [resending: left Jan off the original mail by accident]
> > 
> > We have a multi-threaded workload which is currently "losing" files in the form
> > of unattached inodes. The workload is link, rename, unlink intensive. This is
> > happening on an ext2 filesystem and have reproduced the issue in kernel
> > 2.6.37.  Here's a sample strace:
> > 
> >     open("/a/tmp/tmpfile.1296184058", O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 0666) = 9
> >     link("/a/tmp/tmpfile.1296184058", "/a/tmp/tmpfile.28117.1296184059") = 0
> >     rename("/a/tmp/tmpfile.28117.1296184059", "/a/tmp/tmpfile") = 0
> >     stat64("/a/tmp/tmpfile", {st_mode=S_IFREG|0644, st_size=24248267, ...}) = 0
> >     link("/a/tmp/tmpfile", "/a/tmp/submit/tmpfile")        = 0
> >     open("/a/tmp/tmpfile.1296184058", O_RDONLY) = 13
> >     open("/a/tmp/submit/tmpfile.send.q9SNoL", O_RDWR|O_CREAT|O_EXCL, 0600) = 824
> >     rename("/a/tmp/submit/tmpfile", "/a/tmp/submit/tmpfile.send.q9SNoL")                = 0
> >     unlink("/a/tmp/tmpfile.1296184058") = 0
> >     open("/a/tmp/submit/tmpfile.send.q9SNoL", O_RDONLY) = 827
> >     open("/a/tmp/submit/tmpfile.send.q9SNoL", O_RDONLY) = 828
> >     open("/a/tmp/submit/tmpfile.send.q9SNoL", O_RDONLY) = 829
> >     unlink("/a/tmp/submit/tmpfile.send.q9SNoL") = 0
> > 
> > The application behavior shown above repeats indefinitely with most filenames
> > changing during each iteration except for 'tmpfile'. Looking into this issue I
> > see that vfs_rename_other() only takes i_mutex for the new inode and the new
> > inode's directory as well as the old directory's mutex. This works for
> > modifying the dir entry and appears to be fine for most filesystems, but
> > ext2 and a few others (exofs, minix, nilfs2, omfs, sysv, ufs) modify i_nlink
> > inside of their respective rename functions without grabbing the i_mutex. The
> > modifications are done through calls to inode_inc_link_count(old_inode) and
> > inode_dec_link_count(old_inode), etc.
> > 
> > Taking the mutex for the old inode appears to resolve the issue of the
> > lost files/unattached inodes that I am seeing with this workload. I've attached
> > a patch below doing what I've described above. If this is an accepted solution
> > I believe other filesystems may also be affected by this and I could provide
> > a patch for those as well.
> 
> I don't know...  The thing is, we mostly do that to make life easier for
> fsck in case of crash.  Other than that, there's no reason to play with
> link count of that sucker at all.  The question is, do we really want
> such rename() interrupted by dirty shutdown to result in what looks like two
> legitimate links to that inode without any indications of what had happened?
> Note that fsck (at least on ext2) will correct link counts anyway and if
> nothing else, we probably want some noise pointing to the inode in question...
  Yeah, I agree that playing with the link count is not worth it. It is
even more disputable because it would have some reasonable effect only if
we happened to write out the moved inode after it is linked to the new
directory and before it is unlinked from the old one. Moreover we'd need
to writeout the new directory and not the old directory before crash
happens. All this is highly unlikely and even if that happens, it is
questionable whether the result is worth it. So I'll just do away with
those games with link count...
  The patch is attached. Josh, can you test it as well? Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--GvXjxJ+pjyke8COw
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext2-Fix-link-count-corruption-under-heavy-link-rena.patch"

>From 69b42a924bcdbbc68413d9217a4269b9d95d79fc Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 24 Feb 2011 11:48:22 +0100
Subject: [PATCH] ext2: Fix link count corruption under heavy link+rename load

vfs_rename_other() does not lock renamed inode with i_mutex. Thus changing
i_nlink in a non-atomic manner (which happens in ext2_rename()) can corrupt
it as reported and analyzed by Josh.

In fact, there is no good reason to mess with i_nlink of the moved file.
We did it presumably to simulate linking into the new directory and unlinking
from an old one. But the practical effect of this is disputable because fsck
can possibly treat file as being properly linked into both directories without
writing any error which is confusing. So we just stop increment-decrement
games with i_nlink which also fixes the corruption.

CC: Al Viro <viro@ZenIV.linux.org.uk>
Reported-by: Josh Hunt <johunt@akamai.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/namei.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 2e1d834..801a5bf 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -344,7 +344,6 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 		new_de = ext2_find_entry (new_dir, &new_dentry->d_name, &new_page);
 		if (!new_de)
 			goto out_dir;
-		inode_inc_link_count(old_inode);
 		ext2_set_link(new_dir, new_de, new_page, old_inode, 1);
 		new_inode->i_ctime = CURRENT_TIME_SEC;
 		if (dir_de)
@@ -356,12 +355,9 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 			if (new_dir->i_nlink >= EXT2_LINK_MAX)
 				goto out_dir;
 		}
-		inode_inc_link_count(old_inode);
 		err = ext2_add_link(new_dentry, old_inode);
-		if (err) {
-			inode_dec_link_count(old_inode);
+		if (err)
 			goto out_dir;
-		}
 		if (dir_de)
 			inode_inc_link_count(new_dir);
 	}
@@ -374,7 +370,6 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 	old_inode->i_ctime = CURRENT_TIME_SEC;
 
 	ext2_delete_entry (old_de, old_page);
-	inode_dec_link_count(old_inode);
 
 	if (dir_de) {
 		if (old_dir != new_dir)
-- 
1.7.1


--GvXjxJ+pjyke8COw--

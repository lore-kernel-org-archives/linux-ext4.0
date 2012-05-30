From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] vfs: avoid hang caused by attempting to rmdir an
 invalid file system
Date: Wed, 30 May 2012 13:37:09 -0400
Message-ID: <20120530173709.GB16317@fieldses.org>
References: <1338226422-8845-1-git-send-email-tytso@mit.edu>
 <4790434C-0DF2-4186-BE4C-CE97633F107C@dilger.ca>
 <20120528210511.GA5610@thunk.org>
 <20120529195019.GE23991@quack.suse.cz>
 <20120529200856.GF23991@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
	linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@ZenIV.linux.org.uk, sami.liedes@iki.fi
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:38614 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739Ab2E3RhS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 May 2012 13:37:18 -0400
Content-Disposition: inline
In-Reply-To: <20120529200856.GF23991@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 29, 2012 at 10:08:56PM +0200, Jan Kara wrote:
> On Tue 29-05-12 21:50:19, Jan Kara wrote:
> > On Mon 28-05-12 17:05:11, Ted Tso wrote:
> > > On Mon, May 28, 2012 at 02:29:05PM -0600, Andreas Dilger wrote:
> > > > This patch is good from the POV of covering all filesystems, and
> > > > avoiding the deadlock at the dcache level.  It would be possible to
> > > > detect this problem in the filesystem itself during lookup, before
> > > > the bad link got into the dcache itself.  Something like:
> > > 
> > > I like that as a solution for detecting the problem in ext4.  As you
> > > say, it's still an issue for other file systems, and so the patch I
> > > proposed is still probably a good idea for the VFS.  But this way ext4
> > > (and ext3 when Jan backports it) will be able to detect the problem
> > > and mark the file system as being corrupted.
> >   Actually, I think there's even better way. d_splice_alias() can rather
> > easily detect the problem and report it to filesystem. The advantage is
> > that the check in d_splice_alias() can catch any "hardlinks" to
> > directories, not just self loops. The patch is attached, I also have
> > corresponding handling written for ext? filesystems but that's trivial.
> > I'll post the whole series to Al to have a look.
>   And now with the attachment. Sorry.

Well, my understanding of d_splice_alias is that it should just return
the existing dentry instead of failing.  (It does that now for
DISCONNECTED dentries, but I don't understand why they're special.)
So that's what:

	http://git.kernel.org/?p=linux/kernel/git/viro/vfs.git;a=commit;h=9d345b3217b384813680901d42eae3fb380b9f77

does.

--b.

> 
> 								Honza

> >From 0715b656ac88ce1bb62800b14d99ef2e25c26d28 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Tue, 29 May 2012 21:19:01 +0200
> Subject: [PATCH 1/4] vfs: Avoid creation of directory loops for corrupted filesystems
> 
> When a directory hierarchy is corrupted (e. g. due to a bit flip on the media),
> it can happen that it contains loops of directories. That creates possibilities
> for deadlock when locking directories.
> 
> Fix the problem by checking in d_splice_alias() that when we splice a
> directory, it does not have any other connected alias.
> 
> Reported-by: Sami Liedes <sami.liedes@iki.fi>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/dcache.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 4435d8b..ca31a1e 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1658,6 +1658,10 @@ struct dentry *d_splice_alias(struct inode *inode, struct dentry *dentry)
>  			d_move(new, dentry);
>  			iput(inode);
>  		} else {
> +			if (unlikely(!list_empty(&inode->i_dentry))) {
> +				spin_unlock(&inode->i_lock);
> +				return ERR_PTR(-EIO);
> +			}
>  			/* already taking inode->i_lock, so d_add() by hand */
>  			__d_instantiate(dentry, inode);
>  			spin_unlock(&inode->i_lock);
> -- 
> 1.7.1
> 


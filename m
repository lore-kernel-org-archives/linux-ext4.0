From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] ext2: symlink must be handled via filesystem
 specific operation
Date: Mon, 29 Mar 2010 16:26:24 +0200
Message-ID: <20100329142623.GC5835@quack.suse.cz>
References: <1269620996-11400-1-git-send-email-dmonakhov@openvz.org>
 <20100329142135.GB5835@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34488 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab0C2P0K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Mar 2010 11:26:10 -0400
Content-Disposition: inline
In-Reply-To: <20100329142135.GB5835@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 29-03-10 16:21:35, Jan Kara wrote:
> On Fri 26-03-10 19:29:54, Dmitry Monakhov wrote:
> > generic setattr implementation is no longer responsible for
> > quota transfer so synlinks must be handled via ext2_setattr.
>   Ah, good catch. I'll merge ext2 and ext3 patch.
  BTW, you forgot to add your signed-off-by. I'll take the liberty
of adding it but please confirm so that we don't set a bad precedens
(this legal stuff is sensitive...).

 							Honza
> > ---
> >  fs/ext2/symlink.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext2/symlink.c b/fs/ext2/symlink.c
> > index 4e2426e..565cf81 100644
> > --- a/fs/ext2/symlink.c
> > +++ b/fs/ext2/symlink.c
> > @@ -32,6 +32,7 @@ const struct inode_operations ext2_symlink_inode_operations = {
> >  	.readlink	= generic_readlink,
> >  	.follow_link	= page_follow_link_light,
> >  	.put_link	= page_put_link,
> > +	.setattr	= ext2_setattr,
> >  #ifdef CONFIG_EXT2_FS_XATTR
> >  	.setxattr	= generic_setxattr,
> >  	.getxattr	= generic_getxattr,
> > @@ -43,6 +44,7 @@ const struct inode_operations ext2_symlink_inode_operations = {
> >  const struct inode_operations ext2_fast_symlink_inode_operations = {
> >  	.readlink	= generic_readlink,
> >  	.follow_link	= ext2_follow_link,
> > +	.setattr	= ext2_setattr,
> >  #ifdef CONFIG_EXT2_FS_XATTR
> >  	.setxattr	= generic_setxattr,
> >  	.getxattr	= generic_getxattr,
> > -- 
> > 1.6.6.1
> > 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

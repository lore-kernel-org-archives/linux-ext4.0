From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 01/11] ext4: Fix xattr shifting when expanding inodes
Date: Thu, 4 Aug 2016 10:43:55 +0200
Message-ID: <20160804084355.GA6821@quack2.suse.cz>
References: <1470220795-17045-1-git-send-email-jack@suse.cz>
 <1470220795-17045-2-git-send-email-jack@suse.cz>
 <4FEAD03B-D92D-4DB6-8144-9202DE1A9DA9@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756802AbcHDIom (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Aug 2016 04:44:42 -0400
Content-Disposition: inline
In-Reply-To: <4FEAD03B-D92D-4DB6-8144-9202DE1A9DA9@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 03-08-16 17:25:58, Andreas Dilger wrote:
> On Aug 3, 2016, at 4:39 AM, Jan Kara <jack@suse.cz> wrote:
> > 
> > The code in ext4_expand_extra_isize_ea() treated new_extra_isize
> > argument sometimes as the desired target i_extra_isize and sometimes as
> > the amount by which we need to grow current i_extra_isize. These happen
> > to coincide when i_extra_isize is 0 which used to be the common case and
> > so nobody noticed this until recently when we added i_projid to the
> > inode and so i_extra_isize now needs to grow from 28 to 32 bytes.
> > 
> > The result of these bugs was that we sometimes unnecessarily decided to
> > move xattrs out of inode even if there was enough space and we often
> > ended up corrupting in-inode xattrs because arguments to
> > ext4_xattr_shift_entries() were just wrong. This could demonstrate
> > itself as BUG_ON in ext4_xattr_shift_entries() triggering.
> > 
> > Fix the problem by introducing new isize_diff variable and use it where
> > appropriate.
> > 
> > CC: <stable@vger.kernel.org> # 4.4.x-
> > Reported-by: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> > fs/ext4/xattr.c | 27 ++++++++++++++-------------
> > 1 file changed, 14 insertions(+), 13 deletions(-)
> > 
> > diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> > index 39e9cfb1b371..cb1d7b4482de 100644
> > --- a/fs/ext4/xattr.c
> > +++ b/fs/ext4/xattr.c
> > @@ -1353,11 +1353,13 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
> > 	size_t min_offs, free;
> > 	int total_ino;
> > 	void *base, *start, *end;
> > -	int extra_isize = 0, error = 0, tried_min_extra_isize = 0;
> > +	int error = 0, tried_min_extra_isize = 0;
> > 	int s_min_extra_isize = le16_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_min_extra_isize);
> > +	int isize_diff;	/* How much do we need to grow i_extra_isize */
> > 
> > 	down_write(&EXT4_I(inode)->xattr_sem);
> > retry:
> > +	isize_diff = new_extra_isize - EXT4_I(inode)->i_extra_isize;
> > 	if (EXT4_I(inode)->i_extra_isize >= new_extra_isize) {
> 
> Not a big deal, but either the isize_diff calculation could be moved
> after the "if () {}" block, or the condition could be changed to:
> 
> 	if (isize_diff <= 0) {
> 
> since isize_diff is otherwise unused if this condition is true.
> 
> You can add my
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Thanks for review. Yes, my plan was to use isize_diff in couple more places
in the function (including the following condition) but I didn't want to
introduce unnecessary churn in these initial patches for stable kernel. It
seems I forgot to do this in the followup cleanup patches but I guess it's
not worth a respin now. If there are more comments, I'll include this as
well.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

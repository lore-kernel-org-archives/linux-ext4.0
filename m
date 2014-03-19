From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [RFC][PATCH 1/1] ext4: Undelete Feature for Ext4
Date: Wed, 19 Mar 2014 15:59:54 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1403191554270.5960@localhost.localdomain>
References: <1395155384.15587.10.camel@zerobox.home>  <2C2D46FC-AB12-41F2-BF92-427FD5965C26@dilger.ca> <1395237544.15587.15.camel@zerobox.home>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-971071887-1395241197=:5960"
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	vojnar@fit.vutbr.cz
To: Lubos Uhliarik <uhliarik@seznam.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933543AbaCSPjN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Mar 2014 11:39:13 -0400
In-Reply-To: <1395237544.15587.15.camel@zerobox.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-971071887-1395241197=:5960
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 19 Mar 2014, Lubos Uhliarik wrote:

> Date: Wed, 19 Mar 2014 14:59:04 +0100
> From: Lubos Uhliarik <uhliarik@seznam.cz>
> To: Andreas Dilger <adilger@dilger.ca>
> Cc: linux-ext4@vger.kernel.org, vojnar@fit.vutbr.cz, lczerner@redhat.com
> Subject: Re: [RFC][PATCH 1/1] ext4: Undelete Feature for Ext4
> 
> Hi Andreas,
> 
> maybe you didn't notice, but I sent comments in email with subject
> "[RFC][PATCH 0/1] ext4: Undelete Feature for Ext4". Maybe, I should
> mention this in [PATCH 1/1]. In this mail is also link to git repository
> with undelete app (uses ext2fslibs), which demonstrates how to undelete
> file with changes in kernel.

Hi Lubos,

you should definitely put some description into PATCH 1/1 as well -
that's what will eventually end up in the git repository and it
should contain description so that people know what it is all about.

Having e2fsprogs debugfs undelete command is actually a very good
idea. But I think this should be very easy to do with your current
program, or in addition to what you currently have since you're
already using ext2fs library.

Thanks!
-Lukas

> 
> I hope, it will help you.
> 
> Regards,
> 
> Lubos
> 
> Andreas Dilger píše v Út 18. 03. 2014 v 12:23 -0600:
> > On Mar 18, 2014, at 9:09 AM, Lubos Uhliarik <uhliarik@seznam.cz> wrote:
> > > This patch should make undelete process for deleted files under ext4 fs easier.
> > 
> > Hi Lubos,
> > thanks for the interesting patch.  This does seem like an improvement.
> > It would be good to add more description to your commit comment, since
> > it should explain what is actually being done in your patch (e.g. store
> > the extent count and depth in the ext4_extent_header eh_generation field,
> > ...).
> > 
> > It would also be good to include a matching patch for e2fsprogs debugfs
> > in the "undelete" command.  I think one obstacle is the fact that inodes
> > have their blocks zeroed out by the kernel during truncation.  It would
> > be necessary to change the kernel slightly to avoid writing out i_blocks
> > with zero if the inode is being deleted.  Otherwise, this change is not
> > as useful as it could be.
> > 
> > Cheers, Andreas
> > 
> > > Signed-off-by: Lubos Uhliarik <uhliarik@seznam.cz>
> > > ---
> > > fs/ext4/ext4_extents.h | 14 +++++++++++
> > > fs/ext4/extents.c      | 67 +++++++++++++++++++++++++++++++++++++++++++++-----
> > > 2 files changed, 75 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
> > > index 5074fe2..22cf2cd 100644
> > > --- a/fs/ext4/ext4_extents.h
> > > +++ b/fs/ext4/ext4_extents.h
> > > @@ -251,6 +251,20 @@ static inline void ext4_ext_store_pblock(struct ext4_extent *ex,
> > > 				      0xffff);
> > > }
> > > 
> > > +static inline void ext4_ext_store_entries(struct ext4_extent_header *eh,
> > > +					  __u16 eh_entries){
> > > +	eh->eh_generation &= cpu_to_le32((unsigned long) 0x0000ffff);
> > > +	eh->eh_generation |= cpu_to_le32(((unsigned long) (eh_entries) << 16)
> > > +				& 0xffff0000);
> > > +}
> > > +
> > > +static inline void ext4_ext_store_depth(struct ext4_extent_header *eh,
> > > +					 __u16 eh_depth){
> > > +	eh->eh_generation &= cpu_to_le32((unsigned long) 0xffff0000);
> > > +	eh->eh_generation |= cpu_to_le32(((unsigned long) (eh_depth))
> > > +				& 0x0000ffff);
> > > +}
> > > +
> > > /*
> > >  * ext4_idx_store_pblock:
> > >  * stores a large physical block number into an index struct,
> > > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > > index 74bc2d5..f0f3615 100644
> > > --- a/fs/ext4/extents.c
> > > +++ b/fs/ext4/extents.c
> > > @@ -2565,6 +2565,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
> > > 	ext4_lblk_t ex_ee_block;
> > > 	unsigned short ex_ee_len;
> > > 	unsigned uninitialized = 0;
> > > +	unsigned short ex_ee_entries;
> > > 	struct ext4_extent *ex;
> > > 	ext4_fsblk_t pblk;
> > > 
> > > @@ -2584,6 +2585,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
> > > 
> > > 	ex_ee_block = le32_to_cpu(ex->ee_block);
> > > 	ex_ee_len = ext4_ext_get_actual_len(ex);
> > > +	ex_ee_entries = le16_to_cpu(eh->eh_entries);
> > > 
> > > 	trace_ext4_ext_rm_leaf(inode, start, ex, *partial_cluster);
> > > 
> > > @@ -2662,11 +2664,9 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
> > > 		if (err)
> > > 			goto out;
> > > 
> > > -		if (num == 0)
> > > -			/* this extent is removed; mark slot entirely unused */
> > > -			ext4_ext_store_pblock(ex, 0);
> > > +		if (num != 0)
> > > +			ex->ee_len = cpu_to_le16(num);
> > > 
> > > -		ex->ee_len = cpu_to_le16(num);
> > > 		/*
> > > 		 * Do not mark uninitialized if all the blocks in the
> > > 		 * extent have been removed.
> > > @@ -2726,8 +2726,19 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
> > > 
> > > 	/* if this leaf is free, then we should
> > > 	 * remove it from index block above */
> > > -	if (err == 0 && eh->eh_entries == 0 && path[depth].p_bh != NULL)
> > > +	if (err == 0 && eh->eh_entries == 0 && path[depth].p_bh != NULL) {
> > > +		err = ext4_ext_get_access(handle, inode, path + depth);
> > > +		if (err)
> > > +			goto out;
> > > +
> > > +		ext4_ext_store_entries(path[depth].p_hdr, ex_ee_entries);
> > > +
> > > +		err = ext4_ext_dirty(handle, inode, path + depth);
> > > +		if (err)
> > > +			goto out;
> > > +
> > > 		err = ext4_ext_rm_idx(handle, inode, path, depth);
> > > +	}
> > > 
> > > out:
> > > 	return err;
> > > @@ -2760,6 +2771,7 @@ int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
> > > 	struct super_block *sb = inode->i_sb;
> > > 	int depth = ext_depth(inode);
> > > 	struct ext4_ext_path *path = NULL;
> > > +	unsigned short *entries_path = NULL;
> > > 	long long partial_cluster = 0;
> > > 	handle_t *handle;
> > > 	int i = 0, err = 0;
> > > @@ -2864,6 +2876,18 @@ again:
> > > 	}
> > > 	err = 0;
> > > 
> > > +	if (!inode->i_nlink) {
> > > +		entries_path = kzalloc(sizeof(short) * (depth + 1),
> > > +				       GFP_NOFS);
> > > +		if (entries_path == NULL) {
> > > +			kfree(path);
> > > +			ext4_journal_stop(handle);
> > > +			return -ENOMEM;
> > > +		}
> > > +
> > > +		entries_path[0] = le16_to_cpu(ext_inode_hdr(inode)->eh_entries);
> > > +	}
> > > +
> > > 	while (i >= 0 && err == 0) {
> > > 		if (i == depth) {
> > > 			/* this is leaf block */
> > > @@ -2890,6 +2914,10 @@ again:
> > > 			ext_debug("init index ptr: hdr 0x%p, num %d\n",
> > > 				  path[i].p_hdr,
> > > 				  le16_to_cpu(path[i].p_hdr->eh_entries));
> > > +			if (entries_path != NULL) {
> > > +				entries_path[i] = le16_to_cpu(
> > > +					path[i].p_hdr->eh_entries);
> > > +			}
> > > 		} else {
> > > 			/* we were already here, see at next index */
> > > 			path[i].p_idx--;
> > > @@ -2928,10 +2956,24 @@ again:
> > > 		} else {
> > > 			/* we finished processing this index, go up */
> > > 			if (path[i].p_hdr->eh_entries == 0 && i > 0) {
> > > +				if (entries_path != NULL) {
> > > +					err = ext4_ext_get_access(handle,
> > > +						inode, path);
> > > +					if (err == 0) {
> > > +						ext4_ext_store_entries(
> > > +							path[i].p_hdr,
> > > +							(entries_path[i]));
> > > +						err = ext4_ext_dirty(handle,
> > > +							inode, path);
> > > +					}
> > > +				}
> > > +
> > > 				/* index is empty, remove it;
> > > 				 * handle must be already prepared by the
> > > 				 * truncatei_leaf() */
> > > -				err = ext4_ext_rm_idx(handle, inode, path, i);
> > > +				if (err == 0)
> > > +					err = ext4_ext_rm_idx(handle, inode,
> > > +						path, i);
> > > 			}
> > > 			/* root level has p_bh == NULL, brelse() eats this */
> > > 			brelse(path[i].p_bh);
> > > @@ -2964,6 +3006,17 @@ again:
> > > 		 */
> > > 		err = ext4_ext_get_access(handle, inode, path);
> > > 		if (err == 0) {
> > > +			/* Store depth and entries to eh_generation to make
> > > +			 * recovering deleted files easier. */
> > > +			if (entries_path != NULL) {
> > > +				ext4_ext_store_entries(ext_inode_hdr(inode),
> > > +					(entries_path[0]));
> > > +
> > > +				ext4_ext_store_depth(ext_inode_hdr(inode),
> > > +					le16_to_cpu(
> > > +					ext_inode_hdr(inode)->eh_depth));
> > > +			}
> > > +
> > > 			ext_inode_hdr(inode)->eh_depth = 0;
> > > 			ext_inode_hdr(inode)->eh_max =
> > > 				cpu_to_le16(ext4_ext_space_root(inode, 0));
> > > @@ -2973,6 +3026,8 @@ again:
> > > out:
> > > 	ext4_ext_drop_refs(path);
> > > 	kfree(path);
> > > +	kfree(entries_path);
> > > +
> > > 	if (err == -EAGAIN) {
> > > 		path = NULL;
> > > 		goto again;
> > > -- 
> > > 1.8.3.2
> > > 
> > > 
> > > 
> > > 
> > > 
> > > 
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> > Cheers, Andreas
> > 
> > 
> > 
> > 
> > 
> 
> 
> 
--8323328-971071887-1395241197=:5960--

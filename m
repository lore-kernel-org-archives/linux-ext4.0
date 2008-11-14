From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: [RFC PATCH 13/17] Support 48-bit file acl blocks
Date: Thu, 13 Nov 2008 21:30:22 -0500
Message-ID: <20081114023022.GA20637@shell>
References: <1226461390-5502-6-git-send-email-vaurora@redhat.com> <1226461390-5502-7-git-send-email-vaurora@redhat.com> <1226461390-5502-8-git-send-email-vaurora@redhat.com> <1226461390-5502-9-git-send-email-vaurora@redhat.com> <1226461390-5502-10-git-send-email-vaurora@redhat.com> <1226461390-5502-11-git-send-email-vaurora@redhat.com> <1226461390-5502-12-git-send-email-vaurora@redhat.com> <1226461390-5502-13-git-send-email-vaurora@redhat.com> <1226461390-5502-14-git-send-email-vaurora@redhat.com> <20081113201109.GX16005@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbYKNCaZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Nov 2008 21:30:25 -0500
Content-Disposition: inline
In-Reply-To: <20081113201109.GX16005@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 13, 2008 at 01:14:50PM -0700, Andreas Dilger wrote:
> On Nov 11, 2008  19:43 -0800, Valerie Aurora Henson wrote:
> > @@ -82,8 +82,8 @@ struct dup_inode {
> >  	struct block_el		*block_list;
> >  };
> >  
> > -static int process_pass1b_block(ext2_filsys fs, blk_t	*blocknr,
> > -				e2_blkcnt_t blockcnt, blk_t ref_blk,
> > +static int process_pass1b_block(ext2_filsys fs, blk64_t	*blocknr,
> > +				e2_blkcnt_t blockcnt, blk64_t ref_blk,
> >  				int ref_offset, void *priv_data);
> >  static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
> >  			struct dup_inode *dp, char *block_buf);
> > @@ -293,12 +293,15 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
> > -			pctx.errcode = ext2fs_block_iterate2(fs, ino,
> > +			pctx.errcode = ext2fs_block_iterate3(fs, ino,
> >  					     BLOCK_FLAG_READ_ONLY, block_buf,
> >  					     process_pass1b_block, &pb);
> 
> Several of these changes should probably be part of the previous patch,
> since they are not really related to ACLs.

I'll go back and look at that, but in general it's hard to transition
from ext2fs_block_iterate2() ext2fs_block_iterate3() independently
because the iterate function has to convert to 64-bit at the same time
(or else you have to write complex and ugly glue code which lives for
exactly one revision).

> > + * XXX Ignoring 64-bit file system flag - most places where this is
> > + * called don't have access to the fs struct, and the high bits should
> > + * be 0 in the non-64-bit case anyway.
> > + */
> > +blk64_t ext2fs_file_acl_block(const struct ext2_inode *inode)
> > +{
> > +	return (inode->i_file_acl |
> > +		(__u64) inode->osd2.linux2.l_i_file_acl_high << 32);
> > +}
> > +
> > +/*
> > + * Set the acl block of a file
> > + */
> > +void ext2fs_file_acl_block_set(struct ext2_inode *inode, blk64_t blk)
> > +{
> > +	inode->i_file_acl = blk;
> > +	inode->osd2.linux2.l_i_file_acl_high = (__u64) blk >> 32;
> > +}
> 
> Does e2fsck validate the ACL block number is within the filesystem
> limits when it is checking the filesystem?

Yes, in check_ext_attr() in pass1.c (and in process_bad_inode() in
pass2.c).

> > diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> > index d7d7bdb..3fa7555 100644
> > --- a/lib/ext2fs/ext2_fs.h
> > +++ b/lib/ext2fs/ext2_fs.h
> > @@ -343,7 +343,7 @@ struct ext2_inode {
> > -	__u32	i_dir_acl;	/* Directory ACL */
> > +	__u32	i_size_high;	/* Formerly i_dir_acl, directory ACL */
> >  	__u32	i_faddr;	/* Fragment address */
> >  	union {
> >  		struct {
> > @@ -390,7 +390,7 @@ struct ext2_inode_large {
> > -	__u32	i_dir_acl;	/* Directory ACL */
> > +	__u32	i_size_high;	/* Formerly i_dir_acl, directory ACL */
> > @@ -419,7 +419,7 @@ struct ext2_inode_large {
> > -#define i_size_high	i_dir_acl
> > +#define i_dir_acl	i_size_high
> 
> These changes should be landed upstream directly, independent of this patch.

Fine by me.  I'll include them with your "*_lo" rename suggestions if
Ted agrees.

-VAL

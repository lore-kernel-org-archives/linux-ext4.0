From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v1 03/22] libext2fs: add functions to operate on extended
 attribute
Date: Sat, 12 Oct 2013 16:41:11 +0800
Message-ID: <20131012084111.GF6462@gmail.com>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-4-git-send-email-wenqing.lz@taobao.com>
 <20131011225115.GA20432@birch.djwong.org>
 <20131012055154.GA6377@gmail.com>
 <20131012083200.GD14971@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Theodore Ts'o <tytso@mit.edu>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:39004 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3JLIjS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Oct 2013 04:39:18 -0400
Received: by mail-pa0-f49.google.com with SMTP id ld10so5427992pab.22
        for <linux-ext4@vger.kernel.org>; Sat, 12 Oct 2013 01:39:18 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20131012083200.GD14971@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 12, 2013 at 01:32:00AM -0700, Darrick J. Wong wrote:
> On Sat, Oct 12, 2013 at 01:51:54PM +0800, Zheng Liu wrote:
> > On Fri, Oct 11, 2013 at 03:51:15PM -0700, Darrick J. Wong wrote:
> > > On Fri, Aug 02, 2013 at 05:49:30PM +0800, Zheng Liu wrote:
> > > > From: Zheng Liu <wenqing.lz@taobao.com>
> > > > 
> > > > We need to define some functions to operate extended attribute in order
> > > > to support inline data.
> > > > 
> > > > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > > > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > > > ---
> > > >  lib/ext2fs/ext2_err.et.in  |    3 +
> > > >  lib/ext2fs/ext2_ext_attr.h |   31 ++++++++
> > > >  lib/ext2fs/ext2fs.h        |    9 +++
> > > >  lib/ext2fs/ext_attr.c      |  186 ++++++++++++++++++++++++++++++++++++++++++++
> > > >  4 files changed, 229 insertions(+)
> > > > 
> > > > diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
> > > > index d20c6b7..7e6d6e5 100644
> > > > --- a/lib/ext2fs/ext2_err.et.in
> > > > +++ b/lib/ext2fs/ext2_err.et.in
> > > > @@ -476,4 +476,7 @@ ec	EXT2_ET_MMP_CSUM_INVALID,
> > > >  ec	EXT2_ET_FILE_EXISTS,
> > > >  	"Ext2 file already exists"
> > > >  
> > > > +ec	EXT2_ET_EXT_ATTR_CURRUPTED,
> > > > +	"Extended attribute currupted"
> > > > +
> > > >  	end
> > > > diff --git a/lib/ext2fs/ext2_ext_attr.h b/lib/ext2fs/ext2_ext_attr.h
> > > > index bbb0aaa..99ad849 100644
> > > > --- a/lib/ext2fs/ext2_ext_attr.h
> > > > +++ b/lib/ext2fs/ext2_ext_attr.h
> > > > @@ -15,6 +15,10 @@
> > > >  /* Maximum number of references to one attribute block */
> > > >  #define EXT2_EXT_ATTR_REFCOUNT_MAX	1024
> > > >  
> > > > +/* Name indexes */
> > > > +#define EXT4_EXT_ATTR_INDEX_SYSTEM	7
> > > > +#define EXT4_EXT_ATTR_SYSTEM_DATA	"data"
> > > > +
> > > >  struct ext2_ext_attr_header {
> > > >  	__u32	h_magic;	/* magic number for identification */
> > > >  	__u32	h_refcount;	/* reference count */
> > > > @@ -25,6 +29,10 @@ struct ext2_ext_attr_header {
> > > >  	__u32	h_reserved[3];	/* zero right now */
> > > >  };
> > > >  
> > > > +struct ext2_ext_attr_ibody_header {
> > > > +	__u32	h_magic;
> > > > +};
> > > > +
> > > >  struct ext2_ext_attr_entry {
> > > >  	__u8	e_name_len;	/* length of name */
> > > >  	__u8	e_name_index;	/* attribute name index */
> > > > @@ -57,6 +65,29 @@ struct ext2_ext_attr_entry {
> > > >  #define EXT2_XATTR_SIZE(size) \
> > > >  	(((size) + EXT2_EXT_ATTR_ROUND) & ~EXT2_EXT_ATTR_ROUND)
> > > >  
> > > > +#define IHDR(inode) \
> > > > +	((struct ext2_ext_attr_ibody_header *) \
> > > > +		((char *)inode + \
> > > > +		EXT2_GOOD_OLD_INODE_SIZE + \
> > > > +		inode->i_extra_isize))
> > > > +#define IFIRST(hdr) ((struct ext2_ext_attr_entry *)((hdr)+1))
> > > > +#define EXT2_ZERO_EXT_ATTR_VALUE ((void *)-1)
> > > > +
> > > > +struct ext2_ext_attr_info {
> > > > +	int name_index;
> > > > +	const char *name;
> > > > +	const void *value;
> > > > +	size_t value_len;
> > > > +};
> > > > +
> > > > +struct ext2_ext_attr_search {
> > > > +	struct ext2_ext_attr_entry *first;
> > > > +	void *base;
> > > > +	void *end;
> > > > +	struct ext2_ext_attr_entry *here;
> > > > +	int not_found;
> > > > +};
> > > > +
> > > >  #ifdef __KERNEL__
> > > >  # ifdef CONFIG_EXT2_FS_EXT_ATTR
> > > >  extern int ext2_get_ext_attr(struct inode *, const char *, char *, size_t, int);
> > > > diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> > > > index 3346c00..8c30197 100644
> > > > --- a/lib/ext2fs/ext2fs.h
> > > > +++ b/lib/ext2fs/ext2fs.h
> > > > @@ -1136,6 +1136,15 @@ extern errcode_t ext2fs_adjust_ea_refcount3(ext2_filsys fs, blk64_t blk,
> > > >  					   char *block_buf,
> > > >  					   int adjust, __u32 *newcount,
> > > >  					   ext2_ino_t inum);
> > > > +extern errcode_t ext2fs_ext_attr_ibody_find(ext2_filsys fs,
> > > > +					    struct ext2_inode_large *inode,
> > > > +					    struct ext2_ext_attr_info *i,
> > > > +					    struct ext2_ext_attr_search *s);
> > > > +extern errcode_t ext2fs_ext_attr_find_entry(struct ext2_ext_attr_entry **pentry,
> > > > +					    int name_index, const char *name,
> > > > +					    size_t size, int sorted);
> > > > +extern errcode_t ext2fs_ext_attr_set_entry(struct ext2_ext_attr_info *i,
> > > > +					   struct ext2_ext_attr_search *s);
> > > >  
> > > >  /* extent.c */
> > > >  extern errcode_t ext2fs_extent_header_verify(void *ptr, int size);
> > > > diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
> > > > index 9649a14..6d55340 100644
> > > > --- a/lib/ext2fs/ext_attr.c
> > > > +++ b/lib/ext2fs/ext_attr.c
> > > > @@ -186,3 +186,189 @@ errcode_t ext2fs_adjust_ea_refcount(ext2_filsys fs, blk_t blk,
> > > >  	return ext2fs_adjust_ea_refcount2(fs, blk, block_buf, adjust,
> > > >  					  newcount);
> > > >  }
> > > > +
> > > > +static errcode_t
> > > > +ext2fs_ext_attr_check_names(struct ext2_ext_attr_entry *entry, void *end)
> > > > +{
> > > > +	while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
> > > > +		struct ext2_ext_attr_entry *next = EXT2_EXT_ATTR_NEXT(entry);
> > > > +		if ((void *)next >= end)
> > > > +			return EXT2_ET_EXT_ATTR_CURRUPTED;
> > > > +		entry = next;
> > > > +	}
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static inline errcode_t
> > > > +ext2fs_ext_attr_check_entry(struct ext2_ext_attr_entry *entry, size_t size)
> > > > +{
> > > > +	size_t value_size = entry->e_value_size;
> > > > +
> > > > +	if (entry->e_value_block != 0 || value_size > size ||
> > > > +	    entry->e_value_offs + value_size > size)
> > > > +		return EXT2_ET_EXT_ATTR_CURRUPTED;
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +errcode_t ext2fs_ext_attr_find_entry(struct ext2_ext_attr_entry **pentry,
> > > > +				     int name_index, const char *name,
> > > > +				     size_t size, int sorted)
> > > > +{
> > > > +	struct ext2_ext_attr_entry *entry;
> > > > +	size_t name_len;
> > > > +	int cmp = 1;
> > > > +
> > > > +	if (name == NULL)
> > > > +		return EXT2_ET_INVALID_ARGUMENT;
> > > > +	name_len = strlen(name);
> > > > +	for (entry = *pentry; !EXT2_EXT_IS_LAST_ENTRY(entry);
> > > > +	     entry = EXT2_EXT_ATTR_NEXT(entry)) {
> > > > +		cmp = name_index - entry->e_name_index;
> > > > +		if (!cmp)
> > > > +			cmp = name_len - entry->e_name_len;
> > > > +		if (!cmp)
> > > > +			cmp = memcmp(name, EXT2_EXT_ATTR_NAME(entry),
> > > > +				     name_len);
> > > > +		if (cmp <= 0 && (sorted || cmp == 0))
> > > > +			break;
> > > > +	}
> > > > +	*pentry = entry;
> > > > +	if (!cmp && ext2fs_ext_attr_check_entry(entry, size))
> > > > +		return EXT2_ET_EXT_ATTR_CURRUPTED;
> > > > +	return cmp ? ENODATA : 0;
> > > > +}
> > > > +
> > > > +errcode_t ext2fs_ext_attr_ibody_find(ext2_filsys fs,
> > > > +				     struct ext2_inode_large *inode,
> > > > +				     struct ext2_ext_attr_info *i,
> > > > +				     struct ext2_ext_attr_search *s)
> > > > +{
> > > > +	struct ext2_ext_attr_ibody_header *header;
> > > > +	errcode_t error;
> > > > +
> > > > +	if (inode->i_extra_isize == 0)
> > > > +		return 0;
> > > > +	header = IHDR(inode);
> > > > +	s->base = s->first = IFIRST(header);
> > > > +	s->here = s->first;
> > > > +	s->end = (char *)inode + EXT2_INODE_SIZE(fs->super);
> > > > +
> > > > +	error = ext2fs_ext_attr_check_names(IFIRST(header), s->end);
> > > > +	if (error)
> > > > +		return error;
> > > > +	/* Find the named attribute. */
> > > > +	error = ext2fs_ext_attr_find_entry(&s->here, i->name_index,
> > > > +					   i->name, (char *)s->end -
> > > > +					   (char *)s->base, 0);
> > > > +	if (error && error != ENODATA)
> > > > +		return error;
> > > > +	s->not_found = error;
> > > > +	return 0;
> > > 
> > > Huh.  It just occurred to me (yes, after three months, sorry...) that your
> > > patchset doesn't deal with EAs that live in a separate block.  For the purposes
> > > of inline_data I suppose that's sufficient, but if we're going to add an API to
> > > mess with EAs, we ought to be able to handle all of a file's EAs.
> > > 
> > > The implementation that I wrote for fuse2fs does this, but it has no facility
> > > to ensure that the inline data ends up in the ibody and not the EA block.
> > > Though really, they're written out in array order, so it wouldn't be difficult
> > > to sort before writing, or use some knapsack variant.
> > 
> > Sorry, I still havn't had a chance to take a closer look at your patch
> > set for e2fsprogs.  I will review it ASAP.
> 
> Ok.  I'm getting ready to re-spam the mailing list with some more fixes, so you
> can relax for a day or two.  There were some bugs handling inode_size=128.

Welcome to flush my mail box. :-p

                                                - Zheng

> 
> (If you want to take a quick look that's fine; I haven't changed the patch
> significantly.)
> 
> --D
> > 
> > > 
> > > I think I might be drifting towards the idea of attaching your patch series to
> > > the end of mine, but as yours is already in -pu I'm open to discussing how to
> > > reconcile our implementations.
> > 
> > I agree with you that we need to reconcile our implementation.  I was
> > wondering if we really need to add all APIs for EAs in e2fsprogs when I
> > added these functions.  But now it seems that we do need them.
> > 
> > > 
> > > I _do_ like the comments you added to ext2fs_ext_attr_set_entry() though. :)
> > 
> > Yes, there is no any difficulty to add this API. :-)
> > 
> > Regards,
> >                                                 - Zheng
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

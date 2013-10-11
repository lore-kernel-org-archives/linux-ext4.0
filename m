From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v1 03/22] libext2fs: add functions to operate on extended
 attribute
Date: Fri, 11 Oct 2013 15:51:15 -0700
Message-ID: <20131011225115.GA20432@birch.djwong.org>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-4-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39005 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3JKWvZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Oct 2013 18:51:25 -0400
Content-Disposition: inline
In-Reply-To: <1375436989-18948-4-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 02, 2013 at 05:49:30PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> We need to define some functions to operate extended attribute in order
> to support inline data.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  lib/ext2fs/ext2_err.et.in  |    3 +
>  lib/ext2fs/ext2_ext_attr.h |   31 ++++++++
>  lib/ext2fs/ext2fs.h        |    9 +++
>  lib/ext2fs/ext_attr.c      |  186 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 229 insertions(+)
> 
> diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
> index d20c6b7..7e6d6e5 100644
> --- a/lib/ext2fs/ext2_err.et.in
> +++ b/lib/ext2fs/ext2_err.et.in
> @@ -476,4 +476,7 @@ ec	EXT2_ET_MMP_CSUM_INVALID,
>  ec	EXT2_ET_FILE_EXISTS,
>  	"Ext2 file already exists"
>  
> +ec	EXT2_ET_EXT_ATTR_CURRUPTED,
> +	"Extended attribute currupted"
> +
>  	end
> diff --git a/lib/ext2fs/ext2_ext_attr.h b/lib/ext2fs/ext2_ext_attr.h
> index bbb0aaa..99ad849 100644
> --- a/lib/ext2fs/ext2_ext_attr.h
> +++ b/lib/ext2fs/ext2_ext_attr.h
> @@ -15,6 +15,10 @@
>  /* Maximum number of references to one attribute block */
>  #define EXT2_EXT_ATTR_REFCOUNT_MAX	1024
>  
> +/* Name indexes */
> +#define EXT4_EXT_ATTR_INDEX_SYSTEM	7
> +#define EXT4_EXT_ATTR_SYSTEM_DATA	"data"
> +
>  struct ext2_ext_attr_header {
>  	__u32	h_magic;	/* magic number for identification */
>  	__u32	h_refcount;	/* reference count */
> @@ -25,6 +29,10 @@ struct ext2_ext_attr_header {
>  	__u32	h_reserved[3];	/* zero right now */
>  };
>  
> +struct ext2_ext_attr_ibody_header {
> +	__u32	h_magic;
> +};
> +
>  struct ext2_ext_attr_entry {
>  	__u8	e_name_len;	/* length of name */
>  	__u8	e_name_index;	/* attribute name index */
> @@ -57,6 +65,29 @@ struct ext2_ext_attr_entry {
>  #define EXT2_XATTR_SIZE(size) \
>  	(((size) + EXT2_EXT_ATTR_ROUND) & ~EXT2_EXT_ATTR_ROUND)
>  
> +#define IHDR(inode) \
> +	((struct ext2_ext_attr_ibody_header *) \
> +		((char *)inode + \
> +		EXT2_GOOD_OLD_INODE_SIZE + \
> +		inode->i_extra_isize))
> +#define IFIRST(hdr) ((struct ext2_ext_attr_entry *)((hdr)+1))
> +#define EXT2_ZERO_EXT_ATTR_VALUE ((void *)-1)
> +
> +struct ext2_ext_attr_info {
> +	int name_index;
> +	const char *name;
> +	const void *value;
> +	size_t value_len;
> +};
> +
> +struct ext2_ext_attr_search {
> +	struct ext2_ext_attr_entry *first;
> +	void *base;
> +	void *end;
> +	struct ext2_ext_attr_entry *here;
> +	int not_found;
> +};
> +
>  #ifdef __KERNEL__
>  # ifdef CONFIG_EXT2_FS_EXT_ATTR
>  extern int ext2_get_ext_attr(struct inode *, const char *, char *, size_t, int);
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 3346c00..8c30197 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1136,6 +1136,15 @@ extern errcode_t ext2fs_adjust_ea_refcount3(ext2_filsys fs, blk64_t blk,
>  					   char *block_buf,
>  					   int adjust, __u32 *newcount,
>  					   ext2_ino_t inum);
> +extern errcode_t ext2fs_ext_attr_ibody_find(ext2_filsys fs,
> +					    struct ext2_inode_large *inode,
> +					    struct ext2_ext_attr_info *i,
> +					    struct ext2_ext_attr_search *s);
> +extern errcode_t ext2fs_ext_attr_find_entry(struct ext2_ext_attr_entry **pentry,
> +					    int name_index, const char *name,
> +					    size_t size, int sorted);
> +extern errcode_t ext2fs_ext_attr_set_entry(struct ext2_ext_attr_info *i,
> +					   struct ext2_ext_attr_search *s);
>  
>  /* extent.c */
>  extern errcode_t ext2fs_extent_header_verify(void *ptr, int size);
> diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
> index 9649a14..6d55340 100644
> --- a/lib/ext2fs/ext_attr.c
> +++ b/lib/ext2fs/ext_attr.c
> @@ -186,3 +186,189 @@ errcode_t ext2fs_adjust_ea_refcount(ext2_filsys fs, blk_t blk,
>  	return ext2fs_adjust_ea_refcount2(fs, blk, block_buf, adjust,
>  					  newcount);
>  }
> +
> +static errcode_t
> +ext2fs_ext_attr_check_names(struct ext2_ext_attr_entry *entry, void *end)
> +{
> +	while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
> +		struct ext2_ext_attr_entry *next = EXT2_EXT_ATTR_NEXT(entry);
> +		if ((void *)next >= end)
> +			return EXT2_ET_EXT_ATTR_CURRUPTED;
> +		entry = next;
> +	}
> +	return 0;
> +}
> +
> +static inline errcode_t
> +ext2fs_ext_attr_check_entry(struct ext2_ext_attr_entry *entry, size_t size)
> +{
> +	size_t value_size = entry->e_value_size;
> +
> +	if (entry->e_value_block != 0 || value_size > size ||
> +	    entry->e_value_offs + value_size > size)
> +		return EXT2_ET_EXT_ATTR_CURRUPTED;
> +	return 0;
> +}
> +
> +errcode_t ext2fs_ext_attr_find_entry(struct ext2_ext_attr_entry **pentry,
> +				     int name_index, const char *name,
> +				     size_t size, int sorted)
> +{
> +	struct ext2_ext_attr_entry *entry;
> +	size_t name_len;
> +	int cmp = 1;
> +
> +	if (name == NULL)
> +		return EXT2_ET_INVALID_ARGUMENT;
> +	name_len = strlen(name);
> +	for (entry = *pentry; !EXT2_EXT_IS_LAST_ENTRY(entry);
> +	     entry = EXT2_EXT_ATTR_NEXT(entry)) {
> +		cmp = name_index - entry->e_name_index;
> +		if (!cmp)
> +			cmp = name_len - entry->e_name_len;
> +		if (!cmp)
> +			cmp = memcmp(name, EXT2_EXT_ATTR_NAME(entry),
> +				     name_len);
> +		if (cmp <= 0 && (sorted || cmp == 0))
> +			break;
> +	}
> +	*pentry = entry;
> +	if (!cmp && ext2fs_ext_attr_check_entry(entry, size))
> +		return EXT2_ET_EXT_ATTR_CURRUPTED;
> +	return cmp ? ENODATA : 0;
> +}
> +
> +errcode_t ext2fs_ext_attr_ibody_find(ext2_filsys fs,
> +				     struct ext2_inode_large *inode,
> +				     struct ext2_ext_attr_info *i,
> +				     struct ext2_ext_attr_search *s)
> +{
> +	struct ext2_ext_attr_ibody_header *header;
> +	errcode_t error;
> +
> +	if (inode->i_extra_isize == 0)
> +		return 0;
> +	header = IHDR(inode);
> +	s->base = s->first = IFIRST(header);
> +	s->here = s->first;
> +	s->end = (char *)inode + EXT2_INODE_SIZE(fs->super);
> +
> +	error = ext2fs_ext_attr_check_names(IFIRST(header), s->end);
> +	if (error)
> +		return error;
> +	/* Find the named attribute. */
> +	error = ext2fs_ext_attr_find_entry(&s->here, i->name_index,
> +					   i->name, (char *)s->end -
> +					   (char *)s->base, 0);
> +	if (error && error != ENODATA)
> +		return error;
> +	s->not_found = error;
> +	return 0;

Huh.  It just occurred to me (yes, after three months, sorry...) that your
patchset doesn't deal with EAs that live in a separate block.  For the purposes
of inline_data I suppose that's sufficient, but if we're going to add an API to
mess with EAs, we ought to be able to handle all of a file's EAs.

The implementation that I wrote for fuse2fs does this, but it has no facility
to ensure that the inline data ends up in the ibody and not the EA block.
Though really, they're written out in array order, so it wouldn't be difficult
to sort before writing, or use some knapsack variant.

I think I might be drifting towards the idea of attaching your patch series to
the end of mine, but as yours is already in -pu I'm open to discussing how to
reconcile our implementations.

I _do_ like the comments you added to ext2fs_ext_attr_set_entry() though. :)

--D

> +}
> +
> +errcode_t ext2fs_ext_attr_set_entry(struct ext2_ext_attr_info *i,
> +				    struct ext2_ext_attr_search *s)
> +{
> +	struct ext2_ext_attr_entry *last;
> +	size_t freesize, min_offs = (char *)s->end - (char *)s->base;
> +	size_t name_len = strlen(i->name);
> +
> +	/* Compute min_offs and last. */
> +	last = s->first;
> +	for (; !EXT2_EXT_IS_LAST_ENTRY(last); last = EXT2_EXT_ATTR_NEXT(last)) {
> +		if (!last->e_value_block && last->e_value_size) {
> +			size_t offs = last->e_value_offs;
> +			if (offs < min_offs)
> +				min_offs = offs;
> +		}
> +	}
> +	freesize = min_offs - ((char *)last - (char *)s->base) - sizeof(__u32);
> +	if (!s->not_found) {
> +		if (!s->here->e_value_block && s->here->e_value_size) {
> +			size_t size = s->here->e_value_size;
> +			freesize += EXT2_EXT_ATTR_SIZE(size);
> +		}
> +		freesize += EXT2_EXT_ATTR_LEN(name_len);
> +	}
> +	if (i->value) {
> +		if (freesize < EXT2_EXT_ATTR_SIZE(i->value_len) ||
> +		    freesize < EXT2_EXT_ATTR_LEN(name_len) +
> +			   EXT2_EXT_ATTR_SIZE(i->value_len))
> +			return ENOSPC;
> +	}
> +
> +	if (i->value && s->not_found) {
> +		/* Insert the new name. */
> +		size_t size = EXT2_EXT_ATTR_LEN(name_len);
> +		size_t rest = (char *)last - (char *)s->here + sizeof(__u32);
> +		memmove((char *)s->here + size, s->here, rest);
> +		memset(s->here, 0, size);
> +		s->here->e_name_index = i->name_index;
> +		s->here->e_name_len = name_len;
> +		memcpy(EXT2_EXT_ATTR_NAME(s->here), i->name, name_len);
> +	} else {
> +		if (!s->here->e_value_block && s->here->e_value_size) {
> +			char *first_val = (char *) s->base + min_offs;
> +			size_t offs = s->here->e_value_offs;
> +			char *val = (char *)s->base + offs;
> +			size_t size = EXT2_EXT_ATTR_SIZE(s->here->e_value_size);
> +
> +			if (i->value && size == EXT2_EXT_ATTR_SIZE(i->value_len)) {
> +				/* The old and the new value have the same
> +				 * size. Just replace. */
> +				s->here->e_value_size = i->value_len;
> +				if (i->value == EXT2_ZERO_EXT_ATTR_VALUE) {
> +					memset(val, 0, size);
> +				} else {
> +					memset(val + size - EXT2_EXT_ATTR_PAD, 0,
> +						EXT2_EXT_ATTR_PAD);
> +					memcpy(val, i->value, i->value_len);
> +				}
> +				return 0;
> +			}
> +
> +			/* Remove the old value. */
> +			memmove(first_val + size, first_val, val - first_val);
> +			memset(first_val, 0, size);
> +			s->here->e_value_size = 0;
> +			s->here->e_value_offs = 0;
> +			min_offs += size;
> +
> +			/* Adjust all value offsets. */
> +			last = s->first;
> +			while (!EXT2_EXT_IS_LAST_ENTRY(last)) {
> +				size_t o = last->e_value_offs;
> +				if (!last->e_value_block &&
> +				    last->e_value_size && o < offs)
> +					last->e_value_offs = o + size;
> +				last = EXT2_EXT_ATTR_NEXT(last);
> +			}
> +		}
> +		if (!i->value) {
> +			/* Remove the old name. */
> +			size_t size = EXT2_EXT_ATTR_LEN(name_len);
> +			last = (struct ext2_ext_attr_entry *)last - size;
> +			memmove(s->here, (char *)s->here + size,
> +				(char *)last - (char *)s->here + sizeof(__u32));
> +			memset(last, 0, size);
> +		}
> +	}
> +
> +	if (i->value) {
> +		/* Insert the new value. */
> +		s->here->e_value_size = i->value_len;
> +		if (i->value_len) {
> +			size_t size = EXT2_EXT_ATTR_SIZE(i->value_len);
> +			char *val = (char *)s->base + min_offs - size;
> +			s->here->e_value_offs = min_offs - size;
> +			if (i->value == EXT2_ZERO_EXT_ATTR_VALUE) {
> +				memset(val, 0, size);
> +			} else {
> +				memset(val + size - EXT2_EXT_ATTR_PAD, 0,
> +					EXT2_EXT_ATTR_PAD);
> +				memcpy(val, i->value, i->value_len);
> +			}
> +		}
> +	}
> +	return 0;
> +}
> -- 
> 1.7.9.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

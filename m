From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v1 03/22] libext2fs: add functions to operate on extended
 attribute
Date: Sat, 12 Oct 2013 02:02:35 -0700
Message-ID: <20131012090235.GF14971@birch.djwong.org>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-4-git-send-email-wenqing.lz@taobao.com>
 <20131011225115.GA20432@birch.djwong.org>
 <20131012055154.GA6377@gmail.com>
 <20131012083200.GD14971@birch.djwong.org>
 <20131012084111.GF6462@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46185 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3JLJCo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Oct 2013 05:02:44 -0400
Content-Disposition: inline
In-Reply-To: <20131012084111.GF6462@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 12, 2013 at 04:41:11PM +0800, Zheng Liu wrote:
> On Sat, Oct 12, 2013 at 01:32:00AM -0700, Darrick J. Wong wrote:
> > On Sat, Oct 12, 2013 at 01:51:54PM +0800, Zheng Liu wrote:
> > > On Fri, Oct 11, 2013 at 03:51:15PM -0700, Darrick J. Wong wrote:
> > > > On Fri, Aug 02, 2013 at 05:49:30PM +0800, Zheng Liu wrote:
> > > > > From: Zheng Liu <wenqing.lz@taobao.com>
> > > > > 
> > > > > We need to define some functions to operate extended attribute in order
> > > > > to support inline data.
> > > > > 
> > > > > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > > > > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > > > > ---
> > > > >  lib/ext2fs/ext2_err.et.in  |    3 +
> > > > >  lib/ext2fs/ext2_ext_attr.h |   31 ++++++++
> > > > >  lib/ext2fs/ext2fs.h        |    9 +++
> > > > >  lib/ext2fs/ext_attr.c      |  186 ++++++++++++++++++++++++++++++++++++++++++++
> > > > >  4 files changed, 229 insertions(+)
> > > > > 
> > > > > diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
> > > > > index d20c6b7..7e6d6e5 100644
> > > > > --- a/lib/ext2fs/ext2_err.et.in
> > > > > +++ b/lib/ext2fs/ext2_err.et.in
> > > > > @@ -476,4 +476,7 @@ ec	EXT2_ET_MMP_CSUM_INVALID,
> > > > >  ec	EXT2_ET_FILE_EXISTS,
> > > > >  	"Ext2 file already exists"
> > > > >  
> > > > > +ec	EXT2_ET_EXT_ATTR_CURRUPTED,
> > > > > +	"Extended attribute currupted"
> > > > > +
> > > > >  	end
> > > > > diff --git a/lib/ext2fs/ext2_ext_attr.h b/lib/ext2fs/ext2_ext_attr.h
> > > > > index bbb0aaa..99ad849 100644
> > > > > --- a/lib/ext2fs/ext2_ext_attr.h
> > > > > +++ b/lib/ext2fs/ext2_ext_attr.h
> > > > > @@ -15,6 +15,10 @@
> > > > >  /* Maximum number of references to one attribute block */
> > > > >  #define EXT2_EXT_ATTR_REFCOUNT_MAX	1024
> > > > >  
> > > > > +/* Name indexes */
> > > > > +#define EXT4_EXT_ATTR_INDEX_SYSTEM	7
> > > > > +#define EXT4_EXT_ATTR_SYSTEM_DATA	"data"
> > > > > +
> > > > >  struct ext2_ext_attr_header {
> > > > >  	__u32	h_magic;	/* magic number for identification */
> > > > >  	__u32	h_refcount;	/* reference count */
> > > > > @@ -25,6 +29,10 @@ struct ext2_ext_attr_header {
> > > > >  	__u32	h_reserved[3];	/* zero right now */
> > > > >  };
> > > > >  
> > > > > +struct ext2_ext_attr_ibody_header {
> > > > > +	__u32	h_magic;
> > > > > +};
> > > > > +
> > > > >  struct ext2_ext_attr_entry {
> > > > >  	__u8	e_name_len;	/* length of name */
> > > > >  	__u8	e_name_index;	/* attribute name index */
> > > > > @@ -57,6 +65,29 @@ struct ext2_ext_attr_entry {
> > > > >  #define EXT2_XATTR_SIZE(size) \
> > > > >  	(((size) + EXT2_EXT_ATTR_ROUND) & ~EXT2_EXT_ATTR_ROUND)
> > > > >  
> > > > > +#define IHDR(inode) \
> > > > > +	((struct ext2_ext_attr_ibody_header *) \
> > > > > +		((char *)inode + \
> > > > > +		EXT2_GOOD_OLD_INODE_SIZE + \
> > > > > +		inode->i_extra_isize))
> > > > > +#define IFIRST(hdr) ((struct ext2_ext_attr_entry *)((hdr)+1))
> > > > > +#define EXT2_ZERO_EXT_ATTR_VALUE ((void *)-1)
> > > > > +
> > > > > +struct ext2_ext_attr_info {
> > > > > +	int name_index;
> > > > > +	const char *name;
> > > > > +	const void *value;
> > > > > +	size_t value_len;
> > > > > +};
> > > > > +
> > > > > +struct ext2_ext_attr_search {
> > > > > +	struct ext2_ext_attr_entry *first;
> > > > > +	void *base;
> > > > > +	void *end;
> > > > > +	struct ext2_ext_attr_entry *here;
> > > > > +	int not_found;
> > > > > +};
> > > > > +
> > > > >  #ifdef __KERNEL__
> > > > >  # ifdef CONFIG_EXT2_FS_EXT_ATTR
> > > > >  extern int ext2_get_ext_attr(struct inode *, const char *, char *, size_t, int);
> > > > > diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> > > > > index 3346c00..8c30197 100644
> > > > > --- a/lib/ext2fs/ext2fs.h
> > > > > +++ b/lib/ext2fs/ext2fs.h
> > > > > @@ -1136,6 +1136,15 @@ extern errcode_t ext2fs_adjust_ea_refcount3(ext2_filsys fs, blk64_t blk,
> > > > >  					   char *block_buf,
> > > > >  					   int adjust, __u32 *newcount,
> > > > >  					   ext2_ino_t inum);
> > > > > +extern errcode_t ext2fs_ext_attr_ibody_find(ext2_filsys fs,
> > > > > +					    struct ext2_inode_large *inode,
> > > > > +					    struct ext2_ext_attr_info *i,
> > > > > +					    struct ext2_ext_attr_search *s);
> > > > > +extern errcode_t ext2fs_ext_attr_find_entry(struct ext2_ext_attr_entry **pentry,
> > > > > +					    int name_index, const char *name,
> > > > > +					    size_t size, int sorted);
> > > > > +extern errcode_t ext2fs_ext_attr_set_entry(struct ext2_ext_attr_info *i,
> > > > > +					   struct ext2_ext_attr_search *s);
> > > > >  
> > > > >  /* extent.c */
> > > > >  extern errcode_t ext2fs_extent_header_verify(void *ptr, int size);
> > > > > diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
> > > > > index 9649a14..6d55340 100644
> > > > > --- a/lib/ext2fs/ext_attr.c
> > > > > +++ b/lib/ext2fs/ext_attr.c
> > > > > @@ -186,3 +186,189 @@ errcode_t ext2fs_adjust_ea_refcount(ext2_filsys fs, blk_t blk,
> > > > >  	return ext2fs_adjust_ea_refcount2(fs, blk, block_buf, adjust,
> > > > >  					  newcount);
> > > > >  }
> > > > > +
> > > > > +static errcode_t
> > > > > +ext2fs_ext_attr_check_names(struct ext2_ext_attr_entry *entry, void *end)
> > > > > +{
> > > > > +	while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
> > > > > +		struct ext2_ext_attr_entry *next = EXT2_EXT_ATTR_NEXT(entry);
> > > > > +		if ((void *)next >= end)
> > > > > +			return EXT2_ET_EXT_ATTR_CURRUPTED;
> > > > > +		entry = next;
> > > > > +	}
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > > +static inline errcode_t
> > > > > +ext2fs_ext_attr_check_entry(struct ext2_ext_attr_entry *entry, size_t size)
> > > > > +{
> > > > > +	size_t value_size = entry->e_value_size;
> > > > > +
> > > > > +	if (entry->e_value_block != 0 || value_size > size ||
> > > > > +	    entry->e_value_offs + value_size > size)
> > > > > +		return EXT2_ET_EXT_ATTR_CURRUPTED;
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > > +errcode_t ext2fs_ext_attr_find_entry(struct ext2_ext_attr_entry **pentry,
> > > > > +				     int name_index, const char *name,
> > > > > +				     size_t size, int sorted)
> > > > > +{
> > > > > +	struct ext2_ext_attr_entry *entry;
> > > > > +	size_t name_len;
> > > > > +	int cmp = 1;
> > > > > +
> > > > > +	if (name == NULL)
> > > > > +		return EXT2_ET_INVALID_ARGUMENT;
> > > > > +	name_len = strlen(name);
> > > > > +	for (entry = *pentry; !EXT2_EXT_IS_LAST_ENTRY(entry);
> > > > > +	     entry = EXT2_EXT_ATTR_NEXT(entry)) {
> > > > > +		cmp = name_index - entry->e_name_index;
> > > > > +		if (!cmp)
> > > > > +			cmp = name_len - entry->e_name_len;
> > > > > +		if (!cmp)
> > > > > +			cmp = memcmp(name, EXT2_EXT_ATTR_NAME(entry),
> > > > > +				     name_len);
> > > > > +		if (cmp <= 0 && (sorted || cmp == 0))
> > > > > +			break;
> > > > > +	}
> > > > > +	*pentry = entry;
> > > > > +	if (!cmp && ext2fs_ext_attr_check_entry(entry, size))
> > > > > +		return EXT2_ET_EXT_ATTR_CURRUPTED;
> > > > > +	return cmp ? ENODATA : 0;
> > > > > +}
> > > > > +
> > > > > +errcode_t ext2fs_ext_attr_ibody_find(ext2_filsys fs,
> > > > > +				     struct ext2_inode_large *inode,
> > > > > +				     struct ext2_ext_attr_info *i,
> > > > > +				     struct ext2_ext_attr_search *s)
> > > > > +{
> > > > > +	struct ext2_ext_attr_ibody_header *header;
> > > > > +	errcode_t error;
> > > > > +
> > > > > +	if (inode->i_extra_isize == 0)
> > > > > +		return 0;
> > > > > +	header = IHDR(inode);
> > > > > +	s->base = s->first = IFIRST(header);
> > > > > +	s->here = s->first;
> > > > > +	s->end = (char *)inode + EXT2_INODE_SIZE(fs->super);
> > > > > +
> > > > > +	error = ext2fs_ext_attr_check_names(IFIRST(header), s->end);
> > > > > +	if (error)
> > > > > +		return error;
> > > > > +	/* Find the named attribute. */
> > > > > +	error = ext2fs_ext_attr_find_entry(&s->here, i->name_index,
> > > > > +					   i->name, (char *)s->end -
> > > > > +					   (char *)s->base, 0);
> > > > > +	if (error && error != ENODATA)
> > > > > +		return error;
> > > > > +	s->not_found = error;
> > > > > +	return 0;
> > > > 
> > > > Huh.  It just occurred to me (yes, after three months, sorry...) that your
> > > > patchset doesn't deal with EAs that live in a separate block.  For the purposes
> > > > of inline_data I suppose that's sufficient, but if we're going to add an API to
> > > > mess with EAs, we ought to be able to handle all of a file's EAs.
> > > > 
> > > > The implementation that I wrote for fuse2fs does this, but it has no facility
> > > > to ensure that the inline data ends up in the ibody and not the EA block.
> > > > Though really, they're written out in array order, so it wouldn't be difficult
> > > > to sort before writing, or use some knapsack variant.
> > > 
> > > Sorry, I still havn't had a chance to take a closer look at your patch
> > > set for e2fsprogs.  I will review it ASAP.
> > 
> > Ok.  I'm getting ready to re-spam the mailing list with some more fixes, so you
> > can relax for a day or two.  There were some bugs handling inode_size=128.
> 
> Welcome to flush my mail box. :-p

He he he there are 24 of those patches... I got lucky and Ted picked a few more
tonight. :)

--D

Well, if you're curious, here's the latest xattr API patch.  I wonder if the
minimum size of the inode ought to be EXT2_GOOD_OLD_SIZE + i_extra_isize + 8
bytes (to fit the EA magic and the magic zero that says "end of keys")?  But
it's too late at night to think.

From: Darrick J. Wong <darrick.wong@oracle.com>
Subject: [PATCH] libext2fs: support modifying arbitrary extended attributes

Add functions to allow clients to get, set, and remove extended
attributes from any file.  It also supports modifying EAs living in
i_file_acl.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext2_err.et.in |   18 +
 lib/ext2fs/ext2fs.h       |   28 ++
 lib/ext2fs/ext_attr.c     |  742 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 788 insertions(+)

diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index c547a2c..262f4a4 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -479,4 +479,22 @@ ec	EXT2_ET_FILE_EXISTS,
 ec	EXT2_ET_BLOCK_BITMAP_CSUM_INVALID,
 	"Block bitmap checksum does not match bitmap"
 
+ec	EXT2_ET_EA_BAD_NAME_LEN,
+	"Extended attribute has an invalid name length"
+
+ec	EXT2_ET_EA_BAD_VALUE_SIZE,
+	"Extended attribute has an invalid value length"
+
+ec	EXT2_ET_BAD_EA_HASH,
+	"Extended attribute has an incorrect hash"
+
+ec	EXT2_ET_BAD_EA_HEADER,
+	"Extended attribute block has a bad header"
+
+ec	EXT2_ET_EA_KEY_NOT_FOUND,
+	"Extended attribute key not found"
+
+ec	EXT2_ET_EA_NO_SPACE,
+	"Insufficient space to store extended attribute data"
+
 	end
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index c280ea0..09d3d4c 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -637,6 +637,13 @@ typedef struct stat ext2fs_struct_stat;
 #define EXT2_FLAG_FLUSH_NO_SYNC          1
 
 /*
+ * Modify and iterate extended attributes
+ */
+struct ext2_xattr_handle;
+#define XATTR_ABORT	1
+#define XATTR_CHANGED	2
+
+/*
  * function prototypes
  */
 static inline int ext2fs_has_group_desc_csum(ext2_filsys fs)
@@ -1145,6 +1152,27 @@ extern errcode_t ext2fs_adjust_ea_refcount3(ext2_filsys fs, blk64_t blk,
 					   char *block_buf,
 					   int adjust, __u32 *newcount,
 					   ext2_ino_t inum);
+errcode_t ext2fs_xattrs_expand(struct ext2_xattr_handle *h,
+			       unsigned int expandby);
+errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle);
+errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle);
+errcode_t ext2fs_xattrs_iterate(struct ext2_xattr_handle *h,
+				int (*func)(char *name, char *value,
+					    void *data),
+				void *data);
+errcode_t ext2fs_xattr_get(struct ext2_xattr_handle *h, const char *key,
+			   void **value, unsigned int *value_len);
+errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
+			   const char *key,
+			   const void *value,
+			   unsigned int value_len);
+errcode_t ext2fs_xattr_remove(struct ext2_xattr_handle *handle,
+			      const char *key);
+errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
+			     struct ext2_xattr_handle **handle);
+errcode_t ext2fs_xattrs_close(struct ext2_xattr_handle **handle);
+errcode_t ext2fs_free_ext_attr(ext2_filsys fs, ext2_ino_t ino,
+			       struct ext2_inode_large *inode);
 
 /* extent.c */
 extern errcode_t ext2fs_extent_header_verify(void *ptr, int size);
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 9649a14..59894ab 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -186,3 +186,745 @@ errcode_t ext2fs_adjust_ea_refcount(ext2_filsys fs, blk_t blk,
 	return ext2fs_adjust_ea_refcount2(fs, blk, block_buf, adjust,
 					  newcount);
 }
+
+/* Manipulate the contents of extended attribute regions */
+struct ext2_xattr {
+	char *name;
+	void *value;
+	unsigned int value_len;
+};
+
+struct ext2_xattr_handle {
+	ext2_filsys fs;
+	struct ext2_xattr *attrs;
+	unsigned int length;
+	ext2_ino_t ino;
+	int dirty;
+};
+
+errcode_t ext2fs_xattrs_expand(struct ext2_xattr_handle *h,
+			       unsigned int expandby)
+{
+	struct ext2_xattr *new_attrs;
+	errcode_t err;
+
+	err = ext2fs_get_arrayzero(h->length + expandby,
+				   sizeof(struct ext2_xattr), &new_attrs);
+	if (err)
+		return err;
+
+	memcpy(new_attrs, h->attrs, h->length * sizeof(struct ext2_xattr));
+	ext2fs_free_mem(&h->attrs);
+	h->length += expandby;
+	h->attrs = new_attrs;
+
+	return 0;
+}
+
+struct ea_name_index {
+	int index;
+	const char *name;
+};
+
+static struct ea_name_index ea_names[] = {
+	{1, "user."},
+	{2, "system.posix_acl_access"},
+	{3, "system.posix_acl_default"},
+	{4, "trusted."},
+	{6, "security."},
+	{7, "system."},
+	{0, NULL},
+};
+
+static const char *find_ea_prefix(int index)
+{
+	struct ea_name_index *e;
+
+	for (e = ea_names; e->name; e++)
+		if (e->index == index)
+			return e->name;
+
+	return NULL;
+}
+
+static int find_ea_index(const char *fullname, char **name, int *index)
+{
+	struct ea_name_index *e;
+
+	for (e = ea_names; e->name; e++)
+		if (memcmp(fullname, e->name, strlen(e->name)) == 0) {
+			*name = (char *)fullname + strlen(e->name);
+			*index = e->index;
+			return 1;
+		}
+	return 0;
+}
+
+errcode_t ext2fs_free_ext_attr(ext2_filsys fs, ext2_ino_t ino,
+			       struct ext2_inode_large *inode)
+{
+	struct ext2_ext_attr_header *header;
+	void *block_buf = NULL;
+	dgrp_t grp;
+	blk64_t blk, goal;
+	errcode_t err;
+
+	/* Do we already have an EA block? */
+	blk = ext2fs_file_acl_block(fs, (struct ext2_inode *)inode);
+	if (blk == 0)
+		return 0;
+
+	/* Find block, zero it, write back */
+	if ((blk < fs->super->s_first_data_block) ||
+	    (blk >= ext2fs_blocks_count(fs->super))) {
+		err = EXT2_ET_BAD_EA_BLOCK_NUM;
+		goto out;
+	}
+
+	err = ext2fs_get_mem(fs->blocksize, &block_buf);
+	if (err)
+		goto out;
+
+	err = ext2fs_read_ext_attr3(fs, blk, block_buf, ino);
+	if (err)
+		goto out2;
+
+	header = (struct ext2_ext_attr_header *) block_buf;
+	if (header->h_magic != EXT2_EXT_ATTR_MAGIC) {
+		err = EXT2_ET_BAD_EA_HEADER;
+		goto out2;
+	}
+
+	header->h_refcount--;
+	err = ext2fs_write_ext_attr3(fs, blk, block_buf, ino);
+	if (err)
+		goto out2;
+
+	/* Erase link to block */
+	ext2fs_file_acl_block_set(fs, (struct ext2_inode *)inode, 0);
+	if (header->h_refcount == 0)
+		ext2fs_block_alloc_stats2(fs, blk, -1);
+out2:
+	ext2fs_free_mem(&block_buf);
+out:
+	return err;
+}
+
+static errcode_t prep_ea_block_for_write(ext2_filsys fs, ext2_ino_t ino,
+					 struct ext2_inode_large *inode)
+{
+	struct ext2_ext_attr_header *header;
+	void *block_buf = NULL;
+	dgrp_t grp;
+	blk64_t blk, goal;
+	errcode_t err;
+
+	/* Do we already have an EA block? */
+	blk = ext2fs_file_acl_block(fs, (struct ext2_inode *)inode);
+	if (blk != 0) {
+		if ((blk < fs->super->s_first_data_block) ||
+		    (blk >= ext2fs_blocks_count(fs->super))) {
+			err = EXT2_ET_BAD_EA_BLOCK_NUM;
+			goto out;
+		}
+
+		err = ext2fs_get_mem(fs->blocksize, &block_buf);
+		if (err)
+			goto out;
+
+		err = ext2fs_read_ext_attr3(fs, blk, block_buf, ino);
+		if (err)
+			goto out2;
+
+		header = (struct ext2_ext_attr_header *) block_buf;
+		if (header->h_magic != EXT2_EXT_ATTR_MAGIC) {
+			err = EXT2_ET_BAD_EA_HEADER;
+			goto out2;
+		}
+
+		/* Single-user block.  We're done here. */
+		if (header->h_refcount == 1)
+			return 0;
+
+		/* We need to CoW the block. */
+		header->h_refcount--;
+		err = ext2fs_write_ext_attr3(fs, blk, block_buf, ino);
+		if (err)
+			goto out2;
+	} else {
+		/* No block, we must increment i_blocks */
+		err = ext2fs_iblk_add_blocks(fs, (struct ext2_inode *)inode,
+					     1);
+		if (err)
+			goto out;
+	}
+
+	/* Allocate a block */
+	grp = ext2fs_group_of_ino(fs, ino);
+	goal = ext2fs_inode_table_loc(fs, grp);
+	err = ext2fs_alloc_block2(fs, goal, NULL, &blk);
+	if (err)
+		return err;
+	ext2fs_file_acl_block_set(fs, (struct ext2_inode *)inode, blk);
+out2:
+	ext2fs_free_mem(&block_buf);
+out:
+	return err;
+}
+
+
+static errcode_t write_xattrs_to_buffer(struct ext2_xattr_handle *handle,
+					struct ext2_xattr **pos,
+					void *entries_start,
+					unsigned int storage_size,
+					unsigned int value_offset_correction)
+{
+	struct ext2_xattr *x = *pos;
+	struct ext2_ext_attr_entry *e = entries_start;
+	void *end = entries_start + storage_size;
+	char *shortname;
+	unsigned int entry_size, value_size;
+	int idx, ret;
+
+	/* For all remaining x...  */
+	for (; x < handle->attrs + handle->length; x++) {
+		if (!x->name)
+			continue;
+
+		/* Calculate index and shortname position */
+		shortname = x->name;
+		ret = find_ea_index(x->name, &shortname, &idx);
+
+		/* Calculate entry and value size */
+		entry_size = (sizeof(*e) + strlen(shortname) +
+			      EXT2_EXT_ATTR_PAD - 1) &
+			     ~(EXT2_EXT_ATTR_PAD - 1);
+		value_size = ((x->value_len + EXT2_EXT_ATTR_PAD - 1) /
+			      EXT2_EXT_ATTR_PAD) * EXT2_EXT_ATTR_PAD;
+
+		/*
+		 * Would entry collide with value?
+		 * Note that we must leave sufficient room for a (u32)0 to
+		 * mark the end of the entries.
+		 */
+		if ((void *)e + entry_size + sizeof(__u32) > end - value_size)
+			break;
+
+		/* Fill out e appropriately */
+		e->e_name_len = strlen(shortname);
+		e->e_name_index = (ret ? idx : 0);
+		e->e_value_offs = end - value_size - (void *)entries_start +
+				value_offset_correction;
+		e->e_value_block = 0;
+		e->e_value_size = x->value_len;
+
+		/* Store name and value */
+		end -= value_size;
+		memcpy((void *)e + sizeof(*e), shortname, e->e_name_len);
+		memcpy(end, x->value, e->e_value_size);
+
+		e->e_hash = ext2fs_ext_attr_hash_entry(e, end);
+
+		e = EXT2_EXT_ATTR_NEXT(e);
+		*(__u32 *)e = 0;
+	}
+	*pos = x;
+
+	return 0;
+}
+
+errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
+{
+	struct ext2_xattr *x;
+	struct ext2_inode_large *inode;
+	void *start, *block_buf = NULL;
+	struct ext2_ext_attr_header *header;
+	__u32 ea_inode_magic;
+	blk64_t blk;
+	unsigned int storage_size;
+	unsigned int i, written;
+	errcode_t err;
+
+	if (!EXT2_HAS_COMPAT_FEATURE(handle->fs->super,
+				     EXT2_FEATURE_COMPAT_EXT_ATTR))
+		return 0;
+
+	i = EXT2_INODE_SIZE(handle->fs->super);
+	if (i < sizeof(*inode))
+		i = sizeof(*inode);
+	err = ext2fs_get_memzero(i, &inode);
+	if (err)
+		return err;
+
+	err = ext2fs_read_inode_full(handle->fs, handle->ino,
+				     (struct ext2_inode *)inode,
+				     EXT2_INODE_SIZE(handle->fs->super));
+	if (err)
+		goto out;
+
+	x = handle->attrs;
+	/* Does the inode have size for EA? */
+	if (EXT2_INODE_SIZE(handle->fs->super) <= EXT2_GOOD_OLD_INODE_SIZE +
+						  inode->i_extra_isize +
+						  sizeof(__u32))
+		goto write_ea_block;
+
+	/* Write the inode EA */
+	ea_inode_magic = EXT2_EXT_ATTR_MAGIC;
+	memcpy(((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
+	       inode->i_extra_isize, &ea_inode_magic, sizeof(__u32));
+	storage_size = EXT2_INODE_SIZE(handle->fs->super) -
+		EXT2_GOOD_OLD_INODE_SIZE - inode->i_extra_isize -
+		sizeof(__u32);
+	start = ((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
+		inode->i_extra_isize + sizeof(__u32);
+
+	err = write_xattrs_to_buffer(handle, &x, start, storage_size, 0);
+	if (err)
+		goto out;
+
+	/* Are we done? */
+	if (x == handle->attrs + handle->length)
+		goto skip_ea_block;
+
+write_ea_block:
+	/* Write the EA block */
+	err = ext2fs_get_mem(handle->fs->blocksize, &block_buf);
+	if (err)
+		goto out;
+
+	storage_size = handle->fs->blocksize -
+		sizeof(struct ext2_ext_attr_header);
+	start = block_buf + sizeof(struct ext2_ext_attr_header);
+
+	err = write_xattrs_to_buffer(handle, &x, start, storage_size,
+				     (void *)start - block_buf);
+	if (err)
+		goto out2;
+
+	if (x < handle->attrs + handle->length) {
+		err = EXT2_ET_EA_NO_SPACE;
+		goto out2;
+	}
+
+	if (block_buf) {
+		/* Write a header on the EA block */
+		header = block_buf;
+		header->h_magic = EXT2_EXT_ATTR_MAGIC;
+		header->h_refcount = 1;
+		header->h_blocks = 1;
+
+		/* Get a new block for writing */
+		err = prep_ea_block_for_write(handle->fs, handle->ino, inode);
+		if (err)
+			goto out2;
+
+		/* Finally, write the new EA block */
+		blk = ext2fs_file_acl_block(handle->fs,
+					    (struct ext2_inode *)inode);
+		err = ext2fs_write_ext_attr3(handle->fs, blk, block_buf,
+					     handle->ino);
+		if (err)
+			goto out2;
+	}
+
+skip_ea_block:
+	blk = ext2fs_file_acl_block(handle->fs, (struct ext2_inode *)inode);
+	if (!block_buf && blk) {
+		/* xattrs shrunk, free the block */
+		ext2fs_file_acl_block_set(handle->fs,
+					  (struct ext2_inode *)inode, 0);
+		err = ext2fs_iblk_sub_blocks(handle->fs,
+					     (struct ext2_inode *)inode, 1);
+		if (err)
+			goto out;
+		ext2fs_block_alloc_stats2(handle->fs, blk, -1);
+	}
+
+	/* Write the inode */
+	err = ext2fs_write_inode_full(handle->fs, handle->ino,
+				      (struct ext2_inode *)inode,
+				      EXT2_INODE_SIZE(handle->fs->super));
+	if (err)
+		goto out2;
+
+out2:
+	ext2fs_free_mem(&block_buf);
+out:
+	ext2fs_free_mem(&inode);
+	handle->dirty = 0;
+	return err;
+}
+
+static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
+					 struct ext2_ext_attr_entry *entries,
+					 unsigned int storage_size,
+					 void *value_start)
+{
+	struct ext2_xattr *x;
+	struct ext2_ext_attr_entry *entry;
+	const char *prefix;
+	void *ptr;
+	unsigned int remain, prefix_len;
+	errcode_t err;
+
+	x = handle->attrs;
+	while (x->name)
+		x++;
+
+	entry = entries;
+	while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
+		__u32 hash;
+
+		/* header eats this space */
+		remain -= sizeof(struct ext2_ext_attr_entry);
+
+		/* is attribute name valid? */
+		if (EXT2_EXT_ATTR_SIZE(entry->e_name_len) > remain)
+			return EXT2_ET_EA_BAD_NAME_LEN;
+
+		/* attribute len eats this space */
+		remain -= EXT2_EXT_ATTR_SIZE(entry->e_name_len);
+
+		/* check value size */
+		if (entry->e_value_size > remain)
+			return EXT2_ET_EA_BAD_VALUE_SIZE;
+
+		/* e_value_block must be 0 in inode's ea */
+		if (entry->e_value_block != 0)
+			return EXT2_ET_BAD_EA_BLOCK_NUM;
+
+		hash = ext2fs_ext_attr_hash_entry(entry, value_start +
+							 entry->e_value_offs);
+
+		/* e_hash may be 0 in older inode's ea */
+		if (entry->e_hash != 0 && entry->e_hash != hash)
+			return EXT2_ET_BAD_EA_HASH;
+
+		remain -= entry->e_value_size;
+
+		/* Allocate space for more attrs? */
+		if (x == handle->attrs + handle->length) {
+			err = ext2fs_xattrs_expand(handle, 4);
+			if (err)
+				return err;
+			x = handle->attrs + handle->length - 4;
+		}
+
+		/* Extract name/value */
+		prefix = find_ea_prefix(entry->e_name_index);
+		prefix_len = (prefix ? strlen(prefix) : 0);
+		err = ext2fs_get_memzero(entry->e_name_len + prefix_len + 1,
+					 &x->name);
+		if (err)
+			return err;
+		if (prefix)
+			memcpy(x->name, prefix, prefix_len);
+		if (entry->e_name_len)
+			memcpy(x->name + prefix_len,
+			       (void *)entry + sizeof(*entry),
+			       entry->e_name_len);
+
+		err = ext2fs_get_mem(entry->e_value_size, &x->value);
+		if (err)
+			return err;
+		x->value_len = entry->e_value_size;
+		memcpy(x->value, value_start + entry->e_value_offs,
+		       entry->e_value_size);
+		x++;
+		entry = EXT2_EXT_ATTR_NEXT(entry);
+	}
+
+	return 0;
+}
+
+errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
+{
+	struct ext2_xattr *attrs = NULL, *x;
+	unsigned int attrs_len;
+	struct ext2_inode_large *inode;
+	struct ext2_ext_attr_header *header;
+	__u32 ea_inode_magic;
+	unsigned int storage_size;
+	void *start, *block_buf = NULL;
+	blk64_t blk;
+	int i;
+	errcode_t err;
+
+	if (!EXT2_HAS_COMPAT_FEATURE(handle->fs->super,
+				     EXT2_FEATURE_COMPAT_EXT_ATTR))
+		return 0;
+
+	i = EXT2_INODE_SIZE(handle->fs->super);
+	if (i < sizeof(*inode))
+		i = sizeof(*inode);
+	err = ext2fs_get_memzero(i, &inode);
+	if (err)
+		return err;
+
+	err = ext2fs_read_inode_full(handle->fs, handle->ino,
+				     (struct ext2_inode *)inode,
+				     EXT2_INODE_SIZE(handle->fs->super));
+	if (err)
+		goto out;
+
+	/* Does the inode have size for EA? */
+	if (EXT2_INODE_SIZE(handle->fs->super) <= EXT2_GOOD_OLD_INODE_SIZE +
+						  inode->i_extra_isize +
+						  sizeof(__u32))
+		goto read_ea_block;
+
+	/* Look for EA in the inode */
+	memcpy(&ea_inode_magic, ((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
+	       inode->i_extra_isize, sizeof(__u32));
+	if (ea_inode_magic == EXT2_EXT_ATTR_MAGIC) {
+		storage_size = EXT2_INODE_SIZE(handle->fs->super) -
+			EXT2_GOOD_OLD_INODE_SIZE - inode->i_extra_isize -
+			sizeof(__u32);
+		start = ((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
+			inode->i_extra_isize + sizeof(__u32);
+
+		err = read_xattrs_from_buffer(handle, start, storage_size,
+					      start);
+		if (err)
+			goto out;
+	}
+
+read_ea_block:
+	/* Look for EA in a separate EA block */
+	blk = ext2fs_file_acl_block(handle->fs, (struct ext2_inode *)inode);
+	if (blk != 0) {
+		if ((blk < handle->fs->super->s_first_data_block) ||
+		    (blk >= ext2fs_blocks_count(handle->fs->super))) {
+			err = EXT2_ET_BAD_EA_BLOCK_NUM;
+			goto out;
+		}
+
+		err = ext2fs_get_mem(handle->fs->blocksize, &block_buf);
+		if (err)
+			goto out;
+
+		err = ext2fs_read_ext_attr3(handle->fs, blk, block_buf,
+					    handle->ino);
+		if (err)
+			goto out3;
+
+		header = (struct ext2_ext_attr_header *) block_buf;
+		if (header->h_magic != EXT2_EXT_ATTR_MAGIC) {
+			err = EXT2_ET_BAD_EA_HEADER;
+			goto out3;
+		}
+
+		if (header->h_blocks != 1) {
+			err = EXT2_ET_BAD_EA_HEADER;
+			goto out3;
+		}
+
+		/* Read EAs */
+		storage_size = handle->fs->blocksize -
+			sizeof(struct ext2_ext_attr_header);
+		start = block_buf + sizeof(struct ext2_ext_attr_header);
+		err = read_xattrs_from_buffer(handle, start, storage_size,
+					      block_buf);
+		if (err)
+			goto out3;
+
+		ext2fs_free_mem(&block_buf);
+	}
+
+	ext2fs_free_mem(&block_buf);
+	ext2fs_free_mem(&inode);
+	return 0;
+
+out3:
+	ext2fs_free_mem(&block_buf);
+out:
+	ext2fs_free_mem(&inode);
+	return err;
+}
+
+#define XATTR_ABORT	1
+#define XATTR_CHANGED	2
+errcode_t ext2fs_xattrs_iterate(struct ext2_xattr_handle *h,
+				int (*func)(char *name, char *value,
+					    void *data),
+				void *data)
+{
+	struct ext2_xattr *x;
+	errcode_t err;
+	int ret;
+
+	for (x = h->attrs; x < h->attrs + h->length; x++) {
+		if (!x->name)
+			continue;
+
+		ret = func(x->name, x->value, data);
+		if (ret & XATTR_CHANGED)
+			h->dirty = 1;
+		if (ret & XATTR_ABORT)
+			return 0;
+	}
+
+	return 0;
+}
+
+errcode_t ext2fs_xattr_get(struct ext2_xattr_handle *h, const char *key,
+			   void **value, unsigned int *value_len)
+{
+	struct ext2_xattr *x;
+	void *val;
+	errcode_t err;
+
+	for (x = h->attrs; x < h->attrs + h->length; x++) {
+		if (!x->name)
+			continue;
+
+		if (strcmp(x->name, key) == 0) {
+			err = ext2fs_get_mem(x->value_len, &val);
+			if (err)
+				return err;
+			memcpy(val, x->value, x->value_len);
+			*value = val;
+			*value_len = x->value_len;
+			return 0;
+		}
+	}
+
+	return EXT2_ET_EA_KEY_NOT_FOUND;
+}
+
+errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
+			   const char *key,
+			   const void *value,
+			   unsigned int value_len)
+{
+	struct ext2_xattr *x, *last_empty;
+	char *new_value;
+	errcode_t err;
+
+	last_empty = NULL;
+	for (x = handle->attrs; x < handle->attrs + handle->length; x++) {
+		if (!x->name) {
+			last_empty = x;
+			continue;
+		}
+
+		/* Replace xattr */
+		if (strcmp(x->name, key) == 0) {
+			err = ext2fs_get_mem(value_len, &new_value);
+			if (err)
+				return err;
+			memcpy(new_value, value, value_len);
+			ext2fs_free_mem(&x->value);
+			x->value = new_value;
+			x->value_len = value_len;
+			handle->dirty = 1;
+			return 0;
+		}
+	}
+
+	/* Add attr to empty slot */
+	if (last_empty) {
+		err = ext2fs_get_mem(strlen(key) + 1, &last_empty->name);
+		if (err)
+			return err;
+		strcpy(last_empty->name, key);
+
+		err = ext2fs_get_mem(value_len, &last_empty->value);
+		if (err)
+			return err;
+		memcpy(last_empty->value, value, value_len);
+		last_empty->value_len = value_len;
+		handle->dirty = 1;
+		return 0;
+	}
+
+	/* Expand array, append slot */
+	err = ext2fs_xattrs_expand(handle, 4);
+	if (err)
+		return err;
+
+	x = handle->attrs + handle->length - 4;
+	err = ext2fs_get_mem(strlen(key) + 1, &x->name);
+	if (err)
+		return err;
+	strcpy(x->name, key);
+
+	err = ext2fs_get_mem(value_len, &x->value);
+	if (err)
+		return err;
+	memcpy(x->value, value, value_len);
+	x->value_len = value_len;
+	handle->dirty = 1;
+	return 0;
+}
+
+errcode_t ext2fs_xattr_remove(struct ext2_xattr_handle *handle,
+			      const char *key)
+{
+	struct ext2_xattr *x;
+	errcode_t err;
+
+	for (x = handle->attrs; x < handle->attrs + handle->length; x++) {
+		if (!x->name)
+			continue;
+
+		if (strcmp(x->name, key) == 0) {
+			ext2fs_free_mem(&x->name);
+			ext2fs_free_mem(&x->value);
+			x->value_len = 0;
+			handle->dirty = 1;
+			return 0;
+		}
+	}
+
+	return EXT2_ET_EA_KEY_NOT_FOUND;
+}
+
+errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
+			     struct ext2_xattr_handle **handle)
+{
+	struct ext2_xattr_handle *h;
+	errcode_t err;
+
+	err = ext2fs_get_memzero(sizeof(*h), &h);
+	if (err)
+		return err;
+
+	h->length = 4;
+	err = ext2fs_get_arrayzero(h->length, sizeof(struct ext2_xattr),
+				   &h->attrs);
+	if (err) {
+		ext2fs_free_mem(&h);
+		return err;
+	}
+	h->ino = ino;
+	h->fs = fs;
+	*handle = h;
+	return 0;
+}
+
+errcode_t ext2fs_xattrs_close(struct ext2_xattr_handle **handle)
+{
+	unsigned int i;
+	struct ext2_xattr_handle *h = *handle;
+	struct ext2_xattr *a = h->attrs;
+	errcode_t err;
+
+	if (h->dirty) {
+		err = ext2fs_xattrs_write(h);
+		if (err)
+			return err;
+	}
+
+	for (i = 0; i < h->length; i++) {
+		if (a[i].name)
+			ext2fs_free_mem(&a[i].name);
+		if (a[i].value)
+			ext2fs_free_mem(&a[i].value);
+	}
+
+	ext2fs_free_mem(&h->attrs);
+	ext2fs_free_mem(handle);
+	return 0;
+}

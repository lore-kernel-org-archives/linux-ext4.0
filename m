From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] add ext4 inode inline data support to grub2
Date: Wed, 06 Mar 2013 11:13:27 +0800
Message-ID: <5136B457.1060805@tao.ma>
References: <1362508235-4656-1-git-send-email-arvidjaar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: grub-devel@gnu.org, linux-ext4@vger.kernel.org
To: Andrey Borzenkov <arvidjaar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:46922 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750780Ab3CFDNk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Mar 2013 22:13:40 -0500
In-Reply-To: <1362508235-4656-1-git-send-email-arvidjaar@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andrey,
	Thanks for the effort.
On 03/06/2013 02:30 AM, Andrey Borzenkov wrote:
> Add support for reading inode inline data as supported by ext4
> as of linux kernel 3.8.
> 
> grub_ext2_inode_read() - read full inode (not only minimal compatible
> ext2 part) and use it to search for inline data. Additionally it
> saves inode block and offset for later use in grub_ext2_file_read for
> inline data.
> 
> grub_ext2_find_inline_data() - search for extended attribute "data" in
> system namespace. if present, inode has inline data. Calculate offset
> and store it and size. Non-zero offset is used as flag that inline data
> is present.
> 
> grub_ext2_file_read() - if inode has inline data, it is stored in up
> to two chunks - in place of block pointers and in available space after
> inode proper. It uses standard grub_disk_read() so all hooks are called
> if present.
> 
> To actually create inline data EXT4_FEATURE_INCOMPAT_INLINE_DATA must
> be present in superblock. As of today e2fsprogs refuse to touch filesystem
> if this flag is present; the only way to set it is to use debugfs
> directly.
I guess you can use the dev branch of e2fsprogs.git so that mkfs can
build an inline data enabled volume for you? That test would be more
realistic. :)

Anyway, the codes look good to me.

Thanks,
Tao
> 
> Patch was lightly tested using grub-fstest on a ext4 image created under
> 3.8 with EXT4_FEATURE_INCOMPAT_INLINE_DATA set using debugfs. Tested were
> inline files, inline directories and inline symlinks.
> 
> Signed-off-by: Andrey Borzenkov <arvidjaar@gmail.com>
> 
> ---
>  grub-core/fs/ext2.c |  255 ++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 214 insertions(+), 41 deletions(-)
> 
> diff --git a/grub-core/fs/ext2.c b/grub-core/fs/ext2.c
> index 18429ac..7304891 100644
> --- a/grub-core/fs/ext2.c
> +++ b/grub-core/fs/ext2.c
> @@ -89,6 +89,9 @@ GRUB_MOD_LICENSE ("GPLv3+");
>  #define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0010
>  #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
>  #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
> +#define EXT4_FEATURE_RO_COMPAT_QUOTA            0x0100
> +#define EXT4_FEATURE_RO_COMPAT_BIGALLOC         0x0200
> +#define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM    0x0400
>  /* Superblock filesystem feature flags (back-incompatible)
>   * A filesystem with any of these enabled should not be attempted to be read
>   * by a driver that does not understand them, since they usually indicate
> @@ -101,13 +104,19 @@ GRUB_MOD_LICENSE ("GPLv3+");
>  #define EXT4_FEATURE_INCOMPAT_EXTENTS		0x0040 /* Extents used */
>  #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
>  #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
> +#define EXT4_FEATURE_INCOMPAT_EA_INODE          0x0400 /* EA in inode */
> +#define EXT4_FEATURE_INCOMPAT_DIRDATA           0x1000 /* data in dirent */
> +#define EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM  0x2000 /* use crc32c for bg */
> +#define EXT4_FEATURE_INCOMPAT_LARGEDIR          0x4000 /* >2GB or 3-lvl htree */
> +#define EXT4_FEATURE_INCOMPAT_INLINE_DATA       0x8000 /* data in inode */
>  
>  /* The set of back-incompatible features this driver DOES support. Add (OR)
>   * flags here as the related features are implemented into the driver.  */
>  #define EXT2_DRIVER_SUPPORTED_INCOMPAT ( EXT2_FEATURE_INCOMPAT_FILETYPE \
>                                         | EXT4_FEATURE_INCOMPAT_EXTENTS  \
>                                         | EXT4_FEATURE_INCOMPAT_FLEX_BG \
> -                                       | EXT4_FEATURE_INCOMPAT_64BIT)
> +                                       | EXT4_FEATURE_INCOMPAT_64BIT \
> +				       | EXT4_FEATURE_INCOMPAT_INLINE_DATA)
>  /* List of rationales for the ignored "incompatible" features:
>   * needs_recovery: Not really back-incompatible - was added as such to forbid
>   *                 ext2 drivers from mounting an ext3 volume with a dirty
> @@ -308,12 +317,40 @@ struct grub_ext4_extent_idx
>    grub_uint16_t unused;
>  };
>  
> +#define EXT4_XATTR_MAGIC	0xEA020000
> +#define EXT4_XATTR_INDEX_SYSTEM	7
> +#define EXT4_XATTR_SYSTEM_DATA	"data"
> +#define EXT4_INLINE_DOTDOT_SIZE	4
> +
> +struct grub_ext4_xattr_entry
> +{
> +  grub_uint8_t name_len;	/* length of name */
> +  grub_uint8_t name_index;	/* attribute name index */
> +  grub_uint16_t value_offs;	/* offset in disk block of value */
> +  grub_uint32_t value_block;	/* disk block attribute is stored on */
> +  grub_uint32_t value_size;	/* size of attribute value */
> +  grub_uint32_t hash;		/* hash value of name and value */
> +  char name[0];			/* attribute name */
> +};
> +
> +#define EXT4_XATTR_LEN(name_len) \
> +  (((name_len) + sizeof(struct grub_ext4_xattr_entry) + 3) & ~3)
> +#define EXT4_XATTR_NEXT(entry) \
> +  ((struct grub_ext4_xattr_entry *)( \
> +   (char *)(entry) + EXT4_XATTR_LEN((entry)->name_len)))
> +#define IS_LAST_ENTRY(entry) (*(grub_uint32_t *)(entry) == 0)
> +
> +
>  struct grub_fshelp_node
>  {
>    struct grub_ext2_data *data;
>    struct grub_ext2_inode inode;
>    int ino;
>    int inode_read;
> +  grub_disk_addr_t inode_base;	/* Inode filesystem block */
> +  grub_off_t inode_offs;	/* Inode offset in filesystem block */
> +  grub_off_t inline_offs;	/* Offset of inline data from start of inode */
> +  grub_size_t inline_size;	/* Size of inline data */
>  };
>  
>  /* Information about a "mounted" ext2 filesystem.  */
> @@ -330,6 +367,61 @@ static grub_dl_t my_mod;
>  
>  


>  
> +/* Inline data is stored using inline extended attributes. Attributes consist
> +   of entry and value. Entries start after inode proper, following 4 bytes
> +   magic header. Each entry is 4 bytes aligned, end of list is marked with
> +   4 bytes zero. Values are stored after entries.
> +   
> +   Inline data is stored as system attribute with name "data". First part of
> +   data is kept in space reserved for block pointers, so it is valid for value
> +   size to be zero. Offset is apparently non-zero even in this case.
> + */
> +inline static void
> +grub_ext2_find_inline_data (struct grub_fshelp_node *node, grub_size_t isize, grub_uint8_t *inode)
> +{
> +  grub_size_t extra;
> +  grub_uint32_t *ihdr;
> +  struct grub_ext4_xattr_entry *entry;
> +  grub_uint8_t *iend = inode + isize - sizeof (grub_uint32_t);
> +
> +  node->inline_offs = 0;
> +
> +  if (isize < EXT2_GOOD_OLD_INODE_SIZE + sizeof (grub_uint16_t))
> +    return;
> +  extra = grub_le_to_cpu16 (*(grub_uint16_t *)(inode + EXT2_GOOD_OLD_INODE_SIZE));
> +  if (EXT2_GOOD_OLD_INODE_SIZE + extra + sizeof (*ihdr) > isize)
> +    return;
> +  ihdr = (grub_uint32_t *)(inode + EXT2_GOOD_OLD_INODE_SIZE + extra);
> +  if (*ihdr != grub_cpu_to_le32_compile_time (EXT4_XATTR_MAGIC))
> +    return;
> +  entry = (struct grub_ext4_xattr_entry *)(ihdr + 1);
> +  for (; (grub_uint8_t *)entry < iend && !IS_LAST_ENTRY(entry); entry = EXT4_XATTR_NEXT(entry))
> +    {
> +      grub_size_t value_size;
> +      grub_off_t value_offs;
> +
> +      if (entry->value_block)
> +	continue;
> +      if (entry->name_index != EXT4_XATTR_INDEX_SYSTEM)
> +	continue;
> +      if (entry->name_len != sizeof (EXT4_XATTR_SYSTEM_DATA) - 1)
> +	continue;
> +      if (grub_memcmp (entry->name, EXT4_XATTR_SYSTEM_DATA, sizeof (EXT4_XATTR_SYSTEM_DATA) - 1))
> +	continue;
> +      value_size = grub_le_to_cpu32 (entry->value_size);
> +      value_offs = grub_le_to_cpu16 (entry->value_offs);
> +      /* extra is additional size of base inode. Extended attributes start
> +	 after base inode, offset is calculated from the end of extended
> +	 attributes header.
> +      */
> +      if (EXT2_GOOD_OLD_INODE_SIZE + extra + sizeof (*ihdr) + value_offs + value_size > isize)
> +	continue;
> +      node->inline_offs = EXT2_GOOD_OLD_INODE_SIZE + extra + sizeof (*ihdr) + value_offs;
> +      node->inline_size = value_size;
> +      return;
> +    }
> +}
> +
>  /* Read into BLKGRP the blockgroup descriptor of blockgroup GROUP of
>     the mounted filesystem DATA.  */
>  inline static grub_err_t
> @@ -528,6 +620,52 @@ grub_ext2_read_file (grub_fshelp_node_t node,
>  		     grub_disk_read_hook_t read_hook, void *read_hook_data,
>  		     grub_off_t pos, grub_size_t len, char *buf)
>  {
> +  /* Does inode have inine data? */
> +  if (node->inline_offs)
> +    {
> +      grub_size_t cp_len;
> +      grub_off_t cp_pos;
> +      grub_ssize_t total = 0;
> +
> +      if (pos < 60)
> +	{
> +	  cp_pos = node->inode_offs + ((char *)&node->inode.blocks - (char *)&node->inode) + pos;
> +	  cp_len = 60 - pos;
> +	  if (cp_len > len)
> +	    cp_len = len;
> +
> +	  node->data->disk->read_hook = read_hook;
> +	  node->data->disk->read_hook_data = read_hook_data;
> +	  grub_disk_read (node->data->disk, node->inode_base, cp_pos,
> +			  cp_len, buf);
> +	  node->data->disk->read_hook = 0;
> +	  if (grub_errno)
> +	    return -1;
> +	  pos += cp_len;
> +	  buf += cp_len;
> +	  len -= cp_len;
> +	  total = cp_len;
> +	}
> +
> +      if (len)
> +	{
> +	  pos -= 60;
> +	  if (pos >= node->inline_size)
> +	    return 0;
> +	  if (pos + len > node->inline_size)
> +	    len = node->inline_size - pos;
> +	  cp_pos = node->inode_offs + node->inline_offs + pos;
> +	  node->data->disk->read_hook = read_hook;
> +	  node->data->disk->read_hook_data = read_hook_data;
> +	  grub_disk_read (node->data->disk, node->inode_base, cp_pos,
> +			  len, buf);
> +	  node->data->disk->read_hook = 0;
> +          if (!grub_errno)
> +	    total += len;
> +	}
> +      return total;
> +    }
> +	  
>    return grub_fshelp_read_file (node->data->disk, node,
>  				read_hook, read_hook_data,
>  				pos, len, buf, grub_ext2_read_block,
> @@ -538,17 +676,28 @@ grub_ext2_read_file (grub_fshelp_node_t node,
>  }
>  
>  
> -/* Read the inode INO for the file described by DATA into INODE.  */
> +/* Read the inode NODE->INO for the file described by NODE->DATA into NODE->INODE.  */
>  static grub_err_t
> -grub_ext2_read_inode (struct grub_ext2_data *data,
> -		      int ino, struct grub_ext2_inode *inode)
> +grub_ext2_read_inode (struct grub_fshelp_node *node)
>  {
> +  struct grub_ext2_data *data = node->data;
> +  int ino = node->ino;
>    struct grub_ext2_block_group blkgrp;
>    struct grub_ext2_sblock *sblock = &data->sblock;
>    int inodes_per_block;
>    unsigned int blkno;
>    unsigned int blkoff;
>    grub_disk_addr_t base;
> +  grub_uint8_t *full_inode;
> +  grub_size_t full_isize;
> +
> +  if (node->inode_read)
> +    return 0;
> +
> +  full_isize = EXT2_INODE_SIZE (data);
> +  full_inode = grub_malloc (full_isize);
> +  if (!full_inode)
> +    return 0;
>  
>    /* It is easier to calculate if the first inode is 0.  */
>    ino--;
> @@ -557,9 +706,12 @@ grub_ext2_read_inode (struct grub_ext2_data *data,
>                          ino / grub_le_to_cpu32 (sblock->inodes_per_group),
>  			&blkgrp);
>    if (grub_errno)
> -    return grub_errno;
> +    {
> +      grub_free (full_inode);
> +      return grub_errno;
> +    }
>  
> -  inodes_per_block = EXT2_BLOCK_SIZE (data) / EXT2_INODE_SIZE (data);
> +  inodes_per_block = EXT2_BLOCK_SIZE (data) / full_isize;
>    blkno = (ino % grub_le_to_cpu32 (sblock->inodes_per_group))
>      / inodes_per_block;
>    blkoff = (ino % grub_le_to_cpu32 (sblock->inodes_per_group))
> @@ -571,12 +723,18 @@ grub_ext2_read_inode (struct grub_ext2_data *data,
>  	     << 32);
>  
>    /* Read the inode.  */
> -  if (grub_disk_read (data->disk,
> -		      ((base + blkno) << LOG2_EXT2_BLOCK_SIZE (data)),
> -		      EXT2_INODE_SIZE (data) * blkoff,
> -		      sizeof (struct grub_ext2_inode), inode))
> -    return grub_errno;
> +  node->inode_base = (base + blkno) << LOG2_EXT2_BLOCK_SIZE (data);
> +  node->inode_offs = full_isize * blkoff;
> +  if (grub_disk_read (data->disk, node->inode_base, node->inode_offs,
> +		      full_isize, full_inode))
> +    {
> +      grub_free (full_inode);
> +      return grub_errno;
> +    }
> +  grub_memcpy (&node->inode, full_inode, sizeof (struct grub_ext2_inode));
>  
> +  node->inode_read = 1;
> +  grub_ext2_find_inline_data (node, full_isize, full_inode);
>    return 0;
>  }
>  
> @@ -632,11 +790,9 @@ grub_ext2_mount (grub_disk_t disk)
>  
>    data->diropen.data = data;
>    data->diropen.ino = 2;
> -  data->diropen.inode_read = 1;
> -
>    data->inode = &data->diropen.inode;
>  
> -  grub_ext2_read_inode (data, 2, data->inode);
> +  grub_ext2_read_inode (&data->diropen);
>    if (grub_errno)
>      goto fail;
>  
> @@ -656,12 +812,9 @@ grub_ext2_read_symlink (grub_fshelp_node_t node)
>    char *symlink;
>    struct grub_fshelp_node *diro = node;
>  
> -  if (! diro->inode_read)
> -    {
> -      grub_ext2_read_inode (diro->data, diro->ino, &diro->inode);
> -      if (grub_errno)
> -	return 0;
> -    }
> +  grub_ext2_read_inode (diro);
> +  if (grub_errno)
> +    return 0;
>  
>    symlink = grub_malloc (grub_le_to_cpu32 (diro->inode.size) + 1);
>    if (! symlink)
> @@ -697,11 +850,42 @@ grub_ext2_iterate_dir (grub_fshelp_node_t dir,
>    unsigned int fpos = 0;
>    struct grub_fshelp_node *diro = (struct grub_fshelp_node *) dir;
>  
> -  if (! diro->inode_read)
> +  grub_ext2_read_inode (diro);
> +  if (grub_errno)
> +    return 0;
> +
> +  /* Inline directory has only parent inode number and no explicit entries
> +     for . or ..; simulate them */
> +  if (diro->inline_offs)
>      {
> -      grub_ext2_read_inode (diro->data, diro->ino, &diro->inode);
> +      struct grub_fshelp_node *dot, *dotdot;
> +      grub_uint32_t inum;
> +
> +      dot = grub_malloc (sizeof (struct grub_fshelp_node));
> +      if (!dot)
> +	return 0;
> +
> +      dot->inode_read = 0;
> +      dot->ino = dir->ino;
> +      dot->data = diro->data;
> +      if (hook (".", FILETYPE_DIRECTORY, dot, hook_data))
> +	return 1;
> +
> +      /* First 4 bytes of inline directory data is parent inode number */
> +      grub_ext2_read_file (diro, 0, 0, 0, EXT4_INLINE_DOTDOT_SIZE, (char *) &inum);
>        if (grub_errno)
>  	return 0;
> +      dotdot = grub_malloc (sizeof (struct grub_fshelp_node));
> +      if (!dotdot)
> +	return 0;
> +
> +      dotdot->inode_read = 0;
> +      dotdot->ino = grub_le_to_cpu32 (inum);
> +      dotdot->data = diro->data;
> +      if (hook ("..", FILETYPE_DIRECTORY, dotdot, hook_data))
> +	return 1;
> +
> +      fpos = EXT4_INLINE_DOTDOT_SIZE;
>      }
>  
>    /* Search the file.  */
> @@ -752,17 +936,13 @@ grub_ext2_iterate_dir (grub_fshelp_node_t dir,
>  	    {
>  	      /* The filetype can not be read from the dirent, read
>  		 the inode to get more information.  */
> -	      grub_ext2_read_inode (diro->data,
> -                                    grub_le_to_cpu32 (dirent.inode),
> -				    &fdiro->inode);
> +	      grub_ext2_read_inode (fdiro);
>  	      if (grub_errno)
>  		{
>  		  grub_free (fdiro);
>  		  return 0;
>  		}
>  
> -	      fdiro->inode_read = 1;
> -
>  	      if ((grub_le_to_cpu16 (fdiro->inode.mode)
>  		   & FILETYPE_INO_MASK) == FILETYPE_INO_DIRECTORY)
>  		type = GRUB_FSHELP_DIR;
> @@ -807,14 +987,11 @@ grub_ext2_open (struct grub_file *file, const char *name)
>    if (err)
>      goto fail;
>  
> -  if (! fdiro->inode_read)
> -    {
> -      err = grub_ext2_read_inode (data, fdiro->ino, &fdiro->inode);
> -      if (err)
> -	goto fail;
> -    }
> +  err = grub_ext2_read_inode (fdiro);
> +  if (err)
> +    goto fail;
>  
> -  grub_memcpy (data->inode, &fdiro->inode, sizeof (struct grub_ext2_inode));
> +  grub_memcpy (&data->diropen, fdiro, sizeof (struct grub_fshelp_node));
>    grub_free (fdiro);
>  
>    file->size = grub_le_to_cpu32 (data->inode->size);
> @@ -873,13 +1050,9 @@ grub_ext2_dir_iter (const char *filename, enum grub_fshelp_filetype filetype,
>    struct grub_dirhook_info info;
>  
>    grub_memset (&info, 0, sizeof (info));
> -  if (! node->inode_read)
> -    {
> -      grub_ext2_read_inode (ctx->data, node->ino, &node->inode);
> -      if (!grub_errno)
> -	node->inode_read = 1;
> -      grub_errno = GRUB_ERR_NONE;
> -    }
> +  grub_ext2_read_inode (node);
> +  grub_errno = GRUB_ERR_NONE;
> +
>    if (node->inode_read)
>      {
>        info.mtimeset = 1;
> 


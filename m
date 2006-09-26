From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: [patch 11/12] rfc: 2fsprogs update
Date: Tue, 26 Sep 2006 16:50:32 +0200
Message-ID: <20060926145032.GK25755@openx1.frec.bull.fr>
References: <20060926143343.GA20020@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:61066 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S932107AbWIZOul
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Sep 2006 10:50:41 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 9B6A219D915
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 16:50:37 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 12580-03 for <linux-ext4@vger.kernel.org>;
 Tue, 26 Sep 2006 16:50:34 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 9DDCB19D90C
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 16:50:33 +0200 (CEST)
To: linux-ext4@vger.kernel.org
In-Reply-To: <20060926143343.GA20020@openx1.frec.bull.fr>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

allow larger block group descriptors

Signed-off-by: Alexandre Ratchov <alexandre.ratchov@bull.net>              

Index: e2fsprogs-1.39/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/ext2fs.h	2006-09-22 15:52:50.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/ext2fs.h	2006-09-22 15:53:09.000000000 +0200
@@ -213,6 +213,7 @@ struct struct_ext2_filsys {
 	char *				device_name;
 	struct ext2_super_block	* 	super;
 	unsigned int			blocksize;
+	unsigned int			desc_size;
 	int				fragsize;
 	dgrp_t				group_desc_count;
 	unsigned long			desc_blocks;
Index: e2fsprogs-1.39/lib/ext2fs/swapfs.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/swapfs.c	2006-09-22 15:52:50.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/swapfs.c	2006-09-22 15:53:09.000000000 +0200
@@ -63,6 +63,7 @@ void ext2fs_swap_super(struct ext2_super
 	sb->s_journal_inum = ext2fs_swab32(sb->s_journal_inum);
 	sb->s_journal_dev = ext2fs_swab32(sb->s_journal_dev);
 	sb->s_last_orphan = ext2fs_swab32(sb->s_last_orphan);
+	sb->s_desc_size = ext2fs_swab16(sb->s_desc_size);
 	sb->s_default_mount_opts = ext2fs_swab32(sb->s_default_mount_opts);
 	sb->s_first_meta_bg = ext2fs_swab32(sb->s_first_meta_bg);
 	sb->s_mkfs_time = ext2fs_swab32(sb->s_mkfs_time);
Index: e2fsprogs-1.39/misc/mke2fs.c
===================================================================
--- e2fsprogs-1.39.orig/misc/mke2fs.c	2006-09-22 15:52:50.000000000 +0200
+++ e2fsprogs-1.39/misc/mke2fs.c	2006-09-22 15:53:09.000000000 +0200
@@ -94,7 +94,7 @@ int linux_version_code = 0;
 static void usage(void)
 {
 	fprintf(stderr, _("Usage: %s [-c|-t|-l filename] [-b block-size] "
-	"[-f fragment-size]\n\t[-i bytes-per-inode] [-I inode-size] "
+	"[-f fragment-size]\n\t[-i bytes-per-inode] [-I inode-size] [-D descriptor-size]"
 	"[-j] [-J journal-options]\n"
 	"\t[-N number-of-inodes] [-m reserved-blocks-percentage] "
 	"[-o creator-os]\n\t[-g blocks-per-group] [-L volume-label] "
@@ -680,6 +680,8 @@ static void show_stats(ext2_filsys fs)
 		s->s_log_block_size);
 	printf(_("Fragment size=%u (log=%u)\n"), fs->fragsize,
 		s->s_log_frag_size);
+	if (s->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		printf(_("Descriptor size=%u\n"), fs->desc_size);
 	printf(_("%u inodes, %llu blocks\n"), s->s_inodes_count,
 	       EXT2_BLOCKS_COUNT(s));
 	printf(_("%llu blocks (%2.2f%%) reserved for the super user\n"),
@@ -689,7 +691,7 @@ static void show_stats(ext2_filsys fs)
 	if (s->s_reserved_gdt_blocks)
 		printf(_("Maximum filesystem blocks=%llu\n"),
 		       (blk_t)((s->s_reserved_gdt_blocks + fs->desc_blocks) *
-		       (fs->blocksize / sizeof(struct ext2_group_desc)) *
+		       (fs->blocksize / fs->desc_size) *
 		       s->s_blocks_per_group));
 	if (fs->group_desc_count > 1)
 		printf(_("%u block groups\n"), fs->group_desc_count);
@@ -822,7 +824,7 @@ static void parse_extended_opts(struct e
 			bpg = param->s_blocks_per_group;
 			if (!bpg)
 				bpg = blocksize * 8;
-			gdpb = blocksize / sizeof(struct ext2_group_desc);
+			gdpb = blocksize / EXT2_DESC_SIZE(param);
 			group_desc_count = 
 				ext2fs_div_ceil(EXT2_BLOCKS_COUNT(param), bpg);
 			desc_blocks = (group_desc_count +
@@ -861,7 +863,8 @@ static __u32 ok_features[3] = {
 		EXT2_FEATURE_COMPAT_LAZY_BG,	/* Compat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE|		/* Incompat */
 		EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|
-		EXT2_FEATURE_INCOMPAT_META_BG,
+		EXT2_FEATURE_INCOMPAT_META_BG|
+		EXT4_FEATURE_INCOMPAT_64BIT,
 	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	/* R/O compat */
 };
 
@@ -896,6 +899,7 @@ static void PRS(int argc, char *argv[])
 	int		blocksize = 0;
 	int		inode_ratio = 0;
 	int		inode_size = 0;
+	int		desc_size = 0;
 	double		reserved_ratio = 5.0;
 	int		sector_size = 0;
 	int		show_version_only = 0;
@@ -971,7 +975,7 @@ static void PRS(int argc, char *argv[])
 	}
 
 	while ((c = getopt (argc, argv,
-		    "b:cf:g:i:jl:m:no:qr:s:tvE:FI:J:L:M:N:O:R:ST:V")) != EOF) {
+		    "b:cf:g:i:jl:m:no:qr:s:tvD:E:FI:J:L:M:N:O:R:ST:V")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocksize = strtol(optarg, &tmp, 0);
@@ -1088,6 +1092,14 @@ static void PRS(int argc, char *argv[])
 				exit(1);
 			}
 			break;
+		case 'D':
+			desc_size = strtoul(optarg, &tmp, 0);
+			if (*tmp) {
+				com_err(program_name, 0,
+					_("invalid descriptor size - %s"), optarg);
+				exit(1);
+			}
+			break;
 		case 'v':
 			verbose = 1;
 			break;
@@ -1252,7 +1264,10 @@ static void PRS(int argc, char *argv[])
 				exit(1);
 			}
 			if (dev_size >> 31) {
-				fs_param.s_feature_incompat |= EXT4_FEATURE_INCOMPAT_64BIT;
+				fs_param.s_feature_incompat |= 
+					EXT4_FEATURE_INCOMPAT_64BIT;
+				fs_param.s_desc_size = 
+					EXT2_MIN_DESC_SIZE_64BIT;
 			}
 			EXT2_BLOCKS_COUNT_SET(&fs_param, dev_size);
 			if (sys_page_size > EXT2_BLOCK_SIZE(&fs_param))
@@ -1438,6 +1453,26 @@ static void PRS(int argc, char *argv[])
 				inode_size);
 		fs_param.s_inode_size = inode_size;
 	}
+	
+	if (desc_size) {
+		unsigned desc_size_min;
+		
+		if (fs_param.s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+			desc_size_min = EXT2_MIN_DESC_SIZE_64BIT;
+		else
+			desc_size_min = EXT2_MIN_DESC_SIZE;
+		
+		if (desc_size < desc_size_min ||
+		    desc_size > EXT2_MAX_DESC_SIZE ||
+		    desc_size & (desc_size - 1)) {
+			com_err(program_name, 0,
+			    _("invalid descriptor size %d (min %d/max %d)"),
+			    desc_size, EXT2_MIN_DESC_SIZE,
+			    EXT2_MAX_DESC_SIZE);
+			exit(1);
+		}
+		fs_param.s_desc_size = desc_size;
+	}
 
 	/* Make sure number of inodes specified will fit in 32 bits */
 	if (num_inodes == 0) {
Index: e2fsprogs-1.39/lib/ext2fs/openfs.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/openfs.c	2006-09-22 15:52:50.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/openfs.c	2006-09-22 15:53:09.000000000 +0200
@@ -39,7 +39,7 @@ blk_t ext2fs_descriptor_block_loc(ext2_f
 	    (i < fs->super->s_first_meta_bg))
 		return (group_block + i + 1);
 
-	bg = (fs->blocksize / sizeof (struct ext2_group_desc)) * i;
+	bg = (fs->blocksize / fs->desc_size) * i;
 	if (ext2fs_bg_has_super(fs, bg))
 		has_super = 1;
 	ret_blk = EXT2_GROUP_BASE(fs->super, bg) + has_super;
@@ -87,8 +87,10 @@ errcode_t ext2fs_open2(const char *name,
 	unsigned long	i;
 	int		j, groups_per_block, blocks_per_group, io_flags;
 	blk_t		group_block, blk;
-	char		*dest, *cp;
+	char		*cp;
 	struct ext2_group_desc *gdp;
+	char		shadow_block[EXT2_MAX_BLOCK_SIZE];
+	size_t		desc_buflen;
 	
 	EXT2_CHECK_MAGIC(manager, EXT2_ET_MAGIC_IO_MANAGER);
 
@@ -231,6 +233,13 @@ errcode_t ext2fs_open2(const char *name,
 			goto cleanup;
 		}
 	}
+	
+	if (fs->super->s_feature_incompat & 
+	    EXT4_FEATURE_INCOMPAT_64BIT) {
+		fs->desc_size = EXT2_DESC_SIZE(fs->super);
+	} else {
+		fs->desc_size = EXT2_MIN_DESC_SIZE;
+	}
 	/*
 	 * Set the blocksize to the filesystem's blocksize.
 	 */
@@ -262,27 +271,32 @@ errcode_t ext2fs_open2(const char *name,
 					       blocks_per_group);
 	fs->desc_blocks = ext2fs_div_ceil(fs->group_desc_count,
 					  EXT2_DESC_PER_BLOCK(fs->super));
-	retval = ext2fs_get_mem(fs->desc_blocks * fs->blocksize,
-				&fs->group_desc);
+
+	desc_buflen = fs->desc_blocks * EXT2_DESC_PER_BLOCK(fs->super) *
+		sizeof(struct ext2_group_desc);
+	retval = ext2fs_get_mem(desc_buflen, &fs->group_desc);
 	if (retval)
 		goto cleanup;
+	memset(fs->group_desc, 0, desc_buflen);
+
 	if (!group_block)
 		group_block = fs->super->s_first_data_block;
-	dest = (char *) fs->group_desc;
-	groups_per_block = fs->blocksize / sizeof(struct ext2_group_desc);
+	gdp = fs->group_desc;
+	groups_per_block = fs->blocksize / fs->desc_size;
 	for (i=0 ; i < fs->desc_blocks; i++) {
 		blk = ext2fs_descriptor_block_loc(fs, group_block, i);
-		retval = io_channel_read_blk(fs->io, blk, 1, dest);
+		retval = io_channel_read_blk(fs->io, blk, 1, shadow_block);
 		if (retval)
 			goto cleanup;
+		
+		for (j=0; j < groups_per_block; j++) {
+			memcpy(gdp, shadow_block + j * fs->desc_size, fs->desc_size);
 #ifdef EXT2FS_ENABLE_SWAPFS
-		if (fs->flags & EXT2_FLAG_SWAP_BYTES) {
-			gdp = (struct ext2_group_desc *) dest;
-			for (j=0; j < groups_per_block; j++)
-				ext2fs_swap_group_desc(gdp++);
-		}
+			if (fs->flags & EXT2_FLAG_SWAP_BYTES)
+					ext2fs_swap_group_desc(gdp);
 #endif
-		dest += fs->blocksize;
+			gdp++;
+		}
 	}
 
 	*ret_fs = fs;
Index: e2fsprogs-1.39/lib/ext2fs/closefs.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/closefs.c	2006-09-22 15:52:50.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/closefs.c	2006-09-22 15:53:09.000000000 +0200
@@ -80,7 +80,7 @@ int ext2fs_super_and_bgd_loc(ext2_filsys
 		super_blk = group_block;
 		numblocks--;
 	}
-	meta_bg_size = (fs->blocksize / sizeof (struct ext2_group_desc));
+	meta_bg_size = (fs->blocksize / fs->desc_size);
 	meta_bg = group / meta_bg_size;
 
 	if (!(fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) ||
@@ -204,14 +204,14 @@ static errcode_t write_backup_super(ext2
 
 errcode_t ext2fs_flush(ext2_filsys fs)
 {
-	dgrp_t		i,j;
+	dgrp_t		i;
 	errcode_t	retval;
 	unsigned long	fs_state;
 	struct ext2_super_block *super_shadow = 0;
-	struct ext2_group_desc *group_shadow = 0;
-	struct ext2_group_desc *s, *t;
-	char	*group_ptr;
-	int	old_desc_blocks;
+	struct ext2_group_desc *gd;
+	char *desc_shadow = NULL;
+	size_t desc_buflen;
+	int old_desc_blocks;
 	
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -219,33 +219,36 @@ errcode_t ext2fs_flush(ext2_filsys fs)
 
 	fs->super->s_wtime = fs->now ? fs->now : time(NULL);
 	fs->super->s_block_group_nr = 0;
+
+	desc_buflen = fs->desc_blocks * fs->blocksize;
+	retval = ext2fs_get_mem(desc_buflen, &desc_shadow);
+	if (retval)
+		goto errout;
+	memset(desc_shadow, 0, desc_buflen);
+
+	/*
+	 * copy the group descriptors adjusting size to the
+	 * on-disk size. If needed, also bswap them on the fly
+	 */
+	for (i = 0; i < fs->group_desc_count; i++) {
+		gd = (struct ext2_group_desc *)(desc_shadow + i * fs->desc_size);
+		memcpy(gd, &fs->group_desc[i], fs->desc_size);
+#ifdef EXT2FS_ENABLE_SWAPFS
+		if (fs->flags & EXT2_FLAG_SWAP_BYTES)
+			ext2fs_swap_group_desc(gd);
+#endif
+	}
+
 #ifdef EXT2FS_ENABLE_SWAPFS
 	if (fs->flags & EXT2_FLAG_SWAP_BYTES) {
-		retval = EXT2_ET_NO_MEMORY;
 		retval = ext2fs_get_mem(SUPERBLOCK_SIZE, &super_shadow);
 		if (retval)
 			goto errout;
-		retval = ext2fs_get_mem((size_t)(fs->blocksize *
-						 fs->desc_blocks),
-					&group_shadow);
-		if (retval)
-			goto errout;
-		memset(group_shadow, 0, (size_t) fs->blocksize *
-		       fs->desc_blocks);
-
-		/* swap the group descriptors */
-		for (j=0, s=fs->group_desc, t=group_shadow;
-		     j < fs->group_desc_count; j++, t++, s++) {
-			*t = *s;
-			ext2fs_swap_group_desc(t);
-		}
 	} else {
 		super_shadow = fs->super;
-		group_shadow = fs->group_desc;
 	}
 #else
 	super_shadow = fs->super;
-	group_shadow = fs->group_desc;
 #endif
 	
 	/*
@@ -273,7 +276,6 @@ errcode_t ext2fs_flush(ext2_filsys fs)
 	 * Write out the master group descriptors, and the backup
 	 * superblocks and group descriptors.
 	 */
-	group_ptr = (char *) group_shadow;
 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
 		old_desc_blocks = fs->super->s_first_meta_bg;
 	else
@@ -297,13 +299,14 @@ errcode_t ext2fs_flush(ext2_filsys fs)
 		if ((old_desc_blk) && 
 		    (!(fs->flags & EXT2_FLAG_MASTER_SB_ONLY) || (i == 0))) {
 			retval = io_channel_write_blk(fs->io,
-			      old_desc_blk, old_desc_blocks, group_ptr);
+			      old_desc_blk, old_desc_blocks, desc_shadow);
 			if (retval)
 				goto errout;
 		}
 		if (new_desc_blk) {
-			retval = io_channel_write_blk(fs->io, new_desc_blk,
-				1, group_ptr + (meta_bg*fs->blocksize));
+			retval = io_channel_write_blk(
+				fs->io, new_desc_blk, 1, 
+				desc_shadow + meta_bg * fs->blocksize);
 			if (retval)
 				goto errout;
 		}
@@ -352,8 +355,8 @@ errout:
 	if (fs->flags & EXT2_FLAG_SWAP_BYTES) {
 		if (super_shadow)
 			ext2fs_free_mem(&super_shadow);
-		if (group_shadow)
-			ext2fs_free_mem(&group_shadow);
+		if (desc_shadow)
+			ext2fs_free_mem(&desc_shadow);
 	}
 	return retval;
 }
Index: e2fsprogs-1.39/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/ext2_fs.h	2006-09-22 15:52:50.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/ext2_fs.h	2006-09-22 18:23:10.000000000 +0200
@@ -225,6 +225,12 @@ struct ext2_dx_countlimit {
 /*
  * Macro-instructions used to manage group descriptors
  */
+#define EXT2_MIN_DESC_SIZE		32
+#define EXT2_MIN_DESC_SIZE_64BIT	64
+#define EXT2_MAX_DESC_SIZE		EXT2_MIN_BLOCK_SIZE
+#define EXT2_DESC_SIZE(s)						  \
+	((EXT2_SB(s)->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) ? \
+	 EXT2_SB(s)->s_desc_size : EXT2_MIN_DESC_SIZE)
 #define EXT2_BLOCKS_PER_GROUP(s)	((__u64)EXT2_SB(s)->s_blocks_per_group)
 #define EXT2_INODES_PER_GROUP(s)	(EXT2_SB(s)->s_inodes_per_group)
 #define EXT2_INODES_PER_BLOCK(s)	(EXT2_BLOCK_SIZE(s)/EXT2_INODE_SIZE(s))
@@ -235,7 +241,7 @@ struct ext2_dx_countlimit {
 #define EXT2_DESC_PER_BLOCK(s)		(EXT2_SB(s)->s_desc_per_block)
 #define EXT2_DESC_PER_BLOCK_BITS(s)	(EXT2_SB(s)->s_desc_per_block_bits)
 #else
-#define EXT2_DESC_PER_BLOCK(s)		(EXT2_BLOCK_SIZE(s) / sizeof (struct ext2_group_desc))
+#define EXT2_DESC_PER_BLOCK(s)		(EXT2_BLOCK_SIZE(s) / EXT2_DESC_SIZE(s))
 #endif
 
 /*
@@ -556,7 +562,7 @@ struct ext2_super_block {
 	__u32	s_hash_seed[4];		/* HTREE hash seed */
 	__u8	s_def_hash_version;	/* Default hash version to use */
 	__u8	s_jnl_backup_type; 	/* Default type of journal backup */
-	__u16	s_reserved_word_pad;
+	__u16	s_desc_size;		/* size of group descriptor */
 	__u32	s_default_mount_opts;
 	__u32	s_first_meta_bg;	/* First metablock group */
 	__u32	s_mkfs_time;		/* When the filesystem was created */
Index: e2fsprogs-1.39/lib/ext2fs/initialize.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/initialize.c	2006-09-22 15:52:50.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/initialize.c	2006-09-22 15:53:09.000000000 +0200
@@ -67,7 +67,7 @@ static unsigned int calc_reserved_gdt_bl
 {
 	struct ext2_super_block *sb = fs->super;
 	unsigned long bpg = sb->s_blocks_per_group;
-	unsigned int gdpb = fs->blocksize / sizeof(struct ext2_group_desc);
+	unsigned int gdpb = fs->blocksize / fs->desc_size;
 	unsigned long max_blocks = 0xffffffff;
 	unsigned long rsv_groups;
 	unsigned int rsv_gdb;
@@ -106,6 +106,7 @@ errcode_t ext2fs_initialize(const char *
 	int		io_flags;
 	char		*buf;
 	blk_t		inodes;
+	size_t		desc_buflen;
 
 	if (!param || !EXT2_BLOCKS_COUNT(param))
 		return EXT2_ET_INVALID_ARGUMENT;
@@ -149,6 +150,7 @@ errcode_t ext2fs_initialize(const char *
 
 	set_field(s_log_block_size, 0);	/* default blocksize: 1024 bytes */
 	set_field(s_log_frag_size, 0); /* default fragsize: 1024 bytes */
+	set_field(s_desc_size, 0);
 	set_field(s_first_data_block, super->s_log_block_size ? 0 : 1);
 	set_field(s_max_mnt_count, EXT2_DFL_MAX_MNT_COUNT);
 	set_field(s_errors, EXT2_ERRORS_DEFAULT);
@@ -178,6 +180,7 @@ errcode_t ext2fs_initialize(const char *
 
 	fs->blocksize = EXT2_BLOCK_SIZE(super);
 	fs->fragsize = EXT2_FRAG_SIZE(super);
+	fs->desc_size = EXT2_DESC_SIZE(super);
 	frags_per_block = fs->blocksize / fs->fragsize;
 
 	set_field(s_blocks_per_group, fs->blocksize * 8);
@@ -350,12 +353,12 @@ ipg_retry:
 
 	ext2fs_free_mem(&buf);
 
-	retval = ext2fs_get_mem((size_t) fs->desc_blocks * fs->blocksize,
-				&fs->group_desc);
+	desc_buflen = fs->desc_blocks * EXT2_DESC_PER_BLOCK(fs->super) * 
+		sizeof(struct ext2_group_desc);
+	retval = ext2fs_get_mem(desc_buflen, &fs->group_desc);
 	if (retval)
 		goto cleanup;
-
-	memset(fs->group_desc, 0, (size_t) fs->desc_blocks * fs->blocksize);
+	memset(fs->group_desc, 0, desc_buflen);
 
 	/*
 	 * Reserve the superblock and group descriptors for each
Index: e2fsprogs-1.39/resize/resize2fs.c
===================================================================
--- e2fsprogs-1.39.orig/resize/resize2fs.c	2006-09-22 15:52:50.000000000 +0200
+++ e2fsprogs-1.39/resize/resize2fs.c	2006-09-22 15:53:09.000000000 +0200
@@ -187,6 +187,7 @@ errcode_t adjust_fs_info(ext2_filsys fs,
 	unsigned long	i, j, old_desc_blocks, max_group;
 	unsigned int	meta_bg, meta_bg_size;
 	int		has_super;
+	size_t		odesc_buflen, ndesc_buflen;
 	__u64		new_inodes;	/* u64 to check for overflow */
 
 	EXT2_BLOCKS_COUNT_SET(fs->super, new_size);
@@ -276,17 +277,20 @@ retry:
 	 * Reallocate the group descriptors as necessary.
 	 */
 	if (old_fs->desc_blocks != fs->desc_blocks) {
-		retval = ext2fs_resize_mem(old_fs->desc_blocks *
-					   fs->blocksize,
-					   fs->desc_blocks * fs->blocksize,
+		odesc_buflen = old_fs->desc_blocks * 
+			EXT2_DESC_PER_BLOCK(old_fs->super) * 
+			sizeof(struct ext2_group_desc);
+		ndesc_buflen = fs->desc_blocks * 
+			EXT2_DESC_PER_BLOCK(fs->super) * 
+			sizeof(struct ext2_group_desc);
+		retval = ext2fs_resize_mem(odesc_buflen, ndesc_buflen, 
 					   &fs->group_desc);
 		if (retval)
 			goto errout;
 		if (fs->desc_blocks > old_fs->desc_blocks) 
-			memset((char *) fs->group_desc + 
-			       (old_fs->desc_blocks * fs->blocksize), 0,
-			       (fs->desc_blocks - old_fs->desc_blocks) *
-			       fs->blocksize);
+			memset(&fs->group_desc[old_fs->group_desc_count], 0,
+			       (fs->group_desc_count - old_fs->group_desc_count) *
+			       sizeof(struct ext2_group_desc));
 	}
 
 	/*
@@ -365,8 +369,7 @@ retry:
 			fs->super->s_reserved_gdt_blocks;
 	for (i = old_fs->group_desc_count;
 	     i < fs->group_desc_count; i++) {
-		memset(&fs->group_desc[i], 0,
-		       sizeof(struct ext2_group_desc));
+		memset(&fs->group_desc[i], 0, sizeof(struct ext2_group_desc));
 		adjblocks = 0;
 
 		if (i == fs->group_desc_count-1) {
@@ -383,8 +386,7 @@ retry:
 			ext2fs_mark_block_bitmap(fs->block_map, group_block);
 			adjblocks++;
 		}
-		meta_bg_size = (fs->blocksize /
-				sizeof (struct ext2_group_desc));
+		meta_bg_size = fs->blocksize / fs->desc_size;
 		meta_bg = i / meta_bg_size;
 		if (!(fs->super->s_feature_incompat &
 		      EXT2_FEATURE_INCOMPAT_META_BG) ||
@@ -550,7 +552,7 @@ static errcode_t mark_table_blocks(ext2_
 	unsigned long		meta_bg_size;
 	unsigned int		old_desc_blocks;
 
-	meta_bg_size = (fs->blocksize / sizeof (struct ext2_group_desc));
+	meta_bg_size = fs->blocksize / fs->desc_size;
 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
 		old_desc_blocks = fs->super->s_first_meta_bg;
 	else
@@ -717,7 +719,7 @@ static errcode_t blocks_to_move(ext2_res
 	 * If we're increasing the number of descriptor blocks, life
 	 * gets interesting....  
 	 */
-	meta_bg_size = (fs->blocksize / sizeof (struct ext2_group_desc));
+	meta_bg_size = fs->blocksize / fs->desc_size;
 	for (i = 0; i < max_groups; i++) {
 		has_super = ext2fs_bg_has_super(fs, i);
 		if (has_super)
Index: e2fsprogs-1.39/lib/ext2fs/dupfs.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/dupfs.c	2006-09-22 15:08:12.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/dupfs.c	2006-09-22 15:53:09.000000000 +0200
@@ -23,6 +23,7 @@ errcode_t ext2fs_dup_handle(ext2_filsys 
 {
 	ext2_filsys	fs;
 	errcode_t	retval;
+	size_t		desc_buflen;
 
 	EXT2_CHECK_MAGIC(src, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 	
@@ -59,12 +60,13 @@ errcode_t ext2fs_dup_handle(ext2_filsys 
 		goto errout;
 	memcpy(fs->orig_super, src->orig_super, SUPERBLOCK_SIZE);
 
-	retval = ext2fs_get_mem((size_t) fs->desc_blocks * fs->blocksize,
-				&fs->group_desc);
+
+	desc_buflen = fs->desc_blocks * EXT2_DESC_PER_BLOCK(fs->super) * 
+		sizeof(struct ext2_group_desc);
+	retval = ext2fs_get_mem(desc_buflen, &fs->group_desc);
 	if (retval)
 		goto errout;
-	memcpy(fs->group_desc, src->group_desc,
-	       (size_t) fs->desc_blocks * fs->blocksize);
+	memcpy(fs->group_desc, src->group_desc, desc_buflen);
 
 	if (src->inode_map) {
 		retval = ext2fs_copy_bitmap(src->inode_map, &fs->inode_map);

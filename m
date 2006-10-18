From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [PATCH, E2FSPROGS] On-disk format definition for 64-bit support
Date: Wed, 18 Oct 2006 15:30:56 +0200
Message-ID: <45362C90.4030305@bull.net>
References: <E1Ga4l7-0003mU-46@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:51690 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP
	id S1751483AbWJRNch (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Oct 2006 09:32:37 -0400
To: Theodore Ts'o <tytso@mit.edu>
In-Reply-To: <E1Ga4l7-0003mU-46@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Ts'o wrote:
> After thinking about it some more, and looking at the code committed
> into the kernel git tree, I've changed my mind and agree that the
> extending current group descriptor is simpler than having two version=
s
> of the structure depending on the size of the group descriptor.
>=20
> Does everyone agree this is what the 64-bit on-desk definition should
> be?
See my remarks below. Otherwise, it's good for me.

   Should 64-bit support also imply BIG_BG support?
Yes. There is no flag added for the support of the big block groups, we=
=20
just use the INCOMPAT_64BIT flag.

>=20
> Index: e2fsprogs/lib/ext2fs/ext2_fs.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.orig/lib/ext2fs/ext2_fs.h	2006-10-18 00:33:56.000000000=
 -0400
> +++ e2fsprogs/lib/ext2fs/ext2_fs.h	2006-10-18 01:08:06.000000000 -040=
0
> @@ -147,6 +147,25 @@
>  	__u32	bg_reserved[3];
>  };
> =20
> +struct ext4_group_desc

struct ext2_group_desc ?

> +{
> +	__u32	bg_block_bitmap;		/* Blocks bitmap block */
> +	__u32	bg_inode_bitmap;		/* Inodes bitmap block */
> +	__u32	bg_inode_table;			/* Inodes table block */
> +	__u16	bg_free_blocks_count;		/* Free blocks count */
> +	__u16	bg_free_inodes_count;		/* Free inodes count */
> +	__u16	bg_used_dirs_count;		/* Directories count */
> +	__u16	bg_flags;
> +	__u32	bg_reserved[3];
> +	__u32	bg_block_bitmap_hi;		/* Blocks bitmap block MSB */
> +	__u32	bg_inode_bitmap_hi;		/* Inodes bitmap block MSB */
> +	__u32	bg_inode_table_hi;		/* Inodes table block MSB */
> +	__u16	bg_free_blocks_count_hi;	/* Free blocks count MSB */
> +	__u16	bg_free_inodes_count_hi;	/* Free inodes count MSB */
> +	__u16	bg_used_dirs_count_hi;		/* Directories count MSB */
> +	__u32	bg_reserved2[3];
> +};
> +
>  #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initia=
lized */
>  #define EXT2_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not initialized =
*/
> =20
> @@ -524,12 +543,15 @@
>  	__u32	s_hash_seed[4];		/* HTREE hash seed */
>  	__u8	s_def_hash_version;	/* Default hash version to use */
>  	__u8	s_jnl_backup_type; 	/* Default type of journal backup */
> -	__u16	s_reserved_word_pad;
> +	__u16	s_desc_size;		/* Group desc. size: INCOMPAT_64BIT */
>  	__u32	s_default_mount_opts;
>  	__u32	s_first_meta_bg;	/* First metablock group */
>  	__u32	s_mkfs_time;		/* When the filesystem was created */
>  	__u32	s_jnl_blocks[17]; 	/* Backup of the journal inode */
> -	__u32	s_reserved[172];	/* Padding to the end of the block */
> +	__u32	s_blocks_count_hi;	/* Blocks count high 32bits */
> +	__u32	s_r_blocks_count_hi;	/* Reserved blocks count high 32 bits*/
> +	__u32	s_free_blocks_hi; 	/* Free blocks count */

I'd prefer s_free_blocks_count_hi

> +	__u32	s_reserved[169];	/* Padding to the end of the block */
>  };

Regards,
   Val=E9rie

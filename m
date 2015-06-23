From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC 1/2] btree header
Date: Tue, 23 Jun 2015 12:33:33 -0700
Message-ID: <20150623193333.GA10037@birch.djwong.org>
References: <1435029878-4517-1-git-send-email-mingming.cao@oracle.com>
 <1435029878-4517-2-git-send-email-mingming.cao@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: mingming cao <mingming.cao@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38420 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909AbbFWTdg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jun 2015 15:33:36 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t5NJXZoN019611
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2015 19:33:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t5NJXZlr023051
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2015 19:33:35 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t5NJXYa2019916
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2015 19:33:34 GMT
Content-Disposition: inline
In-Reply-To: <1435029878-4517-2-git-send-email-mingming.cao@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 22, 2015 at 08:24:37PM -0700, mingming cao wrote:
> ---
>  ext4_btree.h | 146 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 146 insertions(+)
>  create mode 100644 ext4_btree.h
> 
> diff --git a/ext4_btree.h b/ext4_btree.h
> new file mode 100644
> index 0000000..efd5ce3
> --- /dev/null
> +++ b/ext4_btree.h
> @@ -0,0 +1,146 @@
> +/*
> + * copyright (C) 2015 Oracle.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License v2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.
> + */
> +
> +#ifndef EXT4_BTREE_H
> +#define EXT4_BTREE_H
> +
> +/*
> + * This btree geometry structure is used to defines how the btree block
> + * layout for different type of btrees. This is used to implement a generic
> + * btree implementation. The record length, value lenth, etc, are variable
> + * based on different btree type, like reflink btree, and other btree use cases.
> + */
> +struct ext4_btree_geo {
> +	__le16 node_len;
> +	__le16 header_len;
> +	__le16 key_len;
> +	__le16 val_len;
> +	__le16 rec_len;

(I wonder if these four _len values could be u8, but whatever...)

> +	__le16 max_pairs;
> +	__le16 max_records;
> +};

Does this geometry structure live on disk?  The __le prefix suggests that it
does, but the only definition of one of these is the in-core ref_btree_geo,
which means that u16 is sufficient.

Given that the ext4_btree_geo seems to contain all the incore info about the
btree you're working with, it ought to know about the magic number so that it
can compare with whatever it reads off disk.

(Thinking ahead to when we have multiple btrees with different record
definitions and magic numbers.)

> +
> +/*
> + * Every btree block starts from a header structure, including the index node
> + * and the leaf node.
> + * The index btree node started from this header structure, followed by 
> + * (key,value) pairs
> + * Index node:
> + * ---------------------------------------------------------------------------
> + * |header| key | key | key | key|...........| value | value | value | value |
> + * |--------------------------------------------------------------------------
> + *
> + * And the leaf node begins with ext4_btree_header, and followed by records.
> + * leaf node
> + * * ------------------------------------------------------------------------
> + * |header| rec | rec | rec | rec |...........| rec | rec | rec | rec | rec |
> + * |-------------------------------------------------------------------------
> + */
> +
> +#define REF_BTREE_MAGIC  0x52454642 /* "REFB" magic number for refcount btree */
> +
> +struct ext4_btree_header {
> +	__le32	btree_magic;	/* type of btree */
> +	__le32	btree_generation; /* generation for this type of btree */
> +	__le32	btree_level;	/* the level of this node in the tree */
> +	__le32	btree_numkeys;	/* # of records for leaf node*/
> +	__le32	btree_padding1;

I think this padding field results in a hidden u32 gap here?

> +	__le64	btree_blockno;	/* remember the blk# of this node */

(Unfortunate that you have to burn all 64 bits for all btrees, but I remembered
that ext4 lets you set flexbg size to 2^31.  Oh well.)

> +	__le64	btree_leftsib;	/* used for fast search sibling nodes */
> +	__le64	btree_rightsib; 
> +	__le64	btree_crc;	/* this node checksums */

Future proofing, I guess?  Since we don't use 64-bit crcs right now.

If you decide that we only need 32 bits for a crc, you could make btree_level a
u16 (since max levels is 8), numkeys a u16, and store the crc32 after that.
Then this on-disk header would only be 40 bytes, instead of 64 bytes.

(Hmm.  Maybe you were trying to make things align to a 64B cacheline?)

> +	__le64	btree_padding2;
> +};
> +
> +# define EXT4_BLOCK_SIZE	4096

Shouldn't this be the FS blocksize?  It'll waste a lot of space on a 64k block
filesystem (reduced fanout opportunities as well as 60K of empty space in each
tree node) and I'm not sure what happens with 1k blocks.

> +#define EXT4_BTREE_HEADER_SIZE	sizeof(struct ext4_btree_header)
> +#define EXT4_BTREE_NODESIZE	EXT4_BLOCK_SIZE	
> +
> +struct ext4_btree_key {
> +	__le64		blockno;
> +};
> +#define EXT4_BTREE_KEY_SIZE	sizeof(struct ext4_btree_key)
> +
> +struct ext4_btree_val {
> +	__le64		blockno;
> +};
> +#define EXT4_BTREE_VAL_SIZE	sizeof(struct ext4_btree_val)
> +
> +struct ext4_btree_rec {
> +	struct ext4_btree_key	key;
> +	__le32			len;
> +	__le32			ref_count;
> +};

Hm.  Looking forward to having btrees to track things other than refcount, I
imagine it'll become necessary to parameterize the record definition for each
type of btree?

(Though, I guess this record format works well enough for the inode and block
bitmaps, and maybe that's as far as you want to go...)

> +#define EXT4_BTREE_REC_SIZE	sizeof(struct ext4_btree_rec)
> +
> +#define EXT4_BTREE_MAX_KEY_VAL_PAIRS \
> +	((EXT4_BTREE_NODESIZE - EXT4_BTREE_HEADER_SIZE) / \
> +	 (EXT4_BTREE_KEY_SIZE + EXT4_BTREE_VAL_SIZE))
> +
> +#define EXT4_BTREE_MIN_KEY_VAL_PAIRS \
> +        (EXT4_BTREE_MAX_KEY_VAL_PAIRS / 2)
> +
> +#define EXT4_BTREE_MAX_RECS \
> +	((EXT4_BTREE_NODESIZE - EXT4_BTREE_HEADER_SIZE) / \
> +	  EXT4_BTREE_REC_SIZE)
> +
> +#define EXT4_BTREE_MIN_RECS \
> +	(EXT4_BTREE_MAX_RECS / 2)
> +
> +#define EXT4_BTREE_MAX_LEVELS		8
> +
> +
> +/* Index node */
> +struct ext4_btree_index_node {
> +	struct ext4_btree_header	node_header;
> +	struct ext4_btree_key		key[EXT4_BTREE_MAX_KEY_VAL_PAIRS];
> +	struct ext4_btree_val		val[EXT4_BTREE_MAX_KEY_VAL_PAIRS];

(Changing EXT4_BTREE_NODESIZE to depend on the FS blocksize makes it impossible
to use arrays here, oh well...)

> +};
> +
> +/* Record Node */
> +struct ext4_btree_leaf_node {
> +	struct ext4_btree_header	node_header;
> +	struct ext4_btree_rec		rec[EXT4_BTREE_MAX_RECS];
> +};
> +
> +struct ext4_btree_node {
> +	struct ext4_btree_header	node_header;
> +};
> +
> +struct ext4_btree_root {
> +	struct ext4_btree_node *node;
> +	struct ext4_btree_geo	geo;
> +};
> +
> +#define ext4_btree_trace printf

printk?

--D

> +
> +/* Ref B+Tree interface */
> +struct ext4_btree_node * ext4_btree_node_alloc();
> +void ext4_btree_node_free( struct ext4_btree_node *node);
> +struct ext4_btree_rec * ext4_btree_lookup(struct ext4_btree_root * root, 
> +					  struct ext4_btree_key * key);
> +int ext4_btree_insert(struct ext4_btree_root *root, 
> +		      struct ext4_btree_rec *rec);
> +int ext4_btree_delete(struct ext4_btree_root *root, 
> +		  struct ext4_btree_key *key);
> +void ext4_btree_print(struct ext4_btree_root * root);
> +int ext4_btree_valid_check(struct ext4_btree_root *root);
> +void ext4_ref_btree_init(struct ext4_btree_root * root);
> +
> +
> +#endif
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in

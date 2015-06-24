From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC 1/2] btree header
Date: Tue, 23 Jun 2015 22:21:56 -0700
Message-ID: <20150624052156.GA15410@birch.djwong.org>
References: <1435029878-4517-1-git-send-email-mingming.cao@oracle.com>
 <1435029878-4517-2-git-send-email-mingming.cao@oracle.com>
 <20150623193333.GA10037@birch.djwong.org>
 <558A2E9B.6080808@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mingming Cao <mingming.cao@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19592 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbbFXFV6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Jun 2015 01:21:58 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t5O5LvXC030064
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2015 05:21:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t5O5Lvu5021571
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2015 05:21:57 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t5O5LvDQ011229
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2015 05:21:57 GMT
Content-Disposition: inline
In-Reply-To: <558A2E9B.6080808@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 23, 2015 at 10:14:19PM -0600, Mingming Cao wrote:
> On 06/23/2015 01:33 PM, Darrick J. Wong wrote:
> > On Mon, Jun 22, 2015 at 08:24:37PM -0700, mingming cao wrote:
> >> ---
> >>  ext4_btree.h | 146 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 146 insertions(+)
> >>  create mode 100644 ext4_btree.h
> >>
> >> diff --git a/ext4_btree.h b/ext4_btree.h
> >> new file mode 100644
> >> index 0000000..efd5ce3
> >> --- /dev/null
> >> +++ b/ext4_btree.h
> >> @@ -0,0 +1,146 @@
> >> +/*
> >> + * copyright (C) 2015 Oracle.  All rights reserved.
> >> + *
> >> + * This program is free software; you can redistribute it and/or
> >> + * modify it under the terms of the GNU General Public
> >> + * License v2 as published by the Free Software Foundation.
> >> + *
> >> + * This program is distributed in the hope that it will be useful,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> >> + * General Public License for more details.
> >> + *
> >> + * You should have received a copy of the GNU General Public
> >> + * License along with this program; if not, write to the
> >> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> >> + * Boston, MA 021110-1307, USA.
> >> + */
> >> +
> >> +#ifndef EXT4_BTREE_H
> >> +#define EXT4_BTREE_H
> >> +
> >> +/*
> >> + * This btree geometry structure is used to defines how the btree block
> >> + * layout for different type of btrees. This is used to implement a generic
> >> + * btree implementation. The record length, value lenth, etc, are variable
> >> + * based on different btree type, like reflink btree, and other btree use cases.
> >> + */
> >> +struct ext4_btree_geo {
> >> +	__le16 node_len;
> >> +	__le16 header_len;
> >> +	__le16 key_len;
> >> +	__le16 val_len;
> >> +	__le16 rec_len;
> > (I wonder if these four _len values could be u8, but whatever...)
> 
> okay...
> 
> >
> >> +	__le16 max_pairs;
> >> +	__le16 max_records;
> >> +};
> > Does this geometry structure live on disk?  The __le prefix suggests that it
> > does, but the only definition of one of these is the in-core ref_btree_geo,
> > which means that u16 is sufficient.
> 
> At the beginning since the prototype is a in memory btree, the geometry
> structure was not on disk, and declared globally. So I had those values to be
> u8 before... but I am planning to store those layout info on disk... that's
> why here I made change to __le, but hasnt really update the rest of code to
> reflect the geo is stored on disk yet. One question I have is whethere to
> store the geometry structure into the btree block header. Maybe only for
> index node...

Hm.  XFS declares a struct xfs_btree_ops which holds the size of the key and
record fields (the pointer is assumed to be a AG block pointer), and function
pointers to various tree-specific helpers.  The max_{pairs,records} values
are kept in the XFS context structure.  None of it ever recorded on disk,
though (obviously) the values are used for sanity-checks of whatever's being
read in...

...or written out.  Hm, I sort of wonder (random aside here) if we could
abuse the jbd2 triggers to do spot-checks of what's being written out to disk
while we're also computing block checksums. </ramble>

(Nuts, 10pm, uh... I'll keep going in the morning.)

--D

> >
> > Given that the ext4_btree_geo seems to contain all the incore info about the
> > btree you're working with, it ought to know about the magic number so that it
> > can compare with whatever it reads off disk.
>
> Good point, it should know the magic number to compare with the header, if we
> decide to keep the geometry incore only.... I started to wonder if we really
> need to store geometry info on disk...
> 
> > (Thinking ahead to when we have multiple btrees with different record
> > definitions and magic numbers.)
> Agree...
> 
> >> +
> >> +/*
> >> + * Every btree block starts from a header structure, including the index node
> >> + * and the leaf node.
> >> + * The index btree node started from this header structure, followed by 
> >> + * (key,value) pairs
> >> + * Index node:
> >> + * ---------------------------------------------------------------------------
> >> + * |header| key | key | key | key|...........| value | value | value | value |
> >> + * |--------------------------------------------------------------------------
> >> + *
> >> + * And the leaf node begins with ext4_btree_header, and followed by records.
> >> + * leaf node
> >> + * * ------------------------------------------------------------------------
> >> + * |header| rec | rec | rec | rec |...........| rec | rec | rec | rec | rec |
> >> + * |-------------------------------------------------------------------------
> >> + */
> >> +
> >> +#define REF_BTREE_MAGIC  0x52454642 /* "REFB" magic number for refcount btree */
> >> +
> >> +struct ext4_btree_header {
> >> +	__le32	btree_magic;	/* type of btree */
> >> +	__le32	btree_generation; /* generation for this type of btree */
> >> +	__le32	btree_level;	/* the level of this node in the tree */
> >> +	__le32	btree_numkeys;	/* # of records for leaf node*/
> >> +	__le32	btree_padding1;
> > I think this padding field results in a hidden u32 gap here?
> 
> Sorry that was a mistake. I added generation but forget to remove this padding.
> >> +	__le64	btree_blockno;	/* remember the blk# of this node */
> > (Unfortunate that you have to burn all 64 bits for all btrees, but I remembered
> > that ext4 lets you set flexbg size to 2^31.  Oh well.)
> 
> true... though this block no is
> >> +	__le64	btree_leftsib;	/* used for fast search sibling nodes */
> >> +	__le64	btree_rightsib; 
> >> +	__le64	btree_crc;	/* this node checksums */
> > Future proofing, I guess?  Since we don't use 64-bit crcs right now.
> 
> yes... that was the intention... I guess that is a little overkill for now.
> > If you decide that we only need 32 bits for a crc, you could make btree_level a
> > u16 (since max levels is 8), numkeys a u16, and store the crc32 after that.
> > Then this on-disk header would only be 40 bytes, instead of 64 bytes.
> 
> Sounds good to me .. make it more packed...
> > (Hmm.  Maybe you were trying to make things align to a 64B cacheline?)
> >
> >> +	__le64	btree_padding2;
> >> +};
> >> +
> >> +# define EXT4_BLOCK_SIZE	4096
> > Shouldn't this be the FS blocksize?  It'll waste a lot of space on a 64k block
> > filesystem (reduced fanout opportunities as well as 60K of empty space in each
> > tree node) and I'm not sure what happens with 1k blocks.
> 
> Again, sorry this is me being lazy in the prototype here. I will fix it properly with filesystem blocksize ...
> 
> >> +#define EXT4_BTREE_HEADER_SIZE	sizeof(struct ext4_btree_header)
> >> +#define EXT4_BTREE_NODESIZE	EXT4_BLOCK_SIZE	
> >> +
> >> +struct ext4_btree_key {
> >> +	__le64		blockno;
> >> +};
> >> +#define EXT4_BTREE_KEY_SIZE	sizeof(struct ext4_btree_key)
> >> +
> >> +struct ext4_btree_val {
> >> +	__le64		blockno;
> >> +};
> >> +#define EXT4_BTREE_VAL_SIZE	sizeof(struct ext4_btree_val)
> >> +
> >> +struct ext4_btree_rec {
> >> +	struct ext4_btree_key	key;
> >> +	__le32			len;
> >> +	__le32			ref_count;
> >> +};
> > Hm.  Looking forward to having btrees to track things other than refcount, I
> > imagine it'll become necessary to parameterize the record definition for each
> > type of btree?
> >
> totally agree. Will need to make it more generic by adding interface to define different type of btree, with own record_data structure and let the btree user to pass those info into the generic code..
> 
> > (Though, I guess this record format works well enough for the inode and block
> > bitmaps, and maybe that's as far as you want to go...)
> 
> for reflink, block allocation, yes. But I like to make the code more generic if possible
> >> +#define EXT4_BTREE_REC_SIZE	sizeof(struct ext4_btree_rec)
> >> +
> >> +#define EXT4_BTREE_MAX_KEY_VAL_PAIRS \
> >> +	((EXT4_BTREE_NODESIZE - EXT4_BTREE_HEADER_SIZE) / \
> >> +	 (EXT4_BTREE_KEY_SIZE + EXT4_BTREE_VAL_SIZE))
> >> +
> >> +#define EXT4_BTREE_MIN_KEY_VAL_PAIRS \
> >> +        (EXT4_BTREE_MAX_KEY_VAL_PAIRS / 2)
> >> +
> >> +#define EXT4_BTREE_MAX_RECS \
> >> +	((EXT4_BTREE_NODESIZE - EXT4_BTREE_HEADER_SIZE) / \
> >> +	  EXT4_BTREE_REC_SIZE)
> >> +
> >> +#define EXT4_BTREE_MIN_RECS \
> >> +	(EXT4_BTREE_MAX_RECS / 2)
> >> +
> >> +#define EXT4_BTREE_MAX_LEVELS		8
> >> +
> >> +
> >> +/* Index node */
> >> +struct ext4_btree_index_node {
> >> +	struct ext4_btree_header	node_header;
> >> +	struct ext4_btree_key		key[EXT4_BTREE_MAX_KEY_VAL_PAIRS];
> >> +	struct ext4_btree_val		val[EXT4_BTREE_MAX_KEY_VAL_PAIRS];
> > (Changing EXT4_BTREE_NODESIZE to depend on the FS blocksize makes it impossible
> > to use arrays here, oh well...)
> 
> Hmm.. okay, probably a pointer here.
> >> +};
> >> +
> >> +/* Record Node */
> >> +struct ext4_btree_leaf_node {
> >> +	struct ext4_btree_header	node_header;
> >> +	struct ext4_btree_rec		rec[EXT4_BTREE_MAX_RECS];
> >> +};
> >> +
> >> +struct ext4_btree_node {
> >> +	struct ext4_btree_header	node_header;
> >> +};
> >> +
> >> +struct ext4_btree_root {
> >> +	struct ext4_btree_node *node;
> >> +	struct ext4_btree_geo	geo;
> >> +};
> >> +
> >> +#define ext4_btree_trace printf
> > printk?
> >
> > --D
> 
> :) this was done in the user-space first. When the code finally all move to kernel will be something like printk
> 
> Thanks a lot , for your review and comments!:)
> 
> Mingming

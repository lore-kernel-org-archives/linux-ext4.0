From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/3] ext4: use ext4_get_block_write in buffer write
Date: Sun, 17 Jan 2010 19:51:14 +0530
Message-ID: <87zl4c24o5.fsf@linux.vnet.ibm.com>
References: <1263583812-21355-1-git-send-email-tytso@mit.edu>
	<1263583812-21355-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Jiaying Zhang <jiayingz@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:53227 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab0AQOVV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jan 2010 09:21:21 -0500
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [202.81.31.247])
	by e23smtp04.au.ibm.com (8.14.3/8.13.1) with ESMTP id o0HEHq2T011924
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jan 2010 01:17:52 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o0HEGd3b1667104
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jan 2010 01:16:39 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o0HELJ69024349
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jan 2010 01:21:19 +1100
In-Reply-To: <1263583812-21355-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 15 Jan 2010 14:30:11 -0500, "Theodore Ts'o" <tytso@mit.edu> wrote:
> Allocate uninitialized extent before ext4 buffer write and
> convert the extent to initialized after io completes.
> The purpose is to make sure an extent can only be marked
> initialized after it has been written with new data so
> we can safely drop the i_mutex lock in ext4 DIO read without
> exposing stale data. This helps to improve multi-thread DIO
> read performance on high-speed disks.
> 
> Skip the nobh and data=journal mount cases to make things simple for now.
> 
> Signed-off-by: Jiaying Zhang <jiayingz@google.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/ext4.h      |   12 +++++-
>  fs/ext4/ext4_jbd2.h |   24 ++++++++++++
>  fs/ext4/extents.c   |   22 ++++++-----
>  fs/ext4/inode.c     |  105 ++++++++++++++++++++++++++++++++++++++++----------
>  fs/ext4/super.c     |   30 +++++++++++++--
>  5 files changed, 157 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b1dcbb7..b8b4887 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -134,6 +134,7 @@ struct mpage_da_data {
>  	int retval;
>  };
>  #define	EXT4_IO_UNWRITTEN	0x1
> +#define	EXT4_IO_WRITTEN		0x2
>  typedef struct ext4_io_end {
>  	struct list_head	list;		/* per-file finished AIO list */
>  	struct inode		*inode;		/* file being written to */
> @@ -370,7 +371,7 @@ struct ext4_new_group_data {
>  					 EXT4_GET_BLOCKS_CREATE_UNINIT_EXT)
>  	/* Convert extent to initialized after IO complete */
>  #define EXT4_GET_BLOCKS_IO_CONVERT_EXT		(EXT4_GET_BLOCKS_CONVERT|\
> -					 EXT4_GET_BLOCKS_IO_CREATE_EXT)
> +					 EXT4_GET_BLOCKS_CREATE_UNINIT_EXT)
> 
>  /*
>   * Flags used by ext4_free_blocks
> @@ -761,6 +762,7 @@ struct ext4_inode_info {
>  #define EXT4_MOUNT_QUOTA		0x80000 /* Some quota option set */
>  #define EXT4_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
>  #define EXT4_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
> +#define EXT4_MOUNT_DIOREAD_NOLOCK	0x400000 /* Enable support for dio read nolocking */
>  #define EXT4_MOUNT_JOURNAL_CHECKSUM	0x800000 /* Journal checksums */
>  #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal Async Commit */
>  #define EXT4_MOUNT_I_VERSION            0x2000000 /* i_version support */
> @@ -1774,6 +1776,14 @@ static inline void set_bitmap_uptodate(struct buffer_head *bh)
>  	set_bit(BH_BITMAP_UPTODATE, &(bh)->b_state);
>  }
> 
> +/* BH_Uninit flag: blocks are allocated but uninitialized on disk */
> +enum ext4_state_bits {
> +	BH_Uninit	/* blocks are allocated but uninitialized on disk */
> +	  = BH_JBDPrivateStart,
> +};
> +
> +BUFFER_FNS(Uninit, uninit)
> +


I asked this in the last post. Why we need a new buffer head flag ?
Why can't we use the unwritten flag ?

-aneesh


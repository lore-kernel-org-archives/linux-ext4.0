From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 1/3] ext4: mechanical change on dio get_block code in
 prepare for it to be used by buffer write
Date: Sun, 17 Jan 2010 20:06:32 +0530
Message-ID: <87y6jw23yn.fsf@linux.vnet.ibm.com>
References: <1263583812-21355-1-git-send-email-tytso@mit.edu>
	<1263583812-21355-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Jiaying Zhang <jiayingz@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:48628 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab0AQOgk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jan 2010 09:36:40 -0500
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [202.81.31.247])
	by e23smtp01.au.ibm.com (8.14.3/8.13.1) with ESMTP id o0HEYlhs031240
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jan 2010 01:34:47 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o0HEVwxW1528042
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jan 2010 01:31:58 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o0HEabCK011352
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jan 2010 01:36:38 +1100
In-Reply-To: <1263583812-21355-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 15 Jan 2010 14:30:10 -0500, "Theodore Ts'o" <tytso@mit.edu> wrote:
> Renaming the dio block allocation flags, variables, and functions
> introduced in Mingming's "Direct IO for holes and fallocate"
> patches so that they can be used by ext4 buffer write as well.
> Also changed the related function comments accordingly to cover
> both direct write and buffer wirte cases.
> 
> Signed-off-by: Jiaying Zhang <jiayingz@google.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/ext4.h    |   18 ++++++------
>  fs/ext4/extents.c |   24 +++++++-------
>  fs/ext4/fsync.c   |    2 +-
>  fs/ext4/inode.c   |   84 ++++++++++++++++++++++++-----------------------------
>  fs/ext4/super.c   |    2 +-
>  5 files changed, 61 insertions(+), 69 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 2ca1b41..b1dcbb7 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -133,7 +133,7 @@ struct mpage_da_data {
>  	int pages_written;
>  	int retval;
>  };
> -#define	DIO_AIO_UNWRITTEN	0x1
> +#define	EXT4_IO_UNWRITTEN	0x1
>  typedef struct ext4_io_end {
>  	struct list_head	list;		/* per-file finished AIO list */
>  	struct inode		*inode;		/* file being written to */
> @@ -364,13 +364,13 @@ struct ext4_new_group_data {
>  	/* caller is from the direct IO path, request to creation of an
>  	unitialized extents if not allocated, split the uninitialized
>  	extent if blocks has been preallocated already*/
> -#define EXT4_GET_BLOCKS_DIO			0x0008
> +#define EXT4_GET_BLOCKS_PRE_IO			0x0008
>  #define EXT4_GET_BLOCKS_CONVERT			0x0010
> -#define EXT4_GET_BLOCKS_DIO_CREATE_EXT		(EXT4_GET_BLOCKS_DIO|\
> +#define EXT4_GET_BLOCKS_IO_CREATE_EXT		(EXT4_GET_BLOCKS_PRE_IO|\
>  					 EXT4_GET_BLOCKS_CREATE_UNINIT_EXT)
> -	/* Convert extent to initialized after direct IO complete */
> -#define EXT4_GET_BLOCKS_DIO_CONVERT_EXT		(EXT4_GET_BLOCKS_CONVERT|\
> -					 EXT4_GET_BLOCKS_DIO_CREATE_EXT)
> +	/* Convert extent to initialized after IO complete */
> +#define EXT4_GET_BLOCKS_IO_CONVERT_EXT		(EXT4_GET_BLOCKS_CONVERT|\
> +					 EXT4_GET_BLOCKS_IO_CREATE_EXT)
>

All these flags are really confusing. I guess we can make it much more
cleaner. For ex: Why is EXT4_GET_BLOCKS_IO_CONVERT_EXT enabling
EXT4_GET_BLOCKS_CREATE_UNINIT_EXT. The renaming to PRE_IO made it
better. But i guess these names should be self documenting.

How about

EXT4_GET_BLOCKS_CREATE. Indicate we should do block
allocation. But that flag alone doesn't say whether we are suppose
to create init or uninit extent.

EXT4_GET_BLOCKS_UNINIT_EXT -> Request the creation of uninit extent

EXT4_GET_BLOCKS_CREATE_UNINIT_EXT -> EXT4_GET_BLOCKS_CREATE|EXT4_GET_BLOCKS_UNINIT_EXT;

EXT4_GET_BLOCKS_DELALLOC_RESERVE -> Request for delayed allocaion
reservation

EXT4_GET_BLOCKS_PRE_IO  -> 0x0008 -> Indicate that we should do all
necessary extent split and make the requested range in to single extent.

EXT4_GET_BLOCKS_CONVERT_IO -> Convert the specified range which should be a
single extent into init and then try to merge the extent to left/right

EXT4_GET_BLOCKS_IO_CREATE_EXT -> EXT4_GET_BLOCKS_PRE_IO | EXT4_GET_BLOCKS_CREATE_UNINIT_EXT

EXT4_GET_BLOCKS_IO_CONVERT_EXT -> EXT4_GET_BLOCKS_CREATE | EXT4_GET_BLOCKS_CONVERT_IO; 

So from the above list it is only the last flag that is different from
what is already there. But i guess we need more documentation around
these flags.

-aneesh


From: Mark Fasheh <mark.fasheh@ORACLE.COM>
Subject: Re: [PATCH 1/2] Add FIEMAP header file
Date: Mon, 12 Nov 2007 15:55:27 -0800
Message-ID: <20071112235527.GA28607@ca-server1.us.oracle.com>
References: <1194901202.12045.17.camel@garfield>
Reply-To: Mark Fasheh <mark.fasheh@ORACLE.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>, David Chinner <dgc@sgi.com>
To: Kalpak Shah <Kalpak.Shah@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:50649 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbXKLX4O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Nov 2007 18:56:14 -0500
Content-Disposition: inline
In-Reply-To: <1194901202.12045.17.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 13, 2007 at 02:30:02AM +0530, Kalpak Shah wrote:
> Recently there was discussion about an "FIle Extent MAP"(FIEMAP) ioctl for
> efficiently mapping the extents and holes of a file. This will be many
> times more efficient than FIBMAP by cutting down the number of ioctls.

Thanks for sending this out.


> This patch adds the FIEMAP header file in include/linux.

Any problem with defining the IOC_FIEMAP ioctl number in this header too? No
EXT4 prefix so we keep things generic too, please.
	--Mark


> Signed-off-by: Andreas Dilger <adilger@sun.com>
> Signed-off-by: Kalpak Shah <kalpak.shah@sun.com> 
> 
> Index: linux-2.6.23.1/include/linux/fiemap.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6.23.1/include/linux/fiemap.h
> @@ -0,0 +1,49 @@
> +/*
> + * include/linux/fiemap.h
> + *
> + * Copyright (C) 2007 Sun Microsystems, Inc.
> + *
> + * Author: Kalpak Shah <kalpak.shah@sun.com>
> + *	   Andreas Dilger <adilger@sun.com>
> + */
> +
> +#ifndef _LINUX_FIEMAP_H
> +#define _LINUX_FIEMAP_H
> +
> +struct fiemap_extent {
> +	__u64	fe_offset; /* offset in bytes for the start of the extent */
> +	__u64	fe_length; /* length in bytes for the extent */
> +	__u32	fe_flags;  /* returned FIEMAP_EXTENT_* flags for the extent */
> +	__u32	fe_lun;	   /* logical device number for extent (starting at 0)*/
> +};
> +
> +struct fiemap {
> +	__u64	fm_start;	 /* logical starting byte offset (in/out) */
> +	__u64	fm_length;	 /* logical length of map (in/out) */
> +	__u32	fm_flags;	 /* FIEMAP_FLAG_* flags for request (in/out) */
> +	__u32	fm_extent_count; /* number of extents in fm_extents (in/out) */
> +	__u64	fm_end_offset;	 /* logical offset of end of mapping in last ioctl */
> +	struct fiemap_extent	fm_extents[0];
> +};
> +
> +#define FIEMAP_FLAG_SYNC	0x00000001 /* sync file data before map */
> +#define FIEMAP_FLAG_HSM_READ	0x00000002 /* get data from HSM before map */
> +#define FIEMAP_FLAG_NUM_EXTENTS	0x00000004 /* return only number of extents */
> +#define FIEMAP_FLAG_INCOMPAT	0xff000000 /* error for unknown flags in here */
> +
> +#define FIEMAP_FLAG_LUN_OFFSET	0x01000000 /* use lun offsets, instead of
> +					    * logical file offsets */
> +
> +#define FIEMAP_EXTENT_HOLE	0x00000001 /* has no data or space allocation */
> +#define FIEMAP_EXTENT_UNWRITTEN	0x00000002 /* space allocated, but no data */
> +#define FIEMAP_EXTENT_UNMAPPED	0x00000004 /* has data but no space allocation*/
> +#define FIEMAP_EXTENT_ERROR	0x00000008 /* mapping error, errno in fe_start*/
> +#define FIEMAP_EXTENT_NO_DIRECT	0x00000010 /* cannot access data directly */
> +#define FIEMAP_EXTENT_LAST	0x00000020 /* last extent in the file */
> +#define FIEMAP_EXTENT_DELALLOC	0x00000040 /* has data but not yet written,
> +					    * must have EXTENT_UNKNOWN set */
> +#define FIEMAP_EXTENT_SECONDARY	0x00000080 /* data (also) in secondary storage,
> +					    * not in primary if EXTENT_UNKNOWN*/
> +#define FIEMAP_EXTENT_EOF	0x00000100 /* if fm_start+fm_len is beyond EOF*/
> +
> +#endif /* _LINUX_FIEMAP_H */
> 
--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com

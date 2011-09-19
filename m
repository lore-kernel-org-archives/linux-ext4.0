From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 1/2] libext2fs: add metadata checksum and snapshot
	feature flags
Date: Mon, 19 Sep 2011 11:58:31 -0700
Message-ID: <20110919185831.GI12086@tux1.beaverton.ibm.com>
References: <1316127052-1890-1-git-send-email-tytso@mit.edu> <1316127052-1890-2-git-send-email-tytso@mit.edu>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Amir Goldstein <amir73il@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60840 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932478Ab1ISS6i (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Sep 2011 14:58:38 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p8JIRqnp006110
	for <linux-ext4@vger.kernel.org>; Mon, 19 Sep 2011 14:27:52 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p8JIwbs7172144
	for <linux-ext4@vger.kernel.org>; Mon, 19 Sep 2011 14:58:37 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p8JEwKJf028857
	for <linux-ext4@vger.kernel.org>; Mon, 19 Sep 2011 11:58:21 -0300
Content-Disposition: inline
In-Reply-To: <1316127052-1890-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 06:50:51PM -0400, Theodore Ts'o wrote:
<snip>
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index 4fec5db..1c86cb2 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -363,7 +370,8 @@ struct ext2_inode {
>  			__u16	l_i_file_acl_high;
>  			__u16	l_i_uid_high;	/* these 2 fields    */
>  			__u16	l_i_gid_high;	/* were reserved2[0] */
> -			__u32	l_i_reserved2;
> +			__u16	l_i_checksum_lo;	/* crc32c(uuid+inum+inode) */
> +			__u16	l_i_reserved;	/* crc32c(uuid+inum+inode) */
>  		} linux2;
>  		struct {
>  			__u8	h_i_frag;	/* Fragment number */
> @@ -410,7 +418,8 @@ struct ext2_inode_large {
>  			__u16	l_i_file_acl_high;
>  			__u16	l_i_uid_high;	/* these 2 fields    */
>  			__u16	l_i_gid_high;	/* were reserved2[0] */
> -			__u32	l_i_reserved2;
> +			__u16	l_i_checksum_lo; /* crc32c(uuid+inum+inode) */
> +			__u16	l_i_reserved;
>  		} linux2;
>  		struct {
>  			__u8	h_i_frag;	/* Fragment number */
> @@ -422,7 +431,7 @@ struct ext2_inode_large {
>  		} hurd2;
>  	} osd2;				/* OS dependent 2 */
>  	__u16	i_extra_isize;
> -	__u16	i_pad1;
> +	__u16	i_checksum_hi;	/* crc32c(uuid+inum+inode) */
>  	__u32	i_ctime_extra;	/* extra Change time (nsec << 2 | epoch) */
>  	__u32	i_mtime_extra;	/* extra Modification time (nsec << 2 | epoch) */
>  	__u32	i_atime_extra;	/* extra Access time (nsec << 2 | epoch) */
> @@ -441,7 +450,7 @@ struct ext2_inode_large {
>  #define i_gid_low	i_gid
>  #define i_uid_high	osd2.linux2.l_i_uid_high
>  #define i_gid_high	osd2.linux2.l_i_gid_high
> -#define i_reserved2	osd2.linux2.l_i_reserved2
> +#define i_checksum	osd2.linux2.l_i_checksum

s/i_checksum/i_checksum_lo/, I think.

--D

From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] Ext4: cleanup fsxattr related stuff
Date: Wed, 4 Jan 2017 13:51:22 -0800
Message-ID: <20170104215122.GA14021@birch.djwong.org>
References: <1483566225-25115-1-git-send-email-bo.li.liu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Liu Bo <bo.li.liu@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43750 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751909AbdADVv2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jan 2017 16:51:28 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v04LpQD9022837
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-ext4@vger.kernel.org>; Wed, 4 Jan 2017 21:51:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v04LpPeP016149
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-ext4@vger.kernel.org>; Wed, 4 Jan 2017 21:51:26 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v04LpN8b028901
        for <linux-ext4@vger.kernel.org>; Wed, 4 Jan 2017 21:51:24 GMT
Content-Disposition: inline
In-Reply-To: <1483566225-25115-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 04, 2017 at 01:43:45PM -0800, Liu Bo wrote:
> These definitions have made themselves into include/uapi/linux/fs.h.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Not to mention the flag set is already behind the VFS version. :)
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/ext4/ext4.h | 37 -------------------------------------
>  1 file changed, 37 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 2163c1e..11f59a0 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -639,43 +639,6 @@ enum {
>  #define EXT4_IOC_GET_ENCRYPTION_PWSALT	FS_IOC_GET_ENCRYPTION_PWSALT
>  #define EXT4_IOC_GET_ENCRYPTION_POLICY	FS_IOC_GET_ENCRYPTION_POLICY
>  
> -#ifndef FS_IOC_FSGETXATTR
> -/* Until the uapi changes get merged for project quota... */
> -
> -#define FS_IOC_FSGETXATTR		_IOR('X', 31, struct fsxattr)
> -#define FS_IOC_FSSETXATTR		_IOW('X', 32, struct fsxattr)
> -
> -/*
> - * Structure for FS_IOC_FSGETXATTR and FS_IOC_FSSETXATTR.
> - */
> -struct fsxattr {
> -	__u32		fsx_xflags;	/* xflags field value (get/set) */
> -	__u32		fsx_extsize;	/* extsize field value (get/set)*/
> -	__u32		fsx_nextents;	/* nextents field value (get)	*/
> -	__u32		fsx_projid;	/* project identifier (get/set) */
> -	unsigned char	fsx_pad[12];
> -};
> -
> -/*
> - * Flags for the fsx_xflags field
> - */
> -#define FS_XFLAG_REALTIME	0x00000001	/* data in realtime volume */
> -#define FS_XFLAG_PREALLOC	0x00000002	/* preallocated file extents */
> -#define FS_XFLAG_IMMUTABLE	0x00000008	/* file cannot be modified */
> -#define FS_XFLAG_APPEND		0x00000010	/* all writes append */
> -#define FS_XFLAG_SYNC		0x00000020	/* all writes synchronous */
> -#define FS_XFLAG_NOATIME	0x00000040	/* do not update access time */
> -#define FS_XFLAG_NODUMP		0x00000080	/* do not include in backups */
> -#define FS_XFLAG_RTINHERIT	0x00000100	/* create with rt bit set */
> -#define FS_XFLAG_PROJINHERIT	0x00000200	/* create with parents projid */
> -#define FS_XFLAG_NOSYMLINKS	0x00000400	/* disallow symlink creation */
> -#define FS_XFLAG_EXTSIZE	0x00000800	/* extent size allocator hint */
> -#define FS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
> -#define FS_XFLAG_NODEFRAG	0x00002000  	/* do not defragment */
> -#define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
> -#define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this */
> -#endif /* !defined(FS_IOC_FSGETXATTR) */
> -
>  #define EXT4_IOC_FSGETXATTR		FS_IOC_FSGETXATTR
>  #define EXT4_IOC_FSSETXATTR		FS_IOC_FSSETXATTR
>  
> -- 
> 2.5.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

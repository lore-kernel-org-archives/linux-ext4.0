From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH, E2FSPROGS] On-disk format for inode extra size control inode size
Date: Wed, 18 Oct 2006 13:34:38 -0600
Message-ID: <20061018193437.GG3509@schatzie.adilger.int>
References: <E1Ga4rR-000534-CE@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:8376 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1161322AbWJRTek
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Oct 2006 15:34:40 -0400
To: Theodore Ts'o <tytso@mit.edu>
Content-Disposition: inline
In-Reply-To: <E1Ga4rR-000534-CE@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 18, 2006  02:25 -0400, Theodore Ts'o wrote:
> On-disk format for controlling the inode size
> 
> - EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE (0x0040?) - add s_min_extra_isize and
>   s_want_extra_isize fields to superblock, which allow specifying
>   the minimum and desired i_extra_isize fields in large inodes
>   (for nsec+epoch timestamps, potential other uses).  Needs RO_COMPAT
>   flag handling, needs e2fsck support, patch complete, little testing.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

> @@ -405,6 +405,11 @@
>  	} osd2;				/* OS dependent 2 */
>  	__u16	i_extra_isize;
>  	__u16	i_pad1;
> +	__u32	i_ctime_extra;	/* extra Change time (nsec << 2 | epoch) */

There was some discussion about moving the i_ctime_extra field into the
small inode, for use as a version field by NFSV4.  The proposed field was
l_i_reserved2 in the original Bull patch.

> +	__u32	i_mtime_extra;	/* extra Mod. time (nsec << 2 | epoch) */
                                         ^^^ Modify

Looks good otherwise.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

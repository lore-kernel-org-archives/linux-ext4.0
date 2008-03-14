From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/5] ext4 online defrag header file changes
Date: Fri, 14 Mar 2008 20:58:48 +0800
Message-ID: <20080314125848.GE3542@webber.adilger.int>
References: <200803141202.AA00330@TNESG9526.rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:52254 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbYCNM7E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Mar 2008 08:59:04 -0400
In-reply-to: <200803141202.AA00330@TNESG9526.rs.jp.nec.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 14, 2008  21:02 +0900, Akira Fujita wrote:
> How about renaming this structure from ext4_extent_data to
> ext4_extent_info which used the extent in-core structure
> and put it into ext4_fs_extents.h? 
> Because in-core super_block is ext4_sb_info.
> 
> /*
>  * This is the extent in-core structure.
>  */
> struct ext4_extent_info {
> 	ext4_lblk_t	ee_block;	/* first logical block extent covers */
> 	int		ee_len;		/* number of blocks covered by extent */
> 	ext4_fsblk_t	ee_start;	/* first physical block extent covers */
> };      

Would it be possible to use the FIEMAP interface to get the file mapping
data to userspace?  That would avoid the need to have a second ioctl
with nearly the same data.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC][PATCH V3 1/4] ext4: add EXT4_IOC_CONTROL_PA to create/discard inode PA
Date: Wed, 1 Dec 2010 03:14:20 -0700
Message-ID: <62E660B4-8AF6-4B94-B3C0-1557ACA136DB@dilger.ca>
References: <4CF5E5F2.9080007@sx.jp.nec.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:48666 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab0LAKOW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Dec 2010 05:14:22 -0500
In-Reply-To: <4CF5E5F2.9080007@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-11-30, at 23:06, Kazuya Mio wrote:
> EXT4_IOC_CONTROL_PA allows to create new inode PA based on the specified
> range, or to discard all inode PAs in the target inode.
> 
> INTERFACE
> -----------
> 
> #define EXT4_IOC_CONTROL_PA	_IOWR('f', 16, struct ext4_prealloc_info)
> 
> struct ext4_prealloc_info {
> 	__u64 pi_pstart; /* physical offset for the start of the PA from
> 			  * the beginning of the file (in/out) */
> 	__u32 pi_lstart; /* logical offset for the start of the PA from
> 			  * the beginning of the disk (in/out) */

Is the comment here wrong, or do I misunderstand that there is a 64-bit offset for the file, and only a 32-bit offset for the disk?  It doesn't make sense to create a new API that only has a 32-bit offset for the disk, since ext4 is nearly supporting 64-bit filesystem blocks.

Looking at the patch, it seems that pi_pstart is indeed the physical offset, so it should be 64-bit, and it just appears that the comment is incorrect.

Cheers, Andreas






From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: Ensure zeroout blocks have no dirty metadata
Date: Fri, 11 Dec 2009 02:09:08 -0700
Message-ID: <8352E6B3-4561-40D7-AEC0-A4119A685F46@sun.com>
References: <6601abe90912100928v747671dat489aeee5dabf2c03@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:46111 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbZLKJJG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Dec 2009 04:09:06 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nBB999g1001916
	for <linux-ext4@vger.kernel.org>; Fri, 11 Dec 2009 01:09:09 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KUH00G00D7PHY00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Fri,
 11 Dec 2009 01:09:09 -0800 (PST)
In-reply-to: <6601abe90912100928v747671dat489aeee5dabf2c03@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-12-10, at 10:28, Curt Wohlgemuth wrote:
> This fixes a bug in which new blocks returned from an extent created  
> with
> ext4_ext_zeroout() can have dirty metadata still associated with them.
>
> This is for the problem I reported on 23 Nov ("Bug in extent  
> zeroout: blocks
> not marked as new").  I'm not seeing the corruption with this fix  
> that I was
> seeing without it.
>
> @@ -2474,9 +2474,21 @@ static int ext4_ext_zeroout(struct inode
> +		/* On success, we need to insure all metadata associated
> +		 * with each of these blocks is unmapped. */
> +		if (test_bit(BIO_UPTODATE, &bio->bi_flags)) {
> +			sector_t block = ee_pblock;
> +
> 			ret = 0;
> +			done = 0;
> +			while (done < len) {
> +				unmap_underlying_metadata(inode->i_sb->s_bdev,


IIRC, during the discussion of this problem, Ted pointed out that this  
can only happen if the filesystem is running in no-journal mode.   
Otherwise, there are shadow allocation bitmaps that prevent metadata  
blocks from being reallocated until the transaction that released them  
has committed.

In that case, it makes sense to only do this extra work if the  
filesystem is running in no-journal mode.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


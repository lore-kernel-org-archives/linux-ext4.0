From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/3] ext4: different maxbytes functions for bitmap &	extent
 files
Date: Wed, 05 Dec 2007 17:22:25 -0600
Message-ID: <475732B1.1090809@redhat.com>
References: <47557870.9060405@redhat.com> <47557913.3090208@redhat.com> <20071205231804.GA3604@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbXLEXW2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Dec 2007 18:22:28 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lB5NMRLO010945
	for <linux-ext4@vger.kernel.org>; Wed, 5 Dec 2007 18:22:27 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lB5NMQjD006707
	for <linux-ext4@vger.kernel.org>; Wed, 5 Dec 2007 18:22:26 -0500
In-Reply-To: <20071205231804.GA3604@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Dec 04, 2007  09:58 -0600, Eric Sandeen wrote:
>> +static loff_t ext4_max_size(int blkbits)
>> +{
>> +	loff_t res;
>> +	loff_t upper_limit = MAX_LFS_FILESIZE;
>> +
>> +	/* small i_blocks in vfs inode? */
>> +	if (sizeof(blkcnt_t) < sizeof(u64)) {
> 
> It would probably be more future-proof by having a struct inode here and
> using "if (sizeof(inode->i_blocks) < sizeof(__u64))".

Ok.  Honestly these were both just lifted from the original max_size
function for bitmap files :)

-Eric

>> +		upper_limit = (1LL << 32) - 1;
>> +
>> +		/* total blocks in file system block size */
>> +		upper_limit >>= (blkbits - 9);
>> +		upper_limit <<= blkbits;
> 
> There is probably a cleaner way to do this, maybe:

> 		upper_limit = (1LL << (32 + 9) - 1) & ~((1 << blkbits) - 1);
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 

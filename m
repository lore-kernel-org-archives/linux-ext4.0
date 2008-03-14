From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs- fix ext2fs_swap_inode_full attr test on BE
 boxes
Date: Fri, 14 Mar 2008 12:42:36 -0500
Message-ID: <47DAB90C.8050605@redhat.com>
References: <47C882CD.3090204@redhat.com> <20080314171435.GA13733@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbYCNRmj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Mar 2008 13:42:39 -0400
In-Reply-To: <20080314171435.GA13733@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Fri, Feb 29, 2008 at 04:10:21PM -0600, Eric Sandeen wrote:
>> +
>> +	if (hostorder)
>> +		attr_magic = *eaf;
>>  	*eat = ext2fs_swab32(*eaf);
>> +	if (!hostorder)
>> +		attr_magic = *eat;
>> +
>> +	if (attr_magic != EXT2_EXT_ATTR_MAGIC)
>> +		return; /* it seems no magic here */
> 
> The problem with this is that if the magic isn't there, we still end
> up writing 4 bytes into the destination.  So I think this is a better
> patch....
> 

Seems good to me.

Thanks,
-Eric

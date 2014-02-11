From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v4 0/3] ext4: increase mbcache scalability
Date: Tue, 11 Feb 2014 12:58:19 -0700
Message-ID: <52FA80DB.2000504@hp.com>
References: <1377186876-57291-1-git-send-email-tmac@hp.com> <1390588288-66930-1-git-send-email-tmac@hp.com> <87fvodcb65.fsf@tassilo.jf.intel.com> <DBA818DD-1C87-4B98-8475-8BB8F00F7DA4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: T Makphaibulchoke <tmac@hp.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"aswin@hp.com" <aswin@hp.com>
To: Andreas Dilger <adilger@dilger.ca>,
	Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:17532 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbaBLCH2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Feb 2014 21:07:28 -0500
In-Reply-To: <DBA818DD-1C87-4B98-8475-8BB8F00F7DA4@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/24/2014 11:09 PM, Andreas Dilger wrote:
> I think the ext4 block groups are locked with the blockgroup_lock that has about the same number of locks as the number of cores, with a max of 128, IIRC.  See blockgroup_lock.h. 
> 
> While there is some chance of contention, it is also unlikely that all of the cores are locking this area at the same time.  
> 
> Cheers, Andreas
> 

Andreas, looks like your assumption is correct.  On all 3 systems, 80, 60 and 20 cores, I got almost identical aim7 results using either a smaller dedicated lock array or the block group lock.  I'm inclined to go with using the block group lock as it does not incur any extra space.

One problem is that, with the current implementation mbcache has no knowledge of the super block, including its block group lock, of the filesystem.  In my implementation I have to change the first argument of mb_cache_create() from char * to struct super_block * to be able to access the super block's block group lock. This works with my proposed change to allocate an mb_cache for each mounted ext4 filesystem.  This would also require the same change, allocating an mb_cache for each mounted filesystem, to both ext2 and ext3, which would increase the scope of the patch.  The other alternative, allocating a new smaller spinlock array, would not require any change to either ext2 and ext3.

I'm working on resubmitting my patches using the block group locks and extending the changes to also include both ext2 and ext3.  With this approach, not only that no addition space for dedicated new spinlock array is required, the e_bdev member of struct mb_cache_entry could also be removed, reducing the space required for each mb_cache_entry.

Please let me know if you have any concern or suggestion.

Thanks,
Mak.


From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ditching e4b->alloc_semp
Date: Sun, 6 Mar 2011 23:08:10 -0500
Message-ID: <20110307040810.GE11120@thunk.org>
References: <AANLkTikSLsuiZGYaUKtQnMQNZ6Pj=K_RDkYtpK98ujy1@mail.gmail.com>
 <20110305160656.GA3505@thunk.org>
 <AANLkTikW04brZ549=29N1Yan=GH29BN4WSVrA7erR_F6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40930 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199Ab1CGEIP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Mar 2011 23:08:15 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTikW04brZ549=29N1Yan=GH29BN4WSVrA7erR_F6@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 06, 2011 at 10:15:41PM +0200, Amir Goldstein wrote:
> 
> That sounds about right, but why do I need a new bit?
> Why can't I use EXT4_GROUP_INFO_NEED_INIT_BIT to tell me the exact 
> same thing?

The current meaning of NEED_INIT_BIT is that it indicates that the
group has been initialized once since the file system has been
mounted.  It is used by ext4_mb_good_group() to know whether it can
rely on ext4_group_info->bb_free, ext4_group_info->bb_fragments,
ext4_group_info->bb_largest_free_order, et. al, without needing to
reload the buddy bitmap.

We added this so that even if memory pressure has forced the buddy
bitmap and block allocation bitmaps out of memory, we have enough
information in the ext4_group_info summary array that we can quickly
decide whether or not a group is a likely good candidate to be
examined more closely to have the necessary free blocks.  Without this
(relatively recent) change, the mballoc code might potentially need to
read in tens if not hundreds of block allocation bitmaps only to find
that it didn't have enough contiguous blocks, and then the memory
pressure would push the block bitmap out of memory again.... and file
system performance would go into the toilet.


So we don't want to disturb the meaning of this particular bit.  If we
zap the NEED_INIT_BIT whenever we discover that the group's buddy
bitmap page has been pushed out of memory, then we will once again
need to read in massive numbers of block bitmaps because clearing the
bit effectively marks the summary information stored ext4_group_info
structure as invalid.

							- Ted

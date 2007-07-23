From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH e2fsprogs] properly calculate overhead in ext2fs_initialize()
Date: Mon, 23 Jul 2007 13:00:15 -0500
Message-ID: <46A4ECAF.3040800@redhat.com>
References: <46A12D62.2010704@redhat.com> <20070722193129.GB16658@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933942AbXGWSGe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jul 2007 14:06:34 -0400
In-Reply-To: <20070722193129.GB16658@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> On Fri, Jul 20, 2007 at 04:47:14PM -0500, Eric Sandeen wrote:
>> For some odd geometries*, mkfs will try to allocate inode tables off
>> the end of the block group and fail, rather than warning that too
>> many inodes have been requested.
>>
>> This is because when ext2fs_initialize calculates metadata overhead,
>> it is only adding in group descriptor blocks and the superblock
>> if the *last* bg contains them - but the first bg also has all of 
>> the various metadata bits taking up space.
>>
>> Unconditionally adding those counts into the overhead seems to fix
>> it properly.
> 
> Yes, but it screws up the test right after that.  We need to calculate
> the overheads for both the first and last block group.  When I respun
> your patch and applied it to git, I fixed this.

Yep, I missed that.  Thanks for catching....

> I also added an explicit "Addresses-Red-Hat-Bugzilla: " entry to the
> commit log.  (This is mainly for your convenience when you're
> cherry-picking patches.)

Thanks, I appreciate that.

> Finally, your patch didn't apply because you apparently nuked a
> newline in the patch here:

Urhg, sorry.  Not sure how that happened.

Thanks,

-Eric

From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] libext2fs: write only core inode in update_path()
Date: Wed, 17 Jun 2009 15:43:01 -0500
Message-ID: <4A395555.2070308@redhat.com>
References: <494208.86194.qm@web43505.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: number9652 <number9652@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40750 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761930AbZFQUnD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jun 2009 16:43:03 -0400
In-Reply-To: <494208.86194.qm@web43505.mail.sp1.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

number9652 wrote:
> --- On Wed, 6/17/09, Eric Sandeen wrote:
>> Theodore Tso wrote:
>>> Probably it would be better/simpler to replace this
>> with:
>>> retval =
>> ext2fs_write_inode(handle->fs, handle->ino, handle->inode); - Ted
>>> 
>> Sure, that makes more sense, revised below:
>> 
>> libext2fs: write only core inode in update_path()
>> 
>> The ext2_extent_handle only has a struct ext2_inode allocated on 
>> it, and the same amount copied into it in that same function,
> 
> First, sorry for the original bug.  I don't think the above is the
> right way to fix it, however.  I am concerned that I may have
> basically broken write_inode_full on any inode with extents.  For
> example, there is another call to write_inode_full in extent.c that
> might exhibit this same problem.  I think the right fix would be to
> return to reading the full inode into memory in the extent_open
> function.  See the patch below for what I am talking about.

Hm, well, I wondered about that.  IMHO having these 2 inode sizes is a
big pain in the butt, and the shuffling back and forth is just asking
for bugs.

If this is the case (that it's broken now), then we really need
something in the regression suite to catch it - all tests pass in 1.41.6
....

-Eric



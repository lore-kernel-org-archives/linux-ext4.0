From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC][PATCH] fiemap support for ext3
Date: Mon, 21 Apr 2008 17:16:24 -0500
Message-ID: <480D1238.8080000@redhat.com>
References: <20080418210913.GB13973@unused.rdu.redhat.com> <20080421220851.GP2775@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Josef Bacik <jbacik@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584AbYDUWQ1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2008 18:16:27 -0400
In-Reply-To: <20080421220851.GP2775@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Apr 18, 2008  17:09 -0400, Josef Bacik wrote:
>> Here is my patch for fiemap support on ext3.  The main reason for doing this is
>> because it will make it easier for application developers who are wanting to
>> take advantage of fiemap on extent based fs's to be able to use the same
>> interface for ext3 as well without having to fallback onto something like
>> fibmap.  Fibmap also means you are calling ext3_get_block for _every_ block in
>> the file, which is ineffecient when ext3_get_blocks can map multiple contiguous
>> blocks all at once, reducing the number of times you have to call
>> ext3_get_blocks.  Tested this with sandeens fiemap test program and verified it
>> with filefrag.  Thanks much,
>>
>> Signed-off-by: Josef Bacik <jbacik@redhat.com>
> 
> Josef, thanks for doing this work.  Having more than a single filesystem
> implement FIEMAP (especially a block-mapped one) is very useful.  

I have an xfs patch too if anyone wants it ;)

So hopefully we can roll out at least 3 fs's when it goes upstream.

> Did you
> look at all at making a "generic_fiemap()" function?  It seems very little
> of ext3_fiemap() is ext3 specific, only the call to ext3_force_commit()
> (which could just be a sync on the inode), ext3_block_map() (generic for
> all block-based filesystems), and truncate_mutex (would i_sem be enough?).

Yep, I agree, it'd be good if ! ->fiemap then go the generic route.

Although my only question/worry is do all filesystems behave sanely in
the face of large b_size for getblocks?  All that can handle direct IO
do anyway.

>> +int ext3_fiemap(struct inode *inode, unsigned long arg)
>> +{
>> +	/*
>> +	 * if fm_start is in the middle of the current block, get the next
>> +	 * block so we don't end up returning a start thats before the given
>> +	 * fm_start
>> +	 */
>> +	start_blk = (fiemap_s->fm_start + (1 << inode->i_blkbits) - 1) >>
>> +		inode->i_blkbits;
> 
> Hmm, I'd think that if someone is requesting the mapping for bytes [50-5000]
> they wouldn't be very happy with the mapping returned being [4096-8191],
> because it is missing part of the requested range.  Instead, the fm_start
> should be rounded down to the start of the first block and up to the end
> of the last block to return [0-8191] (fm_start = 0, fm_length = 8192).

In fact that should be part of the interface definition, right.  Should
the returned mapping start at the beginning of the block that contains
the requsted offset, or at the requested offset itself?  I'd vote for
the former.

At some point I should probably write some QA for this thing to test
various file layouts and make sure we get the "right" answers on all
filesystems...

-Eric

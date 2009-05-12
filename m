From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH -V4 1/2] Fix sub-block zeroing for buffered writes into
 unwritten extents
Date: Mon, 11 May 2009 22:37:32 -0500
Message-ID: <4A08EEFC.3050200@redhat.com>
References: <1240980441-8105-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090512024218.GH21518@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36027 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbZELDhr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 May 2009 23:37:47 -0400
In-Reply-To: <20090512024218.GH21518@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Apr 29, 2009 at 10:17:20AM +0530, Aneesh Kumar K.V wrote:
>> We need to mark the  buffer_head mapping prealloc space
>> as new during write_begin. Otherwise we don't zero out the
>> page cache content properly for a partial write. This will
>> cause file corruption with preallocation.
>>
>> Also use block number -1 as the fake block number so that
>> unmap_underlying_metadata doesn't drop wrong buffer_head
> 
> The buffer_head code is starting to scare me more and more. 
> 
> I'm looking at this code again and I can't figure out why it's safe
> (or why we would need to) put in an invalid number into
> bh_result->b_blocknr:

I don't know for sure why it should be invalid; I think a preallocated
block, since it has an *actual* *block* *allocated* after all, should
have that block number.  But if it's going to be fake, let's not use a
"real" one like the superblock location...

A real block nr does eventually get assigned when we do getblock with
create=1 AFAICT.

>> @@ -2323,6 +2323,16 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
>>  		set_buffer_delay(bh_result);
>>  	} else if (ret > 0) {
>>  		bh_result->b_size = (ret << inode->i_blkbits);
>> +		/*
>> +		 * With sub-block writes into unwritten extents
>> +		 * we also need to mark the buffer as new so that
>> +		 * the unwritten parts of the buffer gets correctly zeroed.
>> +		 */
>> +		if (buffer_unwritten(bh_result)) {
>> +			bh_result->b_bdev = inode->i_sb->s_bdev;
>> +			set_buffer_new(bh_result);
>> +			bh_result->b_blocknr = -1;
> 
> Why do we need to avoid calling unmap_underlying_metadata()?

For that matter, why do we call unmap_underlying_metadata at all, ever?

> And after the buffer is zero'ed out, it leaves b_blocknr in a
> buffer_head attached to the page at an invalid block number.  Doesn't
> that get us in trouble later on?
> 
> I see that this line is removed later on in the for-2.6.31 patch "Mark
> the unwritten buffer_head as mapped during write_begin".  But is it
> safe for 2.6.30?

I have this in F11 now, but it's giving me the heebie-jeebies still.  At
least it's confined to preallocation (one of the great new ext4 features
I've been promoting recently... :)

-Eric

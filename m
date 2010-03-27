From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: FIEMAP sometimes returns bad information for delalloc extents
Date: Sat, 27 Mar 2010 13:35:17 -0500
Message-ID: <4BAE4FE5.7020004@redhat.com>
References: <E1NvXbm-00087i-Tf@closure.thunk.org> <DB0601D5-963C-4017-B7EA-A3764D2067EF@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <andreas.dilger@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790Ab0C0SfZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 27 Mar 2010 14:35:25 -0400
In-Reply-To: <DB0601D5-963C-4017-B7EA-A3764D2067EF@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On 2010-03-27, at 09:07, Theodore Ts'o wrote:
>> I was monitoring the progress of a distributed download program, and saw
>> the following output from two runs of filefrag taken a few seconds
>> apart:
>>
>>   8     790  8825663  8825551     65
>>   9     855        0  8825727    319 unknown,delalloc
>>  10    1174  8798367      318    128
>>
>>   7     790  8825663  8825559     69
>>   8    1174  8798367  8825731    128
>>
>> The length of the delalloc extent, 319, is bogus.  The 319 seems to come
>> from 1174 - 855.   But it's not actually the number of delayed
>> allocation blocks, as we can see when the blocks finally get written;
>> apparently it was only 4 blocks long.
> 
> I'm surprised it shows anything at all for delalloc blocks, since AFAIK
> FIEMAP is only walking the extent tree.  It would be interesting if it
> walked the VM pagetable for unallocated extents in the file, and beyond
> i_size.

it does this in the callback for ext4_ext_walk_space:

        if (newex->ec_type == EXT4_EXT_CACHE_GAP) {
...
                page = find_get_page(inode->i_mapping, offset);
...
                bh = page_buffers(page);
...
                if (buffer_delay(bh)) {
                        flags |= FIEMAP_EXTENT_DELALLOC;
...

so it was an attempt, at least, to flag which extents are delalloc.

FWIW, on xfs xfs_bmap initially would cause a file flush, it didn't even ever
try to report delalloc until fiemap came along ...

-Eric

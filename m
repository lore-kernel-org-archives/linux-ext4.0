From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] filefrag: fix wrong extent count calculation when using
 FIBMAP
Date: Tue, 7 Oct 2014 12:12:44 +0800
Message-ID: <5433683C.4070807@cn.fujitsu.com>
References: <5422CAC2.7080409@redhat.com> <1412593539-18328-1-git-send-email-wangxg.fnst@cn.fujitsu.com> <20141007024339.GA10054@birch.djwong.org> <5433630A.5030808@cn.fujitsu.com> <20141007035904.GB10054@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18956 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750718AbaJGENk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2014 00:13:40 -0400
In-Reply-To: <20141007035904.GB10054@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On 10/07/2014 11:59 AM, Darrick J. Wong wrote:
> On Tue, Oct 07, 2014 at 11:50:34AM +0800, Xiaoguang Wang wrote:
>> Hi,
>>
>> On 10/07/2014 10:43 AM, Darrick J. Wong wrote:
>>> On Mon, Oct 06, 2014 at 07:05:39PM +0800, Xiaoguang Wang wrote:
>>>> When using FIBMAP and '-e' option is specified, the calculation for fiemap_extent
>>>> is wrong, we wrongly updated fm_ext.fe_logical for every iteration, please see the
>>>> code in the end of 'for' loop in fm_ext.fe_logical().
>>>>
>>>> In an ext2 file system(block size is 1024 bytes),
>>>>   dd if=/dev/zero of=testfile bs=1k count=15
>>>>   Using debugfs, corresponding physical blocks are "2049 2050 2051 2052 2053 2054
>>>> 2055 2056 2057 2058 2059 2060 1025 2061 2062 2063",  1025 is this indirect block.
>>>> Before this patch, filefrag's output would be:
>>>>   filefrag -B -e testfile
>>>>   Filesystem type is: ef53
>>>>   Filesystem cylinder groups approximately 16
>>>>   File size of testfile is 15360 (15 blocks of 1024 bytes)
>>>>    ext:     logical_offset:        physical_offset: length:   expected: flags:
>>>>      0:        1..       2:       2050..      2051:      2:       2051: merged
>>>>      1:        3..       4:       2052..      2053:      2:       2053: merged
>>>>      2:        5..       6:       2054..      2055:      2:       2055: merged
>>>>      3:        7..       8:       2056..      2057:      2:       2057: merged
>>>>      4:        9..      10:       2058..      2059:      2:       2059: merged
>>>>      5:       11..      12:       2060..      2061:      2:       2062: merged
>>>>      6:       13..      14:       2062..      2063:      2:       2063: merged,eof
>>>>      7:       14..      14:       2063..      2063:      1:       2063: merged,eof
>>>> This output is not reasonable.
>>>
>>> It's just plain whacky.  Why would logical offset 14 be listed twice? :)
>>
>> Because of the wrong code :)  It updates fm_ext.fe_logical and fm_ext.fe_physical for every
>> iteration :) and i think the original code is not that readable.
>>>
>>>> Fix this bug and try to make it readable. After this patch, the output would be:
>>>>   ./filefrag -B -e mntpoint/testfile
>>>>   Filesystem type is: ef53
>>>>   Filesystem cylinder groups approximately 16
>>>>   File size of mntpoint/testfile is 15360 (15 blocks of 1024 bytes)
>>>>    ext:     logical_offset:        physical_offset: length:   expected: flags:
>>>>      0:        0..      11:       2049..      2060:     12:       2062: merged
>>>>      1:       12..      14:       2061..      2063:      3:       2063: merged,eof
>>>>   mntpoint/testfile: 2 extents found, perfection would be 1 extent
>>>
>>> Where'd the indirect block end up, if not in the middle of 2049-2063?
>>
>> Indirect block's information is used to judge whether logical region is continuous physically.
>> For example, the above testfile's first indirect block is 1025, and will not shown in the output.
> 
> 1025?  Huh.  Is this an old FS, or is there something wrong with the block
> allocator?

Yeah, it's strange. I created testfile multiple times, data blocks are basically continuous, but
indirect block always not. It seems that block allocator does not work well.
I have this test on a 128MB loop device(mkfs to ext2), OS: Fedora 19(3.9.5-301.fc19.x86_64)

Regards,
Xiaoguang Wang

> 
> --D
> 
>>
>>>
>>>> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
>>>> ---
>>>>  misc/filefrag.c | 37 +++++++++++++++++++++++--------------
>>>>  1 file changed, 23 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/misc/filefrag.c b/misc/filefrag.c
>>>> index c1a8684..e9f7e68 100644
>>>> --- a/misc/filefrag.c
>>>> +++ b/misc/filefrag.c
>>>> @@ -315,32 +315,41 @@ static int filefrag_fibmap(int fd, int blk_shift, int *num_extents,
>>>>  			return rc;
>>>>  		if (block == 0)
>>>>  			continue;
>>>> +		count++;
>>>> +
>>>>  		if (*num_extents == 0) {
>>>>  			(*num_extents)++;
>>>>  			if (force_extent) {
>>>>  				print_extent_header();
>>>> +				fm_ext.fe_logical = logical;
>>>>  				fm_ext.fe_physical = block * st->st_blksize;
>>>> +				fm_ext.fe_length = st->st_blksize;
>>>>  			}
>>>> +			last_block = block;
>>>> +			continue;
>>>>  		}
>>>> -		count++;
>>>> -		if (force_extent && last_block != 0 &&
>>>> -		    (block != last_block + 1 ||
>>>> -		     fm_ext.fe_logical + fm_ext.fe_length != logical)) {
>>>> -			print_extent_info(&fm_ext, *num_extents - 1,
>>>> -					  (last_block + 1) * st->st_blksize,
>>>> -					  blk_shift, st);
>>>> -			fm_ext.fe_length = 0;
>>>> -			(*num_extents)++;
>>>> +
>>>> +		if (force_extent) {
>>>> +			if (block != last_block + 1 ||
>>>> +			    fm_ext.fe_length + fm_ext.fe_logical != logical) {
>>>> +				print_extent_info(&fm_ext, *num_extents - 1,
>>>> +						  (last_block + 1) *
>>>> +						  st->st_blksize,
>>>> +						  blk_shift, st);
>>>> +				fm_ext.fe_logical = logical;
>>>> +				fm_ext.fe_physical = block * st->st_blksize;
>>>> +				fm_ext.fe_length = st->st_blksize;
>>>> +				(*num_extents)++;
>>>> +			} else {
>>>> +				fm_ext.fe_length += st->st_blksize;
>>>> +			}
>>>>  		} else if (last_block && (block != last_block + 1)) {
>>>> -			if (verbose)
>>>> +			if (verbose) {
>>>>  				printf("Discontinuity: Block %ld is at %lu (was "
>>>>  				       "%lu)\n", i, block, last_block + 1);
>>>> -			fm_ext.fe_length = 0;
>>>> +			}
>>>
>>> The { } is not needed for a single line if statement.
>>
>> OK, I'll send a new version to remove it, thanks!
>>
>> Regards,
>> Xiaoguang Wang
>>>
>>>>  			(*num_extents)++;
>>>>  		}
>>>> -		fm_ext.fe_logical = logical;
>>>> -		fm_ext.fe_physical = block * st->st_blksize;
>>>> -		fm_ext.fe_length += st->st_blksize;
>>>>  		last_block = block;
>>>
>>> Otherwise, I think this looks decent.
>>>
>>> --D
>>>
>>>>  	}
>>>>  
>>>> -- 
>>>> 1.8.2.1
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> .
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 


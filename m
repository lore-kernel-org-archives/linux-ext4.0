From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH] e4defrag: fallocate donor file only once
Date: Sun, 06 Sep 2009 00:29:36 +0800
Message-ID: <4AA291F0.3020505@gmail.com>
References: <1251905704-10078-1-git-send-email-bergwolf@gmail.com>	 <87f94c370909021509u7d07a6e5ia210cfd8b8db70e0@mail.gmail.com>	 <6149e97b0909030100p1930c0fra28663724e51114@mail.gmail.com>	 <87f94c370909030230w6ab49265yf6e689cbae1d458c@mail.gmail.com>	 <6149e97b0909032008m26e554c8x92750455e26a52a0@mail.gmail.com>	 <87f94c370909040536v391bd546ye9eb1038f4a32cba@mail.gmail.com>	 <4AA146B0.6070701@gmail.com> <87f94c370909041210l56c97b9ekf7d98aae6cd10827@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f184.google.com ([209.85.216.184]:37522 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbZIEQ3j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Sep 2009 12:29:39 -0400
Received: by pxi14 with SMTP id 14so1562171pxi.19
        for <linux-ext4@vger.kernel.org>; Sat, 05 Sep 2009 09:29:42 -0700 (PDT)
In-Reply-To: <87f94c370909041210l56c97b9ekf7d98aae6cd10827@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Greg Freemyer wrote:
> On Fri, Sep 4, 2009 at 12:56 PM, Peng Tao<bergwolf@gmail.com> wrote:
>> Greg Freemyer wrote:
>>> On Thu, Sep 3, 2009 at 11:08 PM, Peng Tao<bergwolf@gmail.com> wrote:
>>>> On Thu, Sep 3, 2009 at 5:30 PM, Greg Freemyer<greg.freemyer@gmail.com> wrote:
>>>>> On Thu, Sep 3, 2009 at 4:00 AM, Peng Tao<bergwolf@gmail.com> wrote:
>>>>>> On Thu, Sep 3, 2009 at 6:09 AM, Greg Freemyer<greg.freemyer@gmail.com> wrote:
>>>>>>> On Wed, Sep 2, 2009 at 11:35 AM, Peng Tao<bergwolf@gmail.com> wrote:
>>>>>>>> If we allocate the donor file once for all, it will have a better chance
>>>>>>>> to be continuous.
>>>>>>>>
>>>>>>>> Signed-off-by: "Peng Tao" <bergwolf@gmail.com>
>>>>>>> Seems like an improvement, but I'm not seeing any special handling for
>>>>>>> sparse files.  (Not before or after this patch.)
>>>>>>>
>>>>>>> Seems like there should be an outer loop that identifies contiguous
>>>>>>> data block sets in a sparse file and defrags them individually as
>>>>>>> opposed to trying to defrag the entire file at once.
>>>>>>>
>>>>>>> My impression is that with a large sparse file, e4defrag currently
>>>>>>> (with or without this patch) would fallocate a full non-sparse donor
>>>>>>> set of blocks the full size of the original file, then swap in just
>>>>>>> the truly allocated blocks?
>>>>>> Thanks for the reminder. The original code takes good care of sparse
>>>>>> files in join_extents(). Please ignore my patch.
>>>>>>
>>>>>> Sorry for the noise.
>>>>> RFC from a more ext4 knowledgeable person than me:
>>>>>
>>>>> The code in e4defrag still looks way to complex.  I don't see why it
>>>>> needs to know so much about extents and groups.
>>>>>
>>>>> I just looked at util/copy_sparse.c
>>>>>
>>>>> It simply loops through all the blocks in the source file and calls
>>>>> ioctl(fd, FIBMAP, &b) to see if they are allocated vs. sparse,
>>>>>
>>>>> If allocated it copies the block from src to dest.  Pretty straight
>>>>> forward and has none of the complexity of e4defrag.
>>>>>
>>>>> Seems to me e4defrag should have the actual defrag_file() rewritten to
>>>>> be something like:
>>>>>
>>>>> defrag_file()  {
>>>>>    loop through the blocks looking for the contiguous set of data blocks.
>>>>>          defrag_contiguous_data(start_block, num_blocks)
>>>>> }
>>>>>
>>>>> defrag_contiguous_data(start_block, num_blocks) {
>>>>>    // allocate one full extent at a time and donate the blocks to orig file
>>>>>    for(start=start_block; start < start_block, num_blocks; start+=chunk) {
>>>>>          fallocate(chunk);
>>>>>          move_ext(orig, donor, start, 0, chunk);
>>>>>      }
>>>>> }
>>>>>
>>>>> And then set chunk to be the max size of one extent.  Maybe the
>>>>> "chunk" should be bigger than one extent?
>>>>>
>>>>> Also, I did not put any logic in above to show testing to see if the
>>>>> new file is less fragmented than the original.  That will add to the
>>>>> complexity, but hopefully the actual defrag logic can be as relatively
>>>>> simple as the above instead of what it is now.
>>>>>
>>>>> Anyway, t would be a major change to e4defrag, but it seems that it
>>>>> would give ext4 a much better chance to reorganize itself by calling
>>>>> fallocate on full extent size chunks at minimum, instead of what the
>>>>> code currently does.
>>>> Hi, Greg,
>>>>
>>>> The current e4defrag is doing most of work exactly same as your RFC,
>>>> and in a nicer manner. If you look into the code path, you'll see that
>>>> its logic is very much like the RFC except that it first fallocates a
>>>> donor file to see if a defragmentation is really necessary so it won't
>>>> have to fall back during defragmentation, which IMO is a good design
>>>> point.
>>>>
>>>> Please correct me if I understand anything wrong.
>>> I've looked a lot more at the current code.  I'm pretty sure this is right:
>>>
>>> First, assume defrag of a non-sparse 1TB file.
>>>
>>> The current code will walk the extent tree and create a single extent
>>> group that covers the full 1TB, then call fallocate to try to get 1TB
>>> of donor blocks.  Then compare the number of extents in the original
>>> and the donor.  If the donor has less it will swap in the donor
>>> blocks.
>>>
>>> It seems much smarter work on extent size chunks (or whatever best
>>> fits the kernels block structure.
>>>
>>> ie.
>>>
>>> for (start_block=0; start_block < max_blocks; start_block+=
>>> max_blocks_in_extent)
>>>
>>>       current_extents = num_extents_in_block_range(start_block,
>>> start+max_blocks_in_extent);
>>>
>>>       if (current_extents == 1) continue;
>>>
>>>       // allocate a sparse file with perfectly aligned donor blocks as
>>> currently required by kernel
>>>       fallocate(start_block * block_size, max_blocks_in_extent * block_size);
>>>
>>>       donor_extents = num_extents_in_block_range(start_block,
>>> start+max_blocks_in_extent);
>>>
>>>      if (donor_extents < current_extents)
>>>             donate_donor_blocks_to_orig(start_block,
>>> start+max_blocks_in_extent);
>>>
>>> )
>>>
>>> And in the case of a sparse file, it seems much easier to understand
>>> if the above is called on each logically contiguous set or data
>>> blocks.  Seriously, why bother the kernel by making it able to accept
>>> a block range that has holes in it.
>> Agreed. If the kernel doesn't have to deal with holes, the EXT4_IOC_MOVE_EXT
>> ioctl can be much simplified.
>>> It seems reasonable for the kernel to check the block range being
>>> passed in and if the orig files has a hole in the middle of it, then
>>> return an error.
>>>
>>> Back to e4defrag, even if the code is not greatly simplified, the
>>> above seems like it would use far less resources than the current
>>> code.   Think about a large file that has the first 90% of the blocks
>>> defrag'ed.  The above would cause just the tail to be defrag'ed, not
>>> the entire file.
>> Yes, it makes sense. Are you planning some patch for above changes?
> 
> I'm "planning", but I doubt that I get to it for a few weeks.  If you
> or someone else has time, that would be great.
I don't have time for it in a few weeks either. So if anyone is interested,
please drop in.
> 
> Greg


-- 
Best Regards,
Peng Tao
State Key Laboratory of Networking and Switching Technology
Beijing Univ. of Posts and Telecoms.

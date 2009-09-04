From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH] e4defrag: fallocate donor file only once
Date: Fri, 4 Sep 2009 08:36:11 -0400
Message-ID: <87f94c370909040536v391bd546ye9eb1038f4a32cba@mail.gmail.com>
References: <1251905704-10078-1-git-send-email-bergwolf@gmail.com>
	 <87f94c370909021509u7d07a6e5ia210cfd8b8db70e0@mail.gmail.com>
	 <6149e97b0909030100p1930c0fra28663724e51114@mail.gmail.com>
	 <87f94c370909030230w6ab49265yf6e689cbae1d458c@mail.gmail.com>
	 <6149e97b0909032008m26e554c8x92750455e26a52a0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:33680 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795AbZIDMgJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Sep 2009 08:36:09 -0400
Received: by qw-out-2122.google.com with SMTP id 8so221748qwh.37
        for <linux-ext4@vger.kernel.org>; Fri, 04 Sep 2009 05:36:11 -0700 (PDT)
In-Reply-To: <6149e97b0909032008m26e554c8x92750455e26a52a0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 3, 2009 at 11:08 PM, Peng Tao<bergwolf@gmail.com> wrote:
> On Thu, Sep 3, 2009 at 5:30 PM, Greg Freemyer<greg.freemyer@gmail.com=
> wrote:
>> On Thu, Sep 3, 2009 at 4:00 AM, Peng Tao<bergwolf@gmail.com> wrote:
>>> On Thu, Sep 3, 2009 at 6:09 AM, Greg Freemyer<greg.freemyer@gmail.c=
om> wrote:
>>>> On Wed, Sep 2, 2009 at 11:35 AM, Peng Tao<bergwolf@gmail.com> wrot=
e:
>>>>> If we allocate the donor file once for all, it will have a better=
 chance
>>>>> to be continuous.
>>>>>
>>>>> Signed-off-by: "Peng Tao" <bergwolf@gmail.com>
>>>>
>>>> Seems like an improvement, but I'm not seeing any special handling=
 for
>>>> sparse files. =A0(Not before or after this patch.)
>>>>
>>>> Seems like there should be an outer loop that identifies contiguou=
s
>>>> data block sets in a sparse file and defrags them individually as
>>>> opposed to trying to defrag the entire file at once.
>>>>
>>>> My impression is that with a large sparse file, e4defrag currently
>>>> (with or without this patch) would fallocate a full non-sparse don=
or
>>>> set of blocks the full size of the original file, then swap in jus=
t
>>>> the truly allocated blocks?
>>> Thanks for the reminder. The original code takes good care of spars=
e
>>> files in join_extents(). Please ignore my patch.
>>>
>>> Sorry for the noise.
>>
>> RFC from a more ext4 knowledgeable person than me:
>>
>> The code in e4defrag still looks way to complex. =A0I don't see why =
it
>> needs to know so much about extents and groups.
>>
>> I just looked at util/copy_sparse.c
>>
>> It simply loops through all the blocks in the source file and calls
>> ioctl(fd, FIBMAP, &b) to see if they are allocated vs. sparse,
>>
>> If allocated it copies the block from src to dest. =A0Pretty straigh=
t
>> forward and has none of the complexity of e4defrag.
>>
>> Seems to me e4defrag should have the actual defrag_file() rewritten =
to
>> be something like:
>>
>> defrag_file() =A0{
>> =A0 =A0loop through the blocks looking for the contiguous set of dat=
a blocks.
>> =A0 =A0 =A0 =A0 =A0defrag_contiguous_data(start_block, num_blocks)
>> }
>>
>> defrag_contiguous_data(start_block, num_blocks) {
>> =A0 =A0// allocate one full extent at a time and donate the blocks t=
o orig file
>> =A0 =A0for(start=3Dstart_block; start < start_block, num_blocks; sta=
rt+=3Dchunk) {
>> =A0 =A0 =A0 =A0 =A0fallocate(chunk);
>> =A0 =A0 =A0 =A0 =A0move_ext(orig, donor, start, 0, chunk);
>> =A0 =A0 =A0}
>> }
>>
>> And then set chunk to be the max size of one extent. =A0Maybe the
>> "chunk" should be bigger than one extent?
>>
>> Also, I did not put any logic in above to show testing to see if the
>> new file is less fragmented than the original. =A0That will add to t=
he
>> complexity, but hopefully the actual defrag logic can be as relative=
ly
>> simple as the above instead of what it is now.
>>
>> Anyway, t would be a major change to e4defrag, but it seems that it
>> would give ext4 a much better chance to reorganize itself by calling
>> fallocate on full extent size chunks at minimum, instead of what the
>> code currently does.
> Hi, Greg,
>
> The current e4defrag is doing most of work exactly same as your RFC,
> and in a nicer manner. If you look into the code path, you'll see tha=
t
> its logic is very much like the RFC except that it first fallocates a
> donor file to see if a defragmentation is really necessary so it won'=
t
> have to fall back during defragmentation, which IMO is a good design
> point.
>
> Please correct me if I understand anything wrong.

I've looked a lot more at the current code.  I'm pretty sure this is ri=
ght:

=46irst, assume defrag of a non-sparse 1TB file.

The current code will walk the extent tree and create a single extent
group that covers the full 1TB, then call fallocate to try to get 1TB
of donor blocks.  Then compare the number of extents in the original
and the donor.  If the donor has less it will swap in the donor
blocks.

It seems much smarter work on extent size chunks (or whatever best
fits the kernels block structure.

ie.

for (start_block=3D0; start_block < max_blocks; start_block+=3D
max_blocks_in_extent)

      current_extents =3D num_extents_in_block_range(start_block,
start+max_blocks_in_extent);

      if (current_extents =3D=3D 1) continue;

      // allocate a sparse file with perfectly aligned donor blocks as
currently required by kernel
      fallocate(start_block * block_size, max_blocks_in_extent * block_=
size);

      donor_extents =3D num_extents_in_block_range(start_block,
start+max_blocks_in_extent);

     if (donor_extents < current_extents)
            donate_donor_blocks_to_orig(start_block,
start+max_blocks_in_extent);

)

And in the case of a sparse file, it seems much easier to understand
if the above is called on each logically contiguous set or data
blocks.  Seriously, why bother the kernel by making it able to accept
a block range that has holes in it.

It seems reasonable for the kernel to check the block range being
passed in and if the orig files has a hole in the middle of it, then
return an error.

Back to e4defrag, even if the code is not greatly simplified, the
above seems like it would use far less resources than the current
code.   Think about a large file that has the first 90% of the blocks
defrag'ed.  The above would cause just the tail to be defrag'ed, not
the entire file.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

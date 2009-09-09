From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH] e4defrag: fallocate donor file only once
Date: Wed, 9 Sep 2009 09:24:57 +0800
Message-ID: <6149e97b0909081824h78c6744p4602b70a938670fa@mail.gmail.com>
References: <1251905704-10078-1-git-send-email-bergwolf@gmail.com>
	 <87f94c370909021509u7d07a6e5ia210cfd8b8db70e0@mail.gmail.com>
	 <6149e97b0909030100p1930c0fra28663724e51114@mail.gmail.com>
	 <87f94c370909030230w6ab49265yf6e689cbae1d458c@mail.gmail.com>
	 <6149e97b0909032008m26e554c8x92750455e26a52a0@mail.gmail.com>
	 <87f94c370909040536v391bd546ye9eb1038f4a32cba@mail.gmail.com>
	 <4AA146B0.6070701@gmail.com>
	 <87f94c370909041210l56c97b9ekf7d98aae6cd10827@mail.gmail.com>
	 <4AA291F0.3020505@gmail.com>
	 <87f94c370909080841q5042201du4124ddb253ef0ea8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f201.google.com ([209.85.222.201]:49154 "EHLO
	mail-pz0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbZIIBYy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Sep 2009 21:24:54 -0400
Received: by pzk39 with SMTP id 39so3640891pzk.15
        for <linux-ext4@vger.kernel.org>; Tue, 08 Sep 2009 18:24:57 -0700 (PDT)
In-Reply-To: <87f94c370909080841q5042201du4124ddb253ef0ea8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 8, 2009 at 11:41 PM, Greg Freemyer<greg.freemyer@gmail.com>=
 wrote:
> On Sat, Sep 5, 2009 at 12:29 PM, Peng Tao<bergwolf@gmail.com> wrote:
>> Greg Freemyer wrote:
>>> On Fri, Sep 4, 2009 at 12:56 PM, Peng Tao<bergwolf@gmail.com> wrote=
:
>>>> Greg Freemyer wrote:
>>>>> On Thu, Sep 3, 2009 at 11:08 PM, Peng Tao<bergwolf@gmail.com> wro=
te:
>>>>>> On Thu, Sep 3, 2009 at 5:30 PM, Greg Freemyer<greg.freemyer@gmai=
l.com> wrote:
>>>>>>> On Thu, Sep 3, 2009 at 4:00 AM, Peng Tao<bergwolf@gmail.com> wr=
ote:
>>>>>>>> On Thu, Sep 3, 2009 at 6:09 AM, Greg Freemyer<greg.freemyer@gm=
ail.com> wrote:
>>>>>>>>> On Wed, Sep 2, 2009 at 11:35 AM, Peng Tao<bergwolf@gmail.com>=
 wrote:
>>>>>>>>>> If we allocate the donor file once for all, it will have a b=
etter chance
>>>>>>>>>> to be continuous.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: "Peng Tao" <bergwolf@gmail.com>
>>>>>>>>> Seems like an improvement, but I'm not seeing any special han=
dling for
>>>>>>>>> sparse files. =C2=A0(Not before or after this patch.)
>>>>>>>>>
>>>>>>>>> Seems like there should be an outer loop that identifies cont=
iguous
>>>>>>>>> data block sets in a sparse file and defrags them individuall=
y as
>>>>>>>>> opposed to trying to defrag the entire file at once.
>>>>>>>>>
>>>>>>>>> My impression is that with a large sparse file, e4defrag curr=
ently
>>>>>>>>> (with or without this patch) would fallocate a full non-spars=
e donor
>>>>>>>>> set of blocks the full size of the original file, then swap i=
n just
>>>>>>>>> the truly allocated blocks?
>>>>>>>> Thanks for the reminder. The original code takes good care of =
sparse
>>>>>>>> files in join_extents(). Please ignore my patch.
>>>>>>>>
>>>>>>>> Sorry for the noise.
>>>>>>> RFC from a more ext4 knowledgeable person than me:
>>>>>>>
>>>>>>> The code in e4defrag still looks way to complex. =C2=A0I don't =
see why it
>>>>>>> needs to know so much about extents and groups.
>>>>>>>
>>>>>>> I just looked at util/copy_sparse.c
>>>>>>>
>>>>>>> It simply loops through all the blocks in the source file and c=
alls
>>>>>>> ioctl(fd, FIBMAP, &b) to see if they are allocated vs. sparse,
>>>>>>>
>>>>>>> If allocated it copies the block from src to dest. =C2=A0Pretty=
 straight
>>>>>>> forward and has none of the complexity of e4defrag.
>>>>>>>
>>>>>>> Seems to me e4defrag should have the actual defrag_file() rewri=
tten to
>>>>>>> be something like:
>>>>>>>
>>>>>>> defrag_file() =C2=A0{
>>>>>>> =C2=A0 =C2=A0loop through the blocks looking for the contiguous=
 set of data blocks.
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0defrag_contiguous_data(start_=
block, num_blocks)
>>>>>>> }
>>>>>>>
>>>>>>> defrag_contiguous_data(start_block, num_blocks) {
>>>>>>> =C2=A0 =C2=A0// allocate one full extent at a time and donate t=
he blocks to orig file
>>>>>>> =C2=A0 =C2=A0for(start=3Dstart_block; start < start_block, num_=
blocks; start+=3Dchunk) {
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fallocate(chunk);
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0move_ext(orig, donor, start, =
0, chunk);
>>>>>>> =C2=A0 =C2=A0 =C2=A0}
>>>>>>> }
>>>>>>>
>>>>>>> And then set chunk to be the max size of one extent. =C2=A0Mayb=
e the
>>>>>>> "chunk" should be bigger than one extent?
>>>>>>>
>>>>>>> Also, I did not put any logic in above to show testing to see i=
f the
>>>>>>> new file is less fragmented than the original. =C2=A0That will =
add to the
>>>>>>> complexity, but hopefully the actual defrag logic can be as rel=
atively
>>>>>>> simple as the above instead of what it is now.
>>>>>>>
>>>>>>> Anyway, t would be a major change to e4defrag, but it seems tha=
t it
>>>>>>> would give ext4 a much better chance to reorganize itself by ca=
lling
>>>>>>> fallocate on full extent size chunks at minimum, instead of wha=
t the
>>>>>>> code currently does.
>>>>>> Hi, Greg,
>>>>>>
>>>>>> The current e4defrag is doing most of work exactly same as your =
RFC,
>>>>>> and in a nicer manner. If you look into the code path, you'll se=
e that
>>>>>> its logic is very much like the RFC except that it first falloca=
tes a
>>>>>> donor file to see if a defragmentation is really necessary so it=
 won't
>>>>>> have to fall back during defragmentation, which IMO is a good de=
sign
>>>>>> point.
>>>>>>
>>>>>> Please correct me if I understand anything wrong.
>>>>> I've looked a lot more at the current code. =C2=A0I'm pretty sure=
 this is right:
>>>>>
>>>>> First, assume defrag of a non-sparse 1TB file.
>>>>>
>>>>> The current code will walk the extent tree and create a single ex=
tent
>>>>> group that covers the full 1TB, then call fallocate to try to get=
 1TB
>>>>> of donor blocks. =C2=A0Then compare the number of extents in the =
original
>>>>> and the donor. =C2=A0If the donor has less it will swap in the do=
nor
>>>>> blocks.
>>>>>
>>>>> It seems much smarter work on extent size chunks (or whatever bes=
t
>>>>> fits the kernels block structure.
>>>>>
>>>>> ie.
>>>>>
>>>>> for (start_block=3D0; start_block < max_blocks; start_block+=3D
>>>>> max_blocks_in_extent)
>>>>>
>>>>> =C2=A0 =C2=A0 =C2=A0 current_extents =3D num_extents_in_block_ran=
ge(start_block,
>>>>> start+max_blocks_in_extent);
>>>>>
>>>>> =C2=A0 =C2=A0 =C2=A0 if (current_extents =3D=3D 1) continue;
>>>>>
>>>>> =C2=A0 =C2=A0 =C2=A0 // allocate a sparse file with perfectly ali=
gned donor blocks as
>>>>> currently required by kernel
>>>>> =C2=A0 =C2=A0 =C2=A0 fallocate(start_block * block_size, max_bloc=
ks_in_extent * block_size);
>>>>>
>>>>> =C2=A0 =C2=A0 =C2=A0 donor_extents =3D num_extents_in_block_range=
(start_block,
>>>>> start+max_blocks_in_extent);
>>>>>
>>>>> =C2=A0 =C2=A0 =C2=A0if (donor_extents < current_extents)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 donate_donor_blocks_to_=
orig(start_block,
>>>>> start+max_blocks_in_extent);
>>>>>
>>>>> )
>>>>>
>>>>> And in the case of a sparse file, it seems much easier to underst=
and
>>>>> if the above is called on each logically contiguous set or data
>>>>> blocks. =C2=A0Seriously, why bother the kernel by making it able =
to accept
>>>>> a block range that has holes in it.
>>>> Agreed. If the kernel doesn't have to deal with holes, the EXT4_IO=
C_MOVE_EXT
>>>> ioctl can be much simplified.
>>>>> It seems reasonable for the kernel to check the block range being
>>>>> passed in and if the orig files has a hole in the middle of it, t=
hen
>>>>> return an error.
>>>>>
>>>>> Back to e4defrag, even if the code is not greatly simplified, the
>>>>> above seems like it would use far less resources than the current
>>>>> code. =C2=A0 Think about a large file that has the first 90% of t=
he blocks
>>>>> defrag'ed. =C2=A0The above would cause just the tail to be defrag=
'ed, not
>>>>> the entire file.
>>>> Yes, it makes sense. Are you planning some patch for above changes=
?
>>>
>>> I'm "planning", but I doubt that I get to it for a few weeks. =C2=A0=
If you
>>> or someone else has time, that would be great.
>> I don't have time for it in a few weeks either. So if anyone is inte=
rested,
>> please drop in.
>>>
>>> Greg
>>
>>
>> --
>> Best Regards,
>> Peng Tao
>> State Key Laboratory of Networking and Switching Technology
>> Beijing Univ. of Posts and Telecoms.
>>
>
> If I take a shot at this, which branch should a base my patch against=
? =C2=A0Master?
Yes, I think so. I verified that e4defrag.c is the same in master and p=
u branch.
>
> Thanks
> Greg
>



--=20
Cheers,
Peng Tao
State Key Laboratory of Networking and Switching Technology
Beijing Univ. of Posts and Telecoms.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

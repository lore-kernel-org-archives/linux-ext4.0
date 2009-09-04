From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH] e4defrag: fallocate donor file only once
Date: Fri, 4 Sep 2009 11:08:33 +0800
Message-ID: <6149e97b0909032008m26e554c8x92750455e26a52a0@mail.gmail.com>
References: <1251905704-10078-1-git-send-email-bergwolf@gmail.com>
	 <87f94c370909021509u7d07a6e5ia210cfd8b8db70e0@mail.gmail.com>
	 <6149e97b0909030100p1930c0fra28663724e51114@mail.gmail.com>
	 <87f94c370909030230w6ab49265yf6e689cbae1d458c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f194.google.com ([209.85.216.194]:43449 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596AbZIDDQu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Sep 2009 23:16:50 -0400
Received: by pxi32 with SMTP id 32so376265pxi.25
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2009 20:16:53 -0700 (PDT)
In-Reply-To: <87f94c370909030230w6ab49265yf6e689cbae1d458c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 3, 2009 at 5:30 PM, Greg Freemyer<greg.freemyer@gmail.com> =
wrote:
> On Thu, Sep 3, 2009 at 4:00 AM, Peng Tao<bergwolf@gmail.com> wrote:
>> On Thu, Sep 3, 2009 at 6:09 AM, Greg Freemyer<greg.freemyer@gmail.co=
m> wrote:
>>> On Wed, Sep 2, 2009 at 11:35 AM, Peng Tao<bergwolf@gmail.com> wrote=
:
>>>> If we allocate the donor file once for all, it will have a better =
chance
>>>> to be continuous.
>>>>
>>>> Signed-off-by: "Peng Tao" <bergwolf@gmail.com>
>>>
>>> Seems like an improvement, but I'm not seeing any special handling =
for
>>> sparse files. =C2=A0(Not before or after this patch.)
>>>
>>> Seems like there should be an outer loop that identifies contiguous
>>> data block sets in a sparse file and defrags them individually as
>>> opposed to trying to defrag the entire file at once.
>>>
>>> My impression is that with a large sparse file, e4defrag currently
>>> (with or without this patch) would fallocate a full non-sparse dono=
r
>>> set of blocks the full size of the original file, then swap in just
>>> the truly allocated blocks?
>> Thanks for the reminder. The original code takes good care of sparse
>> files in join_extents(). Please ignore my patch.
>>
>> Sorry for the noise.
>
> RFC from a more ext4 knowledgeable person than me:
>
> The code in e4defrag still looks way to complex. =C2=A0I don't see wh=
y it
> needs to know so much about extents and groups.
>
> I just looked at util/copy_sparse.c
>
> It simply loops through all the blocks in the source file and calls
> ioctl(fd, FIBMAP, &b) to see if they are allocated vs. sparse,
>
> If allocated it copies the block from src to dest. =C2=A0Pretty strai=
ght
> forward and has none of the complexity of e4defrag.
>
> Seems to me e4defrag should have the actual defrag_file() rewritten t=
o
> be something like:
>
> defrag_file() =C2=A0{
> =C2=A0 =C2=A0loop through the blocks looking for the contiguous set o=
f data blocks.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0defrag_contiguous_data(start_block,=
 num_blocks)
> }
>
> defrag_contiguous_data(start_block, num_blocks) {
> =C2=A0 =C2=A0// allocate one full extent at a time and donate the blo=
cks to orig file
> =C2=A0 =C2=A0for(start=3Dstart_block; start < start_block, num_blocks=
; start+=3Dchunk) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fallocate(chunk);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0move_ext(orig, donor, start, 0, chu=
nk);
> =C2=A0 =C2=A0 =C2=A0}
> }
>
> And then set chunk to be the max size of one extent. =C2=A0Maybe the
> "chunk" should be bigger than one extent?
>
> Also, I did not put any logic in above to show testing to see if the
> new file is less fragmented than the original. =C2=A0That will add to=
 the
> complexity, but hopefully the actual defrag logic can be as relativel=
y
> simple as the above instead of what it is now.
>
> Anyway, t would be a major change to e4defrag, but it seems that it
> would give ext4 a much better chance to reorganize itself by calling
> fallocate on full extent size chunks at minimum, instead of what the
> code currently does.
Hi, Greg,

The current e4defrag is doing most of work exactly same as your RFC,
and in a nicer manner. If you look into the code path, you'll see that
its logic is very much like the RFC except that it first fallocates a
donor file to see if a defragmentation is really necessary so it won't
have to fall back during defragmentation, which IMO is a good design
point.

Please correct me if I understand anything wrong.

>
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

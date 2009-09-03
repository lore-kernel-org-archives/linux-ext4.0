From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH] e4defrag: fallocate donor file only once
Date: Thu, 3 Sep 2009 05:30:35 -0400
Message-ID: <87f94c370909030230w6ab49265yf6e689cbae1d458c@mail.gmail.com>
References: <1251905704-10078-1-git-send-email-bergwolf@gmail.com>
	 <87f94c370909021509u7d07a6e5ia210cfd8b8db70e0@mail.gmail.com>
	 <6149e97b0909030100p1930c0fra28663724e51114@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:27634 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbZICJae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Sep 2009 05:30:34 -0400
Received: by qw-out-2122.google.com with SMTP id 8so523900qwh.37
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2009 02:30:35 -0700 (PDT)
In-Reply-To: <6149e97b0909030100p1930c0fra28663724e51114@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 3, 2009 at 4:00 AM, Peng Tao<bergwolf@gmail.com> wrote:
> On Thu, Sep 3, 2009 at 6:09 AM, Greg Freemyer<greg.freemyer@gmail.com=
> wrote:
>> On Wed, Sep 2, 2009 at 11:35 AM, Peng Tao<bergwolf@gmail.com> wrote:
>>> If we allocate the donor file once for all, it will have a better c=
hance
>>> to be continuous.
>>>
>>> Signed-off-by: "Peng Tao" <bergwolf@gmail.com>
>>
>> Seems like an improvement, but I'm not seeing any special handling f=
or
>> sparse files. =A0(Not before or after this patch.)
>>
>> Seems like there should be an outer loop that identifies contiguous
>> data block sets in a sparse file and defrags them individually as
>> opposed to trying to defrag the entire file at once.
>>
>> My impression is that with a large sparse file, e4defrag currently
>> (with or without this patch) would fallocate a full non-sparse donor
>> set of blocks the full size of the original file, then swap in just
>> the truly allocated blocks?
> Thanks for the reminder. The original code takes good care of sparse
> files in join_extents(). Please ignore my patch.
>
> Sorry for the noise.

RFC from a more ext4 knowledgeable person than me:

The code in e4defrag still looks way to complex.  I don't see why it
needs to know so much about extents and groups.

I just looked at util/copy_sparse.c

It simply loops through all the blocks in the source file and calls
ioctl(fd, FIBMAP, &b) to see if they are allocated vs. sparse,

If allocated it copies the block from src to dest.  Pretty straight
forward and has none of the complexity of e4defrag.

Seems to me e4defrag should have the actual defrag_file() rewritten to
be something like:

defrag_file()  {
    loop through the blocks looking for the contiguous set of data bloc=
ks.
          defrag_contiguous_data(start_block, num_blocks)
}

defrag_contiguous_data(start_block, num_blocks) {
    // allocate one full extent at a time and donate the blocks to orig=
 file
    for(start=3Dstart_block; start < start_block, num_blocks; start+=3D=
chunk) {
          fallocate(chunk);
          move_ext(orig, donor, start, 0, chunk);
      }
}

And then set chunk to be the max size of one extent.  Maybe the
"chunk" should be bigger than one extent?

Also, I did not put any logic in above to show testing to see if the
new file is less fragmented than the original.  That will add to the
complexity, but hopefully the actual defrag logic can be as relatively
simple as the above instead of what it is now.

Anyway, t would be a major change to e4defrag, but it seems that it
would give ext4 a much better chance to reorganize itself by calling
fallocate on full extent size chunks at minimum, instead of what the
code currently does.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

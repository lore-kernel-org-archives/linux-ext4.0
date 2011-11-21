From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: Bug with "fix partial page writes"
Date: Mon, 21 Nov 2011 09:59:55 +0800
Message-ID: <CAGBYx2b4+s+YSKFoPbNSw=vWVaCZyxHjQdKGMHhCztTppETT9Q@mail.gmail.com>
References: <CAO81RMa4uRsOsaK4G78EDvOenJpEdTp4y+rtkiDxaK9cASbMtA@mail.gmail.com>
	<alpine.LSU.2.00.1111201121120.1264@sister.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Curt Wohlgemuth <curtw@google.com>, "Ted Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Hugh Dickins <hughd@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48725 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab1KUB74 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Nov 2011 20:59:56 -0500
In-Reply-To: <alpine.LSU.2.00.1111201121120.1264@sister.anvils>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I am curious about the reason we need this operation in write_begin
functions.    I had a look at the commit log just now.   The commit
log explains the intention is to handle writes on a hole and writes on
EOF.   Two cases can be handled successfully by block_write_begin.


Yongqiang.

On Mon, Nov 21, 2011 at 4:59 AM, Hugh Dickins <hughd@google.com> wrote:
> We've seen no response to this, so Cc'ing Ted and linux-kernel,
> and I'll fill in some more detail below.
>
> On Tue, 8 Nov 2011, Curt Wohlgemuth wrote:
>> It appears that there's a bug with this patch:
>>
>> -------------------------------------------
>> commit 02fac1297eb3f471a27368271aadd285548297b0
>> Author: Allison Henderson <achender@linux.vnet.ibm.com>
>> Date: =A0 Tue Sep 6 21:53:01 2011 -0400
>>
>> =A0 =A0 ext4: fix partial page writes
>> ...
>> -------------------------------------------
>>
>> Hugh Dickins found a bug with some nasty testing and lockdep that
>
> It's the tmpfs swapping test that I've been running, with variations,
> for years. =A0System booted with mem=3D700M and 1.5G swap, two repeti=
tious
> make -j20 kernel builds (of a 2.6.24 kernel: I stuck with that becaus=
e
> the balance of built to unbuilt source grows smaller with later kerne=
ls),
> one directly in a tmpfs (irrelevant in this case, except for the adde=
d
> pressure it generates), the other in a 1k-block ext2 (that I drive wi=
th
> ext4's CONFIG_EXT4_USE_FOR_EXT23) on /dev/loop0 on a 450MB tmpfs file=
=2E
>
> The first oops I got was indeed down in lockdep, but I've since seen
> crashes from the same cause without lockdep configured in. =A0I've no=
t
> bothered to write down the stacks, beyond noting ext4_da_write_end()'=
s
> call to ext4_discard_partial_page_buffers_no_lock() in them, since th=
e
> code there is clearly at fault as Curt describes.
>
>> crashed in ext4_da_write_end(), and after looking at the code with
>> him, it appears that the call to
>> ext4_discard_partial_page_buffers_no_lock() in this routine is
>> manipulating an unlocked, and possibly non-existent page:
>>
>>
>> -------------------------------------------
>> ...
>> =A0 =A0 =A0 ret2 =3D generic_write_end(file, mapping, pos, len, copi=
ed,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page, fsdata);
>>
>> =A0 =A0 =A0 page_len =3D PAGE_CACHE_SIZE -
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((pos + copied - 1) & (P=
AGE_CACHE_SIZE - 1));
>>
>> =A0 =A0 =A0 if (page_len > 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_discard_partial_page_buffer=
s_no_lock(handle,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode, page, pos + copie=
d - 1, page_len,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_DISCARD_PARTIAL_PG_=
ZERO_UNMAPPED);
>> =A0 =A0 =A0 }
>> ...
>> -------------------------------------------
>>
>> Note that generic_write_end() will unlock and release the page befor=
e
>> it returns.
>
> Exactly. =A0And clearly the loop-on-tmpfs aspect of the test is
> irrelevant, except in generating more pressure to trigger it.
>
>>
>> I've no good answer for how to fix this properly, but I wanted to le=
t
>> Allison know about this, if she hadn't already. =A0I looked but didn=
't
>> see any related email on the linux-ext4 list for this problem.
>
> There was a second problem I was seeing, more elusive and much harder
> to attribute: occasionally the build on ext2 would fail with errors
> from ld (almost always of the kind "In function `no symbol': multiple
> definition of `no symbol'" and "Warning: size of symbol `' changed":
> I don't know if there's anything to be deduced from that). =A0I took
> these to indicate an error in filesystem or loop or tmpfs or swap.
>
> First suspect was loop changes from hch in 3.2-rc1, but backing those
> out made no difference. =A0I thought I was facing a week's bisection
> (since it would need at least a day to conclude any stage good), but
> took a gamble on backing out *both* parts of 02fac1297eb3: page_len
> additions to ext4_da_write_begin() as well as page_len additions to
> ext4_da_write_end().
>
> That gamble paid off: the test then showed no problems in several
> days running on two machines. =A0So, both parts of 02fac1297eb3 are
> bad, but it's not so easy to see what's wrong with the write_begin.
>
> My *guess* is that the partial page fixes have interfered with the
> subtle page-dirty buffer-dirty protocol in some way, which manifests
> only under memory pressure.
>
> It's conceivable that loop and tmpfs and swap play a part in this
> further error, but I don't think so: I have no evidence for that,
> and no such problem was seen before 3.2-rc1.
>
> ---
>
> I wanted to find you an easier way to reproduce the problem, so I
> tried fsx (I'm still using a pretty old fsx, no fallocate or punch
> hole), run in ext2 on a kernel booted with mem=3D700M. =A0Sorry, I di=
d
> this a week ago, then didn't find time to write it up, and failed to
> note when my ext2 was in /dev/loop0 and when it was directly on disk.
>
> fsx foo -q -c 100 -l 100000000 &
> while :
> do =A0 =A0 =A0# memory hog mmaps and touches each page of 800MB priva=
te area
> =A0 =A0 =A0 =A0swapout 800
> done
>
> I did not reproduce either problem above with that. =A0Instead I foun=
d
> that backing out 02fac1297eb3 made fsx on 3.2-rc1 fail in a few minut=
es.
> But leaving 02fac1297eb3 in, fsx still failed in 20 minutes or an hou=
r.
> On 3.1, fsx failed in a few minutes. =A0On 3.0, fsx failed in half an=
 hour.
> On 2.6.39, fsx failed in a few minutes. =A0I had to go back to 2.6.38=
 for
> fsx to run successfully under memory pressure for more than two hours=
=2E
>
> It looks as if ext4 testing has not been running fsx under memory
> pressure recently. =A0And although I didn't reproduce my main problem=
s
> that way, it could well be that getting fsx to run reliably again
> under memory pressure will be the way to fix those problems.
>
> Thanks,
> Hugh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

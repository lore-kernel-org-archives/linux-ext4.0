From: Surbhi Palande <csurbhi@gmail.com>
Subject: Fwd: Bug with "fix partial page writes"
Date: Mon, 21 Nov 2011 13:26:25 -0800
Message-ID: <CAMBkX3c=cwf7=gyLCDYHSXLhvLgk-Sf209LK8D3=-KQMLF2S5w@mail.gmail.com>
References: <CAO81RMa4uRsOsaK4G78EDvOenJpEdTp4y+rtkiDxaK9cASbMtA@mail.gmail.com>
	<alpine.LSU.2.00.1111201121120.1264@sister.anvils>
	<CAGBYx2b4+s+YSKFoPbNSw=vWVaCZyxHjQdKGMHhCztTppETT9Q@mail.gmail.com>
	<4ECA8CA4.5040804@linux.vnet.ibm.com>
	<CAMBkX3cfQ+XS7M5jvXmj8_rBOJ_Afy+YXL7Roj+fswLqBA7i1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40732 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab1KUV01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Nov 2011 16:26:27 -0500
Received: by bke11 with SMTP id 11so7091402bke.19
        for <linux-ext4@vger.kernel.org>; Mon, 21 Nov 2011 13:26:26 -0800 (PST)
In-Reply-To: <CAMBkX3cfQ+XS7M5jvXmj8_rBOJ_Afy+YXL7Roj+fswLqBA7i1Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Allison,

I still do not understand why there is a need to write zeroes to the
end of a page rather than an end of a partially written block (in case
blocksize < pagesize)

Here is why I dont understand it:


Consider the case when:
blocksize < pagesize.

On a write to a page, we have two cases wrt to a buffer
1) partial writes to a buffer - this is taken care of by page_zero_new_=
buffers()
2) buffer represent a hole - so not written to at all.
Note that this buffer that completely represents a hole is not
allocated on the disk since blocksize < pagesize.
In this case, such a buffer is always unmapped and can never be
written to the disk, nor can it be read from the disk.
Also, ext4_writepage() does not call submit_bh() on an unmapped buffer.

Thus how do we get garbage from a buffer that completely represents a h=
ole?

Regards,
Surbhi.




On Mon, Nov 21, 2011 at 9:38 AM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
>
> On 11/20/2011 06:59 PM, Yongqiang Yang wrote:
>>
>> Hi,
>>
>> I am curious about the reason we need this operation in write_begin
>> functions. =C2=A0 =C2=A0I had a look at the commit log just now. =C2=
=A0 The commit
>> log explains the intention is to handle writes on a hole and writes =
on
>> EOF. =C2=A0 Two cases can be handled successfully by block_write_beg=
in.
>>
>>
>> Yongqiang.
>
> Hi all,
>
> Sorry I missed the first note that came through. =C2=A0I have not bee=
n able to look at this in depth yet, but will do so when I get back fro=
m the holiday break next Thurs. =C2=A0Basically this patch was addressi=
ng a bug I found when I was trying to get the punch hole patch through =
an overnight run of fsx.
>
> With out this patch, fsx fails (after about 6 or so hours, with punch=
 hole enabled). =C2=A0The failure is triggered when a region of the tes=
t file that is supposed to contain zeros, ends up containing garbage. =C2=
=A0In this case what I found was that a write operation that starts/end=
s in a hole or runs off the edge of the file, is supposed to zero out t=
he part of the page that is still in the hole or beyond EOF. =C2=A0But =
instead of zeroing to the end of the page, it would only zero to the ed=
ge of the block. =C2=A0So it would only appear to work when blocksize =3D=
 pagesize, but if blocksize < pagesize, we end up with extra garbage in=
 the page.
>
> ext4_discard_partial_page_buffers_no_lock() and ext4_discard_partial_=
page_buffers(), were modeled off of the original
> ext4_block_zero_page_range routine, but modified to handle multiple b=
locks for a page. =C2=A0ext4_discard_partial_page_buffers is simply a w=
rapper that locks the page before passing it to ext4_discard_partial_pa=
ge_buffers_no_lock. =C2=A0In most cases I found that the page needs to =
be locked, but for ext4_da_write_end and ext4_da_write_begin I ran into=
 deadlocks, so I added the wrapper for optional locking. =C2=A0I will l=
ook more into it when I get back, but perhaps all we need here is some =
more logic to figure out if the page is present and needs locking.
>
> Allison Henderson
>
>>
>> On Mon, Nov 21, 2011 at 4:59 AM, Hugh Dickins<hughd@google.com> =C2=A0=
wrote:
>>>
>>> We've seen no response to this, so Cc'ing Ted and linux-kernel,
>>> and I'll fill in some more detail below.
>>>
>>> On Tue, 8 Nov 2011, Curt Wohlgemuth wrote:
>>>>
>>>> It appears that there's a bug with this patch:
>>>>
>>>> -------------------------------------------
>>>> commit 02fac1297eb3f471a27368271aadd285548297b0
>>>> Author: Allison Henderson<achender@linux.vnet.ibm.com>
>>>> Date: =C2=A0 Tue Sep 6 21:53:01 2011 -0400
>>>>
>>>> =C2=A0 =C2=A0 ext4: fix partial page writes
>>>> ...
>>>> -------------------------------------------
>>>>
>>>> Hugh Dickins found a bug with some nasty testing and lockdep that
>>>
>>> It's the tmpfs swapping test that I've been running, with variation=
s,
>>> for years. =C2=A0System booted with mem=3D700M and 1.5G swap, two r=
epetitious
>>> make -j20 kernel builds (of a 2.6.24 kernel: I stuck with that beca=
use
>>> the balance of built to unbuilt source grows smaller with later ker=
nels),
>>> one directly in a tmpfs (irrelevant in this case, except for the ad=
ded
>>> pressure it generates), the other in a 1k-block ext2 (that I drive =
with
>>> ext4's CONFIG_EXT4_USE_FOR_EXT23) on /dev/loop0 on a 450MB tmpfs fi=
le.
>>>
>>> The first oops I got was indeed down in lockdep, but I've since see=
n
>>> crashes from the same cause without lockdep configured in. =C2=A0I'=
ve not
>>> bothered to write down the stacks, beyond noting ext4_da_write_end(=
)'s
>>> call to ext4_discard_partial_page_buffers_no_lock() in them, since =
the
>>> code there is clearly at fault as Curt describes.
>>>
>>>> crashed in ext4_da_write_end(), and after looking at the code with
>>>> him, it appears that the call to
>>>> ext4_discard_partial_page_buffers_no_lock() in this routine is
>>>> manipulating an unlocked, and possibly non-existent page:
>>>>
>>>>
>>>> -------------------------------------------
>>>> ...
>>>> =C2=A0 =C2=A0 =C2=A0 ret2 =3D generic_write_end(file, mapping, pos=
, len, copied,
>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 page, fsdata);
>>>>
>>>> =C2=A0 =C2=A0 =C2=A0 page_len =3D PAGE_CACHE_SIZE -
>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ((pos + copied - 1)& =C2=A0(PAGE_CACHE_SIZE - 1));
>>>>
>>>> =C2=A0 =C2=A0 =C2=A0 if (page_len> =C2=A00) {
>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D ext4_disc=
ard_partial_page_buffers_no_lock(handle,
>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 inode, page, pos + copied - 1, page_len,
>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 EXT4_DISCARD_PARTIAL_PG_ZERO_UNMAPPED);
>>>> =C2=A0 =C2=A0 =C2=A0 }
>>>> ...
>>>> -------------------------------------------
>>>>
>>>> Note that generic_write_end() will unlock and release the page bef=
ore
>>>> it returns.
>>>
>>> Exactly. =C2=A0And clearly the loop-on-tmpfs aspect of the test is
>>> irrelevant, except in generating more pressure to trigger it.
>>>
>>>>
>>>> I've no good answer for how to fix this properly, but I wanted to =
let
>>>> Allison know about this, if she hadn't already. =C2=A0I looked but=
 didn't
>>>> see any related email on the linux-ext4 list for this problem.
>>>
>>> There was a second problem I was seeing, more elusive and much hard=
er
>>> to attribute: occasionally the build on ext2 would fail with errors
>>> from ld (almost always of the kind "In function `no symbol': multip=
le
>>> definition of `no symbol'" and "Warning: size of symbol `' changed"=
:
>>> I don't know if there's anything to be deduced from that). =C2=A0I =
took
>>> these to indicate an error in filesystem or loop or tmpfs or swap.
>>>
>>> First suspect was loop changes from hch in 3.2-rc1, but backing tho=
se
>>> out made no difference. =C2=A0I thought I was facing a week's bisec=
tion
>>> (since it would need at least a day to conclude any stage good), bu=
t
>>> took a gamble on backing out *both* parts of 02fac1297eb3: page_len
>>> additions to ext4_da_write_begin() as well as page_len additions to
>>> ext4_da_write_end().
>>>
>>> That gamble paid off: the test then showed no problems in several
>>> days running on two machines. =C2=A0So, both parts of 02fac1297eb3 =
are
>>> bad, but it's not so easy to see what's wrong with the write_begin.
>>>
>>> My *guess* is that the partial page fixes have interfered with the
>>> subtle page-dirty buffer-dirty protocol in some way, which manifest=
s
>>> only under memory pressure.
>>>
>>> It's conceivable that loop and tmpfs and swap play a part in this
>>> further error, but I don't think so: I have no evidence for that,
>>> and no such problem was seen before 3.2-rc1.
>>>
>>> ---
>>>
>>> I wanted to find you an easier way to reproduce the problem, so I
>>> tried fsx (I'm still using a pretty old fsx, no fallocate or punch
>>> hole), run in ext2 on a kernel booted with mem=3D700M. =C2=A0Sorry,=
 I did
>>> this a week ago, then didn't find time to write it up, and failed t=
o
>>> note when my ext2 was in /dev/loop0 and when it was directly on dis=
k.
>>>
>>> fsx foo -q -c 100 -l 100000000&
>>> while :
>>> do =C2=A0 =C2=A0 =C2=A0# memory hog mmaps and touches each page of =
800MB private area
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0swapout 800
>>> done
>>>
>>> I did not reproduce either problem above with that. =C2=A0Instead I=
 found
>>> that backing out 02fac1297eb3 made fsx on 3.2-rc1 fail in a few min=
utes.
>>> But leaving 02fac1297eb3 in, fsx still failed in 20 minutes or an h=
our.
>>> On 3.1, fsx failed in a few minutes. =C2=A0On 3.0, fsx failed in ha=
lf an hour.
>>> On 2.6.39, fsx failed in a few minutes. =C2=A0I had to go back to 2=
=2E6.38 for
>>> fsx to run successfully under memory pressure for more than two hou=
rs.
>>>
>>> It looks as if ext4 testing has not been running fsx under memory
>>> pressure recently. =C2=A0And although I didn't reproduce my main pr=
oblems
>>> that way, it could well be that getting fsx to run reliably again
>>> under memory pressure will be the way to fix those problems.
>>>
>>> Thanks,
>>> Hugh
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>>>
>>
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

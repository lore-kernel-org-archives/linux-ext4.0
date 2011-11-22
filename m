From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: Bug with "fix partial page writes"
Date: Tue, 22 Nov 2011 09:44:51 +0800
Message-ID: <CAGBYx2YxTfEKPPwCe5kifwDgfpC7x+QtdpLhrJpcHGixhVS3gA@mail.gmail.com>
References: <CAO81RMa4uRsOsaK4G78EDvOenJpEdTp4y+rtkiDxaK9cASbMtA@mail.gmail.com>
	<alpine.LSU.2.00.1111201121120.1264@sister.anvils>
	<CAGBYx2b4+s+YSKFoPbNSw=vWVaCZyxHjQdKGMHhCztTppETT9Q@mail.gmail.com>
	<4ECA8CA4.5040804@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Hugh Dickins <hughd@google.com>,
	Curt Wohlgemuth <curtw@google.com>, "Ted Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4ECA8CA4.5040804@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 22, 2011 at 1:38 AM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> On 11/20/2011 06:59 PM, Yongqiang Yang wrote:
>>
>> Hi,
>>
>> I am curious about the reason we need this operation in write_begin
>> functions. =A0 =A0I had a look at the commit log just now. =A0 The c=
ommit
>> log explains the intention is to handle writes on a hole and writes =
on
>> EOF. =A0 Two cases can be handled successfully by block_write_begin.
>>
>>
>> Yongqiang.
>
> Hi all,
>
> Sorry I missed the first note that came through. =A0I have not been a=
ble to
> look at this in depth yet, but will do so when I get back from the ho=
liday
> break next Thurs. =A0Basically this patch was addressing a bug I foun=
d when I
> was trying to get the punch hole patch through an overnight run of fs=
x.
>
> With out this patch, fsx fails (after about 6 or so hours, with punch=
 hole
> enabled). =A0The failure is triggered when a region of the test file =
that is
> supposed to contain zeros, ends up containing garbage. =A0In this cas=
e what I
> found was that a write operation that starts/ends in a hole or runs o=
ff the
> edge of the file, is supposed to zero out the part of the page that i=
s still
> in the hole or beyond EOF. =A0But instead of zeroing to the end of th=
e page,
> it would only zero to the edge of the block. =A0So it would only appe=
ar to
> work when blocksize =3D pagesize, but if blocksize < pagesize, we end=
 up with
> extra garbage in the page.
Thank you for your response.

Well.  According to code in vfs, do_mpage_readpage can handle this by
calling block_read_full_page.   Consider that current code can not
handle the case above, then if there is a hole in a file, ext4 with
punching hole does not work as well.   I am suspecting punch hole do
something abnormal, eg. setting false uptodate status or operating on
a unlocked page.   Just a guess:-)   I will have a look at the code.

Yongqiang.
>
> ext4_discard_partial_page_buffers_no_lock() and
> ext4_discard_partial_page_buffers(), were modeled off of the original
> ext4_block_zero_page_range routine, but modified to handle multiple b=
locks
> for a page. =A0ext4_discard_partial_page_buffers is simply a wrapper =
that
> locks the page before passing it to
> ext4_discard_partial_page_buffers_no_lock. =A0In most cases I found t=
hat the
> page needs to be locked, but for ext4_da_write_end and ext4_da_write_=
begin I
> ran into deadlocks, so I added the wrapper for optional locking. =A0I=
 will
> look more into it when I get back, but perhaps all we need here is so=
me more
> logic to figure out if the page is present and needs locking.
>
> Allison Henderson
>
>>
>> On Mon, Nov 21, 2011 at 4:59 AM, Hugh Dickins<hughd@google.com> =A0w=
rote:
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
>>>> Date: =A0 Tue Sep 6 21:53:01 2011 -0400
>>>>
>>>> =A0 =A0 ext4: fix partial page writes
>>>> ...
>>>> -------------------------------------------
>>>>
>>>> Hugh Dickins found a bug with some nasty testing and lockdep that
>>>
>>> It's the tmpfs swapping test that I've been running, with variation=
s,
>>> for years. =A0System booted with mem=3D700M and 1.5G swap, two repe=
titious
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
>>> crashes from the same cause without lockdep configured in. =A0I've =
not
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
>>>> =A0 =A0 =A0 ret2 =3D generic_write_end(file, mapping, pos, len, co=
pied,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page, fsdata);
>>>>
>>>> =A0 =A0 =A0 page_len =3D PAGE_CACHE_SIZE -
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((pos + copied - 1)& =A0=
(PAGE_CACHE_SIZE - 1));
>>>>
>>>> =A0 =A0 =A0 if (page_len> =A00) {
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_discard_partial_page_buff=
ers_no_lock(handle,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode, page, pos + cop=
ied - 1, page_len,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_DISCARD_PARTIAL_P=
G_ZERO_UNMAPPED);
>>>> =A0 =A0 =A0 }
>>>> ...
>>>> -------------------------------------------
>>>>
>>>> Note that generic_write_end() will unlock and release the page bef=
ore
>>>> it returns.
>>>
>>> Exactly. =A0And clearly the loop-on-tmpfs aspect of the test is
>>> irrelevant, except in generating more pressure to trigger it.
>>>
>>>>
>>>> I've no good answer for how to fix this properly, but I wanted to =
let
>>>> Allison know about this, if she hadn't already. =A0I looked but di=
dn't
>>>> see any related email on the linux-ext4 list for this problem.
>>>
>>> There was a second problem I was seeing, more elusive and much hard=
er
>>> to attribute: occasionally the build on ext2 would fail with errors
>>> from ld (almost always of the kind "In function `no symbol': multip=
le
>>> definition of `no symbol'" and "Warning: size of symbol `' changed"=
:
>>> I don't know if there's anything to be deduced from that). =A0I too=
k
>>> these to indicate an error in filesystem or loop or tmpfs or swap.
>>>
>>> First suspect was loop changes from hch in 3.2-rc1, but backing tho=
se
>>> out made no difference. =A0I thought I was facing a week's bisectio=
n
>>> (since it would need at least a day to conclude any stage good), bu=
t
>>> took a gamble on backing out *both* parts of 02fac1297eb3: page_len
>>> additions to ext4_da_write_begin() as well as page_len additions to
>>> ext4_da_write_end().
>>>
>>> That gamble paid off: the test then showed no problems in several
>>> days running on two machines. =A0So, both parts of 02fac1297eb3 are
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
>>> hole), run in ext2 on a kernel booted with mem=3D700M. =A0Sorry, I =
did
>>> this a week ago, then didn't find time to write it up, and failed t=
o
>>> note when my ext2 was in /dev/loop0 and when it was directly on dis=
k.
>>>
>>> fsx foo -q -c 100 -l 100000000&
>>> while :
>>> do =A0 =A0 =A0# memory hog mmaps and touches each page of 800MB pri=
vate area
>>> =A0 =A0 =A0 =A0swapout 800
>>> done
>>>
>>> I did not reproduce either problem above with that. =A0Instead I fo=
und
>>> that backing out 02fac1297eb3 made fsx on 3.2-rc1 fail in a few min=
utes.
>>> But leaving 02fac1297eb3 in, fsx still failed in 20 minutes or an h=
our.
>>> On 3.1, fsx failed in a few minutes. =A0On 3.0, fsx failed in half =
an hour.
>>> On 2.6.39, fsx failed in a few minutes. =A0I had to go back to 2.6.=
38 for
>>> fsx to run successfully under memory pressure for more than two hou=
rs.
>>>
>>> It looks as if ext4 testing has not been running fsx under memory
>>> pressure recently. =A0And although I didn't reproduce my main probl=
ems
>>> that way, it could well be that getting fsx to run reliably again
>>> under memory pressure will be the way to fix those problems.
>>>
>>> Thanks,
>>> Hugh
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>>
>>
>
>



--=20
Best Wishes
Yongqiang Yang

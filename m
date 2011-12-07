From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: Bug with "fix partial page writes" [3.2-rc regression]
Date: Wed, 7 Dec 2011 16:28:56 +0800
Message-ID: <CAGBYx2YmYRw_p5KHJCYaQNsCpe5OVV7X2TpaK=OE7znCiE7oZA@mail.gmail.com>
References: <CAO81RMa4uRsOsaK4G78EDvOenJpEdTp4y+rtkiDxaK9cASbMtA@mail.gmail.com>
	<alpine.LSU.2.00.1111201121120.1264@sister.anvils>
	<20111121165626.GD14568@thunk.org>
	<alpine.LSU.2.00.1111211331120.1879@sister.anvils>
	<alpine.LSU.2.00.1112051456580.3938@sister.anvils>
	<4EDD729E.2060402@linux.vnet.ibm.com>
	<alpine.LSU.2.00.1112060030220.1615@sister.anvils>
	<4EDE85F4.4020503@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Hugh Dickins <hughd@google.com>, "Ted Ts'o" <tytso@mit.edu>,
	Curt Wohlgemuth <curtw@google.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Rafael Wysocki <rjw@sisk.pl>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EDE85F4.4020503@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Allison and Hugh,

 I think I found the problem and it has nothing to do with punching
hole.  The patch [ext4: let ext4_bio_write_page handle EOF correctly]
would fix up the problem.

I post the patch so that it can be tested as early as possible.  The
problem has not appeared on my machine since the patch is applied.

Yongqiang.
On Wed, Dec 7, 2011 at 5:15 AM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> On 12/06/2011 01:55 AM, Hugh Dickins wrote:
>>
>> On Mon, 5 Dec 2011, Allison Henderson wrote:
>>>
>>> On 12/05/2011 04:38 PM, Hugh Dickins wrote:
>>>>
>>>>
>>>> This has been outstanding for a month now, and we've heard no prog=
ress:
>>>> please revert commit 02fac1297eb3 "ext4: fix partial page writes" =
for
>>>> rc5.
>>>>
>>>> The problems appear on a 1k-blocksize filesystem under memory pres=
sure:
>>>> the hunk in ext4_da_write_end() causes oops, because it's playing =
with
>>>> a page after generic_write_end() dropped our last reference to it;=
 and
>>>> backing out the hunk in ext4_da_write_begin() is then found to sto=
p
>>>> rare data corruption seen when kbuilding.
>>>>
>>>> Although I earlier reported that backing out the patch caused an f=
sx
>>>> test to fail earlier, I've since found great variation in how soon=
 it
>>>> fails, and seen it fail just as quickly with 02fac1297eb3 still in=
=2E
>>>> I also reported that I had to go back to 2.6.38 for fsx not to fai=
l
>>>> under memory pressure: you won't be surprised that that turned out=
 to
>>>> be because 2.6.38 defaults nomblk_io_submit but 2.6.39 mblk_io_sub=
mit.
>>>
>>>
>>> Have you tried Yongqiang's patch "[PATCH 1/2] ext4: let mpage_submi=
t_io
>>> works well when blocksize< =A0pagesize" ? =A0I have tried it and it=
 does seem
>>> to
>>> help, but I am still running into some failures that I am trying to
>>> debug,
>>> but let please let us know if it helps the issues that you are seei=
ng.
>>> =A0Thx!
>>
>>
>> That 1/2, or the 2/2 "ext4: let ext4_discard_partial_buffers handle
>> pages without buffers correctly"? =A0The latter is mostly a reversio=
n
>> of your 02fac1297eb3, so that's the one I need to fix the oops and
>> rare data corruption. =A0Perhaps you're suggesting 1/2 for fsx failu=
res
>> under memory pressure?
>>
>> I've now tried the fsx test on three machines, with both 1/2 and 2/2
>> applied to 3.2-rc4. =A0On one machine, with ext2 on loop on tmpfs, t=
he
>> fsx test failed in a couple of minutes with those patches; on anothe=
r
>> machine, with ext2 on loop on tmpfs, it failed after about 40 minute=
s
>> with =A0the patches; on this laptop, with ext2 on SSD, it's just now
>> failed after 35 minutes with the patches.
>>
>> That's not to say that Yongqiang's patches aren't good; but I cannot
>> detect whether they make any improvement or not, since lasting for 2=
 or
>> 40 minutes is typical for fsx under memory pressure with recent kern=
els.
>
>
>
> Well, initially I meant to just try the whole set, but now that I try=
 just
> one of them, I find that I get further with only the first one. =A0I =
think
> Yongqiang and I have a similar set up because I get the hang if I don=
t have
> the first patch, and I get the fsx write failure (in about 20 or so m=
inutes)
> if I have the second one. =A0But I think Yongqiang's right, we need t=
o figure
> out why the page is uptodate when it shouldn't be.
>
>
>>
>> Hugh
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Best Wishes
Yongqiang Yang

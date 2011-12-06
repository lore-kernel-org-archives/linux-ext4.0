From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: Bug with "fix partial page writes" [3.2-rc regression]
Date: Tue, 6 Dec 2011 15:57:07 +0800
Message-ID: <CAGBYx2bmBAzHyG010Cfgh=4ttdSYZ-z78+LfDhVHAv=unS43SA@mail.gmail.com>
References: <CAO81RMa4uRsOsaK4G78EDvOenJpEdTp4y+rtkiDxaK9cASbMtA@mail.gmail.com>
	<alpine.LSU.2.00.1111201121120.1264@sister.anvils>
	<20111121165626.GD14568@thunk.org>
	<alpine.LSU.2.00.1111211331120.1879@sister.anvils>
	<alpine.LSU.2.00.1112051456580.3938@sister.anvils>
	<4EDD729E.2060402@linux.vnet.ibm.com>
	<CAGBYx2YNKEiuRF31CaRiK2ROj_xmVsnL4rcWnoofyziYCkYjpw@mail.gmail.com>
	<4EDD8D1B.5040803@tao.ma>
	<CAGBYx2aPjDY_xXqPw4=Urr5nUMQbHxzgwGu9mZ8fCe7mFsrVXw@mail.gmail.com>
	<4EDD948A.4000506@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tao Ma <tm@tao.ma>, Hugh Dickins <hughd@google.com>,
	"Ted Ts'o" <tytso@mit.edu>, Curt Wohlgemuth <curtw@google.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Rafael Wysocki <rjw@sisk.pl>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EDD948A.4000506@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 6, 2011 at 12:05 PM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> On 12/05/2011 08:44 PM, Yongqiang Yang wrote:
>>
>> On Tue, Dec 6, 2011 at 11:33 AM, Tao Ma<tm@tao.ma> =A0wrote:
>>>
>>> On 12/06/2011 11:08 AM, Yongqiang Yang wrote:
>>>>
>>>> Hi Allison,
>>>>
>>>> I noticed another problem which has nothing to do with punching ho=
le.
>>>> =A0__block_write_begin does not zero buffers beyond EOF.(I guess y=
ou
>>>
>>> yes, that is expected.
>>>>
>>>> tried to zero them in your code, am I right? ) =A0When users mapre=
ad
>>>> beyond EOF, =A0users get non-zero data. =A0I am not sure zero or n=
on-zero
>>>> data should be, but fsx thinks they should be zero data and report=
s an
>>>> error.
>>>
>>> why users can read the data passing EOF? I am also puzzled. Punchin=
g
>>> hole will do this? I don't think it's right.
>>
>> According to code, fiemap_fault handles the case right. =A0 But I me=
t
>> the error - 'non-zero data beyond EOF' reported by fsx. =A0It is
>> strange. =A0It seems that uptodate status is set wrong. =A0Just a gu=
ess:-)
>>
>> I am guessing Allison met the problem before and tried to fix it in
>> write path by zeroing buffers beyond EOF.
>
>
> Yes I did run into something similar. =A0I found 2 cases that involve=
d EOF:
> 1. A truncate shortens EOF, but only zeroed to the end of the block, =
but not
> to the end of the page. =A0This was corrected by "[PATCH 5/6 v7] ext4=
: fix fsx
> truncate failure"
>
> 2. A write extends EOF, but does not zero all of the page beyond EOF,=
 and
> that was what "[PATCH 6/6 v7] ext4: fix partial page writes" was supp=
osed to
> address.
I ran into the 2nd case, this case should be handled by readpage.   In
this case, write_end should not set uptodate on page.   Both mapread
and read should work.  Becasue fiemap_fault calls readpage on
non-uptodate page in mapread case.

It seems that write_end sets page uptodate, as a result garbage data
is seen by applications.  But I can not find why this happens.


Yongqiang.
>
> I am still digging through tracing output at the moment, so I dont ha=
ve a
> very good explanation right now, but I will keep folks posted if I fi=
nd
> something.
>
> Allison Henderson
>
>
>
>>
>> Yongqiang.
>>>
>>>
>>> Thanks
>>> Tao
>>>>
>>>>
>>>> It I understand the problem right, it happens more often with punc=
h
>>>> hole.
>>>>
>>>> Yongqiang.
>>>> On Tue, Dec 6, 2011 at 9:40 AM, Allison Henderson
>>>> <achender@linux.vnet.ibm.com> =A0wrote:
>>>>>
>>>>> On 12/05/2011 04:38 PM, Hugh Dickins wrote:
>>>>>>
>>>>>>
>>>>>> On Mon, 21 Nov 2011, Hugh Dickins wrote:
>>>>>>>
>>>>>>>
>>>>>>> On Mon, 21 Nov 2011, Ted Ts'o wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On Sun, Nov 20, 2011 at 12:59:10PM -0800, Hugh Dickins wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On Tue, 8 Nov 2011, Curt Wohlgemuth wrote:
>>>>>>>>> It appears that there's a bug with this patch:
>>>>>>
>>>>>>
>>>>>>
>>>>>> This has been outstanding for a month now, and we've heard no
>>>>>> progress:
>>>>>> please revert commit 02fac1297eb3 "ext4: fix partial page writes=
" for
>>>>>> rc5.
>>>>>>
>>>>>> The problems appear on a 1k-blocksize filesystem under memory
>>>>>> pressure:
>>>>>> the hunk in ext4_da_write_end() causes oops, because it's playin=
g with
>>>>>> a page after generic_write_end() dropped our last reference to i=
t; and
>>>>>> backing out the hunk in ext4_da_write_begin() is then found to s=
top
>>>>>> rare data corruption seen when kbuilding.
>>>>>>
>>>>>> Although I earlier reported that backing out the patch caused an=
 fsx
>>>>>> test to fail earlier, I've since found great variation in how so=
on it
>>>>>> fails, and seen it fail just as quickly with 02fac1297eb3 still =
in.
>>>>>> I also reported that I had to go back to 2.6.38 for fsx not to f=
ail
>>>>>> under memory pressure: you won't be surprised that that turned o=
ut to
>>>>>> be because 2.6.38 defaults nomblk_io_submit but 2.6.39 mblk_io_s=
ubmit.
>>>>>>
>>>>>> Thanks,
>>>>>> Hugh
>>>>>>
>>>>>
>>>>>
>>>>> Hi there,
>>>>>
>>>>> Have you tried Yongqiang's patch "[PATCH 1/2] ext4: let mpage_sub=
mit_io
>>>>> works well when blocksize< =A0pagesize" ? =A0I have tried it and =
it does
>>>>> seem to
>>>>> help, but I am still running into some failures that I am trying =
to
>>>>> debug,
>>>>> but let please let us know if it helps the issues that you are se=
eing.
>>>>> =A0Thx!
>>>>>
>>>>> Allison Henderson
>>>>>
>>>>
>>>>
>>>>
>>>
>>
>>
>>
>



--=20
Best Wishes
Yongqiang Yang

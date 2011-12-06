From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: Bug with "fix partial page writes" [3.2-rc regression]
Date: Mon, 05 Dec 2011 21:05:30 -0700
Message-ID: <4EDD948A.4000506@linux.vnet.ibm.com>
References: <CAO81RMa4uRsOsaK4G78EDvOenJpEdTp4y+rtkiDxaK9cASbMtA@mail.gmail.com> <alpine.LSU.2.00.1111201121120.1264@sister.anvils> <20111121165626.GD14568@thunk.org> <alpine.LSU.2.00.1111211331120.1879@sister.anvils> <alpine.LSU.2.00.1112051456580.3938@sister.anvils> <4EDD729E.2060402@linux.vnet.ibm.com> <CAGBYx2YNKEiuRF31CaRiK2ROj_xmVsnL4rcWnoofyziYCkYjpw@mail.gmail.com> <4EDD8D1B.5040803@tao.ma> <CAGBYx2aPjDY_xXqPw4=Urr5nUMQbHxzgwGu9mZ8fCe7mFsrVXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Tao Ma <tm@tao.ma>, Hugh Dickins <hughd@google.com>,
	"Ted Ts'o" <tytso@mit.edu>, Curt Wohlgemuth <curtw@google.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Rafael Wysocki <rjw@sisk.pl>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36087 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932877Ab1LFEHR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Dec 2011 23:07:17 -0500
Received: from /spool/local
	by e1.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Mon, 5 Dec 2011 23:07:12 -0500
In-Reply-To: <CAGBYx2aPjDY_xXqPw4=Urr5nUMQbHxzgwGu9mZ8fCe7mFsrVXw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/05/2011 08:44 PM, Yongqiang Yang wrote:
> On Tue, Dec 6, 2011 at 11:33 AM, Tao Ma<tm@tao.ma>  wrote:
>> On 12/06/2011 11:08 AM, Yongqiang Yang wrote:
>>> Hi Allison,
>>>
>>> I noticed another problem which has nothing to do with punching hole.
>>>   __block_write_begin does not zero buffers beyond EOF.(I guess you
>> yes, that is expected.
>>> tried to zero them in your code, am I right? )  When users mapread
>>> beyond EOF,  users get non-zero data.  I am not sure zero or non-zero
>>> data should be, but fsx thinks they should be zero data and reports an
>>> error.
>> why users can read the data passing EOF? I am also puzzled. Punching
>> hole will do this? I don't think it's right.
> According to code, fiemap_fault handles the case right.   But I met
> the error - 'non-zero data beyond EOF' reported by fsx.  It is
> strange.  It seems that uptodate status is set wrong.  Just a guess:-)
>
> I am guessing Allison met the problem before and tried to fix it in
> write path by zeroing buffers beyond EOF.

Yes I did run into something similar.  I found 2 cases that involved EOF:
1. A truncate shortens EOF, but only zeroed to the end of the block, but 
not to the end of the page.  This was corrected by "[PATCH 5/6 v7] ext4: 
fix fsx truncate failure"

2. A write extends EOF, but does not zero all of the page beyond EOF, 
and that was what "[PATCH 6/6 v7] ext4: fix partial page writes" was 
supposed to address.

I am still digging through tracing output at the moment, so I dont have 
a very good explanation right now, but I will keep folks posted if I 
find something.

Allison Henderson


>
> Yongqiang.
>>
>> Thanks
>> Tao
>>>
>>> It I understand the problem right, it happens more often with punch hole.
>>>
>>> Yongqiang.
>>> On Tue, Dec 6, 2011 at 9:40 AM, Allison Henderson
>>> <achender@linux.vnet.ibm.com>  wrote:
>>>> On 12/05/2011 04:38 PM, Hugh Dickins wrote:
>>>>>
>>>>> On Mon, 21 Nov 2011, Hugh Dickins wrote:
>>>>>>
>>>>>> On Mon, 21 Nov 2011, Ted Ts'o wrote:
>>>>>>>
>>>>>>> On Sun, Nov 20, 2011 at 12:59:10PM -0800, Hugh Dickins wrote:
>>>>>>>>
>>>>>>>> On Tue, 8 Nov 2011, Curt Wohlgemuth wrote:
>>>>>>>> It appears that there's a bug with this patch:
>>>>>
>>>>>
>>>>> This has been outstanding for a month now, and we've heard no progress:
>>>>> please revert commit 02fac1297eb3 "ext4: fix partial page writes" for rc5.
>>>>>
>>>>> The problems appear on a 1k-blocksize filesystem under memory pressure:
>>>>> the hunk in ext4_da_write_end() causes oops, because it's playing with
>>>>> a page after generic_write_end() dropped our last reference to it; and
>>>>> backing out the hunk in ext4_da_write_begin() is then found to stop
>>>>> rare data corruption seen when kbuilding.
>>>>>
>>>>> Although I earlier reported that backing out the patch caused an fsx
>>>>> test to fail earlier, I've since found great variation in how soon it
>>>>> fails, and seen it fail just as quickly with 02fac1297eb3 still in.
>>>>> I also reported that I had to go back to 2.6.38 for fsx not to fail
>>>>> under memory pressure: you won't be surprised that that turned out to
>>>>> be because 2.6.38 defaults nomblk_io_submit but 2.6.39 mblk_io_submit.
>>>>>
>>>>> Thanks,
>>>>> Hugh
>>>>>
>>>>
>>>>
>>>> Hi there,
>>>>
>>>> Have you tried Yongqiang's patch "[PATCH 1/2] ext4: let mpage_submit_io
>>>> works well when blocksize<  pagesize" ?  I have tried it and it does seem to
>>>> help, but I am still running into some failures that I am trying to debug,
>>>> but let please let us know if it helps the issues that you are seeing.  Thx!
>>>>
>>>> Allison Henderson
>>>>
>>>
>>>
>>>
>>
>
>
>


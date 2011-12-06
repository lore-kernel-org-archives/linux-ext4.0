From: Tao Ma <tm@tao.ma>
Subject: Re: Bug with "fix partial page writes" [3.2-rc regression]
Date: Tue, 06 Dec 2011 11:33:47 +0800
Message-ID: <4EDD8D1B.5040803@tao.ma>
References: <CAO81RMa4uRsOsaK4G78EDvOenJpEdTp4y+rtkiDxaK9cASbMtA@mail.gmail.com>	<alpine.LSU.2.00.1111201121120.1264@sister.anvils>	<20111121165626.GD14568@thunk.org>	<alpine.LSU.2.00.1111211331120.1879@sister.anvils>	<alpine.LSU.2.00.1112051456580.3938@sister.anvils>	<4EDD729E.2060402@linux.vnet.ibm.com> <CAGBYx2YNKEiuRF31CaRiK2ROj_xmVsnL4rcWnoofyziYCkYjpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Hugh Dickins <hughd@google.com>, Ted Ts'o <tytso@mit.edu>,
	Curt Wohlgemuth <curtw@google.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Rafael Wysocki <rjw@sisk.pl>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:36342 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754606Ab1LFDeD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Dec 2011 22:34:03 -0500
In-Reply-To: <CAGBYx2YNKEiuRF31CaRiK2ROj_xmVsnL4rcWnoofyziYCkYjpw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/06/2011 11:08 AM, Yongqiang Yang wrote:
> Hi Allison,
> 
> I noticed another problem which has nothing to do with punching hole.
>  __block_write_begin does not zero buffers beyond EOF.(I guess you
yes, that is expected.
> tried to zero them in your code, am I right? )  When users mapread
> beyond EOF,  users get non-zero data.  I am not sure zero or non-zero
> data should be, but fsx thinks they should be zero data and reports an
> error.
why users can read the data passing EOF? I am also puzzled. Punching
hole will do this? I don't think it's right.

Thanks
Tao
> 
> It I understand the problem right, it happens more often with punch hole.
> 
> Yongqiang.
> On Tue, Dec 6, 2011 at 9:40 AM, Allison Henderson
> <achender@linux.vnet.ibm.com> wrote:
>> On 12/05/2011 04:38 PM, Hugh Dickins wrote:
>>>
>>> On Mon, 21 Nov 2011, Hugh Dickins wrote:
>>>>
>>>> On Mon, 21 Nov 2011, Ted Ts'o wrote:
>>>>>
>>>>> On Sun, Nov 20, 2011 at 12:59:10PM -0800, Hugh Dickins wrote:
>>>>>>
>>>>>> On Tue, 8 Nov 2011, Curt Wohlgemuth wrote:
>>>>>> It appears that there's a bug with this patch:
>>>
>>>
>>> This has been outstanding for a month now, and we've heard no progress:
>>> please revert commit 02fac1297eb3 "ext4: fix partial page writes" for rc5.
>>>
>>> The problems appear on a 1k-blocksize filesystem under memory pressure:
>>> the hunk in ext4_da_write_end() causes oops, because it's playing with
>>> a page after generic_write_end() dropped our last reference to it; and
>>> backing out the hunk in ext4_da_write_begin() is then found to stop
>>> rare data corruption seen when kbuilding.
>>>
>>> Although I earlier reported that backing out the patch caused an fsx
>>> test to fail earlier, I've since found great variation in how soon it
>>> fails, and seen it fail just as quickly with 02fac1297eb3 still in.
>>> I also reported that I had to go back to 2.6.38 for fsx not to fail
>>> under memory pressure: you won't be surprised that that turned out to
>>> be because 2.6.38 defaults nomblk_io_submit but 2.6.39 mblk_io_submit.
>>>
>>> Thanks,
>>> Hugh
>>>
>>
>>
>> Hi there,
>>
>> Have you tried Yongqiang's patch "[PATCH 1/2] ext4: let mpage_submit_io
>> works well when blocksize < pagesize" ?  I have tried it and it does seem to
>> help, but I am still running into some failures that I am trying to debug,
>> but let please let us know if it helps the issues that you are seeing.  Thx!
>>
>> Allison Henderson
>>
> 
> 
> 


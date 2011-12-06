From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: Bug with "fix partial page writes" [3.2-rc regression]
Date: Tue, 06 Dec 2011 14:15:32 -0700
Message-ID: <4EDE85F4.4020503@linux.vnet.ibm.com>
References: <CAO81RMa4uRsOsaK4G78EDvOenJpEdTp4y+rtkiDxaK9cASbMtA@mail.gmail.com> <alpine.LSU.2.00.1111201121120.1264@sister.anvils> <20111121165626.GD14568@thunk.org> <alpine.LSU.2.00.1111211331120.1879@sister.anvils> <alpine.LSU.2.00.1112051456580.3938@sister.anvils> <4EDD729E.2060402@linux.vnet.ibm.com> <alpine.LSU.2.00.1112060030220.1615@sister.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, Curt Wohlgemuth <curtw@google.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Rafael Wysocki <rjw@sisk.pl>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Hugh Dickins <hughd@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54111 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754239Ab1LFVPl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Dec 2011 16:15:41 -0500
Received: from /spool/local
	by e4.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Tue, 6 Dec 2011 16:15:40 -0500
In-Reply-To: <alpine.LSU.2.00.1112060030220.1615@sister.anvils>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/06/2011 01:55 AM, Hugh Dickins wrote:
> On Mon, 5 Dec 2011, Allison Henderson wrote:
>> On 12/05/2011 04:38 PM, Hugh Dickins wrote:
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
>>
>> Have you tried Yongqiang's patch "[PATCH 1/2] ext4: let mpage_submit_io
>> works well when blocksize<  pagesize" ?  I have tried it and it does seem to
>> help, but I am still running into some failures that I am trying to debug,
>> but let please let us know if it helps the issues that you are seeing.  Thx!
>
> That 1/2, or the 2/2 "ext4: let ext4_discard_partial_buffers handle
> pages without buffers correctly"?  The latter is mostly a reversion
> of your 02fac1297eb3, so that's the one I need to fix the oops and
> rare data corruption.  Perhaps you're suggesting 1/2 for fsx failures
> under memory pressure?
>
> I've now tried the fsx test on three machines, with both 1/2 and 2/2
> applied to 3.2-rc4.  On one machine, with ext2 on loop on tmpfs, the
> fsx test failed in a couple of minutes with those patches; on another
> machine, with ext2 on loop on tmpfs, it failed after about 40 minutes
> with  the patches; on this laptop, with ext2 on SSD, it's just now
> failed after 35 minutes with the patches.
>
> That's not to say that Yongqiang's patches aren't good; but I cannot
> detect whether they make any improvement or not, since lasting for 2 or
> 40 minutes is typical for fsx under memory pressure with recent kernels.


Well, initially I meant to just try the whole set, but now that I try 
just one of them, I find that I get further with only the first one.  I 
think Yongqiang and I have a similar set up because I get the hang if I 
dont have the first patch, and I get the fsx write failure (in about 20 
or so minutes) if I have the second one.  But I think Yongqiang's right, 
we need to figure out why the page is uptodate when it shouldn't be.


>
> Hugh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


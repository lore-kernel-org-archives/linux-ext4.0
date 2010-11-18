From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Thu, 18 Nov 2010 13:02:43 -0600
Message-ID: <4CE57853.5010903@redhat.com>
References: <20101116110058.GA4298@amd>	<20101116130146.GG4757@quack.suse.cz>	<4CE35A6D.2040906@redhat.com>	<20101117043845.GA3586@amd>	<4CE362B0.6040607@redhat.com>	<20101117061057.GA3989@amd>	<20101118030613.GQ3290@thunk.org>	<20101117192900.da859ac7.akpm@linux-foundation.org>	<20101118060000.GA3509@amd>	<20101117222834.2bb36ee1.akpm@linux-foundation.org>	<4CE53E56.4090501@redhat.com>	<20101118091053.c275e1f2.akpm@linux-foundation.org>	<4CE56AA5.4030705@redhat.com> <20101118103638.99c1e8bc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Nick Piggin <npiggin@kernel.dk>, "Ted Ts'o" <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101118103638.99c1e8bc.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 11/18/10 12:36 PM, Andrew Morton wrote:
> On Thu, 18 Nov 2010 12:04:21 -0600 Eric Sandeen <sandeen@redhat.com> wrote:
> 
>> On 11/18/10 11:10 AM, Andrew Morton wrote:
>>> On Thu, 18 Nov 2010 08:55:18 -0600 Eric Sandeen <sandeen@redhat.com> wrote:
>>>
>>>>> Can we just delete writeback_inodes_sb_nr_if_idle() and
>>>>> writeback_inodes_sb_if_idle()?  The changelog for 17bd55d037a02 is
>>>>> pretty handwavy - do we know that deleting these things would make a
>>>>> jot of difference?
>>>>
>>>> Really?  I thought it was pretty decent ;)
>>>>
>>>> Anyway, xfstests 204, "Test out ENOSPC flushing on small filesystems."
>>>> shows the problem clearly, IIRC.  I should have included that in the
>>>> changelog, I suppose, sorry.
>>>
>>> Your email didn't really impart any information :(
>>>
>>> I suppose I could accidentally delete those nasty little functions in a
>>> drivers/parport patch then wait and see if anyone notices.
>>>
>>
>> Um, ok, then, to answer the question directly :
>>
>> No, please don't delete those functions, it will break ENOSPC handling
>> in ext4 as shown by xfstests regression test #204 ...
>>
> 
> If those functions "fix" a testcase then it was by sheer luck, and the
> fs's ENOSPC handling is still busted.
> 
> For a start writeback_inodes_sb_if_idle() is a no-op if the device
> isn't idle!  

so writeback is already in progress and it's already doing what we need,
right?  Space is being freed up as we speak in that case.

> Secondly, if the device _was_ idle,
> writeback_inodes_sb_if_idle() uses a work handoff to another thread,
> which means that the work might not get executed for another six weeks.

We start it quite early, before things are critical.

Yeah, it's not bulletproof but it is tons better.

-Eric

> So no, your ENOSPC handling is still busted and I'll be doing you a
> favour when I send that parport patch.
> 
> No?
> 


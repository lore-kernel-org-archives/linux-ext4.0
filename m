From: Mark Lord <kernel@teksavvy.com>
Subject: Re: ext4 crash on 2.6.37: NULL ptr in ext4_discard_preallocations
Date: Sun, 20 Feb 2011 09:39:23 -0500
Message-ID: <4D61279B.5030203@teksavvy.com>
References: <4D604620.9060204@teksavvy.com> <20110220000550.GA8765@thunk.org> <4D609E87.5000903@teksavvy.com> <4D60A117.8090604@teksavvy.com> <20110220061552.GB8765@thunk.org> <4D611D62.2030703@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:61111 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753746Ab1BTOjZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Feb 2011 09:39:25 -0500
In-Reply-To: <4D611D62.2030703@teksavvy.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11-02-20 08:55 AM, Mark Lord wrote:
> On 11-02-20 01:15 AM, Ted Ts'o wrote:
>> On Sun, Feb 20, 2011 at 12:05:27AM -0500, Mark Lord wrote:
>>> I suppose it must be, as there's no other 0x3c offset in that function.
>>> Which means it's probably this line that's crashing:
>>>
>>>              BUG_ON(pa->pa_obj_lock != &ei->i_prealloc_lock);
>>>
>>> ...which could only happen if "pa" was NULL there.
>>> I wonder how that happened ?
>>
>> Which could only happen if ei->i_prealloc_list were not properly
>> initialized (i..e, it was still NULL).  Which shouldn't ever
>> happen...., since all ext4_inodes are initialized in
>> ext4_alloc_inode().
>>
>> Hmm, can you replicate the crash?
> 
> So far it has been a one time deal here,
> but stuff like this is pretty serious nonetheless.
> 
> I suppose it could also happen if another thread did a list-delete
> at the same time as that function was running.  Which would require
> that there be a locking bug/confusion somewhere.
> 
> Looking over the code, most places use rcu to protect accesses,
> except for the fragment that crashed.  That's probably just fine,
> but something to reexamine just out of paranoia.
> 
> Also, the spinlock pointer appears to be dynamic, one of two
> possible spinlocks.  Maybe something got confused there
> (well, obviously *something* got confused, so..).

That looks like the best candidate:  perhaps pa->pa_obj_lock was
one of the per-cpu lg_prealloc_lock's at that point in time.
In which case an item could be deleted from the pa list
concurrently with the function that actually crashed?

That's as far as I can get with it in the time available.
You folks do know this code much better, so perhaps just expend
a few little grey cells on that theory before calling it quits?

Cheers!

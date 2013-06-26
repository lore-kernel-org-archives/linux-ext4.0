From: Nagachandra P <nagachandra@gmail.com>
Subject: Re: Memory allocation can cause ext4 filesystem to be remounted r/o
Date: Wed, 26 Jun 2013 22:35:22 +0530
Message-ID: <CAFy9=U5m5uew586C2eZJ7HjkRN5PvKr8+FoDdj8xtJoBeuP-_A@mail.gmail.com>
References: <CAFy9=U5n-YF017L+gni4v8pgq-AsLVTZBLwaZhPjHJCMXzLLag@mail.gmail.com>
	<20130626140205.GE3875@thunk.org>
	<20130626145417.GB32092@thunk.org>
	<CAFy9=U5O9qQP5QU_Nw4fEbfy2oVxUub=ddYgJ_ZKXmjdChO4iA@mail.gmail.com>
	<20130626163450.GA2487@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Vikram MP <mp.vikram@gmail.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:50140 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab3FZRFY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Jun 2013 13:05:24 -0400
Received: by mail-la0-f52.google.com with SMTP id fo12so13767116lab.25
        for <linux-ext4@vger.kernel.org>; Wed, 26 Jun 2013 10:05:23 -0700 (PDT)
In-Reply-To: <20130626163450.GA2487@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Theodore,

Kernel version we are using is 3.4.5 (AOSP based).

These issue are not easy to reproduce!!! We are running multiple
applications (of different memory size) over a period of a 24 hrs to
36 hrs and we hit this once. We have seen these issues easier to
reproduce typically with around 512MB memory (may be in about 16 hrs -
20 hrs), and harder to reproduce with 1GB memory.

Most of the time we get into these situation are when an application
(Typically AsyncTasks in Android) that is doing ext4 fs ops are of low
adj values (> 9, typically 10 - 12) and hence would be fairly gullible
to be killed (and there would be no way to distinguish this from
application perspective), this is one of the challenges we are facing.
Also, here we are don't have to completely be out of memory (but just
withing the LMK band for the process adj value).

But, on rethinking your idea on retrying may work if we have some
tweaks in LMK as well (like killing multiple tasks instead of just
one).

Thanks
Naga

On Wed, Jun 26, 2013 at 10:04 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Jun 26, 2013 at 08:50:50PM +0530, Nagachandra P wrote:
>>
>> We also have seen case where the current allocation itself could cause
>> the lowmem shrinker to be called (which in-turn chooses the same
>> process for killing because of oom_adj_value of the current process,
>> oom_adj_value is a weight age value associated with each process based
>> on which the android low memory killer would select a process for
>> killing to get memory). If we chose to retry in such case we could end
>> up in endless loop of retrying the allocation. It would be better to
>> handle this without retrying.
>
> The challenge is that in some cases there's no good way to return an
> error back upwards, and in other cases, the ability to back out of the
> middle of a file system operation is incredibly hard.  This is why we
> have the retry loop in the jbd2 code; the presumption is that some
> other process is scheduable, so that allows other processes to exit
> when the OOM killer takes out other processes.
>
> It's not an ideal solution, but in practice it's been good enough.  In
> general the OOM killer will be able to take out some other process and
> free up memory that way.
>
> Are you seeing this a lot?  If so, I think it's fair to ask why; from
> what I can tell it's not a situation that is happening often on most
> systems using ext4 (including Android devices, of which I have
> several).
>
>> We could your above suggestion which could address this specific path.
>> But, there are quiet a number of allocation in ext4 which could call
>> ext4_std_error on failure and we may need to look each one of them to
>> see on how do we handle each one of them. Do think this something that
>> could be done?
>
> There aren't that many places where ext4 does memory allocations,
> actually.  And once you exclude those which are used when the file
> system is initially mounted, there is quite a manageable number.  It's
> probably better to audit all of those and to make sure we have a good
> error recovery if any of these calls to kmalloc() or
> kmem_cache_alloc() fail.
>
> In many of the cases where we end up calling ext4_std_error(), the
> most common cause of is an I/O error while trying to read some
> critical metadata block, and in that case, declaring that the file
> system is corrupted is in fact the appropriate thing to do.
>
>> We have in the past tried some ugly hacks to workaround the problem
>> (by adjusting oom_adj_values, guarding them from being killed) but
>> they don't seem provide fool proof mechanism at high memory pressure
>> environment. Any advice on what we could try to fix the issue in
>> general would be appreciated?
>
> What version of the kernel are using?  And do you understand why you
> are under so much memory pressure?  Is it due to applications not
> getting killed quickly enough?  Are applications dirtying too much
> memory too quickly?  Is write throttling not working?  Or are they
> allocating too much memory when they start up their JVM?  Or is it
> just that your Android device has far less memory than most of the
> other devices out there?
>
> Speaking generally, if you're regularly seeing that kmem_cache_alloc
> failing, that means free memory has fallen to zero.  Which to me
> sounds like the OOM killer should be trying to kill processes more
> aggressively, and more generally you should be trying to be trying to
> make sure the kernel is maintaining a somewhat larger amount of free
> memory.  The fact that you mentioned trying to prevent certain
> processes from being killed may mean that you are approaching this
> problem from the wrong direction.  It may be more fruitful to
> encourage the system to kill those user applications that most
> deserving _earlier_.
>
> Regards,
>
>                                         - Ted

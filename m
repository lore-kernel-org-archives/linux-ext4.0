From: Ashlie Martinez <ashmrtn@utexas.edu>
Subject: Re: ext4 fix for interaction between i_size, fallocate, and delalloc
 after a crash
Date: Tue, 28 Nov 2017 07:04:54 -0600
Message-ID: <CAFk8rvbxaQ72rvOg6NXDQYG1rXtuZsdzJ5SrbR=C6ftAU0YyPA@mail.gmail.com>
References: <CAFk8rvZYEN4kGP9dF_FQxhP+UGfAY55uKrdsGr4-6ztWSoUp6w@mail.gmail.com>
 <20171122180317.nvymp7eedhswga7l@thunk.org> <CAFk8rvZ=EAUcAzxgi4bk+Qh2Y3ACZEv8unaowi0jvPNRB97XMA@mail.gmail.com>
 <20171127161137.4ghjcxfklpurk2eo@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Vijay Chidambaram <vvijay03@gmail.com>,
        Ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:36682 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751893AbdK1NEz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Nov 2017 08:04:55 -0500
Received: by mail-vk0-f48.google.com with SMTP id p144so176700vkp.3
        for <linux-ext4@vger.kernel.org>; Tue, 28 Nov 2017 05:04:55 -0800 (PST)
In-Reply-To: <20171127161137.4ghjcxfklpurk2eo@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 27, 2017 at 10:11 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Nov 27, 2017 at 08:31:07AM -0600, Ashlie Martinez wrote:
>> Ted,
>>
>> Thank you very much for taking the time to lay all of this out for me
>> (and throwing some humor and youtube links to boot), despite how busy
>> you were (I hope everything is alright!). I see now why the fix works
>> and what was going wrong. It appears I was confused about the order of
>> operations being performed in the test based on what I read in another
>> email. I believe in another email somewhere I read that the fallocate
>> was before a delayed write so I was thinking something like fallocate
>> then write. I see now that it is write with delayed allocation
>> (resolved after fallocate) and then fallocate. With that piece of
>> information everything else about the test, delayed allocation, and
>> the fix make sense.
>
> Sorry, "before" was misleading.  When I used the word "before", I was
> speaking of the order that the operations hit the disk.  The confusion
> comes from the fact that the delayed allocation write was *issued*
> before the fallocate, but in terms of when they are committed to disk,
> the fallocate commits *first*, and then 25-30 seconds later, the
> delayed allocation write is resolved and then committed to disk.

No biggie, part of the reason this was so hard for me to wrap my head
around is I don't have a physical machine that I can reproduce this on
(and I never got around to getting a GCE instance to test on). Not
being able to poke around a reproducing system makes it a little bit
harder for me to reason about :)

>
> It's the difference between the order that the operations are issued
> and when they are committed to disk which is what caused the bug; and
> the problem reproduction relies on crashing/aborting the file system
> between the time that the two operations would have been committed.
>
> Hopefully this will be helpful in terms of finding a way to create
> automated file system testing systems that can detect bugs similar to
> this one.  I can imagine that if you ever want to extend this to
> database testing, a similar technique might be used to detect
> transactions which close in a different order than how they were
> issued, or dealing transactions which end up getting rolled back.
>

Vijay and I are hopeful that we can find some reliable way to
reproduce this in CrashMonkey. It has also showed us a class of timing
bugs that we can't find with the current iteration of CrashMonkey, but
we hope we can expand what we have to find them in the future.

>                                                 - Ted
>
> P.S.  I see you have some Google internships under your belt, so I'm
> sure you know the drill, but I hope you'll consider us for another
> future internship experience.   :-)

Haha it's always been nice to be a little bit spoiled while interning
there for a summer. I hope I can make way back there for another
internship etc. eventually :)

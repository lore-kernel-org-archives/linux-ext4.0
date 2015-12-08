From: The Ghost <the-ghost@inbox.ru>
Subject: Re: Does ext4 write anything during reading with relatime?
Date: Tue, 08 Dec 2015 03:44:47 +0300
Message-ID: <566627FF.3020005@inbox.ru>
References: <5662C472.2050902@inbox.ru> <20151206211454.GB2614@thunk.org> <5665FD3D.1050603@inbox.ru> <20151207231913.GA3094@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp29.i.mail.ru ([94.100.177.89]:37339 "EHLO smtp29.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049AbbLHAox (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Dec 2015 19:44:53 -0500
Received: from [176.193.145.23] (port=38832 helo=[192.168.1.9])
	by smtp29.i.mail.ru with esmtpa (envelope-from <the-ghost@inbox.ru>)
	id 1a66Og-00080G-AM
	for linux-ext4@vger.kernel.org; Tue, 08 Dec 2015 03:44:50 +0300
In-Reply-To: <20151207231913.GA3094@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/12/15 02:19, Theodore Ts'o wrote:
> On Tue, Dec 08, 2015 at 12:42:21AM +0300, The Ghost wrote:
>>
>> I just tried again. With relatime or noatime, the second drive spins up.
>> Always. With read-only, it never spins up. And that doesn't make sense...
>
> The superblock *does* get modified at mount time to update the last
> mount time and the mount count in the superblock.  But I've tested
> using blktrace, and that's the only write I see after copying in a set
> of test files, reading them (so that atime > mtime), and then
> umounting the file system.  I then started the blktrace, mounted the
> file system, and read all of the files using "tar cvzf /tmp/foo.tar.gz /mnt".
>
> Cheers,
>
> 						- Ted

During mount, yes, of course. During unmount, too. But, I spin the 
drives down after I've mounted them and updated the atimes!..

blktrace? thanks for the tip. :) I've installed it, and here is what I see.

I am too lazy to go plug in the drives I used for the RAID, so I just 
set up a loop device and do the test. I set up blktrace to register 
write requests, and for some reason, it shows 1 event each launch (this 
is probably the way it's supposed to be, though I have no idea what it 
means). Fine. I do the test, and it's only that one request, so you're 
right - nothing else gets written.

But then, why does my second drive spin up?! I've plugged in my RAID 
drives, and did the test again. And it did show 5 write events, 1 KiB 
data!! Plus that "one usual event" which, for some reason, does not 
cause the second drive to spin up. So, it does write something only if 
we're using an md device! But not if we're using a loop device, or 
whatever device you've used for the test.

Now I'm getting a feeling I probably won't find out what mysterious data 
gets written onto an md device and not any other kind of device, and 
even if I do, I probably wouldn't understand it...

This leads us to a conclusion that it's not the filesystem's fault - 
it's probably the RAID. But, it does not happen when I mount the 
filesystem in read-only mode, or when I read from the md device itself, 
which led me to believe it must be the filesystem!!..


Thank you for taking your time to explore this mystery with me. :) Now I 
can boast that not only have I contributed to the Linux kernel 
development by helping get one patch accepted, but also I've talked to 
Ted Ts'o once about something that apparently turned out to have nothing 
to do with ext4. :)


-- 
The Ghost

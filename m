From: Liwei <xieliwei@gmail.com>
Subject: Re: Recovering from a damaged root inode
Date: Fri, 29 Aug 2014 01:19:06 +0800
Message-ID: <CAPE0SYzRsYFQ9WrLvRzqABXVzRVshhgSK_q5rb+AgEZGQ_NE5A@mail.gmail.com>
References: <CAPE0SYxva9AkaynNDofObS-U5VW7RYW8io+N9Pz+6jVsCody8A@mail.gmail.com>
 <20140828121637.GA3043@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:45508 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaH1RT1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2014 13:19:27 -0400
Received: by mail-wi0-f181.google.com with SMTP id e4so1293661wiv.2
        for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2014 10:19:26 -0700 (PDT)
In-Reply-To: <20140828121637.GA3043@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
    Thanks for the response! Responses in-line.

On 28 August 2014 20:16, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Aug 26, 2014 at 07:32:59PM +0800, Liwei wrote:
>>
>>     I thought a second fsck run would help, but running it with -n
>> gave me the following:
>
> I take it you don't have the transcript from the first fsck run?

Yes, I initially thought it was a simple problem, so I did not keep a
log of the first run. From memory, all it did was replace the
superblock from a backup.

>
> Also, you didn't tell us what version of e2fsprogs you are using.

Not sure why I left out the obvious: 1.42.5-1.1

>
> Finally, this error is one was caused by your using fsck -n:
>
>> Illegal triple indirect block (3637063325) in inode 1065.  IGNORED.
>> Error while iterating over blocks in inode 1065: Illegal triply
>> indirect block found
>
> There was an illegal indirect bock in inode 1065, which wasn't fixed
> because of e2fsck -n.  Unfortunately, this caused the scan to get
> aborted, because the unfixed error caused the inode iterator to fail.
> We could try to fix things up to make e2fsck -n recover more cleanly
> in the face of errors caused by not fixing previously found errors,
> but that hasn't been something that's been high priority.  (If someone
> would like to improve e2fsck in this regard, please send patches.)

Personally I think the way e2fsck handled it is fine. Maybe a simple
message stating that "errors that occur when using -n may be the
result of the decision to ignore all fixes" would work.

>
> More generally, it looks like part of your inode table got smashed.

That sounds bad. From my limited understanding of ext4's structure,
each block group has its own inode table, right? Or is the inode table
global? What are my chances of recovering from this?

> How, it's hard to say.  There have historically been some bugs with
> resizing, but online resizing has been much more safe than off-line
> resizing with big file systems, and the problems tend to with file
> systems larger than 16TB.  (Although for file systems larger than 8TB,

I believe the problem came as a result of the power failure. Or are
you suggesting that the resize could have been instrumental in causing
this?

> I do strongly recommend that people update to the latest kernel and
> e2fsprogs; and there have been a lot of bug fixes to e2fsprogs in the
> past year and a half.  If you are using an enterprise distribution,
> hopefully you're using one which has been good about backporting fixes
> --- but 3.9.x hasn't been used by a distro kernel as far as I know,
> and 3.9.x isn't even a long-term stable maintenace kernel.  So I'm
> guessing this is a roll-your-own sort of system?)
>

Very good deduction. The machine is mainly a virtual machine host for
my own work, and I had to use the mainline kernel (about a year and
half ago, when I built the machine) in order to get some xen features
working. Since xen was very fidgety between kernel versions, I decided
to "not update when it ain't broke". I'll definitely update everything
after this, but my main concern now is the possibility of recovery.

>                                          - Ted

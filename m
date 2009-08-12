From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: >16TB issues
Date: Wed, 12 Aug 2009 09:12:24 -0500
Message-ID: <4A82CDC8.1040007@redhat.com>
References: <150c16850907021523p25ddae32v2eeea54418d2e6d5@mail.gmail.com>	 <4A824364.20709@redhat.com> <150c16850908112235o10970aefqa16f2e08490d74e7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38254 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbZHLOMZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Aug 2009 10:12:25 -0400
In-Reply-To: <150c16850908112235o10970aefqa16f2e08490d74e7@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Justin Maggard wrote:
> On Tue, Aug 11, 2009 at 9:21 PM, Eric Sandeen<sandeen@redhat.com> wrote:
>>> -  Immediately running e2fsck on the volume before ever mounting it
>>> will not complete, and results in the following:
>>> # e2fsck -n /dev/md2
>>> e2fsck 1.41.7 (29-June-2009)
>>> Error reading block 2435874816 (Attempt to read block from filesystem
>>> resulted in short read).  Ignore error? no
>> This is roughly halfway through the filesystem; the journal is roughly
>> in the middle of the filesystem; this is just over 2^31 blocks.  I bet
>> there are still ints or longs in the userspace journal code.  I'll take
>> a look.
> 
> Thanks for looking into this.  That log message is from when I was
> running a 32-bit kernel,

oh!  ok I missed that tidbit.   Although even full 32-bit should be able
to reach 16T at least.  Hmmm

>  and I was apparently running into page cache
> index limitations.  That error went away when I switched to a x86_64
> kernel, but there are still other errors, as posted in one of my more
> recent messages.

Guess I need to catch up a bit.  :)

-Eric

p.s. I ws wrong about the 73G lifetime writes; just mkfsing a 19T
filesystem even w/ lazy_itable_init=1, it did 351G of writes at mkfs
time so that's not it.

> -Justin


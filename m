From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Subject: Re: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable "kernel
 BUG at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Tue, 6 Dec 2011 15:26:31 -0600
Message-ID: <4DF71AE2-B51F-4D05-A15C-EEE1DF00932C@boeing.com>
References: <AF621113-8320-4973-A88A-1FC048EA4293@boeing.com>
 <BANLkTi=5BLA07tvbv3PFcZ0cc8FmBtg+UA@mail.gmail.com>
 <404FD5CC-8F27-4336-B7D4-10675C53A588@boeing.com>
 <20110624134659.GB26380@quack.suse.cz>
 <2F80BF45-28FA-46D3-9A28-CA9416DC5813@boeing.com>
 <20110624200231.GA32176@quack.suse.cz>
 <5DE8D448-A77D-46E8-BF40-15AA7F7CDBE9@boeing.com>
 <79E8C04C-B5A8-49E5-901F-444C8B8A53DB@boeing.com>
 <20110830221249.GH16202@quack.suse.cz>
 <F33B5C17-2893-44D4-BBE4-C75CDC1375EA@boeing.com>
 <20110901151744.GA2070@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Sean Ryle <seanbo@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
	"615998@bugs.debian.org" <615998@bugs.debian.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from stl-smtpout-01.boeing.com ([130.76.96.56]:49358 "EHLO
	stl-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab1LFXU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Dec 2011 18:20:58 -0500
In-Reply-To: <20110901151744.GA2070@quack.suse.cz>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello again!

I know it's been ages, but I finally got some time to get that patch
tested out and try additional debugging.

On Sep 01, 2011, at 11:17, Jan Kara wrote:
> On Tue 30-08-11 19:26:22, Moffett, Kyle D wrote:
>> On Aug 30, 2011, at 18:12, Jan Kara wrote:
>>>> I can still trigger it on my VM snapshot very easily, so if you have anything
>>>> you think I should test I would be very happy to give it a shot.
>>> 
>>> OK, so in the meantime I found a bug in data=journal code which could be
>>> related to your problem. It is fixed by commit
>>> 2d859db3e4a82a365572592d57624a5f996ed0ec which is in 3.1-rc1. Have you
>>> tried that or newer kernel as well?
>>> 
>>> If the problem still is not fixed, I can provide some debugging patch to
>>> you. We spoke with Josef Bacik how errors like yours could happen so I have
>>> some places to watch...
>> 
>> I have not tried anything more recent; I'm actually a bit reluctant to move
>> away from the Debian squeeze official kernels since I do need the security
>> updates.
>> 
>> I took a quick look and I can't find that function in 2.6.32, so I assume it
>> would be a rather nontrivial back-port.  It looks like the relevant code
>> used to be in ext4_clear_inode somewhere?
> It's not that hard - untested patch attached.

So this applied mostly cleanly (with one minor context-only conflict in
the 2.6.32.17 patch), unfortunately it didn't resolve the problem.
Just as a sanity check, I upgraded to the Debian 3.1.0-1-amd64 kernel,
based on kernel version 3.1.1 and the problem still occurs there too
(additional info at the end of the email).

Looking at the issue again, I don't think it has anything to do with
file deletion at all.

Specifically, there are a grand total of 4 files in that filesystem
(alongside an empty "lost+found" directory):
  master.lock
  prng_exch
  smtpd_scache.db
  smtp_scache.db

As far as I can tell, none of those is ever deleted during normal
operation.

The crash occurs very quickly after starting postfix.  It connects to
the external email server (using TLS) and begins to flush queued mail.

At that point, the "tlsmgr" daemon tries to update the "smtp_scache.db"
file, which is a Berkeley DB about 40k in size.  Somewhere in there,
the Berkeley DB does an fdatasync().

The "fdatasync()" apparently triggers the bad behavior from the "jbd2"
thread, which then oopses in fs/jbd2/commit.c:485 (which appears to be
the same same BUG_ON() as before).

The stack looks something like this:
  jbd_journal_commit_transaction+0x4ea/0x1053 [jbd2]
  kjournald2+0xc0/0x20a [jbd2]
  add_wait_queue+0x3c/0x3c
  commit_timeout+0x5/0x5 [jbd2]
  kthread+0x76/0x7e

Cheers,
Kyle Moffett

--
Curious about my work on the Debian powerpcspe port?
I'm keeping a blog here: http://pureperl.blogspot.com/

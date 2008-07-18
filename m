From: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: ext3 on latest -git: BUG: unable to handle kernel NULL pointer dereference at 0000000c
Date: Fri, 18 Jul 2008 22:28:08 +0200
Message-ID: <19f34abd0807181328m7d484b00had3250f42728dba0@mail.gmail.com>
References: <20080717141333.GC14133@unused.rdu.redhat.com>
	 <19f34abd0807170744r79e46a78odfcfbd67687d2ceb@mail.gmail.com>
	 <20080717143332.GE14133@unused.rdu.redhat.com>
	 <19f34abd0807170800q13cc021dyed27c665c25ac520@mail.gmail.com>
	 <20080717144342.GA15844@unused.rdu.redhat.com>
	 <20080717230905.GI6239@webber.adilger.int>
	 <20080718105152.GB15844@unused.rdu.redhat.com>
	 <19f34abd0807180432i19567dfal5d7d29bb1916b562@mail.gmail.com>
	 <20080718112003.GC15844@unused.rdu.redhat.com>
	 <19f34abd0807180458i2749f5d0jc5c07f691931954e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Andreas Dilger" <adilger@sun.com>,
	"Josef Bacik" <josef@toxicpanda.com>, linux-ext4@vger.kernel.org,
	sct@redhat.com, akpm@linux-foundation.org,
	"Johannes Weiner" <hannes@saeurebad.de>,
	"Duane Griffin" <duaneg@gmail.com>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
To: "Josef Bacik" <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:10638 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131AbYGRU2K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2008 16:28:10 -0400
Received: by yw-out-2324.google.com with SMTP id 9so146893ywe.1
        for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 13:28:09 -0700 (PDT)
In-Reply-To: <19f34abd0807180458i2749f5d0jc5c07f691931954e@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2008 at 1:58 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Fri, Jul 18, 2008 at 1:20 PM, Josef Bacik <jbacik@redhat.com> wrote:
>>> You can see the full log at
>>> http://folk.uio.no/vegardno/linux/log-1216380709.txt which shows that
>>> it already survived a lot of failures, so I'm guessing your patch was
>>> correct and we just hit a different case. What do you think?
>>>
>>
>> Yeah you are right, its like a shitty game of wack-a-mole.  Heres another patch,
>> same thing as last time, pull the other one out put this one on.  Thanks,
>
> It seems to hold up -- no stacktraces, but lots of IO failures.
>
> I would leave it in testing for a bit more, but I've got to run; I'll
> give it another go when I get home.

Ok, we still got this:

BUG: unable to handle kernel NULL pointer dereference at 0000000c
IP: [<c025ea28>] journal_dirty_metadata+0xb8/0x1b0
*pde = 00000000
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 4770, comm: rm Not tainted (2.6.26-03421-g253a722 #49)
EIP: 0060:[<c025ea28>] EFLAGS: 00210246 CPU: 1
EIP is at journal_dirty_metadata+0xb8/0x1b0
EAX: 00000000 EBX: f3d70c90 ECX: 00000001 EDX: f3e12000
ESI: 00000000 EDI: f21118f0 EBP: f3e13d94 ESP: f3e13d6c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process rm (pid: 4770, ti=f3e12000 task=f62cdfa0 task.ti=f3e12000)
Stack: f3d70430 f578047c f578047c f3e13d94 c0222cdb f779c000 f6ff2e70 f21118f0
       f779c000 f21118f0 f3e13db4 c02345ef 0000001c 00001499 c0760bc4 f21118f0
       00000000 ef36d004 f3e13de4 c0228e6f 0000147e 0000001c ef36d004 ef36d400
Call Trace:
 [<c0222cdb>] ? ext3_free_blocks+0x6b/0xa0
 [<c02345ef>] ? __ext3_journal_dirty_metadata+0x1f/0x50
 [<c0228e6f>] ? ext3_free_data+0x9f/0x100
 [<c02290e3>] ? ext3_free_branches+0x213/0x220
 [<c0222cdb>] ? ext3_free_blocks+0x6b/0xa0
 [<c0228f7e>] ? ext3_free_branches+0xae/0x220
 [<c022967c>] ? ext3_truncate+0x58c/0x940
 [<c015ad96>] ? trace_hardirqs_on_caller+0x116/0x170
 [<c0260733>] ? journal_start+0xd3/0x110
 [<c0260710>] ? journal_start+0xb0/0x110
 [<c0229b07>] ? ext3_delete_inode+0xd7/0xe0
 [<c0229a30>] ? ext3_delete_inode+0x0/0xe0
 [<c01b9bc1>] ? generic_delete_inode+0x81/0x120
 [<c01b9d87>] ? generic_drop_inode+0x127/0x180
 [<c01b8c07>] ? iput+0x47/0x50
 [<c01af1dc>] ? do_unlinkat+0xec/0x170
 [<c01b187b>] ? vfs_readdir+0x6b/0xa0
 [<c01b1560>] ? filldir64+0x0/0xf0
 [<c0430a08>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c015ad96>] ? trace_hardirqs_on_caller+0x116/0x170
 [<c01af3a3>] ? sys_unlinkat+0x23/0x50
 [<c010407f>] ? sysenter_past_esp+0x78/0xc5
 =======================
Code: b8 01 00 00 00 e8 c9 3f ed ff 89 e0 25 00 e0 ff ff f6 40 08 08
74 05 e8 47 98 4e 00 83 c4 1c 31 c0 5b 5e 5f 5d c3 90 8d 74 26 00 <8b>
46 0c 85 c0 0f 84 8d 00 00 00 8b 45 f0 39 46 18 74 66 8d 47
EIP: [<c025ea28>] journal_dirty_metadata+0xb8/0x1b0 SS:ESP 0068:f3e13d6c
Kernel panic - not syncing: Fatal exception


It looks similar to one of the others we saw. Are you sure I should
back out all your previous patches? My stack looks like this:

Duane Griffin (1):
      ext3: validate directory entry

Josef Bacik (1):
      ext3 on latest -git: BUG: unable to handle kernel NULL pointer dereference

And I am using error=continue.

Now I've modified my scripts to also save the bad image, so I (or
whomever) can re-test a specific crash easily. For instance, this one
can be downloaded from
http://folk.uio.no/vegardno/linux/ext3-crash-fs.bin.bz2 and mounted.
Then you run rm -rf mnt/* and it should crash.

Log is also available at http://folk.uio.no/vegardno/linux/log-1216412153.txt


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

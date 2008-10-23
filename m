From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: jbd/jbd2 performance improvements
Date: Thu, 23 Oct 2008 08:00:24 -0400
Message-ID: <49006758.9020901@redhat.com>
References: <E1KnCO6-0001qG-SV@closure.thunk.org>	<48F62893.9060606@redhat.com>	<18678.55651.556822.187508@frecb006361.adech.frec.bull.fr>	<48F72E5F.2050409@redhat.com>	<48F735E8.7060803@redhat.com> <18688.21800.641991.52484@frecb006361.adech.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Solofo.Ramangalahy@bull.net,
	Arjan De Ven <arjan.van.de.ven@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55864 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbYJWMB5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Oct 2008 08:01:57 -0400
In-Reply-To: <18688.21800.641991.52484@frecb006361.adech.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Solofo.Ramangalahy@bull.net wrote:
>>>>>> On Thu, 16 Oct 2008 07:39:04 -0500, Eric Sandeen <sandeen@redhat.com> said:
>>>>>>             
>     >> A very thorough test, but the results don't seem to point to a
>     >> consistent winner.
>     >> 
>     >> I agree that running without KVM in the picture might be very
>     >> interesting. Eric has some similar tests underway, I think that
>     >> his results were also inconclusive so far...
>
>     Eric> Yep, I've yet to find an fs_mark invocation, at least, which
>     Eric> shows a clear winner.  I also ran w/ akpm's suggested
>     Eric> io_schedule watcher patch and never see us waiting on this
>     Eric> lock (I did set it to 1s though, which is probably too long
>     Eric> for my storage).
>
> I've redone the tests without kvm. Still no clear winner
>
> To sum up:
> . kernel ext4-stable
> . mkfs (1.41.3) default options
> . mount options: default, akpm, akpm_lock_hack
> . scheduler default (cfq)
> . 8 cpus, single 15K rpm disk.
> . without the high latency detection patch
> . a broad range of fs_mark (all the sync strategies, from 1 to 32
>   threads, up to 10000 files/thread, several directories).
> . a "tangled synchrony" workload as mentionned in the "Analysis and
>   evolution of journaling file systems" paper discussed monday.
>
> First things first, maybe I should have spent more time
> reproducing Arjan behavior before testing.
>
> This was not a complete waste of time though, as the following errors
> were spotted during the runs:
> 1. EXT4-fs error (device sdb): ext4_free_inode: bit already cleared for inode 32769
> 2. EXT4-fs error (device sdb): ext4_init_inode_bitmap: Checksum bad for group 8
> 3. BUG: spinlock wrong CPU on CPU#3, fs_mark/1975
>  lock: ffff88015a44f480, .magic: dead4ead, .owner: fs_mark/1975, .owner_cpu: 1
> Pid: 1975, comm: fs_mark Not tainted 2.6.27.1-ext4-stable-gcov #1
>
> Call Trace:
>  [<ffffffff811a47a2>] spin_bug+0xa2/0xaa
>  [<ffffffff811a481f>] _raw_spin_unlock+0x75/0x8a
>  [<ffffffff814552c1>] _spin_unlock+0x26/0x2a
>  [<ffffffffa00d4fd3>] ext4_read_inode_bitmap+0xfa/0x14e [ext4]
>  [<ffffffffa00d564b>] ext4_new_inode+0x5d4/0xec4 [ext4]
>  [<ffffffff810562db>] ? __lock_acquire+0x481/0x7d8
>  [<ffffffffa00c2430>] ? jbd2_journal_start+0xef/0x11a [jbd2]
>  [<ffffffffa00c2430>] ? jbd2_journal_start+0xef/0x11a [jbd2]
>  [<ffffffffa00deb99>] ext4_create+0xc7/0x144 [ext4]
>  [<ffffffff810b6734>] vfs_create+0xdf/0x155
>  [<ffffffff810b8905>] do_filp_open+0x220/0x7fc
>  [<ffffffff814552c1>] ? _spin_unlock+0x26/0x2a
>  [<ffffffff810abe5a>] do_sys_open+0x53/0xd3
>  [<ffffffff810abf03>] sys_open+0x1b/0x1d
>  [<ffffffff8100bf8b>] system_call_fastpath+0x16/0x1b
>  
> Anybody seen this in their logs?
>
> The "bit already cleared for inode" is triggered by:
> fs_mark -v -d /mnt/test-ext4 -n10000 -D10 -N1000 -t8 -s4096 -S0
>
>   
Arjan,

Do you have any details on the test case that you ran that showed a 
clear improvement? What kind of storage & IO pattern did you use?

Regards,

Ric


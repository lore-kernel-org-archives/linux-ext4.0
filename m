From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: ext4: possible unsafe locking scenario
Date: Thu, 27 Nov 2014 21:32:11 +0900
Message-ID: <20141127123211.GA1001@swordfish>
References: <20141126145951.GA2750@swordfish>
 <20141126152821.GA4004@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141126152821.GA4004@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On (11/26/14 10:28), Theodore Ts'o wrote:
> Date: Wed, 26 Nov 2014 10:28:21 -0500
> From: Theodore Ts'o <tytso@mit.edu>
> To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
>  linux-kernel@vger.kernel.org
> Subject: Re: ext4: possible unsafe locking scenario
> User-Agent: Mutt/1.5.23 (2014-03-12)
> 
> On Wed, Nov 26, 2014 at 11:59:51PM +0900, Sergey Senozhatsky wrote:
> > Hello,
> > 
> > locked spew with the current -next.
> 
> Hmm.... what was the system doing at that time?  Is it something that
> reliably reproduces, or is this a one-off?
> 
> Thanks,
> 
> 						- Ted

sorry for long response, can reply only in my spare time.


yet another one.
in both cases: compiling glibc with gcc (-j2).


[ 1127.189118] =============================================
[ 1127.189119] [ INFO: possible recursive locking detected ]
[ 1127.189122] 3.18.0-rc6-next-20141126-dbg-00001-gb80a67f-dirty #402 Not tainted
[ 1127.189123] ---------------------------------------------
[ 1127.189125] rm/27750 is trying to acquire lock:
[ 1127.189127]  (&ei->i_data_sem){++++..}, at: [<ffffffff8119022f>] ext4_truncate+0x1cc/0x2bc
[ 1127.189137] 
but task is already holding lock:
[ 1127.189139]  (&ei->i_data_sem){++++..}, at: [<ffffffff8119022f>] ext4_truncate+0x1cc/0x2bc
[ 1127.189144] 
other info that might help us debug this:
[ 1127.189145]  Possible unsafe locking scenario:

[ 1127.189147]        CPU0
[ 1127.189148]        ----
[ 1127.189149]   lock(&ei->i_data_sem);
[ 1127.189151]   lock(&ei->i_data_sem);
[ 1127.189153] 
 *** DEADLOCK ***

[ 1127.189155]  May be due to missing lock nesting notation

[ 1127.189157] 5 locks held by rm/27750:
[ 1127.189158]  #0:  (sb_writers#7){.+.+.+}, at: [<ffffffff81101e62>] mnt_want_write+0x1f/0x46
[ 1127.189166]  #1:  (sb_internal){.+.+..}, at: [<ffffffff8119119c>] ext4_evict_inode+0x1cb/0x3d6
[ 1127.189171]  #2:  (jbd2_handle){+.+...}, at: [<ffffffff811c4099>] start_this_handle+0x4e0/0x566
[ 1127.189177]  #3:  (&ei->i_data_sem){++++..}, at: [<ffffffff8119022f>] ext4_truncate+0x1cc/0x2bc
[ 1127.189181]  #4:  (sb_internal){.+.+..}, at: [<ffffffff8119119c>] ext4_evict_inode+0x1cb/0x3d6
[ 1127.189186] 
stack backtrace:
[ 1127.189189] CPU: 0 PID: 27750 Comm: rm Not tainted 3.18.0-rc6-next-20141126-dbg-00001-gb80a67f-dirty #402
[ 1127.189191] Hardware name: Acer             Aspire 5741G    /Aspire 5741G    , BIOS V1.20 02/08/2011
[ 1127.189193]  ffffffff820f71a0 ffff8801045d7908 ffffffff813cd7ff 0000000000000006
[ 1127.189196]  ffffffff820f71a0 ffff8801045d79d8 ffffffff8106c27d ffff880111aafdd0
[ 1127.189200]  ffff880111aafdd0 ffff88015255e800 ffff8801514b0798 0000000000000003
[ 1127.189203] Call Trace:
[ 1127.189208]  [<ffffffff813cd7ff>] dump_stack+0x4c/0x65
[ 1127.189212]  [<ffffffff8106c27d>] __lock_acquire+0x7b5/0x1a17
[ 1127.189216]  [<ffffffff810fe317>] ? find_active_inode_nowait+0x91/0xa8
[ 1127.189219]  [<ffffffff8118eff7>] ? ext4_mark_iloc_dirty+0x70c/0x7ab
[ 1127.189221]  [<ffffffff8106db62>] lock_acquire+0x4f/0x6e
[ 1127.189225]  [<ffffffff8119022f>] ? ext4_truncate+0x1cc/0x2bc
[ 1127.189231]  [<ffffffff81058acf>] ? __might_sleep+0xac/0xb4
[ 1127.189236]  [<ffffffff813d1695>] down_write+0x3d/0x6d
[ 1127.189240]  [<ffffffff8119022f>] ? ext4_truncate+0x1cc/0x2bc
[ 1127.189243]  [<ffffffff8119022f>] ext4_truncate+0x1cc/0x2bc
[ 1127.189247]  [<ffffffff811912a2>] ext4_evict_inode+0x2d1/0x3d6
[ 1127.189250]  [<ffffffff810fd871>] evict+0x102/0x1ad
[ 1127.189253]  [<ffffffff810fe490>] ? iput+0x120/0x131
[ 1127.189257]  [<ffffffff810fe498>] iput+0x128/0x131
[ 1127.189261]  [<ffffffff8118ef21>] ext4_mark_iloc_dirty+0x636/0x7ab
[ 1127.189265]  [<ffffffff8118f1a3>] ext4_mark_inode_dirty+0x8a/0x1a2
[ 1127.189270]  [<ffffffff811a484a>] __ext4_ext_dirty+0x6d/0x79
[ 1127.189274]  [<ffffffff811a731f>] ext4_ext_remove_space+0x858/0xcdc
[ 1127.189278]  [<ffffffff811a8cc7>] ext4_ext_truncate+0x9a/0xbe
[ 1127.189282]  [<ffffffff81190250>] ext4_truncate+0x1ed/0x2bc
[ 1127.189286]  [<ffffffff811912a2>] ext4_evict_inode+0x2d1/0x3d6
[ 1127.189289]  [<ffffffff810fd871>] evict+0x102/0x1ad
[ 1127.189293]  [<ffffffff8106b837>] ? trace_hardirqs_on_caller+0x180/0x19c
[ 1127.189296]  [<ffffffff810fe490>] ? iput+0x120/0x131
[ 1127.189299]  [<ffffffff810fe498>] iput+0x128/0x131
[ 1127.189304]  [<ffffffff810f4449>] do_unlinkat+0x141/0x213
[ 1127.189311]  [<ffffffff8100da89>] ? syscall_trace_enter_phase1+0x112/0x122
[ 1127.189317]  [<ffffffff812166db>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 1127.189322]  [<ffffffff810f4b71>] SyS_unlinkat+0x24/0x26
[ 1127.189328]  [<ffffffff813d34d6>] system_call_fastpath+0x16/0x1b


	-ss

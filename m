From: Jan Kara <jack@suse.cz>
Subject: Re: WARNING: CPU: 26 PID: 93793 at fs/ext4/inode.c:230
 ext4_evict_inode+0x4c9/0x500 [ext4]() still in 3.11-rc3
Date: Wed, 7 Aug 2013 20:45:51 +0200
Message-ID: <20130807184551.GD26516@quack.suse.cz>
References: <1375388059.2097.10.camel@buesod1.americas.hpqcorp.net>
 <20130801203320.GB31857@quack.suse.cz>
 <1375415926.2269.1.camel@buesod1.americas.hpqcorp.net>
 <20130807152050.GA26516@quack.suse.cz>
 <1375898923.2134.63.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	Guenter Roeck <linux@roeck-us.net>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Davidlohr Bueso <davidlohr@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1375898923.2134.63.camel@buesod1.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 07-08-13 11:08:43, Davidlohr Bueso wrote:
> Hi Jan,
> 
> On Wed, 2013-08-07 at 17:20 +0200, Jan Kara wrote:
> > On Thu 01-08-13 20:58:46, Davidlohr Bueso wrote:
> > > On Thu, 2013-08-01 at 22:33 +0200, Jan Kara wrote:
> > > >   Hi,
> > > > 
> > > > On Thu 01-08-13 13:14:19, Davidlohr Bueso wrote:
> > > > > FYI I'm seeing loads of the following messages with Linus' latest
> > > > > 3.11-rc3 (which includes 822dbba33458cd6ad)
> > > >   Thanks for notice. I see you are running reaim to trigger this. What
> > > > workload?
> > > 
> > > After re-running the workloads one by one, I finally hit the issue again
> > > with 'dbase'. FWIW I'm using ramdisks + ext4.
> >   Hum, I'm not able to reproduce this with current Linus' kernel - commit
> > e4ef108fcde0b97ed38923ba1ea06c7a152bab9e - I've tried with ramdisk but no
> > luck. Are you using some special mount options?
> > 
> 
> I just hit the issue again with today's latest pull, 3.11-rc4 (which has
> e4ef108fcde0b97ed38923ba1ea06c7a152bab9e as of yesterday). I create the
> fs with "-b 4096 -J size=4", and mount it with
> "journal_async_commit,nobarrier,async,noatime,nodiratime"
  Still no success :(.

> I cannot really think of any additional info I can give you, but if you
> think of something else just shout :)
  Maybe what's your reaim.config? And what is fs size and machine config?

								Honza


> > > > > ------------[ cut here ]------------
> > > > > WARNING: CPU: 26 PID: 93793 at fs/ext4/inode.c:230 ext4_evict_inode+0x4c9/0x500 [ext4]()
> > > > > Modules linked in: autofs4 cpufreq_ondemand freq_table sunrpc 8021q garp stp llc pcc_cpufreq ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log dm_mod uinput iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode pcspkr sg lpc_ich mfd_core hpilo hpwdt i7core_edac edac_core netxen_nic mperf ext4 jbd2 mbcache sd_mod crc_t10dif aesni_intel ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: freq_table]
> > > > > CPU: 26 PID: 93793 Comm: reaim Tainted: G        W    3.11.0-rc3+ #1
> > > > > Hardware name: HP ProLiant DL980 G7, BIOS P66 06/24/2011
> > > > >  00000000000000e6 ffff8985db603d78 ffffffff8153ce4d 00000000000000e6
> > > > >  0000000000000000 ffff8985db603db8 ffffffff8104cf1c ffff8985db603dc8
> > > > >  ffff8b05c485b8b0 ffff8b05c485b9b8 ffff8b05c485b800 00000000ffffff9c
> > > > > Call Trace:
> > > > >  [<ffffffff8153ce4d>] dump_stack+0x49/0x5c
> > > > >  [<ffffffff8104cf1c>] warn_slowpath_common+0x8c/0xc0
> > > > >  [<ffffffff8104cf6a>] warn_slowpath_null+0x1a/0x20
> > > > >  [<ffffffffa02a0179>] ext4_evict_inode+0x4c9/0x500 [ext4]
> > > > >  [<ffffffff811915e7>] evict+0xa7/0x1c0
> > > > >  [<ffffffff811917e3>] iput_final+0xe3/0x170
> > > > >  [<ffffffff811918ae>] iput+0x3e/0x50
> > > > >  [<ffffffff81187aa6>] do_unlinkat+0x1c6/0x280
> > > > >  [<ffffffff8106f3e4>] ? task_work_run+0x94/0xf0
> > > > >  [<ffffffff81003a44>] ? do_notify_resume+0x84/0x90
> > > > >  [<ffffffff81187b76>] SyS_unlink+0x16/0x20
> > > > >  [<ffffffff81549a02>] system_call_fastpath+0x16/0x1b
> > > > > ---[ end trace 15e812809616488b ]---
> > > > > 
> > > > > 
> > > 
> > > 
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

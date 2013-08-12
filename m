From: Jan Kara <jack@suse.cz>
Subject: Re: WARNING: CPU: 26 PID: 93793 at fs/ext4/inode.c:230
 ext4_evict_inode+0x4c9/0x500 [ext4]() still in 3.11-rc3
Date: Mon, 12 Aug 2013 11:57:04 +0200
Message-ID: <20130812095704.GA4596@quack.suse.cz>
References: <1375388059.2097.10.camel@buesod1.americas.hpqcorp.net>
 <20130801203320.GB31857@quack.suse.cz>
 <1375415926.2269.1.camel@buesod1.americas.hpqcorp.net>
 <20130807152050.GA26516@quack.suse.cz>
 <1375898923.2134.63.camel@buesod1.americas.hpqcorp.net>
 <20130807184551.GD26516@quack.suse.cz>
 <1375909663.2134.70.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	Guenter Roeck <linux@roeck-us.net>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Davidlohr Bueso <davidlohr@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1375909663.2134.70.camel@buesod1.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 07-08-13 14:07:43, Davidlohr Bueso wrote:
> On Wed, 2013-08-07 at 20:45 +0200, Jan Kara wrote:
> > On Wed 07-08-13 11:08:43, Davidlohr Bueso wrote:
> > > Hi Jan,
> > > 
> > > On Wed, 2013-08-07 at 17:20 +0200, Jan Kara wrote:
> > > > On Thu 01-08-13 20:58:46, Davidlohr Bueso wrote:
> > > > > On Thu, 2013-08-01 at 22:33 +0200, Jan Kara wrote:
> > > > > >   Hi,
> > > > > > 
> > > > > > On Thu 01-08-13 13:14:19, Davidlohr Bueso wrote:
> > > > > > > FYI I'm seeing loads of the following messages with Linus' latest
> > > > > > > 3.11-rc3 (which includes 822dbba33458cd6ad)
> > > > > >   Thanks for notice. I see you are running reaim to trigger this. What
> > > > > > workload?
> > > > > 
> > > > > After re-running the workloads one by one, I finally hit the issue again
> > > > > with 'dbase'. FWIW I'm using ramdisks + ext4.
> > > >   Hum, I'm not able to reproduce this with current Linus' kernel - commit
> > > > e4ef108fcde0b97ed38923ba1ea06c7a152bab9e - I've tried with ramdisk but no
> > > > luck. Are you using some special mount options?
> > > > 
> > > 
> > > I just hit the issue again with today's latest pull, 3.11-rc4 (which has
> > > e4ef108fcde0b97ed38923ba1ea06c7a152bab9e as of yesterday). I create the
> > > fs with "-b 4096 -J size=4", and mount it with
> > > "journal_async_commit,nobarrier,async,noatime,nodiratime"
> >   Still no success :(.
> > 
> > > I cannot really think of any additional info I can give you, but if you
> > > think of something else just shout :)
> >   Maybe what's your reaim.config? And what is fs size and machine config?
> 
> The machine is an 8 socket, 80 core, 256Gb RAM, HP DL980 server. No
> special storage being used. Attached is the reaim.config and
> workfile.dbase files.
  This is curious. I was trying really hard even on a similar machine
(well, about half of your size) but no luck with reproducing the warning
you see. OTOH I was getting a *flood* of warnings from
ext4_da_update_reserve_space() - I've fixed that up and posted patch to
linux-ext4 (ext4: Fix warning in ext4_da_update_reserve_space()).

								Honza
> 
> Thanks,
> Davidlohr
> 
> > 
> > 								Honza
> > 
> > 
> > > > > > > ------------[ cut here ]------------
> > > > > > > WARNING: CPU: 26 PID: 93793 at fs/ext4/inode.c:230 ext4_evict_inode+0x4c9/0x500 [ext4]()
> > > > > > > Modules linked in: autofs4 cpufreq_ondemand freq_table sunrpc 8021q garp stp llc pcc_cpufreq ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log dm_mod uinput iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode pcspkr sg lpc_ich mfd_core hpilo hpwdt i7core_edac edac_core netxen_nic mperf ext4 jbd2 mbcache sd_mod crc_t10dif aesni_intel ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: freq_table]
> > > > > > > CPU: 26 PID: 93793 Comm: reaim Tainted: G        W    3.11.0-rc3+ #1
> > > > > > > Hardware name: HP ProLiant DL980 G7, BIOS P66 06/24/2011
> > > > > > >  00000000000000e6 ffff8985db603d78 ffffffff8153ce4d 00000000000000e6
> > > > > > >  0000000000000000 ffff8985db603db8 ffffffff8104cf1c ffff8985db603dc8
> > > > > > >  ffff8b05c485b8b0 ffff8b05c485b9b8 ffff8b05c485b800 00000000ffffff9c
> > > > > > > Call Trace:
> > > > > > >  [<ffffffff8153ce4d>] dump_stack+0x49/0x5c
> > > > > > >  [<ffffffff8104cf1c>] warn_slowpath_common+0x8c/0xc0
> > > > > > >  [<ffffffff8104cf6a>] warn_slowpath_null+0x1a/0x20
> > > > > > >  [<ffffffffa02a0179>] ext4_evict_inode+0x4c9/0x500 [ext4]
> > > > > > >  [<ffffffff811915e7>] evict+0xa7/0x1c0
> > > > > > >  [<ffffffff811917e3>] iput_final+0xe3/0x170
> > > > > > >  [<ffffffff811918ae>] iput+0x3e/0x50
> > > > > > >  [<ffffffff81187aa6>] do_unlinkat+0x1c6/0x280
> > > > > > >  [<ffffffff8106f3e4>] ? task_work_run+0x94/0xf0
> > > > > > >  [<ffffffff81003a44>] ? do_notify_resume+0x84/0x90
> > > > > > >  [<ffffffff81187b76>] SyS_unlink+0x16/0x20
> > > > > > >  [<ffffffff81549a02>] system_call_fastpath+0x16/0x1b
> > > > > > > ---[ end trace 15e812809616488b ]---
> > > > > > > 
> > > > > > > 
> > > > > 
> > > > > 
> > > 
> > > 
> 

> # Sample configuration file for the reaim workload
> # cliff white, OSDL 4/2003
> #
> # This is a comment (duh)
> # all variables are named in UPPER CASE, unless you want
> # to write a better option parser. Send me a patch
> # I'm keeping this, but not used yet
> #
> # The disk tests in the AIM-7 test consist of three groups:
> # basic block I/O tests, the same tests with an added sync,
> # and the sync I/O tests. Each test determines file size from a
> # global variable, disk_iteration_count.
> # 
> # There are two configuration variables that control this,
> # FILESIZE and POOLSIZE  (specified in kilobytes or megabytes).
> # If POOLSIZE is zero, each child will write or read a total of
> # FILESIZE bytes. If POOLSIZE is non-zero, child file size is
> # equal to FILESIZE + (POOLSIZE/number_of_children). Thus when
> # POOLSIZE is non-zero, I/O per child will be reduced on each
> # increase in child count.
> # 
> # For example, specifying a FILESIZE of 10K and a POOLSIZE of
> # 100K will result in a single child creating a 110K byte file
> # on each disk device listed. Two children will create a 60K
> # file, etc. 24 children will create a 14K file, consuming
> # 328KB per disk device.
> #
> # The file and poolsize values can be specified here, or
> # in the workfile. Values in the workfile will over write
> # these values
> FILESIZE 10k
> POOLSIZE 1m
> # 
> # A list of disk directories for the exerciser
> # DISKDIR /tmp/diskdir
> # To control number of users
> # STARTUSERS 2
> # ENDUSERS 3
> # and to control the count
> # INCREMENT 2
> # Number of jobs per child
> # JOBS 20
> # All switch options will use '1' for on, anything else for off
> # Extra output
> # VERBOSE 1
> # Switch for the crossover
> # CROSSOVER 1
> # Switch for STP-style results file
> # BRIEF 1
> DISKDIR /t0
> DISKDIR /t1
> DISKDIR /t2
> DISKDIR /t3
> DISKDIR /t4
> DISKDIR /t5
> DISKDIR /t6
> DISKDIR /t7
> DISKDIR /t8
> DISKDIR /t9
> DISKDIR /t10
> DISKDIR /t11
> DISKDIR /t12
> DISKDIR /t13
> DISKDIR /t14
> DISKDIR /t15

> # @(#) workfile.dbase:1.3 1/22/96 00:00:00
> # Large Database Mix
> # Unchanged from AIM
> # Total Hits: 550
> # Hits with 100% user time: 120 ( 21.8 % )
> # FILESIZE: 1M
> # POOLSIZE: 25M
> # Filesize controlled by reaim.config now - uncomment to over-ride
> 20  add_int
> 20  add_long
> 20  add_short
> 40  disk_rd
> 40  disk_rr
> 10  div_int
> 10  div_long
> 10  div_short
> 10  jmp_test
> 40  mem_rtns_1
> 40  mem_rtns_2
> 10  mul_int
> 10  mul_long
> 10  mul_short
> 40  page_test
> 20  ram_copy
> 40  shared_memory
> 30  sieve
> 30  sort_rtns_1
> 10  stream_pipe
> 30  string_rtns
> 30  sync_disk_rw
> 30  sync_disk_update
> # Calculated percentages
> #Hits           Name            Percent of total
> #20		add_int	 	3.64
> #20		add_long	3.64
> #20		add_short	3.64
> #40		disk_rd	 	7.27
> #40		disk_rr	 	7.27
> #10		div_int	 	1.82
> #10		div_long	1.82
> #10		div_short	1.82
> #10		jmp_test	1.82
> #40		mem_rtns_1	7.27
> #40		mem_rtns_2	7.27
> #10		mul_int	 	1.82
> #10		mul_long	1.82
> #10		mul_short	1.82
> #40		page_test	7.27
> #20		ram_copy	3.64
> #40		shared_memory	7.27
> #30		sieve	 	5.45
> #30		sort_rtns_1	5.45
> #10		stream_pipe	1.82
> #30		string_rtns	5.45
> #30		sync_disk_rw	5.45
> #30		sync_disk_update	5.45

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

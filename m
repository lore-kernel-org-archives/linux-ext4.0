Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77DB22D4E9
	for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2026 03:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786938012; cv=none; b=c8j43j9UgKZjRWhWpOZH0HpebUbR8P4IpxNmHW2EDqHsCA3q59A5QryEbyneBhsPt5mt7nO5v79qUIA0KV6d7JdR31GKqnsXg6MFOekVDOrda+T5deufm57BCxxaxbAO+6MqyNx32IQHFDpC6oS7ISMupFYLKysUgaY1BKjbsF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786938012; c=relaxed/simple;
	bh=iS+z8tCpooQ3mZwqxYr7pICQ4pnhZLFrfaEuvSxXwXg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=QyOBBdbcFmEgi2SQjrBcdfb7gVXI8lmXOtEgXIKhLLENoxrVI4xXXHiVoaZNyQvNfDG+YKU5hPpt7zyx4CB52SewNdKmKdGMCEOOE35TfjJHa63rIE4VFAo868pkmo2TlPk5x1be2RZvGKWHPn/Lup3m76Taovq7S8RVj/IY1Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PfbEsZNP; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PfbEsZNP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786938010; x=1818474010;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=iS+z8tCpooQ3mZwqxYr7pICQ4pnhZLFrfaEuvSxXwXg=;
  b=PfbEsZNPziq+rOsWUkM/R6vkZzM3+YAARb+xF9Rk+gC3KmSc43yJuwX/
   u+ypnOv/gwPBa6vRLtP0loLLZ3TSG5YF45RZWJS5ea5kabJQe23I/JjNc
   zAqA0dSXLWi+le5xF+Ntq9oeW1kvdItTNSUJ5P4UmOJ3tspBo6HjV9sTW
   uLLE9OMeOrlWmsXcx4Nh1J1uT1bmP0VOUSNOPrbVJIV5gGyKOTMhWU46l
   e5+MHuuviPejGuTZnkjoPBol37BPr35AIqkKrAS8JABEQ68Tbfc2aXQQn
   nl4T5ejEEcX/MYrs9kSY24zDQfnNRZwPGrHBIb08R7sDWZS3gCL2GFR2/
   w==;
X-CSE-ConnectionGUID: WwRvpo6TQhycMGC5a4XCvg==
X-CSE-MsgGUID: WFxooPj2Q2qKGY/Nu2/vAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11877"; a="87425807"
X-IronPort-AV: E=Sophos;i="6.25,228,1779174000"; 
   d="scan'208";a="87425807"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2026 20:40:09 -0700
X-CSE-ConnectionGUID: EV8Ik6P7RQKYyBkaO/YTeg==
X-CSE-MsgGUID: a4lYM1uORWG/uWkiF3OD8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,228,1779174000"; 
   d="scan'208";a="303024196"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2026 20:40:08 -0700
Date: Mon, 17 Aug 2026 11:40:04 +0800
From: kernel test robot <yi1.lai@intel.com>
To: shuo chen <1289151713@qq.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-ext4@vger.kernel.org,
	tytso@mit.edu, jack@suse.com, yi1.lai@intel.com
Subject: Re: [RESEND PATCH] jbd2:remove unnecessary finish_wait call in
 jbd2_journal_wait_updates
Message-ID: <202608170527.19fb56ff-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_AA7E2FDA8D68E1E3430F219A8C3DAB442508@qq.com>


Hello,

kernel test robot noticed "INFO:task_blocked_for_more_than#seconds" on:

commit: 2a8eec86fbe20e3599766fd1c3d97949e577dd83 ("[RESEND PATCH] jbd2:remove unnecessary finish_wait call in jbd2_journal_wait_updates")
url: https://github.com/intel-lab-lkp/linux/commits/shuo-chen/jbd2-remove-unnecessary-finish_wait-call-in-jbd2_journal_wait_updates/20260806-124301
base: https://git.kernel.org/cgit/linux/kernel/git/vfs/vfs.git vfs.all patch
link: https://lore.kernel.org/all/tencent_AA7E2FDA8D68E1E3430F219A8C3DAB442508@qq.com/
patch subject: [RESEND PATCH] jbd2:remove unnecessary finish_wait call in jbd2_journal_wait_updates

in testcase: stress-ng
version: stress-ng-x86_64-f179fd9c6-1_20260812
with following parameters:

	nr_threads: 100%
	disk: 1SSD
	testtime: 60s
	fs: ext4
	test: chown
	cpufreq_governor: performance



config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 224 threads 2 sockets Intel(R) Xeon(R) (Sapphire Rapids) with 128G memory

If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202608170527.19fb56ff-lkp@intel.com


kern  :err   : [  991.254044] [   T1509] INFO: task jbd2/sdb3-8:12832 blocked for more than 491 seconds.
kern  :err   : [  991.262978] [   T1509]       Tainted: G S                  7.2.0-rc5+ #1
kern  :err   : [  991.270278] [   T1509] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kern  :info  : [  991.279925] [   T1509] task:jbd2/sdb3-8     state:D stack:0     pid:12832 tgid:12832 ppid:2      task_flags:0x240040 flags:0x00080000
kern  :info  : [  991.293161] [   T1509] Call Trace:
kern  :info  : [  991.296770] [   T1509]  <TASK>
kern  :info  : [  991.299998] [   T1509]  __schedule (sched/core.c:5510 sched/core.c:7234)
kern  :info  : [  991.304788] [   T1509]  schedule (sched/core.c:7311 sched/core.c:7326)
kern  :info  : [  991.309189] [   T1509] jbd2_journal_wait_updates (jbd2/transaction.c:841) jbd2
kern  :info  : [  991.315913] [   T1509]  ? __pfx_autoremove_wake_function (sched/wait_bit.c:161)
kern  :info  : [  991.322656] [   T1509] jbd2_journal_commit_transaction (jbd2/commit.c:482) jbd2
kern  :info  : [  991.330273] [   T1509]  ? raw_spin_rq_lock_nested (sched/core.c:667)
kern  :info  : [  991.336306] [   T1509]  ? finish_task_switch+0xc7/0x3f0
kern  :info  : [  991.342642] [   T1509]  ? __try_to_del_timer_sync (time/timer.c:1467)
kern  :info  : [  991.348674] [   T1509] kjournald2 (jbd2/journal.c:199) jbd2
kern  :info  : [  991.354057] [   T1509]  ? __pfx_autoremove_wake_function (sched/wait_bit.c:161)
kern  :info  : [  991.360786] [   T1509]  ? __pfx_kjournald2 (jbd2/journal.c:893) jbd2
kern  :info  : [  991.366824] [   T1509]  kthread (kthread.c:436)
kern  :info  : [  991.371220] [   T1509]  ? __pfx_kthread (kthread.c:948)
kern  :info  : [  991.376297] [   T1509]  ret_from_fork (x86/kernel/process.c:158)
kern  :info  : [  991.381361] [   T1509]  ? __pfx_kthread (kthread.c:948)
kern  :info  : [  991.386433] [   T1509]  ret_from_fork_asm (x86/entry/entry_64.S:245)
kern  :info  : [  991.391693] [   T1509]  </TASK>
kern  :err   : [  991.395061] [   T1509] INFO: task stress-ng-chown:16436 blocked for more than 491 seconds.
kern  :err   : [  991.404133] [   T1509]       Tainted: G S                  7.2.0-rc5+ #1
kern  :err   : [  991.411439] [   T1509] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kern  :info  : [  991.421059] [   T1509] task:stress-ng-chown state:D stack:0     pid:16436 tgid:16436 ppid:16132  task_flags:0x400040 flags:0x00080002
kern  :info  : [  991.434286] [   T1509] Call Trace:
kern  :info  : [  991.437906] [   T1509]  <TASK>
kern  :info  : [  991.441137] [   T1509]  __schedule (sched/core.c:5510 sched/core.c:7234)
kern  :info  : [  991.445922] [   T1509]  schedule (sched/core.c:7311 sched/core.c:7326)
kern  :info  : [  991.450307] [   T1509] wait_transaction_locked (jbd2.mod.c:?) jbd2
kern  :info  : [  991.456838] [   T1509]  ? __pfx_autoremove_wake_function (sched/wait_bit.c:161)
kern  :info  : [  991.463570] [   T1509] add_transaction_credits (jbd2.mod.c:?) jbd2
kern  :info  : [  991.470288] [   T1509]  ? wake_up_q (sched/core.c:4547 sched/core.c:1173)
kern  :info  : [  991.474954] [   T1509] start_this_handle (jbd2/transaction.c:403) jbd2
kern  :info  : [  991.481011] [   T1509]  ? kmem_cache_alloc_noprof (slub.c:4594 (discriminator 3) slub.c:4917 (discriminator 3) slub.c:4931 (discriminator 3))
kern  :info  : [  991.487246] [   T1509]  ? jbd2__journal_start (jbd2/transaction.c:457 (discriminator 2) jbd2/transaction.c:485 (discriminator 2)) jbd2
kern  :info  : [  991.493688] [   T1509] jbd2__journal_start (jbd2/transaction.c:502) jbd2
kern  :info  : [  991.499924] [   T1509] ext4_dirty_inode (ext4/ext4_jbd2.h:242 ext4/inode.c:6674) ext4
kern  :info  : [  991.505839] [   T1509]  __mark_inode_dirty (fs-writeback.c:2729)
kern  :info  : [  991.511289] [   T1509] ext4_setattr (linux/fs.h:2207 ext4/inode.c:6181) ext4
kern  :info  : [  991.516964] [   T1509]  notify_change (attr.c:556)
kern  :info  : [  991.522317] [   T1509]  ? chown_common (open.c:825)
kern  :info  : [  991.527693] [   T1509]  chown_common (open.c:825)
kern  :info  : [  991.532861] [   T1509]  ? up_write (locking/rwsem.c:1420 locking/rwsem.c:1688)
kern  :info  : [  991.537610] [   T1509]  vfs_fchown (open.c:890 open.c:882)
kern  :info  : [  991.542295] [   T1509]  __x64_sys_fchown (open.c:902 open.c:907 open.c:905 open.c:905)
kern  :info  : [  991.547590] [   T1509]  do_syscall_64 (x86/entry/syscall_64.c:63 x86/entry/syscall_64.c:94)
kern  :info  : [  991.552692] [   T1509]  ? __x64_sys_fchown (open.c:902 open.c:907 open.c:905 open.c:905)
kern  :info  : [  991.558159] [   T1509]  ? do_syscall_64 (linux/irq-entry-common.h:210 linux/irq-entry-common.h:230 linux/entry-common.h:318 x86/entry/syscall_64.c:100)
kern  :info  : [  991.563523] [   T1509]  ? __x64_sys_lchown (open.c:878 open.c:876 open.c:876)
kern  :info  : [  991.568989] [   T1509]  ? do_syscall_64 (linux/irq-entry-common.h:210 linux/irq-entry-common.h:230 linux/entry-common.h:318 x86/entry/syscall_64.c:100)
kern  :info  : [  991.574349] [   T1509]  ? do_syscall_64 (linux/irq-entry-common.h:210 linux/irq-entry-common.h:230 linux/entry-common.h:318 x86/entry/syscall_64.c:100)
kern  :info  : [  991.579732] [   T1509]  ? do_syscall_64 (linux/randomize_kstack.h:57 x86/entry/syscall_64.c:92)
kern  :info  : [  991.584966] [   T1509]  entry_SYSCALL_64_after_hwframe (x86/entry/entry_64.S:121)
kern  :info  : [  991.591591] [   T1509] RIP: 0033:0x7f0b50646e17
kern  :info  : [  991.596546] [   T1509] RSP: 002b:00007ffea1566b48 EFLAGS: 00000213 ORIG_RAX: 000000000000005d
kern  :info  : [  991.605988] [   T1509] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007f0b50646e17
kern  :info  : [  991.614943] [   T1509] RDX: 00000000ffffffff RSI: 00000000ffffffff RDI: 0000000000000005
kern  :info  : [  991.623876] [   T1509] RBP: 00007f0b4fcb99c8 R08: 0000000000000000 R09: 0000000000000000
kern  :info  : [  991.632818] [   T1509] R10: 0000000000000000 R11: 0000000000000213 R12: 00007ffea1566b70
kern  :info  : [  991.641767] [   T1509] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000017
kern  :info  : [  991.650731] [   T1509]  </TASK>
kern  :err   : [  991.654143] [   T1509] INFO: task stress-ng-chown:16453 blocked for more than 491 seconds.
kern  :err   : [  991.663280] [   T1509]       Tainted: G S                  7.2.0-rc5+ #1
kern  :err   : [  991.670694] [   T1509] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kern  :info  : [  991.680398] [   T1509] task:stress-ng-chown state:D stack:0     pid:16453 tgid:16453 ppid:16132  task_flags:0x400040 flags:0x00080002
kern  :info  : [  991.693833] [   T1509] Call Trace:
kern  :info  : [  991.697539] [   T1509]  <TASK>
kern  :info  : [  991.700842] [   T1509]  __schedule (sched/core.c:5510 sched/core.c:7234)
kern  :info  : [  991.705722] [   T1509]  schedule (sched/core.c:7311 sched/core.c:7326)
kern  :info  : [  991.710195] [   T1509] jbd2_log_wait_commit (jbd2/journal.c:681 (discriminator 7)) jbd2
kern  :info  : [  991.716623] [   T1509]  ? __pfx_autoremove_wake_function (sched/wait_bit.c:161)
kern  :info  : [  991.723421] [   T1509] ext4_sync_file (ext4/fsync.c:114 ext4/fsync.c:162) ext4
kern  :info  : [  991.729378] [   T1509]  do_fsync (sync.c:186 sync.c:200 sync.c:211)
kern  :info  : [  991.733854] [   T1509]  __x64_sys_fsync (sync.c:216 sync.c:214 sync.c:214)
kern  :info  : [  991.739008] [   T1509]  do_syscall_64 (x86/entry/syscall_64.c:63 x86/entry/syscall_64.c:94)
kern  :info  : [  991.744074] [   T1509]  ? __x64_sys_lchown (open.c:878 open.c:876 open.c:876)
kern  :info  : [  991.749490] [   T1509]  ? do_syscall_64 (linux/irq-entry-common.h:210 linux/irq-entry-common.h:230 linux/entry-common.h:318 x86/entry/syscall_64.c:100)
kern  :info  : [  991.754832] [   T1509]  ? do_syscall_64 (linux/randomize_kstack.h:57 x86/entry/syscall_64.c:92)
kern  :info  : [  991.760066] [   T1509]  entry_SYSCALL_64_after_hwframe (x86/entry/entry_64.S:121)
kern  :info  : [  991.766655] [   T1509] RIP: 0033:0x7f0b505d6687
kern  :info  : [  991.771614] [   T1509] RSP: 002b:00007ffea1566b00 EFLAGS: 00000202 ORIG_RAX: 000000000000004a
kern  :info  : [  991.781039] [   T1509] RAX: ffffffffffffffda RBX: 00007f0b4fd31b00 RCX: 00007f0b505d6687
kern  :info  : [  991.789965] [   T1509] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
kern  :info  : [  991.798875] [   T1509] RBP: 00007f0b4fcc9268 R08: 0000000000000000 R09: 0000000000000000
kern  :info  : [  991.807820] [   T1509] R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffea1566b70
kern  :info  : [  991.816762] [   T1509] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
kern  :info  : [  991.825727] [   T1509]  </TASK>
kern  :info  : [ 2465.958258] [   T1509] Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260817/202608170527.19fb56ff-lkp@intel.com



--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



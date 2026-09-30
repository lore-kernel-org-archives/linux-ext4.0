Received: from mx1.heh.ee (heh.ee [213.35.143.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4014152121D
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2026 21:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.35.143.160
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804132; cv=none; b=qkIUGPSAl4c9fPEsl/loVSXLqoHFa3t/IyhdD/EMddFXv6Hoog8IAK61DThP3U7xWRONHN8sFIiV9rDgBlRIgAmJ6EZ607ATqTqI8CHBpdBgrt4rHrffhJPKtPOxvaHePc2JslmsEYOcA/WG1mDvvn+tGhFEZaEYBdvmmHfj9Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804132; c=relaxed/simple;
	bh=7Z09zRfDjIjWv3dnqgfR0ujvnwUIYFkziwsslnhkQHg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=Uztk2n0geSX6M+EAaeyzBOSWX23zq15LC2N+pWNR+Q/4tJL13A5hE3FoybWrq4QtQEZCuGG9anmADvIWutVNRUgRvuLhZ32tOmWx9lmLuf7lZJIKvsIR2XbfN0i6oTio9OccPqgxlxzXD1xsbLO4K+aYWsc5pJIdoHvHkyuceGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ristioja.ee; spf=pass smtp.mailfrom=ristioja.ee; dkim=pass (1024-bit key) header.d=ristioja.ee header.i=@ristioja.ee header.b=muZiBD8T; arc=none smtp.client-ip=213.35.143.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ristioja.ee
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ristioja.ee
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ristioja.ee header.i=@ristioja.ee header.b="muZiBD8T"
Received: by mx1.heh.ee (Hehee) id 217B011291F
	for <linux-ext4@vger.kernel.org>; Thu, 01 Oct 2026 00:28:50 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=ristioja.ee; s=mail;
	t=1790803730; bh=7Z09zRfDjIjWv3dnqgfR0ujvnwUIYFkziwsslnhkQHg=;
	h=Date:From:Subject:To;
	b=muZiBD8TUpuei9GEddBxp+u1Ql3r2wvu6FcMXbSPkgRNaGCQ3l+xA6SIVMp9fcgeR
	 aj0nlpVLeUhE9p2zJOfmYCxPtHy8cLfbetraF3C8Fj/0PXnydt+V7CIWp3hn0YnQ+j
	 k4aFWKOLTZenwE8D1jRBjklx3ChboHu7ox09eFyQ=
Message-ID: <592d8c4d-67de-4e9b-89c2-35e580dea24e@ristioja.ee>
Date: Thu, 1 Oct 2026 00:29:18 +0300
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jaak Ristioja <jaak@ristioja.ee>
Subject: [BUG] ext4/jbd2: suspected deadlock under I/O load with data=journal
To: linux-ext4@vger.kernel.org
Content-Language: et-EE
Autocrypt: addr=jaak@ristioja.ee; keydata=
 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
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I'm struggling with what appears to be an EXT4/JBD2 deadlock on a
Gentoo Linux home server acting as a VM host. The issue is highly
reproducible and occurs more frequently under CPU and I/O loads, such as
compilation inside VMs or rsnapshot of LVM snapshots. Increasing numbers
of tasks become stuck in D state and the host eventually becomes
unusable.

Kernel log from 7.2.8 with JBD2 debugging enabled, with nvme0n1p3
containing the root filesystem mounted with data=journal:

[  308.166362] fs/jbd2/checkpoint.c: (jbd2_log_do_checkpoint, 162): 
Start checkpoint
[  308.166369] fs/jbd2/checkpoint.c: (jbd2_log_do_checkpoint, 171): 
cleanup_journal_tail returned 1
[  308.166372] fs/jbd2/journal.c: (jbd2_log_wait_commit, 677): JBD2: 
want 3470957, j_commit_sequence=3470956
[  308.410791] fs/jbd2/revoke.c: (jbd2_journal_write_revoke_records, 
565): Wrote 0 revoke records
[  308.475177] fs/jbd2/commit.c: (jbd2_journal_commit_transaction, 
1152): JBD2: commit 3470957 complete, head 3470955
[  308.475195] fs/jbd2/journal.c: (kjournald2, 192): 
commit_sequence=3470957, commit_request=3470957
[  308.556081] fs/jbd2/checkpoint.c: (__jbd2_journal_drop_transaction, 
730): Dropping transaction 3470955, all done
[  308.557017] fs/jbd2/journal.c: (jbd2_journal_update_sb_log_tail, 
1864): JBD2: updating superblock (start 49947, seq 3470956)
[  308.561334] fs/jbd2/journal.c: (__jbd2_update_log_tail, 1077): 
Cleaning journal tail from 3470955 to 3470956 (offset 49947), freeing 21736
[  308.837338] fs/jbd2/journal.c: (__jbd2_log_start_commit, 462): JBD2: 
requesting commit 3470958/3470957
[  308.837365] fs/jbd2/journal.c: (kjournald2, 234): kjournald2 wakes
[  308.837373] fs/jbd2/journal.c: (kjournald2, 192): 
commit_sequence=3470957, commit_request=3470958
[  308.837376] fs/jbd2/journal.c: (kjournald2, 196): OK, requests differ
[  308.837379] fs/jbd2/commit.c: (jbd2_journal_commit_transaction, 462): 
JBD2: starting commit of transaction 3470958
[  308.850419] fs/jbd2/transaction.c: (jbd2__journal_restart, 780): 
restarting handle 0000000081e858e4
[  308.850467] fs/jbd2/checkpoint.c: (jbd2_log_do_checkpoint, 162): 
Start checkpoint
[  308.850473] fs/jbd2/checkpoint.c: (jbd2_log_do_checkpoint, 171): 
cleanup_journal_tail returned 1
[  308.850487] fs/jbd2/journal.c: (jbd2_log_wait_commit, 677): JBD2: 
want 3470958, j_commit_sequence=3470957
[  308.850490] fs/jbd2/checkpoint.c: (jbd2_log_do_checkpoint, 162): 
Start checkpoint
[  308.850495] fs/jbd2/checkpoint.c: (jbd2_log_do_checkpoint, 171): 
cleanup_journal_tail returned 1
[  308.850498] fs/jbd2/journal.c: (jbd2_log_wait_commit, 677): JBD2: 
want 3470958, j_commit_sequence=3470957
[  308.850500] fs/jbd2/checkpoint.c: (jbd2_log_do_checkpoint, 162): 
Start checkpoint
[  308.850504] fs/jbd2/checkpoint.c: (jbd2_log_do_checkpoint, 171): 
cleanup_journal_tail returned 1
[  308.850508] fs/jbd2/journal.c: (jbd2_log_wait_commit, 677): JBD2: 
want 3470958, j_commit_sequence=3470957
[  308.850512] fs/jbd2/checkpoint.c: (jbd2_log_do_checkpoint, 162): 
Start checkpoint
[  308.850521] fs/jbd2/checkpoint.c: (jbd2_log_do_checkpoint, 171): 
cleanup_journal_tail returned 1
[  308.850525] fs/jbd2/journal.c: (jbd2_log_wait_commit, 677): JBD2: 
want 3470958, j_commit_sequence=3470957
[  308.850529] fs/jbd2/checkpoint.c: (jbd2_log_do_checkpoint, 162): 
Start checkpoint
[  308.850538] fs/jbd2/checkpoint.c: (jbd2_log_do_checkpoint, 171): 
cleanup_journal_tail returned 1
[  308.850542] fs/jbd2/journal.c: (jbd2_log_wait_commit, 677): JBD2: 
want 3470958, j_commit_sequence=3470957
[  308.850547] fs/jbd2/checkpoint.c: (jbd2_log_do_checkpoint, 162): 
Start checkpoint
[  308.850557] fs/jbd2/checkpoint.c: (jbd2_log_do_checkpoint, 171): 
cleanup_journal_tail returned 1
[  308.850562] fs/jbd2/journal.c: (jbd2_log_wait_commit, 677): JBD2: 
want 3470958, j_commit_sequence=3470957
[  312.254056] fs/jbd2/checkpoint.c: (jbd2_log_do_checkpoint, 162): 
Start checkpoint
[  312.254067] fs/jbd2/checkpoint.c: (jbd2_log_do_checkpoint, 171): 
cleanup_journal_tail returned 1
[  312.254070] fs/jbd2/journal.c: (jbd2_log_wait_commit, 677): JBD2: 
want 3470958, j_commit_sequence=3470957
[  322.160918] fs/jbd2/checkpoint.c: (jbd2_log_do_checkpoint, 162): 
Start checkpoint
[  322.161417] fs/jbd2/checkpoint.c: (jbd2_log_do_checkpoint, 171): 
cleanup_journal_tail returned 1
[  322.161427] fs/jbd2/journal.c: (jbd2_log_wait_commit, 677): JBD2: 
want 3470958, j_commit_sequence=3470957
[  341.842808] workqueue: gc_worker hogged CPU for >10000us 19 times, 
consider switching to WQ_UNBOUND
[  493.371699] INFO: task kworker/u129:3:220 blocked for more than 122 
seconds.
[  493.371706]       Tainted: G                T   7.2.8-gentoo-prayer #3
[  493.371708] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  493.371709] task:kworker/u129:3  state:D stack:0     pid:220 tgid:220 
   ppid:2      task_flags:0x4248060 flags:0x00080000
[  493.371715] Workqueue: writeback wb_workfn (flush-259:0)
[  493.371723] Call Trace:
[  493.371724]  <TASK>
[  493.371726]  __schedule+0x468/0x1780
[  493.371731]  ? lock_acquire+0xcf/0x310
[  493.371734]  ? find_held_lock+0x2b/0x90
[  493.371737]  schedule+0x35/0x110
[  493.371739]  jbd2_log_wait_commit+0x169/0x220
[  493.371743]  ? wake_up_bit+0xe0/0xe0
[  493.371745]  jbd2_log_do_checkpoint+0x39d/0x3d0
[  493.371749]  __jbd2_log_wait_for_space+0x81/0x1d0
[  493.371752]  add_transaction_credits+0x42c/0x440
[  493.371754]  ? add_transaction_credits+0x247/0x440
[  493.371757]  start_this_handle+0x127/0x5d0
[  493.371759]  jbd2__journal_restart+0x101/0x240
[  493.371762]  mpage_prepare_extent_to_map+0x1c9/0x510
[  493.371765]  ext4_do_writepages+0x419/0x1130
[  493.371768]  ? ext4_writepages+0xf4/0x2a0
[  493.371769]  ext4_writepages+0xf4/0x2a0
[  493.371771]  do_writepages+0xd4/0x180
[  493.371774]  __writeback_single_inode+0x55/0x5b0
[  493.371777]  writeback_sb_inodes+0x270/0x840
[  493.371779]  __writeback_inodes_wb+0x47/0xf0
[  493.371781]  wb_writeback+0x3ca/0x460
[  493.371783]  wb_workfn+0x3a4/0x590
[  493.371785]  process_one_work+0x232/0x5f0
[  493.371788]  worker_thread+0x1e3/0x3f0
[  493.371790]  ? rescuer_thread+0x5e0/0x5e0
[  493.371792]  kthread+0xe7/0x120
[  493.371795]  ? kthread_affine_node+0x120/0x120
[  493.371796]  ret_from_fork+0x290/0x300
[  493.371799]  ? kthread_affine_node+0x120/0x120
[  493.371801]  ? kthread_affine_node+0x120/0x120
[  493.371803]  ret_from_fork_asm+0x11/0x20
[  493.371806]  </TASK>
[  493.371811] INFO: task jbd2/nvme0n1p3-:661 blocked in I/O wait for 
more than 122 seconds.
[  493.371812]       Tainted: G                T   7.2.8-gentoo-prayer #3
[  493.371814] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  493.371815] task:jbd2/nvme0n1p3- state:D stack:0     pid:661 tgid:661 
   ppid:2      task_flags:0x240040 flags:0x00080000
[  493.371818] Call Trace:
[  493.371819]  <TASK>
[  493.371820]  __schedule+0x468/0x1780
[  493.371822]  ? lock_acquire+0xcf/0x310
[  493.371823]  ? find_held_lock+0x2b/0x90
[  493.371825]  schedule+0x35/0x110
[  493.371827]  io_schedule+0x3e/0x60
[  493.371829]  folio_wait_bit_common+0x131/0x320
[  493.371832]  ? filemap_invalidate_unlock_two+0x60/0x60
[  493.371834]  folio_wait_writeback+0x25/0xe0
[  493.371836]  writeback_iter+0xcf/0x340
[  493.371838]  ext4_journalled_submit_inode_data_buffers+0x9e/0x130
[  493.371842]  jbd2_journal_commit_transaction+0x526/0x1df0
[  493.371845]  ? lock_timer_base+0x6b/0x90
[  493.371848]  ? jbd2_write_superblock+0x1f0/0x1f0
[  493.371850]  ? kjournald2+0xd5/0x370
[  493.371852]  ? jbd2_write_superblock+0x1f0/0x1f0
[  493.371854]  kjournald2+0xd5/0x370
[  493.371856]  ? wake_up_bit+0xe0/0xe0
[  493.371857]  ? jbd2_write_superblock+0x1f0/0x1f0
[  493.371859]  kthread+0xe7/0x120
[  493.371861]  ? kthread_affine_node+0x120/0x120
[  493.371863]  ret_from_fork+0x290/0x300
[  493.371865]  ? kthread_affine_node+0x120/0x120
[  493.371866]  ? kthread_affine_node+0x120/0x120
[  493.371868]  ret_from_fork_asm+0x11/0x20
[  493.371870]  </TASK>
...

I'm no expert on the kernel internals, but I suspect this shows the
writeback worker waiting in __jbd2_log_wait_for_space() for JBD2 to to
make journal space available, while the journal thread is itself waiting
in folio_wait_writeback() for filesystem writeback to complete. This
looks like a circular wait for me, although I may be misunderstanding
the interaction between these paths.

I initially experienced this on an older Intel system, and suspected a
chipset/hardware problem as it produced DMAR and ATA host-bus errors
before the hung-task messages. During recovery I verified that the
drives appeared healthy, e2fscked the filesystems, and moved the drives
(1 x NVMe, 1 x SATA) to a modern AMD system.

On AMD I no longer see kernel messages suggesting hardware problems, but
the hangs continue, typically every 1-2 hourse, with similar call
traces. This makes me think that the hardware error messages might have
been a strange side-effect.

My next suspicion was that this might have been a regression from a
kernel upgrade, but downgrading from 7.2.8 to previously used kernels
(7.2.7, 6.18.22 and 6.18.54) did not resolve the issue; all exhibited
similar hangs.

I have additional logs and debugging information available and can
provide them if useful.

In the meantime, are there any known workarounds I could try to avoid or
mitigate the hangs? In particular, would changing the EXT4 data mode
from data=journal to the default data=ordered be expected to avoid this
particular interaction, or are there other mount or kernel options that
would be useful to try?

Thanks for any insight or suggestions.


Best regards,
Jaak Ristioja

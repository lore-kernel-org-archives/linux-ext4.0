From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] jbd2: fix race between
 jbd2_journal_remove_checkpoint and ->j_commit_callback V2
Date: Wed, 27 Mar 2013 15:32:37 +0100
Message-ID: <20130327143237.GA1771@quack.suse.cz>
References: <20130327025624.GA5861@thunk.org>
 <1364376164-31701-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52001 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab3C0Ocm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 10:32:42 -0400
Content-Disposition: inline
In-Reply-To: <1364376164-31701-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 27-03-13 13:22:42, Dmitry Monakhov wrote:
> Following race is possible
> [kjournald2]                              other_task
> jbd2_journal_commit_transaction()
>   j_state = T_FINISHED;
>   spin_unlock(&journal->j_list_lock);
>                                          ->jbd2_journal_remove_checkpoint()
> 					   ->jbd2_journal_free_transaction();
> 					     ->kmem_cache_free(transaction)
>   ->j_commit_callback(journal, transaction);
>     -> USE_AFTER_FREE
> 
> WARNING: at lib/list_debug.c:62 __list_del_entry+0x1c0/0x250()
> Hardware name:
> list_del corruption. prev->next should be ffff88019a4ec198, but was 6b6b6b6b6b6b6b6b
> Modules linked in: cpufreq_ondemand acpi_cpufreq freq_table mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode sg xhci_hcd button sd_mod crc_t10dif aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul ahci libahci pata_acpi ata_generic dm_mirror dm_region_hash dm_log dm_mod
> Pid: 16400, comm: jbd2/dm-1-8 Tainted: G        W    3.8.0-rc3+ #107
> Call Trace:
>  [<ffffffff8106fb0d>] warn_slowpath_common+0xad/0xf0
>  [<ffffffff8106fc06>] warn_slowpath_fmt+0x46/0x50
>  [<ffffffff813637e9>] ? ext4_journal_commit_callback+0x99/0xc0
>  [<ffffffff8148cae0>] __list_del_entry+0x1c0/0x250
>  [<ffffffff813637bf>] ext4_journal_commit_callback+0x6f/0xc0
>  [<ffffffff813ca336>] jbd2_journal_commit_transaction+0x23a6/0x2570
>  [<ffffffff8108aa42>] ? try_to_del_timer_sync+0x82/0xa0
>  [<ffffffff8108b491>] ? del_timer_sync+0x91/0x1e0
>  [<ffffffff813d3ecf>] kjournald2+0x19f/0x6a0
>  [<ffffffff810ad630>] ? wake_up_bit+0x40/0x40
>  [<ffffffff813d3d30>] ? bit_spin_lock+0x80/0x80
>  [<ffffffff810ac6be>] kthread+0x10e/0x120
>  [<ffffffff810ac5b0>] ? __init_kthread_worker+0x70/0x70
>  [<ffffffff818ff6ac>] ret_from_fork+0x7c/0xb0
>  [<ffffffff810ac5b0>] ? __init_kthread_worker+0x70/0x70
> 
> In order to demonstrace this issue one should mount ext4 with -odiscard option
> on SSD disk. This makes callback longer and race window becomes wider.
> 
> In order to fix this we should mark transaction as finished only after
> callbacks have completed
> 
> Changes since V1:
>  - Simplify code-flow and add comments according to Jan's request
  Looks good. Just one text correction below - Ted can you apply it please?
...
> -
> +	/* Drop all spin_locks because commit_callback may be block.
> +	 * __journal_remove_checkpoint() can not destroy transaction
> +	 * under us because it is marked as T_FINISHED yet */
                               ^^^ is *not*

>  	if (journal->j_commit_callback)
>  		journal->j_commit_callback(journal, commit_transaction);
>  
>  	trace_jbd2_end_commit(journal, commit_transaction);
>  	jbd_debug(1, "JBD2: commit %d complete, head %d\n",
>  		  journal->j_commit_sequence, journal->j_tail_sequence);

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

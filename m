From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [2.6.22] circular lock detected
Date: Mon, 27 Aug 2007 01:03:21 +0200
Message-ID: <6bffcb0e0708261603q75ec2df0g1bf18443f0870427@mail.gmail.com>
References: <20070824210033.GB13237@vanheusden.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: "Folkert van Heusden" <folkert@vanheusden.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932444AbXHZXDe@vger.kernel.org>
In-Reply-To: <20070824210033.GB13237@vanheusden.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

[Adding fsdevel and linux-ext4 to CC]

On 24/08/07, Folkert van Heusden <folkert@vanheusden.com> wrote:
> Hi,
>
> 2.6.22 kernel with hyperthreading enabled only ext3 filesystems (2).
>
> [  346.314640] =======================================================
> [  346.314758] [ INFO: possible circular locking dependency detected ]
> [  346.314815] 2.6.22 #5
> [  346.314862] -------------------------------------------------------
> [  346.314920] tor/2421 is trying to acquire lock:
> [  346.314973]  (tty_mutex){--..}, at: [<c121aa83>] mutex_lock+0x8/0xa
> [  346.315193]
> [  346.315195] but task is already holding lock:
> [  346.316203]  (&s->s_dquot.dqptr_sem){----}, at: [<c10a485f>] dquot_alloc_space+0x50/0x189
> [  346.316457]
> [  346.316458] which lock already depends on the new lock.
> [  346.316461]
> [  346.316585]
> [  346.316586] the existing dependency chain (in reverse order) is:
> [  346.316675]
> [  346.316676] -> #4 (&s->s_dquot.dqptr_sem){----}:
> [  346.316871]        [<c103b2ee>] check_prev_add+0x15b/0x281
> [  346.317204]        [<c103b49f>] check_prevs_add+0x8b/0xe8
> [  346.317535]        [<c103ce2a>] __lock_acquire+0x65d/0xb51
> [  346.317873]        [<c103d786>] lock_acquire+0x62/0x81
> [  346.318195]        [<c10341af>] down_read+0x2b/0x3d
> [  346.318527]        [<c10a485f>] dquot_alloc_space+0x50/0x189
> [  346.318854]        [<c10b5c55>] ext3_new_blocks+0x44b/0x5a2
> [  346.319187]        [<c10b81e4>] ext3_alloc_blocks+0x40/0xdf
> [  346.319513]        [<c10b82d3>] ext3_alloc_branch+0x50/0x21b
> [  346.319850]        [<c10b87b1>] ext3_get_blocks_handle+0x1b8/0x367
> [  346.320184]        [<c10b8ada>] ext3_getblk+0x97/0x228
> [  346.320530]        [<c10b8c85>] ext3_bread+0x1a/0x78
> [  346.320870]        [<c10bde64>] ext3_mkdir+0xf4/0x270
> [  346.321188]        [<c107cdf6>] vfs_mkdir+0xb3/0x161
> [  346.321506]        [<c107cf30>] sys_mkdirat+0x8c/0xc4
> [  346.321820]        [<c107cf88>] sys_mkdir+0x20/0x22
> [  346.322131]        [<c1003eea>] syscall_call+0x7/0xb
> [  346.322446]        [<ffffffff>] 0xffffffff
> [  346.322779]
> [  346.322780] -> #3 (&ei->truncate_mutex){--..}:
> [  346.322965]        [<c103b2ee>] check_prev_add+0x15b/0x281
> [  346.323278]        [<c103b49f>] check_prevs_add+0x8b/0xe8
> [  346.323602]        [<c103ce2a>] __lock_acquire+0x65d/0xb51
> [  346.323919]        [<c103d786>] lock_acquire+0x62/0x81
> [  346.324234]        [<c121ab04>] __mutex_lock_slowpath+0x75/0x28c
> [  346.324857]        [<c121aa83>] mutex_lock+0x8/0xa
> [  346.325177]        [<c10ba380>] ext3_truncate+0x170/0x468
> [  346.325501]        [<c1060e9a>] vmtruncate+0xa6/0x116
> [  346.325828]        [<c1087937>] inode_setattr+0x145/0x16c
> [  346.326150]        [<c10bb301>] ext3_setattr+0x150/0x22f
> [  346.326479]        [<c1087cb0>] notify_change+0x352/0x386
> [  346.326802]        [<c1071af4>] do_truncate+0x5c/0x7f
> [  346.327116]        [<c107c2e3>] may_open+0x1ec/0x231
> [  346.327434]        [<c107c4a4>] open_namei+0xdd/0x5a2
> [  346.327770]        [<c107275b>] do_filp_open+0x2c/0x53
> [  346.328090]        [<c1072a90>] do_sys_open+0x52/0xd8
> [  346.328408]        [<c1072b32>] sys_open+0x1c/0x1e
> [  346.328727]        [<c1003eea>] syscall_call+0x7/0xb
> [  346.329042]        [<ffffffff>] 0xffffffff
> [  346.329368]
> [  346.329370] -> #2 (&inode->i_alloc_sem){--..}:
> [  346.329556]        [<c103b2ee>] check_prev_add+0x15b/0x281
> [  346.329879]        [<c103b49f>] check_prevs_add+0x8b/0xe8
> [  346.330192]        [<c103ce2a>] __lock_acquire+0x65d/0xb51
> [  346.330508]        [<c103d786>] lock_acquire+0x62/0x81
> [  346.330826]        [<c1034245>] down_write+0x2b/0x45
> [  346.331137]        [<c1087c37>] notify_change+0x2d9/0x386
> [  346.331453]        [<c1071af4>] do_truncate+0x5c/0x7f
> [  346.331769]        [<c107c2e3>] may_open+0x1ec/0x231
> [  346.332087]        [<c107c4a4>] open_namei+0xdd/0x5a2
> [  346.332401]        [<c107275b>] do_filp_open+0x2c/0x53
> [  346.332720]        [<c1072a90>] do_sys_open+0x52/0xd8
> [  346.333037]        [<c1072b32>] sys_open+0x1c/0x1e
> [  346.333600]        [<c1003eea>] syscall_call+0x7/0xb
> [  346.333912]        [<ffffffff>] 0xffffffff
> [  346.334232]
> [  346.334233] -> #1 (&sysfs_inode_imutex_key){--..}:
> [  346.334422]        [<c103b2ee>] check_prev_add+0x15b/0x281
> [  346.334734]        [<c103b49f>] check_prevs_add+0x8b/0xe8
> [  346.335046]        [<c103ce2a>] __lock_acquire+0x65d/0xb51
> [  346.335361]        [<c103d786>] lock_acquire+0x62/0x81
> [  346.335685]        [<c121ab04>] __mutex_lock_slowpath+0x75/0x28c
> [  346.336001]        [<c121aa83>] mutex_lock+0x8/0xa
> [  346.336313]        [<c10b2828>] remove_dir+0x2c/0xf1
> [  346.336629]        [<c10b28f5>] sysfs_remove_subdir+0x8/0xa
> [  346.336941]        [<c10b3ccf>] sysfs_remove_group+0x67/0x78
> [  346.337256]        [<c115cc58>] dpm_sysfs_remove+0x12/0x16
> [  346.337574]        [<c115c36f>] device_pm_remove+0x21/0x62
> [  346.337888]        [<c1156dc5>] device_del+0x82/0x291
> [  346.338199]        [<c1156fdf>] device_unregister+0xb/0x15
> [  346.338516]        [<c11571da>] device_destroy+0x8d/0x9a
> [  346.338827]        [<c1142712>] vcs_remove_sysfs+0x1c/0x3a
> [  346.339142]        [<c1149075>] con_close+0x5e/0x6b
> [  346.339458]        [<c113aa5e>] release_dev+0x4c4/0x6ce
> [  346.339767]        [<c113b0d6>] tty_release+0x12/0x1c
> [  346.340078]        [<c1074479>] __fput+0x145/0x16e
> [  346.340392]        [<c1074332>] fput+0x19/0x1b
> [  346.340701]        [<c1072bb3>] filp_close+0x3c/0x75
> [  346.341012]        [<c1072c55>] sys_close+0x69/0xb4
> [  346.341325]        [<c1003eea>] syscall_call+0x7/0xb
> [  346.341892]        [<ffffffff>] 0xffffffff
> [  346.342213]
> [  346.342214] -> #0 (tty_mutex){--..}:
> [  346.342397]        [<c103b1c7>] check_prev_add+0x34/0x281
> [  346.342708]        [<c103b49f>] check_prevs_add+0x8b/0xe8
> [  346.343017]        [<c103ce2a>] __lock_acquire+0x65d/0xb51
> [  346.343333]        [<c103d786>] lock_acquire+0x62/0x81
> [  346.343646]        [<c121ab04>] __mutex_lock_slowpath+0x75/0x28c
> [  346.343956]        [<c121aa83>] mutex_lock+0x8/0xa
> [  346.344263]        [<c10a41d5>] print_warning+0x8c/0x15d
> [  346.344575]        [<c10a4993>] dquot_alloc_space+0x184/0x189
> [  346.344883]        [<c10b5c55>] ext3_new_blocks+0x44b/0x5a2
> [  346.345193]        [<c10b81e4>] ext3_alloc_blocks+0x40/0xdf
> [  346.345507]        [<c10b82d3>] ext3_alloc_branch+0x50/0x21b
> [  346.345816]        [<c10b87b1>] ext3_get_blocks_handle+0x1b8/0x367
> [  346.346127]        [<c10b89d8>] ext3_get_block+0x78/0xe3
> [  346.346441]        [<c1094802>] __block_prepare_write+0x168/0x415
> [  346.346750]        [<c109530e>] block_prepare_write+0x28/0x3b
> [  346.347057]        [<c10b8e84>] ext3_prepare_write+0xe3/0x17e
> [  346.347369]        [<c10552f1>] generic_file_buffered_write+0x1b4/0x614
> [  346.347689]        [<c105598b>] __generic_file_aio_write_nolock+0x23a/0x533
> [  346.348002]        [<c1055d8d>] generic_file_aio_write+0x58/0xc4
> [  346.348314]        [<c10b6a93>] ext3_file_write+0x2d/0xba
> [  346.348627]        [<c107353b>] do_sync_write+0xc7/0x116
> [  346.348935]        [<c10736e2>] vfs_write+0x158/0x15d
> [  346.349246]        [<c1073788>] sys_write+0x3d/0x64
> [  346.349560]        [<c1003eea>] syscall_call+0x7/0xb
> [  346.349869]        [<ffffffff>] 0xffffffff
> [  346.350438]
> [  346.350440] other info that might help us debug this:
> [  346.350442]
> [  346.350562] 3 locks held by tor/2421:
> [  346.350604]  #0:  (&inode->i_mutex){--..}, at: [<c121aa83>] mutex_lock+0x8/0xa
> [  346.350827]  #1:  (&ei->truncate_mutex){--..}, at: [<c121aa83>] mutex_lock+0x8/0xa
> [  346.351049]  #2:  (&s->s_dquot.dqptr_sem){----}, at: [<c10a485f>] dquot_alloc_space+0x50/0x189
> [  346.351274]
> [  346.351276] stack backtrace:
> [  346.351363]  [<c1004cac>] show_trace_log_lvl+0x1a/0x30
> [  346.351446]  [<c1004cd4>] show_trace+0x12/0x14
> [  346.351526]  [<c1004dce>] dump_stack+0x16/0x18
> [  346.351605]  [<c103ab29>] print_circular_bug_tail+0x6f/0x71
> [  346.351686]  [<c103b1c7>] check_prev_add+0x34/0x281
> [  346.351764]  [<c103b49f>] check_prevs_add+0x8b/0xe8
> [  346.351843]  [<c103ce2a>] __lock_acquire+0x65d/0xb51
> [  346.351921]  [<c103d786>] lock_acquire+0x62/0x81
> [  346.352002]  [<c121ab04>] __mutex_lock_slowpath+0x75/0x28c
> [  346.352083]  [<c121aa83>] mutex_lock+0x8/0xa
> [  346.352160]  [<c10a41d5>] print_warning+0x8c/0x15d
> [  346.352240]  [<c10a4993>] dquot_alloc_space+0x184/0x189
> [  346.352323]  [<c10b5c55>] ext3_new_blocks+0x44b/0x5a2
> [  346.352402]  [<c10b81e4>] ext3_alloc_blocks+0x40/0xdf
> [  346.352479]  [<c10b82d3>] ext3_alloc_branch+0x50/0x21b
> [  346.352558]  [<c10b87b1>] ext3_get_blocks_handle+0x1b8/0x367
> [  346.352638]  [<c10b89d8>] ext3_get_block+0x78/0xe3
> [  346.352720]  [<c1094802>] __block_prepare_write+0x168/0x415
> [  346.352801]  [<c109530e>] block_prepare_write+0x28/0x3b
> [  346.352881]  [<c10b8e84>] ext3_prepare_write+0xe3/0x17e
> [  346.352961]  [<c10552f1>] generic_file_buffered_write+0x1b4/0x614
> [  346.353041]  [<c105598b>] __generic_file_aio_write_nolock+0x23a/0x533
> [  346.353121]  [<c1055d8d>] generic_file_aio_write+0x58/0xc4
> [  346.353200]  [<c10b6a93>] ext3_file_write+0x2d/0xba
> [  346.353281]  [<c107353b>] do_sync_write+0xc7/0x116
> [  346.353364]  [<c10736e2>] vfs_write+0x158/0x15d
> [  346.353444]  [<c1073788>] sys_write+0x3d/0x64
> [  346.353524]  [<c1003eea>] syscall_call+0x7/0xb
> [  346.353603]  =======================
>
>
> Folkert van Heusden
>
> --
> www.vanheusden.com/multitail - win een vlaai van multivlaai! zorg
> ervoor dat multitail opgenomen wordt in Fedora Core, AIX, Solaris of
> HP/UX en win een vlaai naar keuze
> ----------------------------------------------------------------------
> Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/

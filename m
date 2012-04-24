From: Jeff Liu <jeff.liu@oracle.com>
Subject: Re: [PATCH] quota: fix a potential dead lock at add_dquot_ref() when
 performing quotaon against ext4 with files was writing
Date: Wed, 25 Apr 2012 00:41:00 +0800
Message-ID: <4F96D79C.4000601@oracle.com>
References: <4F964768.3080302@oracle.com> <20120424153046.GB1474@quack.suse.cz>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:34300 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2DYAnh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Apr 2012 20:43:37 -0400
In-Reply-To: <20120424153046.GB1474@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/24/2012 11:30 PM, Jan Kara wrote:

>   Hello,
> 
> On Tue 24-04-12 14:25:44, Jeff Liu wrote:
>> I just ran into an issue on vanilla-kernel-3.3.0 when executing quotaon(8) on ext4 with "usrquota,grpquota", and there
>> have files are being writing at the same time.
>>
>> I have a lxc guest running on an ext4 partition, 
>> $ mount|grep sda6
>> /dev/sda6 on /ext4 type ext4 (rw,usrquota,grpquota)
>>
>> Execute quotacheck -cvumg /ext4 to force the quota checking without shutdown that guest, at this stage, everything is fine,
>> # quotacheck -cvgum /ext4
>> quotacheck: Your kernel probably supports journaled quota but you are not using it. Consider switching to journaled quota to avoid running quotacheck after an unclean shutdown.
>> quotacheck: Scanning /dev/sda6 [/ext4] done
>> quotacheck: Cannot stat old user quota file /ext4/aquota.user: No such file or directory. Usage will not be subtracted.
>> quotacheck: Cannot stat old group quota file /ext4/aquota.group: No such file or directory. Usage will not be subtracted.
>> quotacheck: Cannot stat old user quota file /ext4/aquota.user: No such file or directory. Usage will not be subtracted.
>> quotacheck: Cannot stat old group quota file /ext4/aquota.group: No such file or directory. Usage will not be subtracted.
>> quotacheck: Checked 3357 directories and 39335 files
>> quotacheck: Old file not found.
>> quotacheck: Old file not found.
>>
>> However, the kernel was hang when running quotaon /ext4.
>>
>> I observed the following info via netconsole:
>>
>> [  423.140177]  *** DEADLOCK ***
>> [  423.140177] 
>> [  423.140177]  May be due to missing lock nesting notation
>> [  423.140177] 
>> [  423.140177] 4 locks held by quotaon/2350:
>> [  423.140177]  #0:  (&type->s_umount_key#26){++++++}, at: [<c122248e>] get_super+0xf9/0x1ec
>> [  423.140177]  #1:  (&s->s_dquot.dqonoff_mutex){+.+...}, at: [<c129b736>] vfs_load_quota_inode+0x3e5/0xac6
>> [  423.140177]  #2:  (inode_sb_list_lock){+.+...}, at: [<c129b99b>] vfs_load_quota_inode+0x64a/0xac6
>> [  423.140177]  #3:  (&sb->s_type->i_lock_key#16){+.+...}, at: [<c129b9de>] vfs_load_quota_inode+0x68d/0xac6
>> [  423.140177] 
>> [  423.140177] stack backtrace:
>> [  423.140177] Pid: 2350, comm: quotaon Not tainted 3.3.0 #79
>> [  423.140177] Call Trace:
>> [  423.140177]  [<c182b385>] ? printk+0x57/0x6a
>> [  423.140177]  [<c10ee73e>] __lock_acquire+0x133d/0x1a8a
>> [  423.140177]  [<c105da85>] ? vprintk+0x910/0x93a
>> [  423.140177]  [<c1298068>] ? inode_get_rsv_space+0x45/0x8b
>> [  423.140177]  [<c10ef795>] lock_acquire+0x13a/0x176
>> [  423.140177]  [<c1298068>] ? inode_get_rsv_space+0x45/0x8b
>> [  423.140177]  [<c182f778>] _raw_spin_lock+0x54/0x7d
>> [  423.140177]  [<c1298068>] ? inode_get_rsv_space+0x45/0x8b
>> [  423.140177]  [<c1298068>] inode_get_rsv_space+0x45/0x8b
>> [  423.140177]  [<c129bbe2>] vfs_load_quota_inode+0x891/0xac6
>> [  423.140177]  [<c129c1cb>] dquot_quota_on+0x82/0x97
>> [  423.140177]  [<f825d352>] ext4_quota_on+0x191/0x219 [ext4]
>> [  423.140177]  [<c106e4e5>] ? ns_capable+0x71/0xa3
>> [  423.140177]  [<c129e300>] do_quotactl+0x2f7/0x80f
>> [  423.140177]  [<f825d1c1>] ? ext4_msg+0x61/0x61 [ext4]
>> [  423.140177]  [<c122248e>] ? get_super+0xf9/0x1ec
>> [  423.140177]  [<c1222788>] ? get_super_thawed+0x33/0x147
>> [  423.140177]  [<c1246311>] ? iput+0x66/0x320
>> [  423.140177]  [<c129eaa8>] sys_quotactl+0x290/0x2fc
>> [  423.140177]  [<c18308ec>] syscall_call+0x7/0xb
>>
>> As per my investigation, it occurred due to inode_get_rsv_space(inode) lock acquiring if the kernel was built with QUOTA_DEBUG enabled.
>> At add_dquot_ref(), the lock did not released if the inode.i_writecount is not *ZERO*, inode is not in I_FREEING|I_WILL_FREE|I_NEW state,
>> as well as it need to do quota init.
>>
>> if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
>>      !atomic_read(&inode->i_writecount) ||
>>      !dqinit_needed(inode, type)) {
>>      spin_unlock(&inode->i_lock);
>>      continue;
>> }
>>
>> #ifdef CONFIG_QUOTA_DEBUG
>> 	if (unlikely(inode_get_rsv_space(inode) > 0))
>>         	reserved = 1;
>> #endif
>>
>> In my situation, atomic_read(&inode->i_writecount) returns -2, looks that the related file have two
>> deny-writers via mmap at that time.
>>
>> To nail down this issue, I refresh formated an ext4 file system, and try to open a file and keep writing to it(so that the atomic_read(&inode->i_writecount) = 1).
>> then perform quotacheck and quotaon at the same time, and repeat this process for 4 times, the kernel hang for 3 times, 1 time its ok.
>>
>> # python -c "f=open('/ext4/test', 'w'); [(f.seek(x) or f.write(str(x))) for x in range(1, 1000000000, 99)]; f.close()"
>> # quotacheck -cvumg /ext4
>> quotacheck: Your kernel probably supports journaled quota but you are not using it. Consider switching to journaled quota to avoid running quotacheck after an unclean shutdown.
>> quotacheck: Scanning /dev/sda6 [/ext4] done
>> quotacheck: Cannot stat old user quota file /ext4/aquota.user: No such file or directory. Usage will not be subtracted.
>> quotacheck: Cannot stat old group quota file /ext4/aquota.group: No such file or directory. Usage will not be subtracted.
>> quotacheck: Cannot stat old user quota file /ext4/aquota.user: No such file or directory. Usage will not be subtracted.
>> quotacheck: Cannot stat old group quota file /ext4/aquota.group: No such file or directory. Usage will not be subtracted.
>> quotacheck: Checked 2 directories and 1 files
>> quotacheck: Old file not found.
>> quotacheck: Old file not found.
>> # quotaon /ext4			/* kernel was hang. */
>>
>> I also verified that this issue can be reproduced against the latest kernel commit(Mon Apr 23 19:52:00 2012 95f714727436836bb46236ce2bcd8ee8f9274aed).
>>
>> Below is a small patch, it looks a bit ugly, but works for me.
>   Thanks for the detailed analysis and the patch! You are correct that it
> is wrong to call inode_get_rsv_space() with i_lock held. However we cannot
> just drop it at that place of add_dquot_ref() because than inode could be
> removed from memory before we call __iget(). The right fix is to move
> inode_get_rsv_space() to a later place in the function where i_lock is no
> longer held. Attached patch should fix the problem.

Thanks for your quick response and confirmation!

Regards,
-Jeff

> 
> 								Honza



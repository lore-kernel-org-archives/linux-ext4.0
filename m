From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/4] ext4: fix reserved space transferring on chown() [V2]
Date: Mon, 07 Dec 2009 22:41:15 +0300
Message-ID: <87ocmalgh0.fsf@openvz.org>
References: <1259132261-16785-1-git-send-email-dmonakhov@openvz.org>
 <1259132261-16785-2-git-send-email-dmonakhov@openvz.org>
 <20091207171835.GB16078@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:51031 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932767AbZLGTlI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Dec 2009 14:41:08 -0500
Received: from dmon-lp ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru (Sun Java(tm) System Messaging Server 7u2-7.02 64bit
 (built Apr 16 2009)) with ESMTPA id <0KUA006VKS8ENG00@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Mon, 07 Dec 2009 22:45:53 +0300 (MSK)
In-reply-to: <20091207171835.GB16078@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> writes:

> On Wed, Nov 25, 2009 at 09:57:39AM +0300, Dmitry Monakhov wrote:
>> Currently all quota's functions except vfs_dq_reserve_block()
>> called without i_block_reservation_lock. This result in
>> ext4_reservation vs quota_reservation inconsistency which provoke
>> incorrect reservation transfer ==> incorrect quota after transfer.
>> 
>> Race (1)
>> | Task 1 (chown)                 | Task 2 (truncate)                    |
>> | dquot_transfer                 |                                      |
>> | ->down_write(dqptr_sem)        | ext4_da_release_spac                 |
>> | -->dquot_get_reserved_space    | ->lock(i_block_reservation_lock)     |
>> | --->get_reserved_space         | /* decrement reservation */          |
>> | ---->ext4_get_reserved_space   | ->unlock(i_block_reservation_lock)   |
>> | ----->lock(i_block_rsv_lock)   | /* During this time window           |
>> | /* Read ext4_rsv from inode */ | * fs's reservation not equals        |
>> | /* transfer it to new quota */ | * to quota's */                      |
>> | ->up_write(dqptr_sem)          | ->vfs_dq_release_reservation_block() |
>> |                                | /* quota_rsv goes negative here */   |
>> |                                |                                      |
>> 
>> Race (2)
>> | Task 1 (chown)                | Task 2 (flush-8:16)             |
>> | dquot_transfer()              | ext4_mb_mark_diskspace_used()   |
>> | ->down_write(dqptr_sem)       | ->vfs_dq_claim_block()          |
>> | --->get_reserved_space()      | /* After this moment         */ |
>> | --->ext4_get_reserved_space() | /* ext4_rsv != quota_ino_rsv */ |
>> | /* Read rsv from inode which  |                                 |
>> | ->dquot_free_reserved_space() |                                 |
>> | /* quota_rsv goes negative */ |                                 |
>> |                               |                                 |
>> |                               | dquot_free_reserved_space()     |
>> |                               | /* finally dec ext4_ino_rsv */  |
>> 
>> So, in order to protect us from this type of races we always have to
>> provides ext4_ino_rsv == quot_ino_rsv guarantee. And this is only
>> possible then i_block_reservation_lock is taken before entering any
>> quota operations.
>> 
>> In fact i_block_reservation_lock is held by ext4_da_reserve_space()
>> while calling vfs_dq_reserve_block(). Lock are held in following order
>> i_block_reservation_lock > dqptr_sem
>> 
>> This may result in deadlock because of different lock ordering:
>> ext4_da_reserve_space()             dquot_transfer()
>> lock(i_block_reservation_lock)	     down_write(dqptr_sem)
>>   down_write(dqptr_sem)		     lock(i_block_reservation_lock)
>> 
>> But this not happen only because both callers must have i_mutex so
>> serialization happens on i_mutex.
>
>
> But that down_write can sleep right ? 
Absolutely right. I've fixed an issue, but overlooked the BIGGEST one.
So off course my patch is wrong, even if we will acquire lock in
different order " dqptr_sem > i_block_reservation_lock"
we sill getting in to sleeping  spin lock problems by following scenario:
ext4_da_update_reserve_space()
->dquot_claim_space()
ASSUMES that we hold i_block_reservation_lock here.
-->mark_dquot_dirty()
--->ext4_write_dquot()
    if (journalled quota) ext4_write_dquot();
---->dquot_commit()
----->mutex_lock(&dqopt->dqio_mutt's); <<< sleep here.

This means that we have fully redesign quota reservation locking. 
As i already suggested previously here:
http://thread.gmane.org/gmane.comp.file-systems.ext4/16576/focus=16587 

* Introduce i_block analog for generic reserved space management:
We may introduce i_rsv_block field in generic intone, it protected
by i_lock(similar to i_block).
Introduce inc/dec/set/get methods similar to inode_get_bytes,
inode_sub_bytes.. . 
This value is managed internally by quota code. Perform reservation
management inside devout_reserve_space, dquot_release_reservation
without interfering with fs internals, as we do for i_blocks.
So locking sequence will looks like follows
ext4_XXX_space()
->spin_lock(&i_block_reservation_lock)
->// update ext4_rsv fields 
->spin_unlock(&i_block_reservation_lock)
->vfs_XXX_space()
-->down_XXX(&dqptr_sem)
--->inode_XXX_reserved_bytes << analog for inode_XXX_bytes()
---->spin_lock(&inode->i_lock)
---->// update inode->i_rsv_block (and inode->i_block if necessary)
---->spin_unlock(&inode->i_lock)
--->mark_dirty()
IMHO this is best way because:
1)This is the only sane way to fix #14739
2)This brings to well defined VFS interface for reserved space management.

I'll prepare the patch soon.
>
> For example:
> http://bugzilla.kernel.org/show_bug.cgi?id=14739
>
> -aneesh

>  LocalWords:  rsv inode dquot

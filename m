From: Tao Ma <tm@tao.ma>
Subject: Re: [URGENT PATCH] ext4: fix potential deadlock in ext4_evict_inode()
Date: Fri, 26 Aug 2011 17:28:28 +0800
Message-ID: <4E57673C.40600@tao.ma>
References: <E1QwnAu-00087H-8X@tytso-glaptop.cam.corp.google.com> <4E57197B.8090009@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jiaying Zhang <jiayingz@google.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:50038 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753892Ab1HZJ2i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Aug 2011 05:28:38 -0400
In-Reply-To: <4E57197B.8090009@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
On 08/26/2011 11:56 AM, Tao Ma wrote:
> Hi Ted,
> On 08/26/2011 11:33 AM, Theodore Ts'o wrote:
>> Note: this will probably need to be sent to Linus as an emergency
>> bugfix ASAP, since it was introduced in 3.1-rc1, so it represents a
>> regression.
>>
>> Jiayingz, I'd appreciate if you could review this, since this is a
>> partial undo of commit 2581fdc810, which you authored.  I don't think
>> taking out the call to ext4_flush_complted_IO() should should cause any
>> problems, since it should only delay how long it takes for an inode to
>> be evicted, and in some cases we are already waiting for a truncate or
>> journal commit to complete.  But I don't want to take any chances, so a
>> second pair of eyes would be appreciated.  Thanks!!
> I do agree that the revert can help to resolve that lockdep issue, but I
> think jiaying's patch and the deadlock described in her commit log does
> make sense. So I am working on another way to resolve it and hope to
> send it out today. Please review the patch when it is ready.
I am afraid I have to take my word back. The change is too complicated
and I don't think it is OK now for such a later rc. Sorry.

As there are so many users complain about this lockdep warning, we'd
better send it out to Linus ASAP although it can't resolve the nasty bug
described in the commit log by Jiaying.

Thanks
Tao
> 
> Thanks
> Tao
>>
>> 	      	     	     	  	   - Ted
>>
>> From 18271e31ece46955c0fd61e726fa7540fddf8924 Mon Sep 17 00:00:00 2001
>> From: Theodore Ts'o <tytso@mit.edu>
>> Date: Thu, 25 Aug 2011 23:26:01 -0400
>> Subject: [PATCH] ext4: fix potential deadlock in ext4_evict_inode()
>>
>> Commit 2581fdc810 moved ext4_ioend_wait() from ext4_destroy_inode() to
>> ext4_evict_inode().  It also added code to explicitly call
>> ext4_flush_completed_IO(inode):
>>
>> 	mutex_lock(&inode->i_mutex);
>> 	ext4_flush_completed_IO(inode);
>> 	mutex_unlock(&inode->i_mutex);
>>
>> Unfortunately, we can't take the i_mutex lock in ext4_evict_inode()
>> without potentially causing a deadlock.
>>
>> Fix this by removing the code sequence altogether.  This may result in
>> ext4_evict_inode() taking longer to complete, but that's ok, we're not
>> in a rush here.  That just means we have to wait until the workqueue
>> is scheduled, which is OK; there's nothing that says we have to do
>> this work on the current thread, which would require taking a lock
>> that might lead to a deadlock condition.
>>
>> See Kernel Bugzilla #41682 for one example of the circular locking
>> problem that arise.  Another one can be seen here:
>>
>> =======================================================
>> [ INFO: possible circular locking dependency detected ]
>> 3.1.0-rc3-00012-g2a22fc1 #1839
>> -------------------------------------------------------
>> dd/7677 is trying to acquire lock:
>>  (&type->s_umount_key#18){++++..}, at: [<c021ea77>] writeback_inodes_sb_if_idle+0x26/0x3d
>>
>> but task is already holding lock:
>>  (&sb->s_type->i_mutex_key#3){+.+.+.}, at: [<c01d5956>] generic_file_aio_write+0x52/0xba
>>
>> which lock already depends on the new lock.
>>
>> the existing dependency chain (in reverse order) is:
>>
>> -> #1 (&sb->s_type->i_mutex_key#3){+.+.+.}:
>>        [<c018eb02>] lock_acquire+0x99/0xbd
>>        [<c06a53b5>] __mutex_lock_common+0x33/0x2fb
>>        [<c06a572b>] mutex_lock_nested+0x26/0x2f
>>        [<c026c2db>] ext4_evict_inode+0x3e/0x2bd
>>        [<c0214bb0>] evict+0x8e/0x131
>>        [<c0214de6>] dispose_list+0x36/0x40
>>        [<c0215239>] evict_inodes+0xcd/0xd5
>>        [<c0204a23>] generic_shutdown_super+0x3d/0xaa
>>        [<c0204ab2>] kill_block_super+0x22/0x5e
>>        [<c0204cb8>] deactivate_locked_super+0x22/0x4e
>>        [<c02055b2>] deactivate_super+0x3d/0x43
>>        [<c0218427>] mntput_no_expire+0xda/0xdf
>>        [<c0219486>] sys_umount+0x286/0x2ab
>>        [<c02194bd>] sys_oldumount+0x12/0x14
>>        [<c06a6ac5>] syscall_call+0x7/0xb
>>
>> -> #0 (&type->s_umount_key#18){++++..}:
>>        [<c018e262>] __lock_acquire+0x967/0xbd2
>>        [<c018eb02>] lock_acquire+0x99/0xbd
>>        [<c06a5991>] down_read+0x28/0x65
>>        [<c021ea77>] writeback_inodes_sb_if_idle+0x26/0x3d
>>        [<c0269630>] ext4_nonda_switch+0xd0/0xe1
>>        [<c026e953>] ext4_da_write_begin+0x3c/0x1cf
>>        [<c01d46ad>] generic_file_buffered_write+0xc0/0x1b4
>>        [<c01d58d3>] __generic_file_aio_write+0x254/0x285
>>        [<c01d596e>] generic_file_aio_write+0x6a/0xba
>>        [<c026732f>] ext4_file_write+0x1d6/0x227
>>        [<c0202789>] do_sync_write+0x8f/0xca
>>        [<c02030d5>] vfs_write+0x85/0xe3
>>        [<c02031d4>] sys_write+0x40/0x65
>>        [<c06a6ac5>] syscall_call+0x7/0xb
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=41682
>>
>> Cc: stable@kernel.org
>> Cc: Jiaying Zhang <jiayingz@google.com>
>> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>> ---
>>  fs/ext4/inode.c |    3 ---
>>  1 files changed, 0 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 29b7148..cf0b515 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -121,9 +121,6 @@ void ext4_evict_inode(struct inode *inode)
>>  
>>  	trace_ext4_evict_inode(inode);
>>  
>> -	mutex_lock(&inode->i_mutex);
>> -	ext4_flush_completed_IO(inode);
>> -	mutex_unlock(&inode->i_mutex);
>>  	ext4_ioend_wait(inode);
>>  
>>  	if (inode->i_nlink) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


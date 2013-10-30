From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v3 1/2] mbcache: decoupling the locking of local from
 global data
Date: Wed, 30 Oct 2013 11:32:05 -0600
Message-ID: <52714295.6040605@hp.com>
References: <1374108934-50550-1-git-send-email-tmac@hp.com> <1378312756-68597-1-git-send-email-tmac@hp.com> <1378312756-68597-2-git-send-email-tmac@hp.com> <20131030144229.GC3305@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, T Makphaibulchoke <tmac@hp.com>,
	adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, aswin@hp.com,
	torvalds@linux-foundation.org, aswin_proj@groups.hp.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20131030144229.GC3305@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/30/2013 08:42 AM, Theodore Ts'o wrote:
> I tried running xfstests with this patch, and it blew up on
> generic/020 test:
> 
> generic/020	[10:21:50][  105.170352] ------------[ cut here ]------------
> [  105.171683] kernel BUG at /usr/projects/linux/ext4/include/linux/bit_spinlock.h:76!
> [  105.173346] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
> [  105.173346] Modules linked in:
> [  105.173346] CPU: 1 PID: 8519 Comm: attr Not tainted 3.12.0-rc5-00008-gffbe1d7-dirty #1492
> [  105.173346] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [  105.173346] task: f5abe560 ti: f2274000 task.ti: f2274000
> [  105.173346] EIP: 0060:[<c026b464>] EFLAGS: 00010246 CPU: 1
> [  105.173346] EIP is at hlist_bl_unlock+0x7/0x1c
> [  105.173346] EAX: f488d360 EBX: f488d360 ECX: 00000000 EDX: f2998800
> [  105.173346] ESI: f29987f0 EDI: 6954c848 EBP: f2275cc8 ESP: f2275cb8
> [  105.173346]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [  105.173346] CR0: 80050033 CR2: b76bcf54 CR3: 34844000 CR4: 000006f0
> [  105.173346] Stack:
> [  105.173346]  c026bc78 f2275d48 6954c848 f29987f0 f2275d24 c02cd7a9 f2275ce4 c02e2881
> [  105.173346]  f255d8c8 00000000 f1109020 f4a67f00 f2275d54 f2275d08 c02cd020 6954c848
> [  105.173346]  f4a67f00 f1109000 f2b0eba8 f2ee3800 f2275d28 f4f811e8 f2275d38 00000000
> [  105.173346] Call Trace:
> [  105.173346]  [<c026bc78>] ? mb_cache_entry_find_first+0x4b/0x55
> [  105.173346]  [<c02cd7a9>] ext4_xattr_block_set+0x248/0x6e7
> [  105.173346]  [<c02e2881>] ? jbd2_journal_put_journal_head+0xe2/0xed
> [  105.173346]  [<c02cd020>] ? ext4_xattr_find_entry+0x52/0xac
> [  105.173346]  [<c02ce307>] ext4_xattr_set_handle+0x1c7/0x30f
> [  105.173346]  [<c02ce4f4>] ext4_xattr_set+0xa5/0xe1
> [  105.173346]  [<c02ceb36>] ext4_xattr_user_set+0x46/0x5f
> [  105.173346]  [<c024a4da>] generic_setxattr+0x4c/0x5e
> [  105.173346]  [<c024a48e>] ? generic_listxattr+0x95/0x95
> [  105.173346]  [<c024ab0f>] __vfs_setxattr_noperm+0x56/0xb6
> [  105.173346]  [<c024abd2>] vfs_setxattr+0x63/0x7e
> [  105.173346]  [<c024ace8>] setxattr+0xfb/0x139
> [  105.173346]  [<c01b200a>] ? __lock_acquire+0x540/0xca6
> [  105.173346]  [<c01877a3>] ? lg_local_unlock+0x1b/0x34
> [  105.173346]  [<c01af8dd>] ? trace_hardirqs_off_caller+0x2e/0x98
> [  105.173346]  [<c0227e69>] ? kmem_cache_free+0xd4/0x149
> [  105.173346]  [<c01b2c2b>] ? lock_acquire+0xdd/0x107
> [  105.173346]  [<c023225e>] ? __sb_start_write+0xee/0x11d
> [  105.173346]  [<c0247383>] ? mnt_want_write+0x1e/0x3e
> [  105.173346]  [<c01b3019>] ? trace_hardirqs_on_caller+0x12a/0x17e
> [  105.173346]  [<c0247353>] ? __mnt_want_write+0x4e/0x60
> [  105.173346]  [<c024af3b>] SyS_lsetxattr+0x6a/0x9f
> [  105.173346]  [<c078d0e8>] syscall_call+0x7/0xb
> [  105.173346] Code: 00 00 00 00 5b 5d c3 55 89 e5 53 3e 8d 74 26 00 8b 58 08 89 c2 8b 43 18 e8 3f c9 fb ff f0 ff 4b 0c 5b 5d c3 8b 10 80 e2 01 75 02 <0f> 0b 55 89 e5 0f ba 30 00 89 e0 25 00 e0 ff ff ff 48 14 5d c3
> [  105.173346] EIP: [<c026b464>] hlist_bl_unlock+0x7/0x1c SS:ESP 0068:f2275cb8
> [  105.273781] ---[ end trace 1ee45ddfc1df0935 ]---
> 
> When I tried to find a potential problem, I immediately ran into this.
> I'm not entirely sure it's the problem, but it's raised a number of
> red flags for me in terms of (a) how much testing you've employed with
> this patch set, and (b) how maintaining and easy-to-audit the code
> will be with this extra locking.  The comments are good start, but
> some additional comments about exactly what assumptions a function
> assumes about locks that are held on function entry, or especially if
> the locking is different on function entry and function exit, might
> make it easier for people to audit this patch.
> 
> Or maybe this commit needs to be split up with first a conversion from
> using list_head to hlist_hl_node, and the changing the locking?  The
> bottom line is that we need to somehow make this patch easier to
> validate/review.
> 

Thanks for the comemnts.  Yes, I did run through xfstests.  My guess is that you probably ran into a race condition that I did not.

I will try to port the patch to a more recent kernel, including the mb_cache_shrink_scan() sent earlier (BTW, it looks good) and debug the problem.

Yes, those are good suggestions.  Once I find the problem, I will resubmit with more comments and also split it into two patches, as suggested. 

>> @@ -520,18 +647,23 @@ __mb_cache_entry_find(struct list_head *l, struct list_head *head,
>>  				ce->e_queued++;
>>  				prepare_to_wait(&mb_cache_queue, &wait,
>>  						TASK_UNINTERRUPTIBLE);
>> -				spin_unlock(&mb_cache_spinlock);
>> +				hlist_bl_unlock(head);
>>  				schedule();
>> -				spin_lock(&mb_cache_spinlock);
>> +				hlist_bl_lock(head);
>> +				mb_assert(ce->e_index_hash_p == head);
>>  				ce->e_queued--;
>>  			}
>> +			hlist_bl_unlock(head);
>>  			finish_wait(&mb_cache_queue, &wait);
>>  
>> -			if (!__mb_cache_entry_is_hashed(ce)) {
>> +			hlist_bl_lock(ce->e_block_hash_p);
>> +			if (!__mb_cache_entry_is_block_hashed(ce)) {
>>  				__mb_cache_entry_release_unlock(ce);
>> -				spin_lock(&mb_cache_spinlock);
>> +				hlist_bl_lock(head);
> 
> <---  are we missing a "hlist_bl_unlock(ce->e_block_hash_p);" here?
> 
> <---- Why is it that we call "hlist_bl_lock(head);" but not in the else clause?

The function __mb_cache_entry_release_unlock() releases both the e_block_hash and e_index_hash locks.  So we have to reacquire the e_index_hash (head) lock in the then part, and release the e_block_hash lock in the else part.
> 
>>  				return ERR_PTR(-EAGAIN);
>> -			}
>> +			} else
>> +				hlist_bl_unlock(ce->e_block_hash_p);
>> +			mb_assert(ce->e_index_hash_p == head);
>>  			return ce;
>>  		}
>>  		l = l->next; 
> 
> 
> Cheers,
> 
> 					- Ted
> 

Thanks,
Mak.


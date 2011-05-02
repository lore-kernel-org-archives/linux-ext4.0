From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Mon, 02 May 2011 09:04:23 -0500
Message-ID: <4DBEB9E7.9070407@redhat.com>
References: <20110331234050.GD2904@dastard> <20110401140856.GA5311@quack.suse.cz> <20110406054005.GD31057@dastard> <20110406061856.GC23285@quack.suse.cz> <20110406112135.GE31057@dastard> <4DBE746F.3090707@ubuntu.com> <20110502105629.GA4556@quack.suse.cz> <4DBE9537.4050708@ubuntu.com> <20110502122055.GB5855@quack.suse.cz> <4DBEA3DF.1060306@ubuntu.com> <20110502131619.GC5855@quack.suse.cz> <4DBEB025.90704@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	"Ted Ts'o" <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: surbhi.palande@ubuntu.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4DBEB025.90704@ubuntu.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 5/2/11 8:22 AM, Surbhi Palande wrote:
> On 05/02/2011 04:16 PM, Jan Kara wrote:
>> On Mon 02-05-11 15:30:23, Surbhi Palande wrote:
>>> On 05/02/2011 03:20 PM, Jan Kara wrote:
>>>> On Mon 02-05-11 14:27:51, Surbhi Palande wrote:
>>>>> On 05/02/2011 01:56 PM, Jan Kara wrote:
>>>>>> On Mon 02-05-11 12:07:59, Surbhi Palande wrote:
>>>>>>> On 04/06/2011 02:21 PM, Dave Chinner wrote:
>>>>>>>> On Wed, Apr 06, 2011 at 08:18:56AM +0200, Jan Kara wrote:
>>>>>>>>> On Wed 06-04-11 15:40:05, Dave Chinner wrote:
>>>>>>>>>> On Fri, Apr 01, 2011 at 04:08:56PM +0200, Jan Kara wrote:
>>>>>>>>>>> On Fri 01-04-11 10:40:50, Dave Chinner wrote:
>>>>>>>>>>>> If you don't allow the page to be dirtied in the fist place, then
>>>>>>>>>>>> nothing needs to be done to the writeback path because there is
>>>>>>>>>>>> nothing dirty for it to write back.
>>>>>>>>>>>    Sure but that's only the problem he was able to hit. But generally,
>>>>>>>>>>> there's a problem with needing s_umount for unfreezing because it isn't
>>>>>>>>>>> clear there aren't other code paths which can block with s_umount held
>>>>>>>>>>> waiting for fs to get unfrozen. And these code paths would cause the same
>>>>>>>>>>> deadlock. That's why I chose to get rid of s_umount during thawing.
>>>>>>>>>> Holding the s_umount lock while checking if frozen and sleeping
>>>>>>>>>> is essentially an ABBA lock inversion bug that can bite in many more
>>>>>>>>>> places that just thawing the filesystem.  Any where this is done should
>>>>>>>>>> be fixed, so I don't think just removing the s_umount lock from the thaw
>>>>>>>>>> path is sufficient to avoid problems.
>>>>>>>>>    That's easily said but hard to do - any transaction start in ext3/4 may
>>>>>>>>> block on filesystem being frozen (this seems to be similar for XFS as I'm
>>>>>>>>> looking into the code) and transaction start traditionally nests inside
>>>>>>>>> s_umount (and basically there's no way around that since sync() calls your
>>>>>>>>> fs code with s_umount held).
>>>>>>>> Sure, but the question must be asked - why is ext3/4 even starting a
>>>>>>>> transaction on a clean filesystem during sync? A frozen filesystem,
>>>>>>>> by definition, is a clean filesytem, and therefore sync calls of any
>>>>>>>> kind should not be trying to write to the FS or start transactions.
>>>>>>>> XFS does this just fine, so I'd consider such behaviour on a frozen
>>>>>>>> filesystem a bug in ext3/4...
>>>>>>> I had a look at the xfs code for seeing how this is done.
>>>>>>> xfs_file_aio_write()
>>>>>>>    xfs_wait_for_freeze()
>>>>>>>      vfs_check_frozen()
>>>>>>> So xfs_file_aio_write() writes to buffers when the FS is not frozen.
>>>>>>>
>>>>>>> Now, I want to know what stops the following scenario from happening:
>>>>>>> --------------------
>>>>>>> xfs_file_aio_write()
>>>>>>>    xfs_wait_for_freeze()
>>>>>>>      vfs_check_frozen()
>>>>>>> At this point F.S was not frozen, so the next instruction in the
>>>>>>> xfs_file_aio_write() will be executed next.
>>>>>>> However at this point (i.e after checking if F.S is frozen) the
>>>>>>> write process gets pre-empted and say the _freeze_ process gets
>>>>>>> control.
>>>>>>>
>>>>>>> Now the F.S freezes and the write process gets the control back. And
>>>>>>> so we end up writing to the page cache when the F.S is frozen.
>>>>>>> --------------------
>>>>>>>
>>>>>>> Can anyone please enlighten me on how&    why this premption is _not_
>>>>>>> possible?
>>>>> Thanks for your reply.
>>>>>>    XFS works similarly as ext4 in this regard I believe. They have the log
>>>>>> frozen in xfs_freeze() so if the race you describe above happens, either
>>>>>> the writing process gets caught waiting for log to unfreeze
>>>>> Agreed.
>>>>>>   or it manages
>>>>>> to start a transaction and then freezing process waits for transaction to
>>>>>> finish before it can proceed with freezing. I'm not sure why is there the
>>>>>> check in xfs_file_aio_write()...
>>>>>>
>>>>>>            
>>>>> I am sorry, but I don't understand how this will happen - i.e I
>>>>> can't understand what stops freeze_super() (or ext4_freeze) from
>>>>> freezing a superblock (as the write process stopped just before
>>>>> writing anything for this transaction and has not taken any locks?)
>>>>    So ext4_freeze() does
>>>> jbd2_journal_lock_updates(journal)
>>>>    which waits for all running transactions to finish and updates
>>>> j_barrier_count which stops any news ones from proceeding (check
>>>> function start_this_handle()).
>>>>
>>> Yes, but ext4_freeze() also calls
>>> jbd2_journal_unlock_updates(journal) which decrements the
>>> j_barrier_count (which was previously updated/incremented in
>>> jbd2_journal_lock_updates) ? before it returns. So after this call a
>>> new transaction/handle can be accepted/started.
>>>
>>> A comment in ext4_freeze() says:
>>> /* we rely on s_frozen to stop further updates */
>>> (before calling jbd2_journal_unlock_updates())
>>    Ah, drat, you're right. I've missed this other part. It's the problem
>> that if you expect to see something, you'll see it regardless of the real
>> code ;).
>>
>> The fact is we do vfs_check_frozen() in ext4_journal_start_sb() but indeed
>> it's still racy (although the race window is relatively small) because the
>> filesystem can become frozen the instant after we check vfs_check_frozen().
>> Commit 6b0310fb broke it for ext4.
>>
>> I guess the code was mostly copied from XFS which seems to have the same
>> problem in xfs_trans_alloc() since the git history beginning. I see two
>> ways to fix this - either fix ext4/xfs to check s_frozen after starting
>> a transaction and if the filesystem is being frozen, we stop the
>> transaction, wait for fs to get unfrozen, and restart. Another option is
>> to create an analogous logic using a atomic counter of write ops in vfs
>> that could be used by all filesystems. We'd just have to replace
>> vfs_check_frozen() with vfs_start_write() and add vfs_stop_write() at
>> appropriate places...
> How about calling  jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
> from ext4_unfreeze()?

we used to have that, but holding it locked until then means we exit the kernel
with a mutex held, which is pretty icky.

    ================================================
    [ BUG: lock held when returning to user space! ]
    ------------------------------------------------
    lvcreate/1075 is leaving the kernel with locks still held!
    1 lock held by lvcreate/1075:
     #0:  (&journal->j_barrier){+.+...}, at: [<ffffffff811c6214>]
    jbd2_journal_lock_updates+0xe1/0xf0


-Eric

> So that indeed no transactions can be started before unfreeze is called.
> 
> This has another advantage, that it rightfully does not let you update the access time when the F.S is frozen (touch_atime called from a read path when the F.S is frozen) Otherwise we also need to fix this path.
> 
> Warm Regards,
> Surbhi.
> 
>> Dave, Christoph, any opinions on this?
>>                                 Honza
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


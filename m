From: Surbhi Palande <surbhi.palande@canonical.com>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Mon, 02 May 2011 15:06:47 +0300
Message-ID: <4DBE9E57.902@canonical.com>
References: <20110216145627.GB5592@quack.suse.cz> <4D5C9B1B.2050304@jp.fujitsu.com> <20110217104552.GD4947@quack.suse.cz> <20110328170628.ffe314fb.toshi.okajima@jp.fujitsu.com> <20110331234050.GD2904@dastard> <20110401140856.GA5311@quack.suse.cz> <20110406054005.GD31057@dastard> <20110406061856.GC23285@quack.suse.cz> <20110406112135.GE31057@dastard> <4DBE746F.3090707@ubuntu.com> <20110502105629.GA4556@quack.suse.cz> <4DBE9537.4050708@ubuntu.com>
Reply-To: surbhi.palande@canonical.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: surbhi.palande@ubuntu.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:33506 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab1EBMGz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 May 2011 08:06:55 -0400
In-Reply-To: <4DBE9537.4050708@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/02/2011 02:27 PM, Surbhi Palande wrote:
> On 05/02/2011 01:56 PM, Jan Kara wrote:
>> On Mon 02-05-11 12:07:59, Surbhi Palande wrote:
>>> On 04/06/2011 02:21 PM, Dave Chinner wrote:
>>>> On Wed, Apr 06, 2011 at 08:18:56AM +0200, Jan Kara wrote:
>>>>> On Wed 06-04-11 15:40:05, Dave Chinner wrote:
>>>>>> On Fri, Apr 01, 2011 at 04:08:56PM +0200, Jan Kara wrote:
>>>>>>> On Fri 01-04-11 10:40:50, Dave Chinner wrote:
>>>>>>>> If you don't allow the page to be dirtied in the fist place, then
>>>>>>>> nothing needs to be done to the writeback path because there is
>>>>>>>> nothing dirty for it to write back.
>>>>>>> Sure but that's only the problem he was able to hit. But generally,
>>>>>>> there's a problem with needing s_umount for unfreezing because it
>>>>>>> isn't
>>>>>>> clear there aren't other code paths which can block with s_umount
>>>>>>> held
>>>>>>> waiting for fs to get unfrozen. And these code paths would cause
>>>>>>> the same
>>>>>>> deadlock. That's why I chose to get rid of s_umount during thawing.
>>>>>> Holding the s_umount lock while checking if frozen and sleeping
>>>>>> is essentially an ABBA lock inversion bug that can bite in many more
>>>>>> places that just thawing the filesystem. Any where this is done
>>>>>> should
>>>>>> be fixed, so I don't think just removing the s_umount lock from
>>>>>> the thaw
>>>>>> path is sufficient to avoid problems.
>>>>> That's easily said but hard to do - any transaction start in ext3/4
>>>>> may
>>>>> block on filesystem being frozen (this seems to be similar for XFS
>>>>> as I'm
>>>>> looking into the code) and transaction start traditionally nests
>>>>> inside
>>>>> s_umount (and basically there's no way around that since sync()
>>>>> calls your
>>>>> fs code with s_umount held).
>>>> Sure, but the question must be asked - why is ext3/4 even starting a
>>>> transaction on a clean filesystem during sync? A frozen filesystem,
>>>> by definition, is a clean filesytem, and therefore sync calls of any
>>>> kind should not be trying to write to the FS or start transactions.
>>>> XFS does this just fine, so I'd consider such behaviour on a frozen
>>>> filesystem a bug in ext3/4...
>>> I had a look at the xfs code for seeing how this is done.
>>> xfs_file_aio_write()
>>> xfs_wait_for_freeze()
>>> vfs_check_frozen()
>>> So xfs_file_aio_write() writes to buffers when the FS is not frozen.
>>>
>>> Now, I want to know what stops the following scenario from happening:
>>> --------------------
>>> xfs_file_aio_write()
>>> xfs_wait_for_freeze()
>>> vfs_check_frozen()
>>> At this point F.S was not frozen, so the next instruction in the
>>> xfs_file_aio_write() will be executed next.
>>> However at this point (i.e after checking if F.S is frozen) the
>>> write process gets pre-empted and say the _freeze_ process gets
>>> control.
>>>
>>> Now the F.S freezes and the write process gets the control back. And
>>> so we end up writing to the page cache when the F.S is frozen.
>>> --------------------
>>>
>>> Can anyone please enlighten me on how& why this premption is _not_
>>> possible?
> Thanks for your reply.
>> XFS works similarly as ext4 in this regard I believe. They have the log
>> frozen in xfs_freeze() so if the race you describe above happens, either
>> the writing process gets caught waiting for log to unfreeze
> Agreed.
>> or it manages
>> to start a transaction and then freezing process waits for transaction to
>> finish before it can proceed with freezing. I'm not sure why is there the
>> check in xfs_file_aio_write()...
>>
>>
> I am sorry, but I don't understand how this will happen - i.e I can't
> understand what stops freeze_super() (or ext4_freeze) from freezing a
> superblock (as the write process stopped just before writing anything
> for this transaction and has not taken any locks?)

To make myself a little more coherent:

freeze_super()
   ext4_freeze()
     1) jbd2_journal_updates()
     2) jbd2_journal_flush(journal)
     3) jbd2_journal_unlock_updates(journal).
     4) return

Say now the fs write process stopped just after checking that fs is not 
frozen (i.e its thawed). So its ready to write to the page cache. Just 
when it has finished this vfs_check_frozen() and before it starts any 
write (or transactions), say the write process gets pre-empted and then 
the freeze process freezes the superblock. Wont ext4_freeze() simply 
lock the current transactions, flush them to the log and then unlock the 
transactions (so that new handles/transactions can be accepted later?)

So then after the fsfreeze finishes freezing the F.S, say if the write 
process gets the control back. The write process assumes that after its 
out of vfs_check_frozen(), the fs is thawed (or unfrozen) where as in 
this case it is not.

So I don't understand, _what_ stops the writing process from starting a 
transaction in this case when the F.S is frozen already
and what stops the fsfreeze from waiting for the write process (when it 
has not yet started the write)?

Warm Regards,
Surbhi.




>
> Thanks!
>
> Warm Regards,
> Surbhi.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html


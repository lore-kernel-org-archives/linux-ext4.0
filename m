From: Surbhi Palande <surbhi.palande@canonical.com>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Tue, 03 May 2011 14:01:50 +0300
Message-ID: <4DBFE09E.5070805@canonical.com>
References: <20110328170628.ffe314fb.toshi.okajima@jp.fujitsu.com> <20110330141205.GC22349@quack.suse.cz> <4D946DAB.3010107@jp.fujitsu.com> <4D9AEE28.4000003@jp.fujitsu.com> <20110405225428.GD8531@quack.suse.cz> <4D9BF57A.6030705@jp.fujitsu.com> <20110406055708.GB23285@quack.suse.cz> <4D9C18DF.90803@jp.fujitsu.com> <20110406174617.GC28689@quack.suse.cz> <4DA84A7B.3040403@jp.fujitsu.com> <20110415171310.GB5432@quack.suse.cz> <4DABFEBD.7030102@jp.fujitsu.com>
Reply-To: surbhi.palande@canonical.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:37054 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab1ECLCA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 May 2011 07:02:00 -0400
In-Reply-To: <4DABFEBD.7030102@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/18/2011 12:05 PM, Toshiyuki Okajima wrote:
> Hi,
>
> (2011/04/16 2:13), Jan Kara wrote:
>> Hello,
>>
>> On Fri 15-04-11 22:39:07, Toshiyuki Okajima wrote:
>>>> For ext3 or ext4 without delayed allocation we block inside writepage()
>>>> function. But as I wrote to Dave Chinner, ->page_mkwrite() should
>>>> probably
>>>> get modified to block while minor-faulting the page on frozen fs
>>>> because
>>>> when blocks are already allocated we may skip starting a transaction
>>>> and so
>>>> we could possibly modify the filesystem.
>>> OK. I think ->page_mkwrite() should also block writing the
>>> minor-faulting pages.
>>>
>>> (minor-pagefault)
>>> -> do_wp_page()
>>> -> page_mkwrite(= ext4_mkwrite())
>>> => BLOCK!
>>>
>>> (major-pagefault)
>>> -> do_liner_fault()
>>> -> page_mkwrite(= ext4_mkwrite())
>>> => BLOCK!
>>>
>>>>
>>>>>>> Mizuma-san's reproducer also writes the data which maps to the
>>>>>>> file (mmap).
>>>>>>> The original problem happens after the fsfreeze operation is done.
>>>>>>> I understand the normal write operation (not mmap) can be blocked
>>>>>>> while
>>>>>>> fsfreezing. So, I guess we don't always block all the write
>>>>>>> operation
>>>>>>> while fsfreezing.
>>>>>> Technically speaking, we block all the transaction starts which
>>>>>> means we
>>>>>> end up blocking all the writes from going to disk. But that does
>>>>>> not mean
>>>>>> we block all the writes from going to in-memory cache - as you
>>>>>> properly
>>>>>> note the mmap case is one of such exceptions.
>>>>> Hm, I also think we can allow the writes to in-memory cache but we
>>>>> can't allow
>>>>> the writes to disk while fsfreezing. I am considering that mmap
>>>>> path can
>>>>> write to disk while fsfreezing because this deadlock problem
>>>>> happens after
>>>>> fsfreeze operation is done...
>>>> I'm sorry I don't understand now - are you speaking about the case
>>>> above
>>>> when writepage() does not wait for filesystem being frozen or something
>>>> else?
>>> Sorry, I didn't understand around the page fault path.
>>> So, I had read the kernel source code around it, then I maybe
>>> understand...
>>>
>>> I worry whether we can update the file data in mmap case while
>>> fsfreezing.
>>> Of course, I understand that we can write to in-memory cache, and it
>>> is not a
>>> problem. However, if we can write to disk while fsfreezing, it is a
>>> problem.
>>> So, I summarize the cases whether we can write to disk or not.
>>>
>>> --------------------------------------------------------------------------
>>>
>>> Cases (Whether we can write the data mmapped to the file on the disk
>>> while fsfreezing)
>>>
>>> [1] One of the page which has been mmapped is not bound. And
>>> the page is not allocated yet. (major fault?)
>>>
>>> (1) user dirtys a page
>>> (2) a page fault occurs (do_page_fault)
>>> (3) __do_falut is called.
>>> (4) ext4_page_mkwrite is called
>>> (5) ext4_write_begin is called
>>> (6) ext4_journal_start_sb => We can STOP!
>>>
>>> [2] One of the page which has been mmapped is not bound. But
>>> the page is already allocated, and the buffer_heads of the page
>>> are not mapped (BH_Mapped). (minor fault?)
>>>
>>> (1) user dirtys a page
>>> (2) a page fault occurs (do_page_fault)
>>> (3) do_wp_page is called.
>>> (4) ext4_page_mkwrite is called
>>> (5) ext4_write_begin is called
>>> (6) ext4_journal_start_sb => We can STOP!

What happens in the case as follows:

Task 1: Mmapped writes
t1)ext4_page_mkwrite()
   t2) ext4_write_begin() (FS is thawed so we proceed)
   t3) ext4_write_end() (journal is stopped now)
-----Pre-empted-----


Task 2: Freeze Task
t4) freezes the super block...
...(continues)....
tn) the page cache is clean and the F.S is frozen. Freeze has completed 
execution.

Task 1: Mmapped writes
tn+1) ext4_page_mkwrite() returns 0.
tn+2) __do_fault() gets control, code gets executed.
tn+3) _do_fault() marks the page dirty if the intent is to write to a 
file based page which faulted.

So you end up dirtying the page cache when the F.S is frozen? No?


Warm Regards,
Surbhi.







>>>
>>> [3] One of the page which has been mmapped is not bound. But
>>> the page is already allocated, and the buffer_heads of the page
>>> are mapped (BH_Mapped). (minor fault?)
>>>
>>> (1) user dirtys a page
>>> (2) a page fault occurs (do_page_fault)
>>> (3) do_wp_page is called.
>>> (4) ext4_page_mkwrite is called
>>> * Cannot block the dirty page to be written because all bh is mapped.
>>> (5) user munmaps the page (munmap)
>>> (6) zap_pte_range dirtys the page (struct page) which is pte_dirtyed.
>>> (7) writeback thread writes the page (struct page) to disk
>>> => We cannot STOP!
>>>
>>> [4] One of the page which has been mmapped is bound. And
>>> the page is already allocated.
>>>
>>> (1) user dirtys a page
>>> ( ) no page fault occurs
>>> (2) user munmaps the page (munmap)
>>> (3) zap_pte_range dirtys the page (struct page) which is pte_dirtyed.
>>> (4) writeback thread writes the page (struct page) to disk
>>> => We cannot STOP!
>>> --------------------------------------------------------------------------
>>>
>>>
>>> So, we can block the cases [1], [2].
>>> But I think we cannot block the cases [3], [4] now.
>>> If fixing the page_mkwrite, we can also block the case [3].
>>> But the case [4] is not blocked because no page fault occurs
>>> when we dirty the mmapped page.
>>>
>>> Therefore, to repair this problem, we need to fix the cases [3], [4].
>>> I think we must modify the writeback thread to fix the case [4].
>> The trick here is that when we write a page to disk, we write-protect
>> the page (you seem to call this that "the page is bound", I'm not sure
>> why).
> Hm, I want to understand how to write-protect the page under fsfreezing.
> But, anyway, I understand we don't need to consider the case [4].
>
>> So we are guaranteed to receive a minor fault (case [3]) if user tries to
>> modify a page after we finish writeback while freezing the filesystem.
>> So principially all we need to do is just wait in ext4_page_mkwrite().
> OK. I understand.
> Are there any concrete ideas to fix this?
> For ext4, we can rescue from the case [3] by modifying ext4_page_mkwrite().
> But for ext3 or other FSs, we must implement ->page_mkwrite() to prevent
> it?
>
> Thanks,
> Toshiyuki Okajima
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html


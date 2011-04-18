From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Mon, 18 Apr 2011 18:05:01 +0900
Message-ID: <4DABFEBD.7030102@jp.fujitsu.com>
References: <20110328170628.ffe314fb.toshi.okajima@jp.fujitsu.com> <20110330141205.GC22349@quack.suse.cz> <4D946DAB.3010107@jp.fujitsu.com> <4D9AEE28.4000003@jp.fujitsu.com> <20110405225428.GD8531@quack.suse.cz> <4D9BF57A.6030705@jp.fujitsu.com> <20110406055708.GB23285@quack.suse.cz> <4D9C18DF.90803@jp.fujitsu.com> <20110406174617.GC28689@quack.suse.cz> <4DA84A7B.3040403@jp.fujitsu.com> <20110415171310.GB5432@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: toshi.okajima@jp.fujitsu.com, Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43795 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1DRJDQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Apr 2011 05:03:16 -0400
In-Reply-To: <20110415171310.GB5432@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

(2011/04/16 2:13), Jan Kara wrote:
>    Hello,
>
> On Fri 15-04-11 22:39:07, Toshiyuki Okajima wrote:
>>>    For ext3 or ext4 without delayed allocation we block inside writepage()
>>> function. But as I wrote to Dave Chinner, ->page_mkwrite() should probably
>>> get modified to block while minor-faulting the page on frozen fs because
>>> when blocks are already allocated we may skip starting a transaction and so
>>> we could possibly modify the filesystem.
>> OK. I think ->page_mkwrite() should also block writing the minor-faulting pages.
>>
>> (minor-pagefault)
>> ->  do_wp_page()
>>     ->  page_mkwrite(= ext4_mkwrite())
>>        =>  BLOCK!
>>
>> (major-pagefault)
>> ->  do_liner_fault()
>>     ->  page_mkwrite(= ext4_mkwrite())
>>        =>  BLOCK!
>>
>>>
>>>>>> Mizuma-san's reproducer also writes the data which maps to the file (mmap).
>>>>>> The original problem happens after the fsfreeze operation is done.
>>>>>> I understand the normal write operation (not mmap) can be blocked while
>>>>>> fsfreezing. So, I guess we don't always block all the write operation
>>>>>> while fsfreezing.
>>>>>    Technically speaking, we block all the transaction starts which means we
>>>>> end up blocking all the writes from going to disk. But that does not mean
>>>>> we block all the writes from going to in-memory cache - as you properly
>>>>> note the mmap case is one of such exceptions.
>>>> Hm, I also think we can allow the writes to in-memory cache but we can't allow
>>>> the writes to disk while fsfreezing. I am considering that mmap path can
>>>> write to disk while fsfreezing because this deadlock problem happens after
>>>> fsfreeze operation is done...
>>>    I'm sorry I don't understand now - are you speaking about the case above
>>> when writepage() does not wait for filesystem being frozen or something
>>> else?
>> Sorry, I didn't understand around the page fault path.
>> So, I had read the kernel source code around it, then I maybe understand...
>>
>> I worry whether we can update the file data in mmap case while fsfreezing.
>> Of course, I understand that we can write to in-memory cache, and it is not a
>> problem. However, if we can write to disk while fsfreezing, it is a problem.
>> So, I summarize the cases whether we can write to disk or not.
>>
>> --------------------------------------------------------------------------
>> Cases (Whether we can write the data mmapped to the file on the disk
>> while fsfreezing)
>>
>> [1] One of the page which has been mmapped is not bound. And
>>   the page is not allocated yet. (major fault?)
>>
>>     (1) user dirtys a page
>>     (2) a page fault occurs (do_page_fault)
>>     (3) __do_falut is called.
>>     (4) ext4_page_mkwrite is called
>>     (5) ext4_write_begin is called
>>     (6) ext4_journal_start_sb       =>  We can STOP!
>>
>> [2] One of the page which has been mmapped is not bound. But
>>   the page is already allocated, and the buffer_heads of the page
>>   are not mapped (BH_Mapped).  (minor fault?)
>>
>>     (1) user dirtys a page
>>     (2) a page fault occurs (do_page_fault)
>>     (3) do_wp_page is called.
>>     (4) ext4_page_mkwrite is called
>>     (5) ext4_write_begin is called
>>     (6) ext4_journal_start_sb       =>  We can STOP!
>>
>> [3] One of the page which has been mmapped is not bound. But
>>   the page is already allocated, and the buffer_heads of the page
>>   are mapped (BH_Mapped).  (minor fault?)
>>
>>     (1) user dirtys a page
>>     (2) a page fault occurs (do_page_fault)
>>     (3) do_wp_page is called.
>>     (4) ext4_page_mkwrite is called
>>     * Cannot block the dirty page to be written because all bh is mapped.
>>     (5) user munmaps the page (munmap)
>>     (6) zap_pte_range dirtys the page (struct page) which is pte_dirtyed.
>>     (7) writeback thread writes the page (struct page) to disk
>>                                             =>  We cannot STOP!
>>
>> [4] One of the page which has been mmapped is bound. And
>>   the page is already allocated.
>>
>>     (1) user dirtys a page
>>     ( ) no page fault occurs
>>     (2) user munmaps the page (munmap)
>>     (3) zap_pte_range dirtys the page (struct page) which is pte_dirtyed.
>>     (4) writeback thread writes the page (struct page) to disk
>>                                             =>  We cannot STOP!
>> --------------------------------------------------------------------------
>>
>> So, we can block the cases [1], [2].
>> But I think we cannot block the cases [3], [4] now.
>> If fixing the page_mkwrite, we can also block the case [3].
>> But the case [4] is not blocked because no page fault occurs
>> when we dirty the mmapped page.
>>
>> Therefore, to repair this problem, we need to fix the cases [3], [4].
>> I think we must modify the writeback thread to fix the case [4].
>    The trick here is that when we write a page to disk, we write-protect
> the page (you seem to call this that "the page is bound", I'm not sure why).
Hm, I want to understand how to write-protect the page under fsfreezing.
But, anyway, I understand we don't need to consider the case [4].

> So we are guaranteed to receive a minor fault (case [3]) if user tries to
> modify a page after we finish writeback while freezing the filesystem.
> So principially all we need to do is just wait in ext4_page_mkwrite().
OK. I understand.
Are there any concrete ideas to fix this?
For ext4, we can rescue from the case [3] by modifying ext4_page_mkwrite().
But for ext3 or other FSs, we must implement ->page_mkwrite() to prevent it?

Thanks,
Toshiyuki Okajima


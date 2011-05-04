From: Surbhi Palande <surbhi.palande@canonical.com>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Thu, 05 May 2011 00:34:51 +0300
Message-ID: <4DC1C67B.3030801@canonical.com>
References: <4D9BF57A.6030705@jp.fujitsu.com> <20110406055708.GB23285@quack.suse.cz> <4D9C18DF.90803@jp.fujitsu.com> <20110406174617.GC28689@quack.suse.cz> <4DA84A7B.3040403@jp.fujitsu.com> <20110415171310.GB5432@quack.suse.cz> <4DABFEBD.7030102@jp.fujitsu.com> <4DBFE09E.5070805@canonical.com> <20110503151948.GB6009@quack.suse.cz> <4DC14201.6090009@canonical.com> <20110504191912.GB6968@quack.suse.cz>
Reply-To: surbhi.palande@canonical.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110504191912.GB6968@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 05/04/2011 10:19 PM, Jan Kara wrote:
> On Wed 04-05-11 15:09:37, Surbhi Palande wrote:
>> On 05/03/2011 06:19 PM, Jan Kara wrote:
>>> On Tue 03-05-11 14:01:50, Surbhi Palande wrote:
>>>> On 04/18/2011 12:05 PM, Toshiyuki Okajima wrote:
>>>>> (2011/04/16 2:13), Jan Kara wrote:
>>>>>> Hello,
>>>>>>
>>>>>> On Fri 15-04-11 22:39:07, Toshiyuki Okajima wrote:
>>>>>>>> For ext3 or ext4 without delayed allocation we block inside writepage()
>>>>>>>> function. But as I wrote to Dave Chinner, ->page_mkwrite() should
>>>>>>>> probably
>>>>>>>> get modified to block while minor-faulting the page on frozen fs
>>>>>>>> because
>>>>>>>> when blocks are already allocated we may skip starting a transaction
>>>>>>>> and so
>>>>>>>> we could possibly modify the filesystem.
>>>>>>> OK. I think ->page_mkwrite() should also block writing the
>>>>>>> minor-faulting pages.
>>>>>>>
>>>>>>> (minor-pagefault)
>>>>>>> ->   do_wp_page()
>>>>>>> ->   page_mkwrite(= ext4_mkwrite())
>>>>>>> =>   BLOCK!
>>>>>>>
>>>>>>> (major-pagefault)
>>>>>>> ->   do_liner_fault()
>>>>>>> ->   page_mkwrite(= ext4_mkwrite())
>>>>>>> =>   BLOCK!
>>>>>>>
>>>>>>>>
>>>>>>>>>>> Mizuma-san's reproducer also writes the data which maps to the
>>>>>>>>>>> file (mmap).
>>>>>>>>>>> The original problem happens after the fsfreeze operation is done.
>>>>>>>>>>> I understand the normal write operation (not mmap) can be blocked
>>>>>>>>>>> while
>>>>>>>>>>> fsfreezing. So, I guess we don't always block all the write
>>>>>>>>>>> operation
>>>>>>>>>>> while fsfreezing.
>>>>>>>>>> Technically speaking, we block all the transaction starts which
>>>>>>>>>> means we
>>>>>>>>>> end up blocking all the writes from going to disk. But that does
>>>>>>>>>> not mean
>>>>>>>>>> we block all the writes from going to in-memory cache - as you
>>>>>>>>>> properly
>>>>>>>>>> note the mmap case is one of such exceptions.
>>>>>>>>> Hm, I also think we can allow the writes to in-memory cache but we
>>>>>>>>> can't allow
>>>>>>>>> the writes to disk while fsfreezing. I am considering that mmap
>>>>>>>>> path can
>>>>>>>>> write to disk while fsfreezing because this deadlock problem
>>>>>>>>> happens after
>>>>>>>>> fsfreeze operation is done...
>>>>>>>> I'm sorry I don't understand now - are you speaking about the case
>>>>>>>> above
>>>>>>>> when writepage() does not wait for filesystem being frozen or something
>>>>>>>> else?
>>>>>>> Sorry, I didn't understand around the page fault path.
>>>>>>> So, I had read the kernel source code around it, then I maybe
>>>>>>> understand...
>>>>>>>
>>>>>>> I worry whether we can update the file data in mmap case while
>>>>>>> fsfreezing.
>>>>>>> Of course, I understand that we can write to in-memory cache, and it
>>>>>>> is not a
>>>>>>> problem. However, if we can write to disk while fsfreezing, it is a
>>>>>>> problem.
>>>>>>> So, I summarize the cases whether we can write to disk or not.
>>>>>>>
>>>>>>> --------------------------------------------------------------------------
>>>>>>>
>>>>>>> Cases (Whether we can write the data mmapped to the file on the disk
>>>>>>> while fsfreezing)
>>>>>>>
>>>>>>> [1] One of the page which has been mmapped is not bound. And
>>>>>>> the page is not allocated yet. (major fault?)
>>>>>>>
>>>>>>> (1) user dirtys a page
>>>>>>> (2) a page fault occurs (do_page_fault)
>>>>>>> (3) __do_falut is called.
>>>>>>> (4) ext4_page_mkwrite is called
>>>>>>> (5) ext4_write_begin is called
>>>>>>> (6) ext4_journal_start_sb =>   We can STOP!
>>>>>>>
>>>>>>> [2] One of the page which has been mmapped is not bound. But
>>>>>>> the page is already allocated, and the buffer_heads of the page
>>>>>>> are not mapped (BH_Mapped). (minor fault?)
>>>>>>>
>>>>>>> (1) user dirtys a page
>>>>>>> (2) a page fault occurs (do_page_fault)
>>>>>>> (3) do_wp_page is called.
>>>>>>> (4) ext4_page_mkwrite is called
>>>>>>> (5) ext4_write_begin is called
>>>>>>> (6) ext4_journal_start_sb =>   We can STOP!
>>>>
>>>> What happens in the case as follows:
>>>>
>>>> Task 1: Mmapped writes
>>>> t1)ext4_page_mkwrite()
>>>>    t2) ext4_write_begin() (FS is thawed so we proceed)
>>>>    t3) ext4_write_end() (journal is stopped now)
>>>> -----Pre-empted-----
>>>>
>>>>
>>>> Task 2: Freeze Task
>>>> t4) freezes the super block...
>>>> ...(continues)....
>>>> tn) the page cache is clean and the F.S is frozen. Freeze has
>>>> completed execution.
>>>>
>>>> Task 1: Mmapped writes
>>>> tn+1) ext4_page_mkwrite() returns 0.
>>>> tn+2) __do_fault() gets control, code gets executed.
>>>> tn+3) _do_fault() marks the page dirty if the intent is to write to
>>>> a file based page which faulted.
>>>>
>>>> So you end up dirtying the page cache when the F.S is frozen? No?
>>>    You are right ext4_page_mkrite() as currently implemented has problems.
>>> You have to return the page locked (and check for frozen fs with page lock
>>> held) to avoid races.
>>>
>>> If you check for frozen fs with page lock held, you are guaranteed that
>>> freezing code must wait for the page to get unlocked before proceeding. And
>>> before the page is unlocked, it is marked dirty by the pagefault code which
>>> makes freezing code write the page and writeprotect it again. So everything
>>> will be safe.
>> For the locked page to be a part of the freeze initiated sync,
>> should its owner inode not be dirtied? The page fault handler
>> dirties the page, but who ensures that the inode is dirtied at this
>> point?
Well, I mean it as follows:

Doesn't the writeback code (invoked via sync_filesystem(sb)) write all 
the dirty pages of all the _dirty_ inodes of a superblock?

So in the window from the point where ext4_page_mkwrite returns to 
__do_fault() _till_ you mark the inode dirty (in __mark_inode_dirty()), 
you can have a race with freeze i.e if freeze happens meanwhile, then 
the sync initiated by freeze will not consider this locked page as the 
owner inode is _clean_ (or not dirtied yet) at that point?

Key: tx: time at unit x

P1: mmapped writes
t1) __do_page_fault()
    t2) ext4_page_mkwrite()
       // owner inode of the page is in _clean_ state - not yet dirtied
    --- pre-empted---

P2: Freeze_super
tn) freeze_super gets control
freezes the F.S, skips the owner inode as it is in the clean state. 
syncs all the other dirty inodes. page cache is now clean.


P1: mmapped writes (resume)
tn+x)__do_page_fault() gets control back:
    tn+x+1) set_page_dirty()
      tn+x+2) __set_page_dirty_buffers()
         tn+x+3) __set_page_dirty()
  	   tn+x+4) radix_tree_tag_set(page, PAGECACHE_TAG_DIRTY)

So don't we end up dirtying the page cache when the F.S is frozen?

Again, apologies if I understood the writeback code or something else wrong!

Warm Regards,
Surbhi.

>    Follow the path from set_page_dirty() ->  __set_page_dirty_buffers()
> ->  __set_page_dirty() ->  __mark_inode_dirty(mapping->host, I_DIRTY_PAGES);


>
>    More code reading would save you (and me) some typing ;).
P/S: Sorry about that!

>
> 								Honza


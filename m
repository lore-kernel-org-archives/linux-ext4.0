From: Surbhi Palande <surbhi.palande@canonical.com>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Tue, 03 May 2011 11:06:49 +0300
Message-ID: <4DBFB799.50302@canonical.com>
References: <4D9BF57A.6030705@jp.fujitsu.com>	<20110406055708.GB23285@quack.suse.cz>	<4D9C18DF.90803@jp.fujitsu.com>	<20110406174617.GC28689@quack.suse.cz>	<4DA84A7B.3040403@jp.fujitsu.com>	<20110415171310.GB5432@quack.suse.cz>	<4DABFEBD.7030102@jp.fujitsu.com>	<20110418105105.GB5557@quack.suse.cz>	<4DAD5934.1030901@jp.fujitsu.com>	<20110422155839.3295e8e8.toshi.okajima@jp.fujitsu.com>	<20110422221025.GF2977@quack.suse.cz> <20110425152858.a9edfe58.toshi.okajima@jp.fujitsu.com>
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
Received: from adelie.canonical.com ([91.189.90.139]:39609 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab1ECIG7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 May 2011 04:06:59 -0400
In-Reply-To: <20110425152858.a9edfe58.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/25/2011 09:28 AM, Toshiyuki Okajima wrote:
> Hi.
>
> On Sat, 23 Apr 2011 00:10:25 +0200
> Jan Kara<jack@suse.cz>  wrote:
>> On Fri 22-04-11 15:58:39, Toshiyuki Okajima wrote:
>>> I have confirmed that the following patch works fine while my or
>>> Mizuma-san's reproducer is running. Therefore,
>>>   we can block to write the data, which is mmapped to a file, into a disk
>>> by a page-fault while fsfreezing.
>>>
>>> I think this patch fixes the following two problems:
>>> - A deadlock occurs between ext4_da_writepages() (called from
>>> writeback_inodes_wb) and thaw_super(). (reported by Mizuma-san)
>>> - We can also write the data, which is mmapped to a file,
>>>    into a disk while fsfreezing (ext3/ext4).
>>>                                         (reported by me)
>>>
>>> Please examine this patch.
>>    Thanks for the patch. The ext3 part is not as easy as this. You cannot
>> really get i_alloc_sem in ext3_page_mkwrite() because mmap_sem is already
>> held by page fault code and i_alloc_sem should be acquired before it (yes I
>> know, ext4 already has this bug which should be fixed when I get to it).
>> Also you'll find that performance of random writers via mmap (which is
>> relatively common) is going to be rather bad with this patch (because the
>> file will be heavily fragmented). We have to be more clever which is
>> exactly why it's taking me so long with my patch :) But tests are already
>> running so if everything goes fine, I should have patches to submit next
>> week.
> OK, I'll wait your patch. :)
>
>>
>> The ext4 part looks correct. I'd just also like to have some comments about
>> how freeze handling is done because it's kind of subtle.
>
> How about this?


We can have a race here too - since we are only checking if the F.S is 
in a frozen state or not at _that_ point. We are _not_ preventing a F.S 
freeze from happening _after_ this point. So here is what can happen:

Key:
(tx: time at xth unit)

Scenario:

Task 1: mmapped write - (case: page mapped to disk and is in page cache)
t1) ext4_page_mkwrite()
t2)   vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
t3) ---- Preempted ----


Task 2: Freeze Task
t4) freezes the super block...
...(continues)....
tn) the page cache is clean and the F.S is frozen. Freeze has completed 
execution.

Task1: mmapped write - (case: page mapped to disk and is in page cache)
tn+1)ext4_page_mkwrite() returns 0. The write to the mmapped page 
continues with writing to a page in the page cache when the F.S is 
frozen! So after the vfs_check_frozen() we _are_ susceptible to 
"dirtying the page cache when F.S is frozen"

In this case we are not protected by a transaction. Are we?

Warm Regards,
Surbhi.




>
> Thanks,
> Toshiyuki Okajima
>
> ----------------------------------------------------------------------------------------------------
> Subject: [PATCH] ext4: prevent the mmapped page flushing to disk while fsfreezing
>
> Signed-off-by: Toshiyuki Okajima<toshi.okajima@jp.fujitsu.com>
> ---
>   fs/ext4/inode.c |   10 +++++++++-
>   1 files changed, 9 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index f2fa5e8..411b177 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5812,7 +5812,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>   	}
>   	ret = 0;
>   	if (PageMappedToDisk(page))
> -		goto out_unlock;
> +		goto out_frozen;
>
>   	if (page->index == size>>  PAGE_CACHE_SHIFT)
>   		len = size&  ~PAGE_CACHE_MASK;
> @@ -5830,6 +5830,14 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>   		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
>   					ext4_bh_unmapped)) {
>   			unlock_page(page);
> +out_frozen:
> +			/*
> +			 * We must wait here while the filesystem is being
> +			 * frozen otherwise a flushing thread can write this
> +			 * page to the disk (we can update the filesystem even
> +			 * if it is frozen).
> +			 */
> +			vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
>   			goto out_unlock;
>   		}
>   	}


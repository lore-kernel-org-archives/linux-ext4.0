From: Surbhi Palande <surbhi.palande@canonical.com>
Subject: Re: your mail
Date: Tue, 03 May 2011 18:26:08 +0300
Message-ID: <4DC01E90.4070506@canonical.com>
References: <4DBFE09E.5070805@canonical.com> <1304428117-6195-1-git-send-email-surbhi.palande@canonical.com> <20110503134636.GA6009@quack.suse.cz> <4DC009A9.20308@canonical.com>
Reply-To: surbhi.palande@canonical.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, toshi.okajima@jp.fujitsu.com,
	tytso@mit.edu, m.mizuma@jp.fujitsu.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: surbhi.palande@canonical.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4DC009A9.20308@canonical.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 05/03/2011 04:56 PM, Surbhi Palande wrote:
> On 05/03/2011 04:46 PM, Jan Kara wrote:
>> On Tue 03-05-11 16:08:36, Surbhi Palande wrote:
>
> Sorry for missing the subject line :(
>>> On munmap() zap_pte_range() is called which dirties the PTE dirty
>>> pages as
>>> Toshiyuki pointed out.
>>>
>>> zap_pte_range()
>>> mapping->a_ops->set_page_dirty (= ext4_journalled_set_page_dirty)
>>>
>>> So, I think that it is here that we should do the checking for a ext4
>>> F.S
>>> frozen state and also prevent a parallel ext4 F.S freeze from happening.
>>>
>>> Attaching a patch for initial review. Please do let me know your
>>> thoughts!
>> This is definitely the wrong place. ->set_page_dirty() callbacks are
>> called with various locks held and the page need not be locked (thus
>> dereferencing page->mapping is oopsable). Moreover this particular
>> callback
>> is called only in data=journal mode.
> Ok! Thanks for that!
>
>>
>> Believe me, the right place is page_mkwrite() - you have to catch the
>> read-only => read-write page transition. Once the page is mapped
>> read-write, you've already lost the race.
Also, we then need to prevent a munmap()/zap_pte_range() call from 
dirtying a mmapped file page when the F.S is frozen?

Warm Regards,
Surbhi.

>
> My only point is:
> 1) something should prevent the freeze from happening. We cant merely
> check the vfs_check_frozen()?
>
> And this should be done where the page is marked dirty.Also, I thought
> that the page is marked read-write only in the page table in the
> __do_page_fault()? i.e the zap_pte_range() marks them dirty in the page
> cache? Is this understanding right?
>
> IMHO, whatever code dirties the page in the page cache should call a F.S
> specific function and let it _prevent_ a fsfreeze while the page is
> getting dirtied, so that a freeze called after this point flushes this
> page!
>
> Warm Regards,
> Surbhi.
>
>
>
>
>
>
>
>
>
>
>>
>> Honza
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html


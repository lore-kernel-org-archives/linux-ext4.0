From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH] JBD: positively dispose the unmapped data buffers in
 journal_commit_transaction
Date: Tue, 24 Jun 2008 17:01:44 +0900
Message-ID: <4860A9E8.9090103@jp.fujitsu.com>
References: <485F8263.8000103@jp.fujitsu.com> <20080623192731.baf0904a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41390 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbYFXIEN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jun 2008 04:04:13 -0400
In-Reply-To: <20080623192731.baf0904a.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thank you for reviewing.

Andrew Morton wrote:
> On Mon, 23 Jun 2008 20:00:51 +0900 Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:
> 
>> Hi.
<SNIP>
>> On ordered mode, before journal_commit_transaction does with
>> t_locked_list, all data buffers which are requested to dispose
>> by journal_unmap_buffer aren't disposed by JBD.
> 
> Why not?  What is it which prevents these buffers from being released
> in the normal fashion?

When an ext3-ordered file is truncated, it is possible that many pages
are not successfully freed, because they are attached to a committing
transaction.
(This description is the comment of release_buffer_page())

So, journal_unmap_buffer() leaves it to journal_commit_transaction()
to release the buffers later.
(journal_unmap_buffer() puts the mark 'BH_Freed' to them
so that journal_commit_transaction() can identify whether they can be
released or not.)

But journal_commit_transaction() doesn't free them if they are treated
as data buffers because there is no code which releases the pages
(which have the data buffers (marked 'BH_Freed')) in it.

Therefore such the buffers and the pages remain by JBD.
(They remain till try_to_free_buffers() is called by someone.
For example, kswapd().)

> 
>> Such all data
<SNIP>
>> all metadata buffers on such situation are disposed at
>> 'JBD: commit phase 7' by JBD and pages corresponding to them
>> can be released on the same time.
>>
>> Therefore, by applying the same statements as ones for disposing
>> metadata buffers (marked 'BH_Freed'), JBD in
>> journal_commit_transaction can release the pages which has data
>> buffers without mapping.
>> As a result, the page which cannot be estimated is lost.
>>
> 
> Are you sure that this change cannot reintroduce the problem which the
> addition of buffer_freed() fixed?

I think no problem happens because I only add
the code which releases the page (and buffer_heads) which should be
released originally.

I use release_buffer_page() to release the page.
The page can be released (try_to_free_buffers() can be executed in JBD)
only if the following is satisfied for a data buffer:
  - it is demanded to be released by journal_unmap_buffer()
  - its b_count is 1
  - the page to which it belongs has no mapping
  - the page is unlocked

And I have never experienced any problems while performing long run test.

>> ---
>>  fs/jbd/commit.c |   45 +++++++++++++++++++++++++++++++++++----------
>>  1 files changed, 35 insertions(+), 10 deletions(-)
>> --- linux-2.6.26-rc6.org/fs/jbd/commit.c	2008-06-13 06:22:24.000000000 +0900
<SNIP>
>>  			BUFFER_TRACE(bh, "already cleaned up");
>> -			put_bh(bh);
>> +			if (buffer_freed(bh)) {
>> +				/* This bh has been marked 'BH_Feed'. */
> 
> "BH_Freed".
> 
> But the comment is rather unnecessary anyway.

I see. I remove it.

>> +				clear_buffer_freed(bh);
>> +				/* Release the page if all other buffers
>> +				 * that belong to the page that has this bh
>> +				 * can be freed.
>> +				 */
>> +				release_buffer_page(bh);
>> +			} else
>> +				put_bh(bh);	
> 
> Perhaps the above code snippet shold be in a function rather than
> repeated three times.
> 
> The patch adds new trailing whitespace.

OK. I will change these statements into one function.

I will send revised patch ASAP.

Thanks,
---
Toshiyuki Okajima


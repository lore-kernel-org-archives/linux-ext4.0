From: majianpeng <majianpeng@gmail.com>
Subject: Re: [PATCH] fs/buffer.c: Remove the unnecessary init operation after
 allocating buffer_head.
Date: Mon, 22 Apr 2013 08:57:25 +0800
Message-ID: <51748AF5.9040408@gmail.com>
References: <5170AC10.60504@gmail.com> <20130419144819.GB26647@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
	tytso@mit.edu, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130419144819.GB26647@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/19/2013 10:48 PM, Jan Kara wrote:
> On Fri 19-04-13 10:29:36, majianpeng wrote:
>> Because alloc struct buffer_head using kmem_cache_zalloc,so it's not need to
>> call 'init_buffer(bh, NULL, NULL)'.
>>
>> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
>> ---
>>  fs/buffer.c       | 2 --
>>  fs/jbd/journal.c  | 1 -
>>  fs/jbd2/journal.c | 1 -
>>  3 files changed, 4 deletions(-)
>>
>> diff --git a/fs/buffer.c b/fs/buffer.c
>> index b4dcb34..52b7739 100644
>> --- a/fs/buffer.c
>> +++ b/fs/buffer.c
>> @@ -865,8 +865,6 @@ try_again:
>>  
>>          /* Link the buffer to its page */
>>          set_bh_page(bh, page, offset);
>> -
>> -        init_buffer(bh, NULL, NULL);
>>      }
>>      return head;
>>  /*
>> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
>> index 81cc7ea..0c3fe90 100644
>> --- a/fs/jbd/journal.c
>> +++ b/fs/jbd/journal.c
>> @@ -311,7 +311,6 @@ int journal_write_metadata_buffer(transaction_t *transaction,
>>      new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
>>      /* keep subsequent assertions sane */
>>      new_bh->b_state = 0;
>> -    init_buffer(new_bh, NULL, NULL);
>   You can also remove b_state = 0 , can't you?
>
>>      atomic_set(&new_bh->b_count, 1);
>>      new_jh = journal_add_journal_head(new_bh);    /* This sleeps */
>>  
>> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
>> index ed10991..95120c6 100644
>> --- a/fs/jbd2/journal.c
>> +++ b/fs/jbd2/journal.c
>> @@ -368,7 +368,6 @@ retry_alloc:
>>  
>>      /* keep subsequent assertions sane */
>>      new_bh->b_state = 0;
>> -    init_buffer(new_bh, NULL, NULL);
>   And the same here. Otherwise the patch looks OK.
>
> 								Honza
Thanks your suggestions.I'll resend .

Thanks!
Jianpeng

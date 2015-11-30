From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: Re: [PATCH] jbd2: fix null committed data return in
	undo_access
Date: Mon, 30 Nov 2015 11:03:57 +0800
Message-ID: <565BBC9D.6040007@oracle.com>
References: <1448589441-19321-1-git-send-email-junxiao.bi@oracle.com>
	<20151127084553.GB3093@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Fasheh <mfasheh@suse.com>, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, jack@suse.com
To: Jan Kara <jack@suse.cz>
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
In-Reply-To: <20151127084553.GB3093@quack.suse.cz>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

On 11/27/2015 04:45 PM, Jan Kara wrote:
> On Fri 27-11-15 09:57:21, Junxiao Bi wrote:
>> commit de92c8c ("jbd2: speedup jbd2_journal_get_[write|undo]_access()")
>> introduced jbd2_write_access_granted() to improve write|undo_access
>> speed, but missed to check the status of b_committed_data which caused
>> a kernel panic on ocfs2.
> 
> Thanks for debugging this! Just a few minor nits:
> 
> 1) Please use at least 12 characters of the commit hash - i.e. de92c8caf16c
> - that is pretty much guaranteed to stay unique for the lifetime of Linux.
> Using just 7 characters will become non-unique with high probability rather
> soon.
I saw this report from checkpatch.pl. Since there have "patch subject",
so i didn't modify it. I will update it in v2 patch.
> 
> 2) Send this patch to Ted Tso as well as he is the one merging jbd2
> patches.
OK.
> 
> 3) The fact that OCFS2 hit this problem means that it is mixing
> jbd2_journal_get_write_access() and jbd2_journal_get_undo_access() for the
> same buffer. That is slightly suspicious to me. Not that it would be
> outright bug but you have to account for the fact that someone can be
> modifying the buffer data while you are getting undo access...
I am not sure about this. Mark involved this in commit b4414eea0e
("ocfs2: Clear undo bits when local alloc is freed").

Mark, is mixing using undo/write access a bug?
> 
> 4) Some other comments below in the code.
> 
>> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
>> index 6b8338e..4750bda 100644
>> --- a/fs/jbd2/transaction.c
>> +++ b/fs/jbd2/transaction.c
>> @@ -1009,7 +1009,8 @@ out:
>>  }
>>  
>>  /* Fast check whether buffer is already attached to the required transaction */
>> -static bool jbd2_write_access_granted(handle_t *handle, struct buffer_head *bh)
>> +static bool jbd2_write_access_granted(handle_t *handle, struct buffer_head *bh,
>> +							int undo)
> 							^^^
> Use 'bool' please. The function is already using bools so it is good for
> consistency.
Will fix this in v2.

Thanks,
Junxiao.
> 
>>  {
>>  	struct journal_head *jh;
>>  	bool ret = false;
>> @@ -1036,6 +1037,8 @@ static bool jbd2_write_access_granted(handle_t *handle, struct buffer_head *bh)
>>  	jh = READ_ONCE(bh->b_private);
>>  	if (!jh)
>>  		goto out;
> 
> Short comment here please. Like:
> 
> 	/* For undo access buffer must have data copied */
> 
>> +	if (undo && !jh->b_committed_data)
>> +		goto out;
>>  	if (jh->b_transaction != handle->h_transaction &&
>>  	    jh->b_next_transaction != handle->h_transaction)
>>  		goto out;
>> @@ -1073,7 +1076,7 @@ int jbd2_journal_get_write_access(handle_t *handle, struct buffer_head *bh)
>>  	struct journal_head *jh;
>>  	int rc;
>>  
>> -	if (jbd2_write_access_granted(handle, bh))
>> +	if (jbd2_write_access_granted(handle, bh, 0))
> 
> Here 'false' instead of 0.
> 
>>  	JBUFFER_TRACE(jh, "entry");
>> -	if (jbd2_write_access_granted(handle, bh))
>> +	if (jbd2_write_access_granted(handle, bh, 1))
> 
> Here 'true' instead of 1.
> 
> Thanks.
> 
> 								Honza
> 

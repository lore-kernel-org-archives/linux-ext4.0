From: Joseph Qi <joseph.qi@huawei.com>
Subject: Re: [PATCH] jbd2: fix ocfs2 corrupt when updating journal superblock
 fails
Date: Tue, 23 Jun 2015 08:48:39 +0800
Message-ID: <5588ACE7.3040808@huawei.com>
References: <5574F060.2080503@huawei.com> <20150619144831.GL4076@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>,
	"ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	"Junxiao Bi" <junxiao.bi@oracle.com>,
	jiangyiwen <jiangyiwen@huawei.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:23266 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbbFWAuI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Jun 2015 20:50:08 -0400
In-Reply-To: <20150619144831.GL4076@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
Thanks for pointing out this issue and fixing it. If return 1 it may
break out those can only handle zero/negative return value.
I am sorry for not considering this before.

On 2015/6/19 22:48, Theodore Ts'o wrote:
> This patch caused test ext4/306 to fail, because it caused resize2fs
> to fail.  The problem is that jbd2_cleanup_journal_tail() will return
> 1 if there is nothing to cleanup, and a negative error number if there
> is an error.  Unfortunately, this patch hunk:
> 
> On Mon, Jun 08, 2015 at 09:31:12AM +0800, Joseph Qi wrote:
>> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
>> index b96bd80..6b33a42 100644
>> --- a/fs/jbd2/journal.c
>> +++ b/fs/jbd2/journal.c
>> @@ -1950,7 +1966,13 @@ int jbd2_journal_flush(journal_t *journal)
>>  		return -EIO;
>>
>>  	mutex_lock(&journal->j_checkpoint_mutex);
>> -	jbd2_cleanup_journal_tail(journal);
>> +	if (!err) {
>> +		err = jbd2_cleanup_journal_tail(journal);
>> +		if (err < 0) {
>> +			mutex_unlock(&journal->j_checkpoint_mutex);
>> +			goto out;
>> +		}
>> +	}
> 
> ... would let the non-negative return value leak out to
> jbd2_journal_flush(), and its callers are *not* prepared to handle the
> non-negative return value (since jbd2_journal_flush wasn't doing this
> before.)
> 
> I've fixed this by adding a "err = 0;" after the if statement.
> 
>           	   	   	    	 - Ted
> 
> .
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in

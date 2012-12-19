From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH RFC] jbd: don't wake kjournald unnecessarily
Date: Tue, 18 Dec 2012 20:36:20 -0600
Message-ID: <50D12824.40605@redhat.com>
References: <50D0A1FD.7040203@redhat.com> <20121219012710.GF5987@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Dave Wysochanski <dwysocha@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab2LSChI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Dec 2012 21:37:08 -0500
In-Reply-To: <20121219012710.GF5987@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/18/12 7:27 PM, Jan Kara wrote:
> On Tue 18-12-12 11:03:57, Eric Sandeen wrote:
>> Commit d9b0193 jbd: fix fsync() tid wraparound bug
>> changed the logic for whether __log_start_commit() should wake up
>> kjournald.

...

>> Anyway, I think this patch helps on the "don't send extra wakeups"
>> side of things.  Does anyone see a problem with it?
>   The patch is fine. I'll queue it up.

Thanks for the review!  I'll get jbd2 on the list soon.

-Eric

> 								Honza
>> =============
>> [PATCH] jbd: don't wake kjournald unnecessarily
>>
>> Don't send an extra wakeup to kjournald in the case where we
>> already have the proper target in j_commit_request, i.e. that
>> commit has already been requested for commit.
>>
>> commit d9b0193 "jbd: fix fsync() tid wraparound bug" changed
>> the logic leading to a wakeup, but it caused some extra wakeups
>> which were found to lead to a measurable performance regression.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>  
>> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
>> index a286233..81cc7ea 100644
>> --- a/fs/jbd/journal.c
>> +++ b/fs/jbd/journal.c
>> @@ -446,7 +446,8 @@ int __log_start_commit(journal_t *journal, tid_t target)
>>  	 * currently running transaction (if it exists).  Otherwise,
>>  	 * the target tid must be an old one.
>>  	 */
>> -	if (journal->j_running_transaction &&
>> +	if (journal->j_commit_request != target &&
>> +	    journal->j_running_transaction &&
>>  	    journal->j_running_transaction->t_tid == target) {
>>  		/*
>>  		 * We want a new commit: OK, mark the request and wakeup the


From: Pavel Emelianov <xemul@sw.ru>
Subject: Re: [PATCH] Check for error returned by kthread_create on creating
 journal thread
Date: Mon, 23 Apr 2007 10:17:56 +0400
Message-ID: <462C4F94.7090107@sw.ru>
References: <4623289A.1000101@sw.ru> <20070420153809.8ce9a662.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	devel@openvz.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:46438 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbXDWGNp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Apr 2007 02:13:45 -0400
In-Reply-To: <20070420153809.8ce9a662.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton wrote:
> On Mon, 16 Apr 2007 11:41:14 +0400
> Pavel Emelianov <xemul@sw.ru> wrote:
> 
>> If the thread failed to create the subsequent wait_event
>> will hang forever.
>>
>> This is likely to happen if kernel hits max_threads limit.
>>
>> Will be critical for virtualization systems that limit the
>> number of tasks and kernel memory usage within the container.
>>
>>
>> [diff-jbd-check-start-journal-thread-return-value  text/plain (1.7KB)]
>> --- ./fs/jbd/journal.c.jbdthreads	2007-04-16 11:17:36.000000000 +0400
>> +++ ./fs/jbd/journal.c	2007-04-16 11:30:09.000000000 +0400
>> @@ -211,10 +211,16 @@ end_loop:
>>  	return 0;
>>  }
>>  
>> -static void journal_start_thread(journal_t *journal)
>> +static int journal_start_thread(journal_t *journal)
>>  {
>> -	kthread_run(kjournald, journal, "kjournald");
>> +	struct task_struct *t;
>> +
>> +	t = kthread_run(kjournald, journal, "kjournald");
>> +	if (IS_ERR(t))
>> +		return PTR_ERR(t);
>> +
>>  	wait_event(journal->j_wait_done_commit, journal->j_task != 0);
>> +	return 0;
>>  }
> 
> Thanks.   Please don't forget those Signed-off-by:s

I will :)

> I assume that you runtime tested this and that the mount failed in
> an appropriate fashion?
> 

Yes. This was easy to test as we can force kthread_run() to fail
at the moment we want with the help of the beancounters ;)

Moreover this patch lives in our tree for a year or so in both
stable and development branches.

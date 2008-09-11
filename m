From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/4] jbd: abort when failed to log metadata buffers
Date: Thu, 11 Sep 2008 13:32:41 -0500
Message-ID: <48C96449.4080704@redhat.com>
References: <488876D3.80004@hitachi.com> <48887776.4080504@hitachi.com> <48C95867.5080707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, sct@redhat.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	adilger@clusterfs.com, snitzer@gmail.com, tglx@linutronix.de,
	yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755929AbYIKSmK@vger.kernel.org>
In-Reply-To: <48C95867.5080707@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> Hidehiro Kawai wrote:
>> If we failed to write metadata buffers to the journal space and
>> succeeded to write the commit record, stale data can be written
>> back to the filesystem as metadata in the recovery phase.
>>
>> To avoid this, when we failed to write out metadata buffers,
>> abort the journal before writing the commit record.
>>
>> Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
>> Acked-by: Jan Kara <jack@suse.cz>
>> ---
>>  fs/jbd/commit.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> Index: linux-2.6.26-rc8-mm1/fs/jbd/commit.c
>> ===================================================================
>> --- linux-2.6.26-rc8-mm1.orig/fs/jbd/commit.c
>> +++ linux-2.6.26-rc8-mm1/fs/jbd/commit.c
>> @@ -762,6 +762,9 @@ wait_for_iobuf:
>>  		/* AKPM: bforget here */
>>  	}
>>  
>> +	if (err)
>> +		journal_abort(journal, err);
>> +
>>  	jbd_debug(3, "JBD: commit phase 6\n");
>>  
>>  	if (journal_write_commit_record(journal, commit_transaction))
> 
> A little late for me to chime in, but why is this a journal_abort() when
> journal aborts before and after this call __journal_abort_hard()?
> 
> I'm just not sure what's different about this one condition that we wish
> to update the error and the superblock here?


I take that back, was looking at an old tree, and Josef pointed out
commit 7a266e75cf5a1efd20d084408a1b7f1a185496dd to me that changes this,
and now it makes much more sense.  :)

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7a266e75cf5a1efd20d084408a1b7f1a185496dd

Thanks,
-Eric

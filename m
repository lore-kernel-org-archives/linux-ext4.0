From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: jbd2: don't wake kjournald unnecessarily
Date: Wed, 23 Jan 2013 09:20:38 -0600
Message-ID: <50FFFFC6.8070308@redhat.com>
References: <CA+icZUWOvk5i+XY22xdZYuxu=Vy3fG2QxJStEgNFQVS4u55y-w@mail.gmail.com> <CA+icZUUzNYE9QAh_p7=ZNuvZbxRPCb9zd4k7+aW-hv34mQWz=A@mail.gmail.com> <20130121104733.GE5588@quack.suse.cz> <CA+icZUVy-=jJkRsEKmX+ZGRjiGr4wwp3pqdxuLCRHeqW_H0x9Q@mail.gmail.com> <CA+icZUVAP4ArN+j34GTUwMxte5DtLPJSrLmK9T6Na8Qy+aM0Rg@mail.gmail.com> <20130121140738.GI5588@quack.suse.cz> <CA+icZUXLcdnNPvA9o8d5msOQ0MkMci8mPXujLZ3zcYjYcVZ7JQ@mail.gmail.com> <20130121231130.GB12410@thunk.org> <20130122235041.GA7497@quack.suse.cz> <50FF3EEA.2030408@redhat.com> <20130123094421.GB9821@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-next <linux-next@vger.kernel.org>, mszeredi@suse.cz
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584Ab3AWPxY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jan 2013 10:53:24 -0500
In-Reply-To: <20130123094421.GB9821@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/23/13 3:44 AM, Jan Kara wrote:
> On Tue 22-01-13 19:37:46, Eric Sandeen wrote:
>> On 1/22/13 5:50 PM, Jan Kara wrote:
>>> On Mon 21-01-13 18:11:30, Ted Tso wrote:
>>>> On Tue, Jan 22, 2013 at 12:04:32AM +0100, Sedat Dilek wrote:
>>>>>
>>>>> Beyond the FUSE/LOOP fun, will you apply this patch to your linux-next GIT tree?
>>>>>
>>>>> Feel free to add...
>>>>>
>>>>>      Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
>>>>>
>>>>> A similiar patch for JBD went through your tree into mainline (see [1] and [2]).
>>>>
>>>> I'm not at all convinced that this patch has anything to do with your
>>>> problem.  I don't see how it could affect things, and I believe you
>>>> mentioned that you saw the problem even with this patch applied?  (I'm
>>>> not sure; some of your messages which you sent were hard to
>>>> understand, and you mentioned something about trying to send messages
>>>> when low on sleep :-).
>>>>
>>>> In any case, the reason why I haven't pulled this patch into the ext4
>>>> tree is because I was waiting for Eric and some of the performance
>>>> team folks at Red Hat to supply some additional information about why
>>>> this commit was making a difference in performance for a particular
>>>> proprietary, closed source benchmark.
>>>   Just a small correction - it was aim7 AFAIK which isn't closed source
>>> (anymore). You can download it from SourceForge
>>> (http://sourceforge.net/projects/aimbench/files/aim-suite7/Initial%20release/).
>>> Now I have some reservations about what the benchmark does but historically
>>> it has found quite a few issues for us as well.
>>>
>>>> I'm very suspicious about applying patches under the "cargo cult"
>>>> school of programming.  ("We don't understand why it makes a
>>>> difference, but it seems to be good, so bombs away!" :-)
>>>   Well, neither am I ;) But it is obvious the patch speeds up
>>> log_start_commit() by 'a bit' (taking spinlock, disabling irqs, ...). And
>>> apparently 'a bit' is noticeable for particular workload on a particular
>>> machine - commit statistics Eric provided showed that clearly. I'd still be
>>> happier if Eric also told us how much log_start_commit() calls there were
>>> so that one could verify that 'a bit' could indeed multiply to a measurable
>>> difference. But given how simple the patch is, I gave away after a while
>>> and just merged it...
>>
>> I am still trying to get our perf guys to collect that data, FWIW...
>> I will send it when I get it.  I bugged them again today.  :)
>>
>> (Just to be sure: I was going to measure the wakeups the old way, and the
>> avoided wakeups with the new change; sound ok?)
>   Yes, that would be what I'm interested in.

Holy cow, this is much more than I expected, but here's what they report:

old JBD: AIM7 jobs/min 97624.39;  got 78193 jbd wakeups
new JBD: AIM7 jobs/min 85929.43;  got 6306999 jbd wakeups, 6264684 extra wakeups

The "extra wakeups" were hacked in like:

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index d492d57..3e0c4eb 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -433,15 +433,25 @@ int __log_space_left(journal_t *journal)
 	return left;
 }
 
+unsigned long jbd_wakeups;
+unsigned long jbd_extra_wakeups;
+
 /*
  * Called under j_state_lock.  Returns true if a transaction commit was started.
  */
 int __log_start_commit(journal_t *journal, tid_t target)
 {
 	/*
-	 * Are we already doing a recent enough commit?
+	 * The only transaction we can possibly wait upon is the
+	 * currently running transaction (if it exists).  Otherwise,
+	 * the target tid must be an old one.
 	 */
-	if (!tid_geq(journal->j_commit_request, target)) {
+	if (/* journal->j_commit_request != target && <--- ERS: Undo "fix" */
+	    journal->j_running_transaction &&
+	    journal->j_running_transaction->t_tid == target) {
+		/* if we already have the right target, this is extra */
+		if (journal->j_commit_request == target)
+			jbd_extra_wakeups++;
 		/*
 		 * We want a new commit: OK, mark the request and wakup the
 		 * commit thread.  We do _not_ do the commit ourselves.
@@ -451,9 +461,17 @@ int __log_start_commit(journal_t *journal, tid_t target)
 		jbd_debug(1, "JBD: requesting commit %d/%d\n",
 			  journal->j_commit_request,
 			  journal->j_commit_sequence);
+		jbd_wakeups++;
 		wake_up(&journal->j_wait_commit);
 		return 1;
-	}
+	} else if (!tid_geq(journal->j_commit_request, target))
+		/* This should never happen, but if it does, preserve
+		   the evidence before kjournald goes into a loop and
+		   increments j_commit_sequence beyond all recognition. */
+		WARN_ONCE(1, "jbd: bad log_start_commit: %u %u %u %u\n",
+		    journal->j_commit_request, journal->j_commit_sequence,
+		    target, journal->j_running_transaction ?
+		    journal->j_running_transaction->t_tid : 0);
 	return 0;
 }
 
@@ -2039,6 +2057,7 @@ static void __exit journal_exit(void)
 	if (n)
 		printk(KERN_EMERG "JBD: leaked %d journal_heads!\n", n);
 #endif
+	printk("got %lu jbd wakeups, %lu extra wakeups\n", jbd_wakeups, jbd_extra_wakeups);
 	jbd_remove_debugfs_entry();
 	journal_destroy_caches();
 }

-Eric

> 								Honza
> 


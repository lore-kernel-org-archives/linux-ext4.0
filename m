From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Fri, 26 Oct 2012 10:25:44 -0500
Message-ID: <508AAB78.5030505@redhat.com>
References: <87objupjlr.fsf@spindle.srvr.nix> <20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix> <20121023143019.GA3040@fieldses.org> <874nllxi7e.fsf_-_@spindle.srvr.nix> <87pq48nbyz.fsf_-_@spindle.srvr.nix> <20121023221913.GC28626@thunk.org> <50873CE5.8090303@redhat.com> <20121024201717.GA5572@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, Nix <nix@esperi.org.uk>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org,
	=?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
	stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933674Ab2JZP0G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Oct 2012 11:26:06 -0400
In-Reply-To: <20121024201717.GA5572@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/24/12 3:17 PM, Jan Kara wrote:
> On Tue 23-10-12 19:57:09, Eric Sandeen wrote:
>> On 10/23/12 5:19 PM, Theodore Ts'o wrote:
>>> On Tue, Oct 23, 2012 at 09:57:08PM +0100, Nix wrote:
>>>>
>>>> It is now quite clear that this is a bug introduced by one or more of
>>>> the post-3.6.1 ext4 patches (which have all been backported at least to
>>>> 3.5, so the problem is probably there too).
>>>>
>>>> [   60.290844] EXT4-fs error (device dm-3): ext4_mb_generate_buddy:741: group 202, 1583 clusters in bitmap, 1675 in gd
>>>> [   60.291426] JBD2: Spotted dirty metadata buffer (dev = dm-3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
>>>>
>>>
>>> I think I've found the problem.  I believe the commit at fault is commit
>>> 14b4ed22a6 (upstream commit eeecef0af5e):
>>>
>>>     jbd2: don't write superblock when if its empty
>>>
>>> which first appeared in v3.6.2.
>>>
>>> The reason why the problem happens rarely is that the effect of the
>>> buggy commit is that if the journal's starting block is zero, we fail
>>> to truncate the journal when we unmount the file system.  This can
>>> happen if we mount and then unmount the file system fairly quickly,
>>> before the log has a chance to wrap.After the first time this has
>>> happened, it's not a disaster, since when we replay the journal, we'll
>>> just replay some extra transactions.  But if this happens twice, the
>>> oldest valid transaction will still not have gotten updated, but some
>>> of the newer transactions from the last mount session will have gotten
>>> written by the very latest transacitons, and when we then try to do
>>> the extra transaction replays, the metadata blocks can end up getting
>>> very scrambled indeed.
>>
>> I'm stumped by this; maybe Ted can see if I'm missing something.
>>
>> (and Nix, is there anything special about your fs?  Any nondefault
>> mkfs or mount options, external journal, inordinately large fs, or
>> anything like that?)
>>
>> The suspect commit added this in jbd2_mark_journal_empty():
>>
>>         /* Is it already empty? */
>>         if (sb->s_start == 0) {
>>                 read_unlock(&journal->j_state_lock);
>>                 return;
>>         }
>>
>> thereby short circuiting the function.
>>
>> But Ted's suggestion that mounting the fs, doing a little work, and
>> unmounting before we wrap would lead to this doesn't make sense to
>> me.  When I do a little work, s_start is at 1, not 0.  We start
>> the journal at s_first:
>>
>> load_superblock()
>> 	journal->j_first = be32_to_cpu(sb->s_first);
>>
>> And when we wrap the journal, we wrap back to j_first:
>>
>> jbd2_journal_next_log_block():
>>         if (journal->j_head == journal->j_last)
>>                 journal->j_head = journal->j_first;
>>
>> and j_first comes from s_first, which is set at journal creation
>> time to be "1" for an internal journal.
>>
>> So s_start == 0 sure looks special to me; so far I can only see that
>> we get there if we've been through jbd2_mark_journal_empty() already,
>> though I'm eyeballing jbd2_journal_get_log_tail() as well.
>>
>> Ted's proposed patch seems harmless but so far I don't understand
>> what problem it fixes, and I cannot recreate getting to
>> jbd2_mark_journal_empty() with a dirty log and s_start == 0.
>   Agreed. I rather thing we might miss journal->j_flags |= JBD2_FLUSHED
> when shortcircuiting jbd2_mark_journal_empty(). But I still don't exactly
> see how that would cause the corruption...

Agreed, except so far I cannot see any way to get here with s_start == 0
without ALREADY having JBD2_FLUSHED set.  Can you?

Anyway, I think the problem is still poorly understood; lots of random facts
floating about, and a pretty weird usecase with nonstandard/dangerous mount
options.  I do want to figure out what regressed (if anything) but so far
this investigation doesn't seem very methodical.

-Eric

> 								Honza
> 


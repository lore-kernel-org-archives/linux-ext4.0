From: Josef Bacik <josef@redhat.com>
Subject: Re: Can a metadata buffer end up in journal_unmap_buffer?
Date: Thu, 11 Aug 2011 16:38:57 -0400
Message-ID: <4E443DE1.1070700@redhat.com>
References: <4E43D9E6.9030503@redhat.com> <20110811152811.GE18802@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab1HKUjH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2011 16:39:07 -0400
In-Reply-To: <20110811152811.GE18802@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/11/2011 11:28 AM, Jan Kara wrote:
>   Hello,
> 
> On Thu 11-08-11 09:32:22, Josef Bacik wrote:
>> I have this weird bug that has been plaguing me for a while where
>> t_outstanding_credits will end up less than t_nr_buffers.  I have done
>> all sorts of things to try and catch when it happens but nothing seems
>> to catch it.  At some point I had thought that we were screwing up in
>> journal_unmap_buffer.  If a buffer is not on a transaction but is still
>> a part of a checkpoint we will do a journal_file_buffer() onto the
>> current running transaction's forget list.  The thing is we can still
>> have b_modified set since we only clear it on
>> do_get_write_access/journal_get_create_access if it isn't a part of the
>> transaction yet.  So if we do the journal_file_buffer() before anybody
>> calls do_get_write_access/journal_get_create_access we will short
>> circuit these checks and b_modified will never be cleared and so when we
>> do journal_dirty_metadata we won't account for the new buffer and it
>> will end up inc'ing t_nr_buffers but not t_outstanding_credits.
>   Good spotting!
> 
>> I had thought this was the problem before and put in a jh->b_modified =
>> 0 in __dispose_buffer, but apparently the problem still happened.  But
>> that support person/customer were not entirely reliable so I'm back to
>> thinking this is what happened and they just didn't run with my patch.
>   Umm, I think there's one more way how buffer b_modified == 1 can get
> to other transaction's forget list. In journal_unmap_buffer(), transaction
> == journal->j_committing_transaction case we do set_buffer_freed() and
> set b_next_transaction to the running transaction. So when the currently
> committing transaction finishes, it refiles the buffer to BJ_Forget list
> of the running transaction. b_modified handling seems to be really fragile
> in this regard. I guess the rule is that whenever we are going to change
> b_transaction or b_next_transaction, we should clear b_modified.
> 
>> The problem is I don't think we can call journal_unmap_buffer() on just
>> a normal metadata block (that is with data=ordered), it only gets called
>> by ext3_invalidatepage() which is only called on pages on the inodes
>> address space, so not metadata.  However, Jan had a patch to delay the
>> free'ing of buffers for orphan reasons, with commit
>>
>> 86963918965eb8fe0c8ae009e7c1b4c630f533d5
>>
>> which makes it seem like metadata can come through
>> journal_unmap_buffer()?  Does anybody know for sure one way or the
>> other?  And if you happen to have a theory on the actual problem itself
>> I would _love_ to hear it :).  Thanks,
>   It can happen either in data=journal mode or for long symlinks. BTW I
> think Kyle Moffet was probably hitting this bug with ext4
> (http://lists.debian.org/debian-kernel/2011/04/msg00145.html) and I was
> also trying to find the culprit for some time without success so I'm glad
> you found it in the end ;).
> 

So I'm back to thinking this particular case can't happen with
data=ordered mode, at least the horrible part where the buffer gets
dirtied without h_buffer_credit getting toggled for it.  Once we create
the symlink we don't ever touch the page again except to get rid of it
when we delete the symlink.  This will make it show back up on the
running transactions forget list, but there's no way it could end up
modified again and end up on it's metadata list.  So it's back to debug
patches because I have no other ideas.  Thanks,

Josef

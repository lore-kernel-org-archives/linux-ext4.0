From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: Sleeping function called in invalid context
Date: Fri, 5 Aug 2016 09:29:59 +0300
Message-ID: <57A43267.7030608@kyup.com>
References: <57A19B9B.60005@kyup.com> <20160804160550.GA12861@quack2.suse.cz>
 <20160804205845.GC10933@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Nikolay Borisov <kernel@kyup.com>, Jan Kara <jack@suse.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:34973 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030288AbcHEGaE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Aug 2016 02:30:04 -0400
Received: by mail-wm0-f51.google.com with SMTP id f65so18825688wmi.0
        for <linux-ext4@vger.kernel.org>; Thu, 04 Aug 2016 23:30:02 -0700 (PDT)
In-Reply-To: <20160804205845.GC10933@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 08/04/2016 11:58 PM, Theodore Ts'o wrote:
> On Thu, Aug 04, 2016 at 06:05:50PM +0200, Jan Kara wrote:
>> On Wed 03-08-16 10:22:03, Nikolay Borisov wrote:
>>> While doing some testing on today's checkout of Linus' master branch I
>>> got the following: 
>>
>>>
>>> [    9.302725] BUG: sleeping function called from invalid context at ./include/linux/buffer_head.h:358
>>> [    9.304403] in_atomic(): 1, irqs_disabled(): 0, pid: 1718, name: mount
>>> [    9.305633] 8 locks held by mount/1718:
>>
>> Yeah, this looks like a regression cause by commit 4743f83990614af "ext4:
>> Fix WARN_ON_ONCE in ext4_commit_super()". Arguably that cure is worse than
>> the disease but OTOH calling ext4_commit_super() from an atomic context
>> (like __ext4_grp_locked_error() does) sucks as well.
>>
>> I'm not sure what the right fix is here. The cleanest would probably be to
>> always drop group lock in __ext4_grp_locked_error() and make sure we always
>> properly bail out of mballoc code on such error. But that's a non-trivial
>> amount of work. Not sure if other ext4 people have opinion on this?
> 
> The easist way to fix this is defer the ext4_commit_super() to a
> workqueue.  We only need this in the errors=continue case, and in that
> scenario we're not in a hurry when the superblock gets written out.

Is errors=continue the default option if nothing specifically is
specified at mount time, since I don't have this set explicitly:

/dev/vda / ext4 rw,relatime,data=ordered 0 0

> 
> In fact, we probably want to be doing this for all of the
> errors=continue cases when we want to save the error state to the
> superblock, so we can do the update properly using the journal,
> instead of calling ext4_commit_super() which just force writes the
> block.
> 
> (Of course, if the journal is aborted we'll need to fall back to using
> ext4_commit_super, of course.)
> 
> 						 - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

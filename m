From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: add ratelimiting to ext4 messages
Date: Sat, 19 Oct 2013 18:04:55 -0500
Message-ID: <52631017.6010001@redhat.com>
References: <1382059728-29483-1-git-send-email-tytso@mit.edu> <526140E8.7000002@redhat.com> <20131018185955.GA7557@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab3JSXE7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Oct 2013 19:04:59 -0400
In-Reply-To: <20131018185955.GA7557@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/18/13 1:59 PM, Theodore Ts'o wrote:
> On Fri, Oct 18, 2013 at 09:08:40AM -0500, Eric Sandeen wrote:
>> On 10/17/13 8:28 PM, Theodore Ts'o wrote:
>>> In the case of a storage device that suddenly disappears, or in the
>>> case of significant file system corruption, this can result in a huge
>>> flood of messages being sent to the console.  This can overflow the
>>> file system containing /var/log/messages, or if a serial console is
>>> configured, this can slow down the system so much that a hardware
>>> watchdog can end up triggering forcing a system reboot.
>>
>> Just out of curiosity, after the fs shuts down, is there still a flood
>> of messages?  Shouldn't that clamp down on the errors?
> 
> Not if we are running with errors=continue.

Maybe the ratelimit should depend on that then?  I'm just concerned about
the possibility of filtering messages that, rather than being a nuisance,
are vital to figuring out what went wrong.

(granted, it's probably the first error or two that matters)

Or maybe it's only relevant with errors=continue, and errors=remount-ro
will be self-limiting in any case.

> There are some ugly
> patches in our tree which pipes error notifications to a netlink
> socket, which allows userspace to do something intelligent with
> errors, and because there are some errors where it's safe to continue
> (especially if you are willing to shut down block allocations to the
> block group where you don't trust the allocation bitmap), we tend to
> run with errors=continue.

hm... :)

> I think I mentioned the errors->netlink feature a while back, but
> there wasn't a whole lot of excitement about it, and the patches
> definitely need a lot of cleanup before they would be ready for
> upstream merging.  If people are curious, I can look into getting the
> patches sent out, since we just finished rebasing them to 3.11.
> 
>> If not, shouldn't it do so?  xfs has a lot of short-circuiting if
>> the filesystem is shut down, so it (I think) won't get into paths that
>> will generate more errors.
> 
> When xfs "shuts down" the file system, it doesn't allow any read or
> write accesses, right?  So it's basically an even stronger version of
> errors=remount-ro.  We should perhaps discuss whether it would be
> better to squelch errors if we've remounted the file system read-only,
> or whether we should implement a complete shutdown errors option.

Yeah, there is no errors=continue type option, that is probably too
dangerous in general for the majority of users.

I'd guess that w/ default remount-ro, the error flood isn't a risk.

> And of course, even if we did this, we would still need to squelch
> ext4_warning and ext4_msg output.  (Although I agree with Lukas that
> it might not be a bad idea to review some of the messages that either
> get emitted via printk, or which are issued via ext4_msg(KERN_CRIT) to
> see if we should perhaps change some of those to ext4_error.)

*nod*

Thanks,
-Eric

> Regards,
> 
> 						- Ted
> 


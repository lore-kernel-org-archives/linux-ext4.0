From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
Date: Tue, 17 Jan 2012 12:46:08 +0200
Message-ID: <4F155170.5000206@panasas.com>
References: <1325774407-28531-1-git-send-email-jack@suse.cz> <CA+55aFy0sidnCzPkP6yjnarLZx3a=7QSpgfaf2mUNVy14y3vCw@mail.gmail.com> <20120116160136.GC16431@quack.suse.cz> <CA+55aFyUiLq7UZeQD=-MU5ppvEDULiBP8xV0mJqVLL6nFAi7VA@mail.gmail.com> <20120117003613.GA28571@dastard> <CA+55aFxZ8dF8WagoyQPYTm92R1ZKd0G_tztqmAc+jrv0LkWGAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Edward Shishkin <edward@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:48209 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab2AQKxg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jan 2012 05:53:36 -0500
In-Reply-To: <CA+55aFxZ8dF8WagoyQPYTm92R1ZKd0G_tztqmAc+jrv0LkWGAA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/17/2012 02:59 AM, Linus Torvalds wrote:
> On Mon, Jan 16, 2012 at 4:36 PM, Dave Chinner <david@fromorbit.com> wrote:
>>
>> Jan is right, Linus. His definition of what up-to-date means for
>> dirty buffers is correct, especially in the case of write errors.
> 
> It's not a dirty buffer any more.
> 
> Go look. We've long since cleared the dirty bit.
> 
> So stop spouting garbage.
> 
> My argument is simple: the contents ARE NOT CORRECT ENOUGH to be
> called "up-to-date and clean".
> 
> And I outlined the two choices:
> 
>  - mark it dirty and continue trying to write it out forever
> 
>  - invalidate it.
> 
> Anything else is crazy talk. And marking it dirty forever isn't really
> an option. So..
> 
>                Linus

I think this conversation is an hint to the fact that the page_cache-page
state machine is clear as mud. And I thought it was only me. For years
I want to catch some VFS guru to sit down and finally explain to me all
the stages and how they are expressed in page-flag bits.

Back to the conversation. The way I understood it (Which is probably wrong)
1. The application dirties a page it is in a *dirty* state.
2. Write-out begins, page goes into that in-write-out state (Am I correct)

Now the page comes back from write-out with an error. As Linus stated we can
not put it back to *dirty* state because it will probably never clear.
(We did bunch of retrys on the block level). And we can't keep it in-write-out
surly. But I think we should surly *not* put it in *not-clean* state. Because
that one implies reading and the worse we can do is read that page as it is
now.

Therefor I agree with Jan. That the best is to use that extra error bit
to indicate an *error-state*, which is up to the FS to handle.
If it was a read error - error-is-set clean-is-cleared
If it was a write err  - error-is-set clean-is-set.

All the rest of the Kernel should consider these as a they are error-sate
and I really like Jan's patch of inspecting for error-bit and not the
not-clean in a write-out which is darn confusing. (Regardless of the meaning
of the clean-bit)

Now the filesystem needs to do something about these pages like put them in a Jurnal,
shove them in a recovery workQ or whatever. All the VFS/MM can do is like Linus
said wait until they are plain removed which is effectively like invalidating them.
(In the case the FS did nothing to fix it)

I wish there was some heavy logging when the VFS/MM trashes error-set but clean-set
pages (Write-errors), even a write-out of these buffers to some global journal, of
which tools can extract and amend later. (Like the USB snatched too soon example)

So I see Linus point of "we can't go back to any of the old states" but let's not
overload the clean-bit and use the proper error-bit like Jan suggested.

My $0.017
Boaz

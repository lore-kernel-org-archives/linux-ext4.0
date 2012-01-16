From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
Date: Mon, 16 Jan 2012 11:06:41 -0800
Message-ID: <CA+55aFx638n1aQ00R6qfiOTrQiWR68uQQubGdy3PSpM+RUHaHQ@mail.gmail.com>
References: <1325774407-28531-1-git-send-email-jack@suse.cz>
 <CA+55aFy0sidnCzPkP6yjnarLZx3a=7QSpgfaf2mUNVy14y3vCw@mail.gmail.com>
 <20120116160136.GC16431@quack.suse.cz> <CA+55aFyUiLq7UZeQD=-MU5ppvEDULiBP8xV0mJqVLL6nFAi7VA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Edward Shishkin <edward@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47357 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab2APTHE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jan 2012 14:07:04 -0500
In-Reply-To: <CA+55aFyUiLq7UZeQD=-MU5ppvEDULiBP8xV0mJqVLL6nFAi7VA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 16, 2012 at 10:55 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> If the write fails, the buffer contents have *nothing* to do with what
> is on disk.

Another way of thinking of it: if the write fails, you really have two choices:

 - retry the write until it doesn't fail. In this case, the buffer is
always "up-to-date" in the sense that it is what we *want* to be on
disk, and what we tro to make sure really *is* on disk.

  This is the "good" case, but we can't really do it, because if we do
and the disk has had a hard-failure, we'll just fill up memory with
dirty data that we cannot do anything about.

 - just admit that the buffer we have have nothing what-so-ever to do
with what the disk contents are. Any claim about the disk buffer
having any relationship to the disk is clearly bogus.

One reason to clear the up-to-date flag is simply to find out what the
f*&^ we actually have on disk, rather than have to wait for the next
reboot or whatever. Maybe the disk contents ended up ok'ish, but we
got an error for some random reason. Clearing the bit and re-reading
means that we can at least figure it out.

Another is that if we don't clear it, it *will* get cleared eventually
anyway, since the buffer will be free'd (which semantically is the
same thing as clearing the up-to-date bit, in that any future access
will have to read it from disk).

So stop trying to claim that the buffer actually somehow is
"up-to-date". It damn well isn't. If it's not marked dirty, and it
doesn't match the disk contents, then it sure as hell is not
"up-to-date", since dropping the buffer would result in something
*different* being read back in.

Now, you can use *other* arguments for not clearing the up-to-date
bit. For example, if the up-to-date bit being cleared results in worse
problems than some random warning, there's an implementation reason
not to clear it. Or if you can argue that instead of clearing the
up-to-date bit we instead flush the buffer aggressively and try to
invalidate it, I would certainly agree that that is conceptually
equally correct as clearing it.

But just leaving it alone, and thinking that it's all good - that's
just ugly and hiding the issue. The buffer is clearly *not* all good.

                         Linus

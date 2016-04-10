From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 bug fixes for 4.6
Date: Sun, 10 Apr 2016 13:29:30 -0700
Message-ID: <CA+55aFwdgD1Y7caKoL=8aPvoKUwObA-Fa8LypPBZMA87pBcu1w@mail.gmail.com>
References: <xr93bn5iyzeq.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Greg Thelen <gthelen@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f194.google.com ([209.85.213.194]:35618 "EHLO
	mail-ig0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbcDJU3c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Apr 2016 16:29:32 -0400
In-Reply-To: <xr93bn5iyzeq.fsf@gthelen.mtv.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 9, 2016 at 7:23 PM, Greg Thelen <gthelen@google.com> wrote:
>
>
> I've been testing 5b5b7fd185e9 (linus/master) and seeing that
> interrupted readdir() now returns duplicate dirents.

Yes, your test-program recreates this beautifully here. Sadly not
while stracing.

Worth adding as a filesystem test to fsstress?

> Reverting commit 1028b55bafb7 ("ext4: allow readdir()'s of large empty
> directories to be interrupted") avoids duplicates.

Ok, so the the "fatal_signal_pending()" case in ext4_readdir() should
be ok, since we're killing the thread at that point.

So I assume it's the ext4_htree_fill_tree() part of the patch.

What I *think* happens is:

 - We are perfectly happy to take a break at "call_filldir()" time (if
that returns an error because the buffer was full or whatever), and at
that point, ctx->pos will point to the last entry that we did *not*
successfully fill in.

 - but if we take an exception at ext4_htree_fill_tree() time, we end
the loop, and now "ctx->pos" contains the offset of the previous entry
- the one we *successfully* already copied

 - so now, when we exit the getdents, we will save the re-start value
at the entry that we already successfully handled.

So I think that commit is entirely bogus.

I think the right choice might be to

 (a) revert that patch (or just change the signal_pending() into
fatal_signal_pending())

 (b) to get the latency advantage, do something like this:

      diff --git a/fs/readdir.c b/fs/readdir.c
     index e69ef3b79787..a2244fe9c003 100644
     --- a/fs/readdir.c
     +++ b/fs/readdir.c
     @@ -248,6 +248,8 @@ static int filldir64(struct dir_context *ctx,
const char *name, int namlen,
                     return -EINVAL;
             dirent = buf->previous;
             if (dirent) {
     +               if (signal_pending)
     +                       return -EINTR;
                     if (__put_user(offset, &dirent->d_off))
                             goto efault;
             }

which returns that error at a point where we can actually take it
(note that we only do this if we have already filled in at least one
entry: "buf->previous" was non-NULL, so we can return EINTR, because
the caller will actually return the length of the result, never the
EINTR error we're returning).

The above patch is *entirely* untested. It might be pure garbage. But
that commit 1028b55bafb7 is _definitely_ broken, and the above _might_
work.

Caveat patchor.

                   Linus

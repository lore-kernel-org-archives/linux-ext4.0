From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ext4: allow readdir()'s of large empty directories to be interrupted
Date: Thu, 14 Apr 2016 19:01:14 -0700
Message-ID: <CA+55aFw63jj-PJ2c=aYZivkfHfei=1W2z72qs0P+aj-f0J1UKw@mail.gmail.com>
References: <1460666265-22596-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f194.google.com ([209.85.213.194]:34552 "EHLO
	mail-ig0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbcDOCBP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Apr 2016 22:01:15 -0400
Received: by mail-ig0-f194.google.com with SMTP id qu10so1209728igc.1
        for <linux-ext4@vger.kernel.org>; Thu, 14 Apr 2016 19:01:15 -0700 (PDT)
In-Reply-To: <1460666265-22596-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 14, 2016 at 1:37 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
>  So Linus's proposal to
> add "if (signal_pending(current)) return -EINTR;" to filldir64() would
> probably cause more than a few userspace regressions.

I don't think you actually read or understood my proposal.

The proposal added it to inside the if-statement in

        dirent = buf->previous;
        if (dirent) {
+               if (signal_pending(current)) return -EINTR;

and that actually guarantees that readdir() _never_ returns -EINTR,
because there is at least one entry that got filled out (the previous
one filled in, now pointed to be "dirent").

So the iterator wrapper that is actually readdir() (getdents) will see
that filldir64 returned an error, and stop filling entries. But
because at least entry has been filled, it will return a positive
number - the amount filled.

This is similar to the interruptible partial read or write case:
getting a signal after something has been read or written will not
return -EINTR, it will return the partial result.

And we _know_ that getdents is ok with partial results, since the
caller by definition doesn't know how many entries it will get, and
you generally never get a completely full buffer anyway (since
directory entries have varying sizes and the last one seldom fits
exactly in the buffer provided).

I ran that kernel for several days, in addition to testing it with the
test-program that broke with the ext4 changes. It was fine. I didn't
commit it, because I didn't think it was appropriate for outside the
merge window, but I don't believe it can break.

Now, it is very possible that ext4 might want to handle the fatal
signal despite that, simply because ext4 may be looping over blocks
that simply don't contain any directory entries at all. That said, it
is possible that my one-liner makes your fatal-signal case irrelevant,
simply because it makes it so unlikely to matter in practice.

              Linus

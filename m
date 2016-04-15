From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: allow readdir()'s of large empty directories to be
 interrupted
Date: Fri, 15 Apr 2016 10:56:22 -0400
Message-ID: <20160415145622.GA11838@thunk.org>
References: <1460666265-22596-1-git-send-email-tytso@mit.edu>
 <CA+55aFw63jj-PJ2c=aYZivkfHfei=1W2z72qs0P+aj-f0J1UKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59790 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbcDOO4a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Apr 2016 10:56:30 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFw63jj-PJ2c=aYZivkfHfei=1W2z72qs0P+aj-f0J1UKw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 14, 2016 at 07:01:14PM -0700, Linus Torvalds wrote:
> On Thu, Apr 14, 2016 at 1:37 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> >
> >  So Linus's proposal to
> > add "if (signal_pending(current)) return -EINTR;" to filldir64() would
> > probably cause more than a few userspace regressions.
> 
> I don't think you actually read or understood my proposal.
> 
> The proposal added it to inside the if-statement in
> 
>         dirent = buf->previous;
>         if (dirent) {
> +               if (signal_pending(current)) return -EINTR;
> 
> and that actually guarantees that readdir() _never_ returns -EINTR,
> because there is at least one entry that got filled out (the previous
> one filled in, now pointed to be "dirent").

Sorry, yes I didn't understand that was what you were getting at.
That makes a lot of sense.  Thanks!!

					- Ted

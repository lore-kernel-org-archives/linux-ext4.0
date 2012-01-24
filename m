From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
Date: Tue, 24 Jan 2012 13:13:14 +0100
Message-ID: <20120124121314.GE15974@quack.suse.cz>
References: <CA+55aFy0sidnCzPkP6yjnarLZx3a=7QSpgfaf2mUNVy14y3vCw@mail.gmail.com>
 <20120116160136.GC16431@quack.suse.cz>
 <CA+55aFyUiLq7UZeQD=-MU5ppvEDULiBP8xV0mJqVLL6nFAi7VA@mail.gmail.com>
 <20120117003613.GA28571@dastard>
 <CA+55aFxZ8dF8WagoyQPYTm92R1ZKd0G_tztqmAc+jrv0LkWGAA@mail.gmail.com>
 <20120123030422.GE15102@dastard>
 <20120123214709.GB17974@thunk.org>
 <CA+55aFxggjW6FKhf7KSCRMD-4YF9ymsxDQ+EMtUTThX16r-8tw@mail.gmail.com>
 <20120124061211.GK15102@dastard>
 <CA+55aFxVKEHrfXwnDb5Q8Y5CkPVn=aVXj=SfVtr98g6ZP1mEmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, Ted Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Edward Shishkin <edward@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxVKEHrfXwnDb5Q8Y5CkPVn=aVXj=SfVtr98g6ZP1mEmg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 23-01-12 23:10:53, Linus Torvalds wrote:
> On Mon, Jan 23, 2012 at 10:12 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > You still haven't grasped that there are many different
> > classes of IO errors and that some require different handling to
> > others. :/
> 
> I think *you* haven't grasped what we're talking about.
> 
> Did you look at the thread?
> 
> We're not talking about some filesystem-specific buffer handling.
> We're talking about the *default* hander in fs/buffer.c for IO
> completion.
  Well, not sure if you remember but the change I was proposing was only
for filesystems that would promise (in their fstype) they they know better
how to handle IO errors. 

> A filesystem can override that handler if it wants to and you can do
> whatever the f*ck you want in your filesystem end-of-io handler.
  That's another possibility but a flag in fstype and a check in default
end-of-io handler looked like an easier solution to me.

> But dammit, in the default handler - which BY DEFINITION IS ABOUT
> FILESYSTEMS THAT DO NOT DO THOSE "many different classes of IO errors"
> that you continue to blather about, there really are two choices:
>  - throw the damn thing away
>  - retry the write forever
> 
> It really is that simple. The thing I objected to was Jan claiming
> that clearing the up-to-date flag made no semantic sense. That's just
> crazy talk.
> 
> What does *not* make any semantic sense is to just mark the damn thing
> clean after an IO error!
  I agree that just keeping the uptodate flag was a half-baked proposal. I
ultimately want to set the dirty flag back as well and we seem to agree
that that would be logically correct. But then, as you noted, filesystem
has to propely handle unwriteable pages to not bring system OOM (or
actually block all writes due to exceeded dirty limit) and that is more
complicated (distinguishing path temporarily down from USB stick is gone
etc.) so I didn't want to go there in the beginning. But it seems I'll have
to ;)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
Date: Mon, 23 Jan 2012 23:10:53 -0800
Message-ID: <CA+55aFxVKEHrfXwnDb5Q8Y5CkPVn=aVXj=SfVtr98g6ZP1mEmg@mail.gmail.com>
References: <1325774407-28531-1-git-send-email-jack@suse.cz>
 <CA+55aFy0sidnCzPkP6yjnarLZx3a=7QSpgfaf2mUNVy14y3vCw@mail.gmail.com>
 <20120116160136.GC16431@quack.suse.cz> <CA+55aFyUiLq7UZeQD=-MU5ppvEDULiBP8xV0mJqVLL6nFAi7VA@mail.gmail.com>
 <20120117003613.GA28571@dastard> <CA+55aFxZ8dF8WagoyQPYTm92R1ZKd0G_tztqmAc+jrv0LkWGAA@mail.gmail.com>
 <20120123030422.GE15102@dastard> <20120123214709.GB17974@thunk.org>
 <CA+55aFxggjW6FKhf7KSCRMD-4YF9ymsxDQ+EMtUTThX16r-8tw@mail.gmail.com> <20120124061211.GK15102@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Ted Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Edward Shishkin <edward@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120124061211.GK15102@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jan 23, 2012 at 10:12 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> You still haven't grasped that there are many different
> classes of IO errors and that some require different handling to
> others. :/

I think *you* haven't grasped what we're talking about.

Did you look at the thread?

We're not talking about some filesystem-specific buffer handling.
We're talking about the *default* hander in fs/buffer.c for IO
completion.

A filesystem can override that handler if it wants to and you can do
whatever the f*ck you want in your filesystem end-of-io handler.

But dammit, in the default handler - which BY DEFINITION IS ABOUT
FILESYSTEMS THAT DO NOT DO THOSE "many different classes of IO errors"
that you continue to blather about, there really are two choices:
 - throw the damn thing away
 - retry the write forever

It really is that simple. The thing I objected to was Jan claiming
that clearing the up-to-date flag made no semantic sense. That's just
crazy talk.

What does *not* make any semantic sense is to just mark the damn thing
clean after an IO error!

I very much NAK that whole idiotic approach, and object to it.  That
is the routine that is used even without any filesystem AT ALL, for
chissake.

So all your arguments are for something totally different that is
irrelevant for the whole discussion.  Really.

                       Linus

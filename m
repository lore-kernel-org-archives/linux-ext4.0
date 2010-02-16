From: tytso@mit.edu
Subject: Re: Help on Implementation of EXT3 type Ordered Mode in EXT4
Date: Tue, 16 Feb 2010 09:18:54 -0500
Message-ID: <20100216141854.GT5337@thunk.org>
References: <20100209174145.GU4494@thunk.org>
 <38f6fb7d1002102301x278c3ddt153f570dd1423074@mail.gmail.com>
 <38f6fb7d1002102332v3482ef49xb2afd5931c5eb2ad@mail.gmail.com>
 <20100211195624.GM739@thunk.org>
 <38f6fb7d1002111922i4ae6131w6b5cce79344efc63@mail.gmail.com>
 <20100212200726.GD5337@thunk.org>
 <38f6fb7d1002130043s54e61e74jcc3297aeeac294b0@mail.gmail.com>
 <20100215150021.GE3434@quack.suse.cz>
 <38f6fb7d1002160210x6dc86fb5o82825e7677c07994@mail.gmail.com>
 <20100216131039.GB3153@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kailas Joshi <kailas.joshi@gmail.com>, linux-ext4@vger.kernel.org,
	Jiaying Zhang <jiayingz@google.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45222 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385Ab0BPOS7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Feb 2010 09:18:59 -0500
Content-Disposition: inline
In-Reply-To: <20100216131039.GB3153@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 16, 2010 at 02:10:39PM +0100, Jan Kara wrote:
>   Actually, stalling on a transaction in LOCKED state does have a negative
> impact on the filesystem performance. But it's hard to avoid it. The
> transaction is in LOCKED state while we've decided it needs a commit but
> there are still tasks which have handle to it and are adding new metadata
> buffers to it. So this transaction is effectively still running and we
> cannot start a next transaction because then we'd have two running
> transactions and the journalling logic isn't able to handle that.

This is also why we try to avoid staying in LOCKED state for very
long.... and why increasing the journal size can help performance
(since if we get ourselves into trouble where are forced to do a
journal checkpoint, we can end up stalling all file system updates for
a non-trivial amount of time).

So changes that increase the amount of time that we spend in LOCKED
are going to be really bad, especially if you have one thread which is
frequently calling fsync() (for example, like Firefox, which can be
*very* fsync() happy) and another thread which is doing lots of file
creates and deletes.  Each fsync() will force a transaction commit,
and if you have to stop all transaction updates while the delayed
allocation blocks are getting resolved, life can really get bad.

This is why, ultimately, we really need to distinguish between files
where we might not care when they get written to disk (i.e., object
files being created by the compiler, ISO files being downloaded from
the web since we can always restart them after the hopefully rare
crash --- unless you're using crappy video drivers, of course) from
files written by buggy applications which are precious and yet where
the application writer didn't bother to use fsync().

Maybe something we ought to consider is doing things both ways.  Maybe
we should have a way for applications to indicate they have been
audited and any precious files will be properly fsync()'ed.  This
could be done via two process personality flags; one which is
inherited across an exec, and which which isn't.  (We need this so
that jobs being fired out of make can be properly exempted from
calling fsync(), even if they are using programs like sort, or shell
redirections, where the coreutils authors don't know whether the files
they are writing are precious or not, and thus whether they should be
fsync'ed.)

These flags would be used to exempt processes from a mount option
which could be set by people who are nervous about not trusting their
application writers, which would force an fsync at every file close
(except for those processes which have these process personality flags
set).  People who are more confident about having a stable set of
kernel drivers (and/or who are running servers where they have UPS's
and where they aren't using crappy desktop applications that seem to
be the most likely to not properly call fsync for precious files) can
simply avoid using this mount option, but we can give users and system
administrators a choice.

Maybe, just for those whiners at Phoronix, we can give them an mount
option where applications which have this flag set will get delayed
allocation, and applications which don't get their files written with
O_SYNC.  :-)

						- Ted
